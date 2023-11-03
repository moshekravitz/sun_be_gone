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
  final RouteQuaryInfo? quaryInfo;
  final Errors? error;

  const DataState({
    required super.navIndex,
    required super.isLoading,
    required super.isInitialized,
    this.quaryInfo,
    this.error,
  });

  DataState.init()
      : this(
            quaryInfo: null,
            navIndex: NavIndex(Pages.home),
            isLoading: false,
            isInitialized: false);
}

class StopPickerState extends DataState {
  final bool isStopPickerDialogOpen;

  const StopPickerState({
    required super.navIndex,
    required super.isLoading,
    required super.isInitialized,
    required super.quaryInfo,
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
    required super.quaryInfo,
    required this.hasResults,
    this.sittingInfo,
    super.error,
  });
}

class BookmarksState extends DataState {
  final Iterable<BusRoutes> historyRoutes;
  final Iterable<BusRoutes> bookmarksRoutes;

  const BookmarksState({
    required super.navIndex,
    required super.isLoading,
    required super.isInitialized,
    required super.quaryInfo,
    required this.historyRoutes,
    required this.bookmarksRoutes,
    super.error,
  });
}
