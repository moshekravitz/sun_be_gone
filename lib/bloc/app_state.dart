import 'package:flutter/foundation.dart';
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sun_be_gone/models/extended_routes.dart';
import 'package:sun_be_gone/models/nav_index.dart';
import 'package:sun_be_gone/models/route_quary_info.dart';
import 'package:sun_be_gone/models/stop_info.dart';
import 'package:sun_business/position_calc.dart' show Point;
import 'package:sun_business/sun_business.dart' show SittingInfo;

enum Errors {
  error,
  serverDown,
  noResults,
  noStops,
  noRoutes,
  noShape,
  noExtendedRoutes,
}

@immutable
class AppState {
  const AppState();
}

class InitState extends AppState {
  final bool isInitialized;
  const InitState({
    required this.isInitialized,
  });
}

class RoutesReadyState extends AppState {
  final Iterable<BusRoutes> routes;
  const RoutesReadyState({
    required this.routes,
  });
}

/*class NavState extends AppState {
  final NavIndex navIndex;
  const NavState({
    required this.navIndex,
  });
}*/

class IsLoadingState extends AppState {
  const IsLoadingState();
}

class ErrorState extends AppState {
  final Errors error;
  const ErrorState({
    required this.error,
  });
}

@immutable
class DataState extends AppState {
  final RouteQuaryInfo? quaryInfo;

  const DataState({
    this.quaryInfo,
  });
}

class StopPickerState extends DataState {
  final bool isStopPickerDialogOpen;

  const StopPickerState({
    required super.quaryInfo,
    required this.isStopPickerDialogOpen,
  });
}

class ResultsState extends DataState {
  final bool hasResults;
  final SittingInfo? sittingInfo;

  const ResultsState({
    required super.quaryInfo,
    required this.hasResults,
    this.sittingInfo,
  });
}

class BookmarksState extends AppState {
  final List<BusRoutes> favoriteRoutes;
  final List<BusRoutes> hisrotyRoutes;
  const BookmarksState({
    required this.favoriteRoutes,
    required this.hisrotyRoutes,
  });
}

class AddedFavoriteState extends AppState {
  final BusRoutes busRoute;
  const AddedFavoriteState({
    required this.busRoute,
  });
}

class AddedHistoryRouteState extends AppState {
  final BusRoutes busRoute;
  const AddedHistoryRouteState({
    required this.busRoute,
  });
}

class RemovedFavoriteState extends AppState {
  final BusRoutes busRoute;
  const RemovedFavoriteState({
    required this.busRoute,
  });
}
