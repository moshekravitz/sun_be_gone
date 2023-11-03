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
  }) : super(DataState.init()) {
    on<InitAppAction>((event, emit) async {
      print('on InitAppAction');
      String checkLive = await serverConnectionApi.checkLive();
      if (checkLive != 'Healthy') {
        emit(DataState(
          isInitialized: true,
          isLoading: false,
          navIndex: NavIndex(Pages.home),
          error: Errors.serverDown,
        ));
      }
      String checkHealth = await serverConnectionApi.checkHealth();
      if (checkHealth != 'Healthy') {
        emit(DataState(
          isInitialized: false,
          isLoading: false,
          navIndex: NavIndex(Pages.home),
          error: Errors.serverDown,
        ));
      }

      emit(DataState(
        isInitialized: true,
        isLoading: false,
        navIndex: NavIndex(Pages.home),
      ));
    });

    on<NavigationAction>((event, emit) {
      print('on NavigationAction');
      emit(AppState(
        isInitialized: state.isInitialized,
        isLoading: false,
        navIndex: NavIndex(event.pageIndex),
      ));
    });

    on<GetStopsAction>((event, emit) async {
      print('on GetStopsAction');
      if (state is! DataState) {
        print('appstate is DataState:${state is DataState}');
        print('the state is not DataState in GetExtendedRouteAction');
        emit(DataState(
          isInitialized: state.isInitialized,
          isLoading: false,
          navIndex: state.navIndex,
          quaryInfo: null,
        ));
      } else {
        print('1 dateTime: ${(state as DataState).quaryInfo?.dateTime}');
        emit(DataState(
          isInitialized: state.isInitialized,
          isLoading: true,
          navIndex: state.navIndex,
          quaryInfo: (state as DataState).quaryInfo,
        ));
        print('2 dateTime: ${(state as DataState).quaryInfo?.dateTime}');
      }

      final dataState = state as DataState;

      final extendedRoutesResponse =
          await extendedRoutesApi.getExtendedRoutes(event.routeId);
      if (extendedRoutesResponse.data == null) {
        print('extendedRoutes api gave an error');
        emit(DataState(
          isInitialized: state.isInitialized,
          isLoading: false,
          navIndex: state.navIndex,
          quaryInfo: dataState.quaryInfo,
          error: Errors.noExtendedRoutes,
        ));
        print('3 dateTime: ${(state as DataState).quaryInfo?.dateTime}');
        return;
      }
      final stopsResponse =
          await busStopsApi.getBusStops(extendedRoutesResponse.data!);
      if (stopsResponse.data == null) {
        print('stops api gave an error');
        emit(DataState(
          isInitialized: state.isInitialized,
          isLoading: false,
          navIndex: state.navIndex,
          quaryInfo: dataState.quaryInfo,
          error: Errors.noStops,
        ));
        print('4 dateTime: ${(state as DataState).quaryInfo?.dateTime}');
        return;
      }
      final shapeResponse =
          await busShapeApi.getShapes(extendedRoutesResponse.data!.shapeId);
      if (shapeResponse.data == null) {
        print('shape api gave an error');
        emit(DataState(
          isInitialized: state.isInitialized,
          isLoading: false,
          navIndex: state.navIndex,
          quaryInfo: dataState.quaryInfo,
          error: Errors.noShape,
        ));
        print('5 dateTime: ${(state as DataState).quaryInfo?.dateTime}');
        return;
      }

      final dataState2 = state as DataState;

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
        dateTime: dataState2.quaryInfo?.dateTime,
      );

      emit(StopPickerState(
        isInitialized: state.isInitialized,
        isLoading: false,
        navIndex: state.navIndex,
        quaryInfo: quaryInfo,
        isStopPickerDialogOpen: true,
      ));
    });

    on<DateTimePickedAction>((event, emit) {
      print("on DateTimePickedAction");

      late final quaryInfo;
      if (state is! DataState || (state as DataState).quaryInfo == null) {
        quaryInfo = RouteQuaryInfo(
          routeId: null,
          routeHeadSign: null,
          shapeStr: null,
          fullStopQuaryInfo: null,
          stopQuaryInfo: null,
          dateTime: event.dateTime,
        );
      } else {
        quaryInfo = (state as DataState).quaryInfo?.copyWith(
              currentTime: event.dateTime,
            );
      }

      emit(DataState(
        isInitialized: state.isInitialized,
        isLoading: false,
        navIndex: state.navIndex,
        quaryInfo: quaryInfo,
      ));
    });

    on<StopPickerClosedAction>((event, emit) async {
      print("on StopPickerClosedAction");
      if (state is! DataState || state is! StopPickerState) {
        print('stopPickerClosedAction state is not DataState');
        emit(DataState(
          isInitialized: state.isInitialized,
          isLoading: false,
          navIndex: state.navIndex,
          quaryInfo: null,
          error: Errors.error,
        ));
      } else {
        print('dateTime: ${(state as DataState).quaryInfo?.dateTime}');
      }
      final dataState = state as DataState;
      if (dataState.quaryInfo!.dateTime == null) {
        print('dateTime is null');
      } else {
        print('dateTime is not null');
      }

      emit(StopPickerState(
        isInitialized: state.isInitialized,
        isLoading: true,
        navIndex: state.navIndex,
        quaryInfo: dataState.quaryInfo,
        isStopPickerDialogOpen: false,
      ));

      final dataState2 = state as DataState;

      List stopsList = dataState.quaryInfo!.fullStopQuaryInfo!.toList();
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
      if (dataState2.quaryInfo!.dateTime == null) {
        print('dateTime is null');
        dateTime = DateTime.now();
      } else {
        dateTime = dataState.quaryInfo!.dateTime!;
      }

      final resultsResponse = await resultsApi.getSittingResults(
        dataState.quaryInfo!.shapeStr!,
        firstStopPoint,
        lastStopPoint,
        dateTime,
      );

      if (resultsResponse.data == null) {
        print('results api gave an error');
        emit(DataState(
          isInitialized: state.isInitialized,
          isLoading: false,
          navIndex: state.navIndex,
          quaryInfo: dataState.quaryInfo,
          error: Errors.noResults,
        ));
        return;
      }

      emit(ResultsState(
        isInitialized: state.isInitialized,
        isLoading: false,
        navIndex: NavIndex(Pages.results),
        quaryInfo: dataState2.quaryInfo,
        hasResults: true,
        sittingInfo: resultsResponse.data,
      ));
    });

    on<NoRouteFoundAction>((event, emit) {
      print("on NoRouteFoundAction");
      if (state is! DataState) return;
      final dataState = state as DataState;

      emit(DataState(
        isInitialized: state.isInitialized,
        isLoading: false,
        navIndex: state.navIndex,
        quaryInfo: dataState.quaryInfo,
        error: Errors.noRoutes,
      ));
    });

    on<NavigatedToBookmarksAction>((event, emit) async {
      print("on NavigatedToBookmarksAction");
      emit(DataState(
        isInitialized: state.isInitialized,
        isLoading: true,
        navIndex: state.navIndex,
        quaryInfo: null,
      ));
      Iterable<BusRoutes>? busRoutes = AppCache.instance().busRoutes;
      if (busRoutes == null) {
        print('busRoutes is null in NavigatedToBookmarksAction');
        emit(DataState(
          isInitialized: state.isInitialized,
          isLoading: false,
          navIndex: state.navIndex,
          quaryInfo: null,
          error: Errors.noRoutes,
        ));
        return;
      }
      Iterable<int> historyRouteIds;
      Iterable<int> bookmarkRouteIds;
      try {
        historyRouteIds =
            (await AppData.getBookmarks()).map((e) => int.parse(e));
        bookmarkRouteIds =
            (await AppData.getHistory()).map((e) => int.parse(e));
      } catch (e) {
        print('error in NavigatedToBookmarksAction error: $e');
        emit(DataState(
          isInitialized: state.isInitialized,
          isLoading: false,
          navIndex: state.navIndex,
          quaryInfo: null,
          error: Errors.noRoutes,
        ));
        return;
      }
      Iterable<BusRoutes>? historyRoutes = busRoutes.where((element) => historyRouteIds.contains(element.routeId));
      Iterable<BusRoutes>? bookmarkRoutes = busRoutes.where((element) => bookmarkRouteIds.contains(element.routeId));

      emit(BookmarksState(
        isInitialized: state.isInitialized,
        isLoading: false,
        navIndex: NavIndex(Pages.bookmarks),
        quaryInfo: null,
        historyRoutes: historyRoutes,
        bookmarksRoutes: bookmarkRoutes,
      ));
    });
  }
}
