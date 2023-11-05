import 'package:bloc/bloc.dart';
import 'package:sun_be_gone/bloc/actions.dart';
import 'package:sun_be_gone/bloc/app_state.dart';
import 'package:sun_be_gone/data/app_cache.dart';
import 'package:sun_be_gone/data/persistent_data.dart';
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sun_be_gone/models/nav_index.dart';
import 'package:sun_be_gone/models/route_quary_info.dart';
import 'package:sun_be_gone/services/bus_extended_route_api.dart';
import 'package:sun_be_gone/services/bus_routes_api.dart';
import 'package:sun_be_gone/services/bus_shape_api.dart';
import 'package:sun_be_gone/services/bus_stops_api.dart';
import 'package:sun_be_gone/services/results_api.dart';
import 'package:sun_be_gone/services/server_connection_api.dart';
import 'package:sun_business/position_calc.dart' show Point;

class AppBloc extends Bloc<AppAction, AppState> {
  final BusRoutesApiProtocol busRoutesApi;
  final ExtendedRouteApiProtocol extendedRoutesApi;
  final BusStopsApiProtocol busStopsApi;
  final BusShapeApiProtocol busShapeApi;
  final ResultsApiProtocol resultsApi;
  final ServerConnectionApiProtocol serverConnectionApi;
  AppBloc({
    required this.busRoutesApi,
    required this.extendedRoutesApi,
    required this.busStopsApi,
    required this.busShapeApi,
    required this.resultsApi,
    required this.serverConnectionApi,
  }) : super(const InitState(isInitialized: false)) {
    on<InitAppAction>((event, emit) async {
      print('on InitAppAction');
      //emit(const IsLoadingState());
      //print('emitted IsLoadingState');
      final routesResponse;
      try {
        String checkLive = await serverConnectionApi.checkLive();
        if (checkLive != 'Healthy') {
          emit(const ErrorState(error: Errors.serverDown));
        }

        String checkHealth = await serverConnectionApi.checkHealth();
        if (checkHealth != 'Healthy') {
          emit(const ErrorState(
            error: Errors.serverDown,
          ));
        }

        routesResponse = await busRoutesApi.getBusRoutes();
        AppCache.instance().busRoutes = routesResponse.data;
      } catch (e) {
        print('routes api gave an error');
        emit(const ErrorState(
          error: Errors.noRoutes,
        ));
        return;
      }
      if (routesResponse.data == null) {
        print('routes api gave an error');
        emit(const ErrorState(
          error: Errors.noRoutes,
        ));
        return;
      }

      emit(const InitState(isInitialized: true));
    });

    on<GetRoutesAction>((event, emit) async {
      print('on GetRoutesAction');

      emit(const IsLoadingState());
      print('started loading in GetRoutesAction');
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
        print('routes api gave an error');
        emit(const ErrorState(
          error: Errors.noRoutes,
        ));
        return;
      }
      if (routesResponse.data == null) {
        print('routes api gave an error');
        emit(const ErrorState(
          error: Errors.noRoutes,
        ));
        return;
      }

      emit(RoutesReadyState(
        routes: routesResponse.data!,
      ));
    });

