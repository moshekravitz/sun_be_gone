import 'package:bloc/bloc.dart';
import 'package:sun_be_gone/bloc/actions.dart';
import 'package:sun_be_gone/bloc/app_state.dart';
import 'package:sun_be_gone/data/app_cache.dart';
import 'package:sun_be_gone/data/persistent_data.dart';
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
import 'package:sun_business/sun_business.dart' show Point, Tuple;

class AppBloc extends Bloc<AppAction, AppState> {
  final BusRoutesApiProtocol busRoutesApi;
  final ExtendedRouteApiProtocol extendedRoutesApi;
  final BusStopsApiProtocol busStopsApi;
  final BusShapeApiProtocol busShapeApi;
  final ResultsApiProtocol resultsApi;
  final ServerConnectionApiProtocol serverConnectionApi;
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
    required this.busRoutesQuaryDB,
    required this.historyIdsDB,
    required this.favoritesIdsDB,
  }) : super(const InitState(isInitialized: false)) {
    on<InitAppAction>((event, emit) async {
      logger.i('on InitAppAction');
      final ApiResponse<Iterable<BusRoutes>?> routesResponse;
      try {
        ApiResponse<String> checkLive = await serverConnectionApi.checkLive();
        if (checkLive.data != 'Healthy') {
          emit(
              ErrorState(error: Errors(ErrorType.serverDown, null, checkLive)));
        }

        ApiResponse<String> checkHealth =
            await serverConnectionApi.checkHealth();
        if (checkHealth.data != 'Healthy') {
          if (checkHealth.statusCode == 0) {
            emit(ErrorState(
              error: Errors(
                ErrorType.networkConnection,
                null,
                checkHealth,
              ),
            ));
          }
          emit(ErrorState(
            error: Errors(
              ErrorType.serverDown,
              null,
              checkHealth,
            ),
          ));
        }

        routesResponse = await busRoutesApi.getBusRoutes();
        AppCache.instance().busRoutes = routesResponse.data;
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

      emit(const InitState(isInitialized: true));
    });

    on<GetRoutesAction>((event, emit) async {
      logger.i('on GetRoutesAction');

      emit(const IsLoadingState());
      logger.i('started loading in GetRoutesAction');
      if (AppCache.instance().busRoutes != null) {
        emit(RoutesReadyState(
          routes: AppCache.instance().busRoutes!,
        ));
        return;
      }

      final routesResponse;
      try {
        routesResponse = await busRoutesApi.getBusRoutes();
        AppCache.instance().busRoutes = routesResponse.data;
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
          await busRoutesQuaryDB.getRouteQuaryInfo(event.routeId);
      if (routeQuaryDb != null) {
        var routeQuaryInfo = RouteQuaryInfo(
          routeId: routeQuaryDb.routeId,
          routeHeadSign: "",
          shapeId: routeQuaryDb.shapeId,
          stopQuaryInfo: routeQuaryDb.stops,
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

      final extendedRoutesResponse =
          await extendedRoutesApi.getExtendedRoutes(event.routeId);
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
        routeId: event.routeId,
        routeHeadSign: extendedRoutesResponse.data!.routeHeadSign,
        shapeId: extendedRoutesResponse.data!.shapeId,
        fullStopQuaryInfo: fullStopQuaryInfo.toList(),
        stopQuaryInfo: null,
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
      if (event.departureIndex == -1 && event.destinationIndex == -1) {
        event.quaryInfo.stopQuaryInfo = event.quaryInfo.fullStopQuaryInfo;

        routesQuaryData = RoutesQuaryData(
          routeId: event.quaryInfo.routeId!,
          shapeId: event.quaryInfo.shapeId!,
          shapeStr: shapeStr,
          stops: null,
          fullStops: event.quaryInfo.fullStopQuaryInfo!.toList(),
        );
      } else {
        event.quaryInfo.stopQuaryInfo = event.quaryInfo.fullStopQuaryInfo!
            .toList()
            .sublist(event.departureIndex, event.destinationIndex + 1);

        routesQuaryData = RoutesQuaryData(
          routeId: event.quaryInfo.routeId!,
          shapeId: event.quaryInfo.shapeId!,
          shapeStr: shapeStr,
          stops: event.quaryInfo.stopQuaryInfo!.toList(),
          fullStops: event.quaryInfo.fullStopQuaryInfo!.toList(),
        );
      }

      //sublist that includes the first and last stop
      late final DateTime dateTime;
      if (event.quaryInfo.dateTime == null) {
        logger.i('dateTime is null');
        dateTime = DateTime.now();
      } else {
        dateTime = event.quaryInfo.dateTime!;
      }

      List<Tuple<Point, DateTime>> poinsWithTime = createPointsTimeTuple(
              event.quaryInfo.stopQuaryInfo!,
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
        emit(ErrorState(
          error: Errors(
            ErrorType.appError,
            null,
            null,
          ),
        ));
        return;
      }
      Iterable<int> historyRouteIds;
      Iterable<int> favoriteRouteIds;
      List<BusRoutes>? historyRoutes;
      List<BusRoutes>? favoriteRoutes;
      //try {
      /*
        favoriteRouteIds =
            (await AppData.getBookmarks()).map((e) => int.parse(e));
        historyRouteIds = (await AppData.getHistory()).map((e) => int.parse(e));
        historyRoutes = busRoutes
            .where((element) => historyRouteIds.contains(element.routeId))
            .toList();
        bookmarkRoutes = busRoutes
            .where((element) => favoriteRouteIds.contains(element.routeId))
            .toList();
            */
      favoriteRouteIds = await favoritesIdsDB.getFavoriteIds();
      print('here1');
      favoriteRoutes = busRoutes
          .where((element) => favoriteRouteIds.contains(element.routeId))
          .toList();
      print('here2');
      historyRouteIds = await historyIdsDB.getHistoryIds();
      print('here3');
      historyRoutes = busRoutes
          .where((element) => historyRouteIds.contains(element.routeId))
          .toList();
      try {//TODO put up
        print('here4');
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
    });

    on<AddRouteToFavoritsAction>((event, emit) async {
      logger.i("on AddToBookmarksAction");
      //no need for a ui loading state
      //emit(const IsLoadingState());

      BusRoutes busRoute;
      try {
        /*
        await AppData.addBookmark(event.routeId);
        */
        int saveFavRes = await favoritesIdsDB.saveFavoriteId(event.routeId);
        print('saveFavRes: $saveFavRes');
        busRoute = AppCache.instance()
            .busRoutes!
            .firstWhere((element) => element.routeId == event.routeId);
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
        busRoute = AppCache.instance().busRoutes!.firstWhere(
            (element) => element.routeId.toString() == event.routeId);
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
