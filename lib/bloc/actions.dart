import 'package:flutter/foundation.dart' show immutable;
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sun_be_gone/models/nav_index.dart';
import 'package:sun_be_gone/models/route_quary_info.dart';

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
class GetRoutesAction extends AppAction{
  const GetRoutesAction();
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
  //final int routeId;
  final BusRoutes busRoute;
  final DateTime? dateTime;
  const GetStopsAction({required this.busRoute, this.dateTime});
}

class DateTimePickedAction extends AppAction {
  final DateTime dateTime;
  const DateTimePickedAction({required this.dateTime});
}

@immutable
class StopPickerClosedAction extends AppAction {
  final RouteQuaryInfo quaryInfo;
  final int departureIndex;
  final int destinationIndex;
  const StopPickerClosedAction({
    required this.quaryInfo,
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

@immutable
class AddRouteToFavoritsAction extends AppAction {
  //final int routeId;
  final BusRoutes busRoute;
  const AddRouteToFavoritsAction({required this.busRoute});
}

@immutable
class RemoveRouteFromFavoritesAction extends AppAction {
  final int routeId;
  const RemoveRouteFromFavoritesAction({required this.routeId});
}

@immutable
class AddRouteToHistoryAction extends AppAction {
  //final int routeId;
  final BusRoutes busRoute;
  const AddRouteToHistoryAction({required this.busRoute});
}

@immutable
class RemoveRouteFromHistoryAction extends AppAction {
  final int routeId;
  const RemoveRouteFromHistoryAction({required this.routeId});
}
