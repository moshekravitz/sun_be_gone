import 'package:flutter/foundation.dart' show immutable;
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sun_be_gone/models/nav_index.dart';

@immutable
abstract class AppAction {
  const AppAction();
}

@immutable
class InitAppAction extends AppAction {
  const InitAppAction();
}

@immutable
class NavigationAction extends AppAction {
  final Pages pageIndex;

  const NavigationAction({required this.pageIndex});
}

@immutable
class GetRoutesAction extends NavigationAction {
  const GetRoutesAction({required super.pageIndex});
}

@immutable
class FilterRoutesAction extends AppAction {
  final bool Function(BusRoutes?) filterFunction;

  const FilterRoutesAction({required this.filterFunction});
}

@immutable
class GetExtendedRouteAction extends AppAction {
  const GetExtendedRouteAction();
}

@immutable
class GetStopsAction extends AppAction {
  final int routeId;
  const GetStopsAction({required this.routeId});
}

class DateTimePickedAction extends AppAction {
  final DateTime dateTime;
  const DateTimePickedAction({required this.dateTime});
}

@immutable
class StopPickerClosedAction extends AppAction {
  final int departureIndex;
  final int destinationIndex;
  const StopPickerClosedAction({
    required this.departureIndex,
    required this.destinationIndex,
  });
}

@immutable
class NoRouteFoundAction extends AppAction {
  const NoRouteFoundAction();
}

@immutable
class NavigatedToBookmarksAction extends AppAction {
  const NavigatedToBookmarksAction();
}
