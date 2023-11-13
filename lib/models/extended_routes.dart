import 'package:sun_be_gone/models/stop_time.dart';

class ExtendedRoutes {
  int routeId;
  String routeHeadSign;
  int shapeId;
  List<StopTime> stopTimes;
  ExtendedRoutes(
      {required this.routeId,
      required this.routeHeadSign,
      required this.shapeId,
      required this.stopTimes});

  @override
  String toString() {
    return 'ExtendedRoutes{routeId: $routeId, routeHeadSign: $routeHeadSign, shapeId: $shapeId, stopTimes: $stopTimes}';
  }

  factory ExtendedRoutes.fromJson(Map<String, dynamic> json) {
    return ExtendedRoutes(
      routeId: json['routeId'] as int,
      routeHeadSign: json['routeHeadSign'] as String,
      shapeId: json['shapeId'] as int,
      stopTimes: (json['stopTimes'] as List).map((e) => StopTime.fromJson(e)).toList(),
    );
  }
}

final mockExtendedRoute = ExtendedRoutes(
  routeId: 1,
  routeHeadSign: 'Route 1',
  shapeId: 1,
  stopTimes: Iterable.generate(
    10,
    (i) => StopTime(
      stopId: i,
      stopInterval: '00:00',
    ),
  ).toList(),
);

