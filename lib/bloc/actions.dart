import 'package:flutter/foundation.dart' show immutable;
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sun_be_gone/models/nav_index.dart';
import 'package:sun_be_gone/models/route_quary_info.dart';
import 'package:sun_be_gone/models/stops_info_time.dart';

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
  final int routeId;
  final DateTime? dateTime;
  const GetStopsAction({required this.routeId, this.dateTime});
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
  final String routeId;
  const AddRouteToFavoritsAction({required this.routeId});
}

@immutable
class RemoveRouteFromFavoritesAction extends AppAction {
  final String routeId;
  const RemoveRouteFromFavoritesAction({required this.routeId});
}

@immutable
class AddRouteToHistoryAction extends AppAction {
  final String routeId;
  const AddRouteToHistoryAction({required this.routeId});
}

@immutable
class RemoveRouteFromHistoryAction extends AppAction {
  final String routeId;
  const RemoveRouteFromHistoryAction({required this.routeId});
}
