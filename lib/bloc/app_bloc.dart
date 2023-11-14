import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sun_be_gone/bloc/actions.dart';
import 'package:sun_be_gone/bloc/app_state.dart';
import 'package:sun_be_gone/data/app_cache.dart';
import 'package:sun_be_gone/data/sqlite_db.dart';
import 'package:sun_be_gone/models/api_response.dart';
import 'package:sun_be_gone/models/bus_route_full_data.dart';
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sun_be_gone/models/errors.dart';
import 'package:sun_be_gone/models/route_quary_info.dart';
import 'package:sun_be_gone/services/bus_extended_route_api.dart';
import 'package:sun_be_gone/services/bus_routes_api.dart';
import 'package:sun_be_gone/services/bus_shape_api.dart';
import 'package:sun_be_gone/services/bus_stops_api.dart';
import 'package:sun_be_gone/services/results_api.dart';
import 'package:sun_be_gone/services/server_connection_api.dart';
import 'package:sun_be_gone/utils/logger.dart';
import 'package:sun_be_gone/utils/stop_quary_to_tuple.dart';
import 'package:sun_business/sun_business.dart' show Point;

class AppBloc extends Bloc<AppAction, AppState> {
  final BusRoutesApiProtocol busRoutesApi;
  final ExtendedRouteApiProtocol extendedRoutesApi;
  final BusStopsApiProtocol busStopsApi;
  final BusShapeApiProtocol busShapeApi;
  final ResultsApiProtocol resultsApi;
  final ServerConnectionApiProtocol serverConnectionApi;
  final BusRoutesDBInterface busRoutesDB;
  final BusRoutesQuaryDBInterface busRoutesQuaryDB;
  final HistoryIdsDBInterface historyIdsDB;
  final FavoritesIdsDBInterface favoritesIdsDB;

  AppBloc({
    required this.busRoutesApi,
    required this.extendedRoutesApi,
    required this.busStopsApi,
    required this.busShapeApi,
    required this.resultsApi,
    required this.serverConnectionApi,
    required this.busRoutesDB,
    required this.busRoutesQuaryDB,
    required this.historyIdsDB,
    required this.favoritesIdsDB,
  }) : super(const InitState(isInitialized: false)) {
    on<InitAppAction>((event, emit) async {
      logger.i('on InitAppAction');
      final Iterable<BusRoutes> routes;
      try {
        final ConnectivityResult connectivityResult =
            await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          emit(const InitState(isInitialized: true));
          return;
        }

        ApiResponse<String> checkLive = await serverConnectionApi.checkLive();
        if (checkLive.data != 'Healthy') {
          emit(
              ErrorState(error: Errors(ErrorType.serverDown, null, checkLive)));
        }

        ApiResponse<String> checkHealth =
            await serverConnectionApi.checkHealth();
        if (checkHealth.data != 'Healthy') {
          if (checkHealth.statusCode == 0) {
            logger.i('no internet connection');
            emit(const InitState(isInitialized: true));
          }
          emit(ErrorState(
            error: Errors(
              ErrorType.serverDown,
              null,
              checkHealth,
            ),
          ));
        }

        routes = await busRoutesDB.getBusRoutes();
        logger.i('got routes from local db, length: ${routes.length}');
        AppCache.instance().busRoutes = routes;
      } catch (e) {
        logger.e('routes api gave an error', e);
        emit(ErrorState(
          error: Errors(
            ErrorType.appError,
            e is Error ? e : null,
            null,
          ),
        ));
        return;
      }

      emit(const InitState(isInitialized: true));
    });

