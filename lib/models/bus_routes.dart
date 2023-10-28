import 'package:sun_be_gone/models/extended_routes.dart';
import 'package:sun_be_gone/models/stop_info.dart';
import 'package:sun_be_gone/models/stop_time.dart';

class BusRoutes {
  int routeId;
  String routeShortName;
  String routeLongName;
  String? routeDeparture;
  String? routeDestination;

  BusRoutes({
    required this.routeId,
    required this.routeShortName,
    required this.routeLongName,
  }) {

    routeDeparture = routeLongName.substring(
      1,
      routeLongName.indexOf('<'),
    );
    routeDestination = routeLongName.substring(
      routeLongName.indexOf('>') + 1,
      routeLongName.lastIndexOf('-'),
    );
  }

//to string
  @override
  String toString() {
    return 'BusRoutes{routeId: $routeId, routeShortName: $routeShortName, routeLongName: $routeLongName}';
  }

  factory BusRoutes.fromJson(Map<String, dynamic> json) {
    return BusRoutes(
      routeId: json['routeId'] as int,
      routeShortName: json['routeShortName'] as String,
      routeLongName: json['routeLongName'] as String,
    );
  }
}

final mockBusRoutes = Iterable.generate(
  3,
  (i) => BusRoutes(
    routeId: i,
    routeShortName: '${i}00',
    routeLongName: 'Route number ${i + 1}',
  ),
);
