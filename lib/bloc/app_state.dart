import 'package:flutter/foundation.dart';
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sun_be_gone/models/extended_routes.dart';
import 'package:sun_be_gone/models/nav_index.dart';
import 'package:sun_be_gone/models/stop_info.dart';
import 'package:sun_business/position_calc.dart' show Point;
import 'package:sun_business/sun_business.dart' show SittingInfo;

enum Errors { serverDown, noResults, noStops, noRoutes, noShape, noExtendedRoutes }

@immutable
class AppState {
  final NavIndex navIndex;
  final bool isLoading;
  final bool isInitialized;

  const AppState({
    required this.isLoading,
    required this.isInitialized,
    required this.navIndex,
  });
}

@immutable
class DataState extends AppState {
  final Iterable<BusRoutes?>? routes;
  final ExtendedRoutes? extendedRoutes;
  final Iterable<StopInfo?>? stops;
  final List<Point>? shape;
  final Errors? error;

  const DataState({
    required super.navIndex,
    required super.isLoading,
    required super.isInitialized,
    this.routes,
    this.extendedRoutes,
    this.stops,
    this.shape,
    this.error,
  });

  DataState.init()
      : this(
            routes: null,
            extendedRoutes: null,
            stops: null,
            shape: null,
            navIndex: NavIndex(Pages.home),
            isLoading: false,
            isInitialized: false);
}

class BusResultState extends DataState {

  const BusResultState({
    required super.navIndex,
    required super.isLoading,
    required super.isInitialized,
    required super.routes,
    required super.extendedRoutes,
    required super.stops,
    required super.shape,
    super.error,
  });
}

class StopPickerState extends DataState {
  final bool isStopPickerDialogOpen;

  const StopPickerState({
    required super.navIndex,
    required super.isLoading,
    required super.isInitialized,
    required super.routes,
    required super.extendedRoutes,
    required super.stops,
    required super.shape,
    required this.isStopPickerDialogOpen,
    super.error,
  });
}

class ResultsState extends DataState {
  final bool hasResults;
  final SittingInfo? sittingInfo;

  const ResultsState({
    required super.navIndex,
    required super.isLoading,
    required super.isInitialized,
    required super.routes,
    required super.extendedRoutes,
    required super.stops,
    required super.shape,
    required this.hasResults,
    this.sittingInfo,
    super.error,
  });
}