    on<GetRoutesAction>((event, emit) async {
      logger.i('on GetRoutesAction');

      emit(const IsLoadingState());
      logger.i('started loading in GetRoutesAction');
      try {
        //check internet connection
        final ConnectivityResult connectivityResult =
            await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          emit(ErrorState(
            error: Errors(
              ErrorType.networkConnection,
              null,
              null,
            ),
          ));
          return;
        }
      } catch (e) {
        logger.e('connectivity gave an error', e);
        emit(ErrorState(
          error: Errors(
            ErrorType.appError,
            e is Error ? e : null,
            null,
          ),
        ));
        return;
      }

      if (AppCache.instance().busRoutesIsComplete) {
        emit(RoutesReadyState(
          routes: AppCache.instance().busRoutes!,
        ));
        return;
      }

      ApiResponse<Iterable<BusRoutes>?> routesResponse;
      try {
        routesResponse = await busRoutesApi.getBusRoutes();
        AppCache.instance().busRoutes = routesResponse.data;
        AppCache.instance().busRoutesIsComplete = true;
      } catch (e) {
        logger.e('routes api gave an error', e);
        emit(ErrorState(
          error: Errors(
            ErrorType.appError,
            e is Error ? e : null,
            null,
          ),
        ));
        return;
      }
      if (routesResponse.data == null) {
        logger.e('routes api gave an error');
        emit(ErrorState(
          error: Errors(
            ErrorType.apiError,
            null,
            routesResponse,
          ),
        ));
        return;
      }

      emit(RoutesReadyState(
        routes: routesResponse.data!,
      ));

      //save routes to local db
    });

    on<GetStopsAction>((event, emit) async {
      logger.i('on GetStopsAction');

      emit(const IsLoadingState());
      logger.i('started loading in GetStopsAction');

      //try to get routeQuaryInfo from local db
      RoutesQuaryData? routeQuaryDb =
          await busRoutesQuaryDB.getRouteQuaryInfo(event.busRoute.routeId);
      if (routeQuaryDb != null) {
        var routeQuaryInfo = RouteQuaryInfo(
          routeId: routeQuaryDb.routeId,
          routeHeadSign: "",
          shapeId: routeQuaryDb.shapeId,
          departureIndex: routeQuaryDb.departureIndex,
          destinationIndex: routeQuaryDb.destinationIndex,
          fullStopQuaryInfo: routeQuaryDb.fullStops,
          dateTime: event.dateTime,
          fromLocal: true,
        );
        logger.i('got routeQuaryInfo from local db');
        //emiting stop picker state and returning
        emit(StopPickerState(
          quaryInfo: routeQuaryInfo,
          isStopPickerDialogOpen: true,
        ));
        return;
      }

      //add bus Route to busRoutes
      try {
        await busRoutesDB.saveBusRoute(event.busRoute);
      } catch (e) {
        logger.e('failed to save bus route to local db', e);
      }

      final extendedRoutesResponse =
          await extendedRoutesApi.getExtendedRoutes(event.busRoute.routeId);
      if (extendedRoutesResponse.data == null) {
        logger.i('extendedRoutes api gave an error');
        emit(ErrorState(
          error: Errors(
            ErrorType.apiError,
            null,
            extendedRoutesResponse,
          ),
        ));
        return;
      }
      final stopsResponse =
          await busStopsApi.getBusStops(extendedRoutesResponse.data!);
      if (stopsResponse.data == null) {
        logger.i('stops api gave an error');
        emit(ErrorState(
          error: Errors(
            ErrorType.apiError,
            null,
            stopsResponse,
          ),
        ));
        return;
      }

      Iterable<StopQuaryInfo> fullStopQuaryInfo =
          StopQuaryInfo.createStopQuaryInfo(
        stopsResponse.data!,
        extendedRoutesResponse.data!.stopTimes,
      );

      RouteQuaryInfo quaryInfo = RouteQuaryInfo(
        routeId: event.busRoute.routeId,
        routeHeadSign: extendedRoutesResponse.data!.routeHeadSign,
        shapeId: extendedRoutesResponse.data!.shapeId,
        fullStopQuaryInfo: fullStopQuaryInfo.toList(),
        departureIndex: -1,
        destinationIndex: -1,
        dateTime: event.dateTime,
        fromLocal: false,
      );

      emit(StopPickerState(
        quaryInfo: quaryInfo,
        isStopPickerDialogOpen: true,
      ));
      logger.i('finished loading in GetStopsAction');
    });

    on<StopPickerClosedAction>((event, emit) async {
      logger.i("on StopPickerClosedAction");

      if (event.quaryInfo.dateTime == null) {
        logger.i('dateTime is null');
      } else {
        logger.i('dateTime is not null');
      }

      emit(const IsLoadingState());
      ApiResponse<String> shapeResponse;
      String shapeStr;
      if (event.quaryInfo.fromLocal!) {
        final routeQuaryInfo =
            await busRoutesQuaryDB.getRouteQuaryInfo(event.quaryInfo.routeId!);
        shapeStr = routeQuaryInfo!.shapeStr!;
      } else {
        shapeResponse = await busShapeApi.getShapes(event.quaryInfo.shapeId!);
        if (shapeResponse.data == null) {
          logger.i('shape api gave an error');
          emit(ErrorState(
            error: Errors(
              ErrorType.apiError,
              null,
              shapeResponse,
            ),
          ));
          return;
        }
        shapeStr = shapeResponse.data!;
      }
      RoutesQuaryData routesQuaryData;
      routesQuaryData = RoutesQuaryData(
        routeId: event.quaryInfo.routeId!,
        shapeId: event.quaryInfo.shapeId!,
        shapeStr: shapeStr,
        departureIndex: event.quaryInfo.departureIndex!,
        destinationIndex: event.quaryInfo.destinationIndex!,
        fullStops: event.quaryInfo.fullStopQuaryInfo!.toList(),
      );
      //sublist that includes the first and last stop
      late final DateTime dateTime;
      if (event.quaryInfo.dateTime == null) {
        logger.i('dateTime is null');
        dateTime = DateTime.now();
      } else {
        dateTime = event.quaryInfo.dateTime!;
      }

      int departureIndex;
      int destinationIndex;
      if (event.quaryInfo.departureIndex == -1 &&
          event.quaryInfo.destinationIndex == -1) {
        //departure and destination not given
        departureIndex = 0;
        destinationIndex = event.quaryInfo.fullStopQuaryInfo!.length - 1;
      } else if (event.quaryInfo.destinationIndex == -1) {
        // only one stop input - destination is beggining, departure is the input
        departureIndex = 0;
        destinationIndex = event.quaryInfo.fullStopQuaryInfo!.length - 1;
      } else {
        //both stops given
        departureIndex = event.quaryInfo.departureIndex!;
        destinationIndex = event.quaryInfo.destinationIndex! + 1;
      }

      List<(Point, DateTime)> poinsWithTime = createPointsTimeTuple(
              event.quaryInfo.fullStopQuaryInfo!
                  .toList()
                  .sublist(departureIndex, destinationIndex),
              event.quaryInfo.fullStopQuaryInfo!.first,
              dateTime)
          .toList();

      final resultsResponse = await resultsApi.getSittingResults(
        shapeStr,
        poinsWithTime,
        dateTime,
      );

      if (resultsResponse.data == null) {
        emit(ErrorState(
          error: Errors(
            ErrorType.apiError,
            null,
            resultsResponse,
          ),
        ));
        return;
      }

      BusRoutes busRoute;
      try {
        busRoute = AppCache.instance().busRoutes!.firstWhere(
            (element) => element.routeId == event.quaryInfo.routeId);
      } catch (e) {
        logger.e('error in AddRouteToHistoryAction error', e);
        emit(ErrorState(
          error: Errors(
            ErrorType.appError,
            e is Error ? e : null,
            null,
          ),
        ));
        return;
      }
      emit(AddedHistoryRouteState(busRoute: busRoute));

      emit(ResultsState(
        quaryInfo: event.quaryInfo,
        hasResults: true,
        sittingInfo: resultsResponse.data,
      ));

      //save routeQuaryInfo to local db
      try {
        busRoutesQuaryDB.saveRouteQuaryInfo(routesQuaryData);
        historyIdsDB.saveHistoryId(event.quaryInfo.routeId!);
        logger.i('saved routeQuaryInfo to local routes and history db');
      } catch (e) {
        logger.e('error saving routeQuaryInfo to local db', e);
      }
    });

    on<NoRouteFoundAction>((event, emit) {
      logger.i("on NoRouteFoundAction");

      emit(ErrorState(
        error: Errors(
          ErrorType.appError,
          null,
          null,
        ),
      ));
    });

    on<NavigatedToBookmarksAction>((event, emit) async {
      logger.i("on NavigatedToBookmarksAction");
      emit(const IsLoadingState());

      Iterable<BusRoutes>? busRoutes = AppCache.instance().busRoutes;
      if (busRoutes == null) {
        logger.i('busRoutes is null in NavigatedToBookmarksAction');
        try {
          busRoutes = await busRoutesDB.getBusRoutes();
          AppCache.instance().busRoutes = busRoutes;
          logger.i('got busRoutes from db');
        } catch (e) {
          logger.e('error in NavigatedToBookmarksAction error', e);
          emit(ErrorState(
            error: Errors(
              ErrorType.appError,
              null,
              null,
            ),
          ));
          return;
        }
      }
      Iterable<int> historyRouteIds;
      Iterable<int> favoriteRouteIds;
      List<BusRoutes>? historyRoutes;
      List<BusRoutes>? favoriteRoutes;
      try {
        favoriteRouteIds = await favoritesIdsDB.getFavoriteIds();
        favoriteRoutes = busRoutes
            .where((element) => favoriteRouteIds.contains(element.routeId))
            .toList();
        historyRouteIds = await historyIdsDB.getHistoryIds();
        historyRoutes = busRoutes
            .where((element) => historyRouteIds.contains(element.routeId))
            .toList();
        logger.i('got history and favorite routes');
      } catch (e) {
        logger.e('error in NavigatedToBookmarksAction error', e);
        emit(ErrorState(
          error: Errors(
            ErrorType.appError,
            e is Error ? e : null,
            null,
          ),
        ));
        return;
      }

      emit(BookmarksState(
        historyRoutes: historyRoutes,
        favoriteRoutes: favoriteRoutes,
      ));
      logger.i('emitting BookmarksState');
    });

    on<AddRouteToFavoritsAction>((event, emit) async {
      logger.i("on AddToBookmarksAction");
      //no need for a ui loading state
      //emit(const IsLoadingState());

      BusRoutes busRoute;
      try {
        int saveFavRes =
            await favoritesIdsDB.saveFavoriteId(event.busRoute.routeId);
        logger.i('saveFavRes: $saveFavRes');
        busRoute = AppCache.instance()
            .busRoutes!
            .firstWhere((element) => element.routeId == event.busRoute.routeId);
        await busRoutesDB.saveBusRoute(busRoute);
      } catch (e) {
        logger.e('error in AddToBookmarksAction error', e);
        emit(ErrorState(
          error: Errors(
            ErrorType.appError,
            e is Error ? e : null,
            null,
          ),
        ));
        return;
      }
      emit(AddedFavoriteState(busRoute: busRoute));
    });

    on<RemoveRouteFromFavoritesAction>((event, emit) async {
      logger.i("on RemoveRouteFromFavoritesAction");
      emit(const IsLoadingState());

      BusRoutes busRoute;
      try {
        await favoritesIdsDB.deleteFavoriteId(event.routeId);
        busRoute = AppCache.instance()
            .busRoutes!
            .firstWhere((element) => element.routeId == event.routeId);
      } catch (e) {
        logger.i('error in RemoveRouteFromFavoritesAction error', e);
        emit(ErrorState(
          error: Errors(
            ErrorType.appError,
            e is Error ? e : null,
            null,
          ),
        ));
        return;
      }
      emit(RemovedFavoriteState(busRoute: busRoute));
    });
  }
}
