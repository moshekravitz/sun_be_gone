import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:sun_be_gone/bloc/actions.dart';
import 'package:sun_be_gone/bloc/app_state.dart';
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sun_be_gone/models/nav_index.dart';
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
      String checkLive = await serverConnectionApi.checkLive();
      if(checkLive == 'false') {
          emit(DataState(
          isInitialized: true,
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

    on<NavigationAction>((event, emit) => emit(AppState(
          isInitialized: state.isInitialized,
          isLoading: false,
          navIndex: NavIndex(event.pageIndex),
        )));

    on<GetRoutesAction>((event, emit) async {
      //print('appstate is DataState:' + (state is DataState).toString());
      emit(DataState(
        isInitialized: state.isInitialized,
        isLoading: true,
        navIndex: state.navIndex,
        routes: null,
        extendedRoutes: null,
        stops: null,
      ));

      final routes = await busRoutesApi.getBusRoutes();

      emit(DataState(
        isInitialized: state.isInitialized,
        isLoading: false,
        navIndex: NavIndex(event.pageIndex),
        routes: routes,
        extendedRoutes: null,
        stops: null,
      ));
    });

    on<FilterRoutesAction>((event, emit) {
      if (state is! DataState) return;
      final dataState = state as DataState;
     // final filteredRoutes = dataState.routes?.where((route) =>
      //    route!.routeShortName.toLowerCase().contains(event.filter!));
      final filteredRoutes = dataState.routes?.where(event.filterFunction);

      print('filteredRoutes length: ' + filteredRoutes!.length.toString());

      emit(DataState(
        isInitialized: state.isInitialized,
        isLoading: false,
        navIndex: state.navIndex,
        routes: filteredRoutes,
        extendedRoutes: dataState.extendedRoutes,
        stops: dataState.stops,
      ));
    });

    on<GetStopsAction>((event, emit) async {
      if (state is! DataState) {
        print('appstate is DataState:' + (state is DataState).toString());
        print('the state is not DataState in GetExtendedRouteAction');
        return;
      }
      final dataState = state as DataState;
      emit(DataState(
        isInitialized: state.isInitialized,
        isLoading: true,
        navIndex: state.navIndex,
        routes: dataState.routes,
        extendedRoutes: dataState.extendedRoutes,
        stops: null,
      ));

      final extendedRoutes =
          await extendedRoutesApi.getExtendedRoutes(event.routeId);
      final stops = await busStopsApi.getBusStops(extendedRoutes!);
      final shape = await busShapeApi.getShapes(extendedRoutes.shapeId);

      final dataState2 = state as DataState;

      emit(StopPickerState(
        isInitialized: state.isInitialized,
        isLoading: false,
        navIndex: state.navIndex,
        routes: dataState2.routes,
        extendedRoutes: extendedRoutes,
        stops: stops,
        shape: shape,
        isStopPickerDialogOpen: true,
      ));
    });

    on<StopPickerClosedAction>((event, emit) async {
      if (state is! DataState) return;
      final dataState = state as DataState;

      emit(StopPickerState(
        isInitialized: state.isInitialized,
        isLoading: true,
        navIndex: state.navIndex,
        routes: dataState.routes,
        extendedRoutes: dataState.extendedRoutes,
        stops: dataState.stops,
        shape: dataState.shape,
        isStopPickerDialogOpen: false,
      ));

      final dataState2 = state as DataState;

      List stopsList = dataState.stops as List;

      Point firstStopPoint = Point(
        stopsList.first.stopLat,
        stopsList.first.stopLon,
      );
      Point lastStopPoint = Point(
        stopsList.last.stopLat,
        stopsList.last.stopLon,
      );
      final results = await resultsApi.getSittingResults(
        dataState.shape!,
        firstStopPoint,
        lastStopPoint,
      );

      emit(ResultsState(
        isInitialized: state.isInitialized,
        isLoading: false,
        navIndex: NavIndex(Pages.results),
        routes: dataState2.routes,
        extendedRoutes: dataState2.extendedRoutes,
        stops: dataState2.stops,
        shape: dataState2.shape,
        hasResults: true,
        sittingInfo: results,
      ));
    });
  }
}