    on<GetStopsAction>((event, emit) async {
      print('on GetStopsAction');

      emit(const IsLoadingState());
      print('started loading in GetStopsAction');

      final extendedRoutesResponse =
          await extendedRoutesApi.getExtendedRoutes(event.routeId);
      if (extendedRoutesResponse.data == null) {
        print('extendedRoutes api gave an error');
        emit(const ErrorState(
          error: Errors.noExtendedRoutes,
        ));
        return;
      }
      final stopsResponse =
          await busStopsApi.getBusStops(extendedRoutesResponse.data!);
      if (stopsResponse.data == null) {
        print('stops api gave an error');
        emit(const ErrorState(
          error: Errors.noStops,
        ));
        return;
      }
      final shapeResponse =
          await busShapeApi.getShapes(extendedRoutesResponse.data!.shapeId);
      if (shapeResponse.data == null) {
        print('shape api gave an error');
        emit(const ErrorState(
          error: Errors.noShape,
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
        shapeStr: shapeResponse.data!,
        fullStopQuaryInfo: fullStopQuaryInfo.toList(),
        stopQuaryInfo: null,
        dateTime: event.dateTime,
      );

      emit(StopPickerState(
        quaryInfo: quaryInfo,
        isStopPickerDialogOpen: true,
      ));
      print('finished loading in GetStopsAction');
    });

    on<StopPickerClosedAction>((event, emit) async {
      print("on StopPickerClosedAction");

      if (event.quaryInfo.dateTime == null) {
        print('dateTime is null');
      } else {
        print('dateTime is not null');
      }

      emit(const IsLoadingState());

      List stopsList = event.quaryInfo.fullStopQuaryInfo!.toList();
      final Point firstStopPoint;
      final Point lastStopPoint;

      if (event.departureIndex == -1 && event.destinationIndex == -1) {
        print('departureIndex and destinationIndex are -1');
        firstStopPoint = Point(
          stopsList.first.stopLon,
          stopsList.first.stopLat,
        );
        lastStopPoint = Point(
          stopsList.last.stopLon,
          stopsList.last.stopLat,
        );
      } else {
        print('departureIndex and destinationIndex are not -1');
        print('departureIndex: ${event.departureIndex}');
        print('destinationIndex: ${event.destinationIndex}');
        firstStopPoint = Point(
          stopsList[event.departureIndex].stopLon,
          stopsList[event.departureIndex].stopLat,
        );
        lastStopPoint = Point(
          stopsList[event.destinationIndex].stopLon,
          stopsList[event.destinationIndex].stopLat,
        );
      }

      late final DateTime dateTime;
      if (event.quaryInfo.dateTime == null) {
        print('dateTime is null');
        dateTime = DateTime.now();
      } else {
        dateTime = event.quaryInfo.dateTime!;
      }

      final resultsResponse = await resultsApi.getSittingResults(
        event.quaryInfo.shapeStr!,
        firstStopPoint,
        lastStopPoint,
        dateTime,
      );

      if (resultsResponse.data == null) {
        print('results api gave an error');
        emit(const ErrorState(
          error: Errors.noResults,
        ));
        return;
      }

      BusRoutes busRoute;
      try {
        await AppData.addHistory(event.quaryInfo.routeId.toString());
        busRoute = AppCache.instance().busRoutes!.firstWhere(
            (element) => element.routeId == event.quaryInfo.routeId);
      } catch (e) {
        print('error in AddRouteToHistoryAction error: $e');
        emit(const ErrorState(
          error: Errors.noRoutes,
        ));
        return;
      }
      emit(AddedHistoryRouteState(busRoute: busRoute));

      emit(ResultsState(
        quaryInfo: event.quaryInfo,
        hasResults: true,
        sittingInfo: resultsResponse.data,
      ));
    });

    on<NoRouteFoundAction>((event, emit) {
      print("on NoRouteFoundAction");

      emit(const ErrorState(
        error: Errors.noRoutes,
      ));
    });

    on<NavigatedToBookmarksAction>((event, emit) async {
      print("on NavigatedToBookmarksAction");
      emit(const IsLoadingState());

      Iterable<BusRoutes>? busRoutes = AppCache.instance().busRoutes;
      if (busRoutes == null) {
        print('busRoutes is null in NavigatedToBookmarksAction');
        emit(const ErrorState(
          error: Errors.noRoutes,
        ));
        return;
      }
      Iterable<int> historyRouteIds;
      Iterable<int> favoriteRouteIds;
      List<BusRoutes>? historyRoutes;
      List<BusRoutes>? bookmarkRoutes;
      try {
        favoriteRouteIds =
            (await AppData.getBookmarks()).map((e) => int.parse(e));
        historyRouteIds = (await AppData.getHistory()).map((e) => int.parse(e));
        historyRoutes = busRoutes
            .where((element) => historyRouteIds.contains(element.routeId))
            .toList();
        bookmarkRoutes = busRoutes
            .where((element) => favoriteRouteIds.contains(element.routeId))
            .toList();

        //AppCache.instance().historyBusRoutes = historyRoutes.toList();
        //AppCache.instance().bookmarksBusRoutes = bookmarkRoutes.toList();
      } catch (e) {
        print('error in NavigatedToBookmarksAction error: $e');
        emit(const ErrorState(
          error: Errors.noRoutes,
        ));
        return;
      }

      emit(BookmarksState(
        hisrotyRoutes: historyRoutes,
        favoriteRoutes: bookmarkRoutes,
      ));
    });

    on<AddRouteToFavoritsAction>((event, emit) async {
      print("on AddToBookmarksAction");
      emit(const IsLoadingState());

      BusRoutes busRoute;
      try {
        await AppData.addBookmark(event.routeId);
        busRoute = AppCache.instance().busRoutes!.firstWhere(
            (element) => element.routeId.toString() == event.routeId);
      } catch (e) {
        print('error in AddToBookmarksAction error: $e');
        emit(const ErrorState(
          error: Errors.noRoutes,
        ));
        return;
      }
      emit(AddedFavoriteState(busRoute: busRoute));
    });

    on<RemoveRouteFromFavoritesAction>((event, emit) async {
      print("on RemoveRouteFromFavoritesAction");
      emit(const IsLoadingState());

      BusRoutes busRoute;
      try {
        await AppData.removeBookmark(event.routeId);
        busRoute = AppCache.instance().busRoutes!.firstWhere(
            (element) => element.routeId.toString() == event.routeId);
      } catch (e) {
        print('error in RemoveRouteFromFavoritesAction error: $e');
        emit(const ErrorState(
          error: Errors.noRoutes,
        ));
        return;
      }
      emit(RemovedFavoriteState(busRoute: busRoute));
    });
  }
}
