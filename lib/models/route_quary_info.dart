import 'package:sun_be_gone/models/stop_info.dart';
import 'package:sun_be_gone/models/stop_time.dart';

class StopQuaryInfo {
  int stopId;
  String stopName;
  double stopLat;
  double stopLon;
  String stopInterval;

  StopQuaryInfo({
    required this.stopId,
    required this.stopName,
    required this.stopLat,
    required this.stopLon,
    required this.stopInterval,
  });

  static Iterable<StopQuaryInfo> createStopQuaryInfo(
      Iterable<StopInfo> stopInfo, Iterable<StopTime> stopTimes) {
    List<StopQuaryInfo> stopQuaryInfo = [];
    for (int i = 0; i < stopInfo.length; i++) {
      stopQuaryInfo.add(StopQuaryInfo(
        stopId: stopInfo.elementAt(i).stopId,
        stopName: stopInfo.elementAt(i).stopName,
        stopLat: stopInfo.elementAt(i).stopLat,
        stopLon: stopInfo.elementAt(i).stopLon,
        stopInterval: stopTimes.elementAt(i).stopInterval,
      ));
    }
    return stopQuaryInfo;
  }
}

class RouteQuaryInfo {
  int? routeId;
  String? routeHeadSign;
  String? shapeStr;
  Iterable<StopQuaryInfo>? stopQuaryInfo;
  Iterable<StopQuaryInfo>? fullStopQuaryInfo;
  DateTime? dateTime;

  RouteQuaryInfo({
    required this.routeId,
    required this.routeHeadSign,
    required this.shapeStr,
    required this.stopQuaryInfo,
    required this.fullStopQuaryInfo,
    required this.dateTime,
  });

  RouteQuaryInfo.empty() {
    routeId = null;
    routeHeadSign = null;
    shapeStr = null;
    stopQuaryInfo = null;
    fullStopQuaryInfo = null;
    dateTime = null;
  }

  @override
  String toString() {
    return 'RouteQuaryInfo{routeId: $routeId, routeHeadSign: $routeHeadSign, shapeStr: $shapeStr, stopQuaryInfo: $stopQuaryInfo, fullStopQuaryInfo: $fullStopQuaryInfo, currentTime: $dateTime}';
  }

  bool quaryInfoIsReady() {
    return (shapeStr != null && stopQuaryInfo != null && dateTime != null);
  }

  RouteQuaryInfo copyWithObj({required RouteQuaryInfo quaryInfo}) {
    return RouteQuaryInfo(
      routeId: quaryInfo.routeId ?? this.routeId,
      routeHeadSign: quaryInfo.routeHeadSign ?? this.routeHeadSign,
      shapeStr: quaryInfo.shapeStr ?? this.shapeStr,
      stopQuaryInfo: quaryInfo.stopQuaryInfo ?? this.stopQuaryInfo,
      fullStopQuaryInfo: quaryInfo.fullStopQuaryInfo ?? this.fullStopQuaryInfo,
      dateTime: quaryInfo.dateTime ?? this.dateTime,
    );
  }

  // copy with
  RouteQuaryInfo copyWith({
    int? routeId,
    String? routeHeadSign,
    String? shapeStr,
    List<StopQuaryInfo>? stopQuaryInfo,
    List<StopQuaryInfo>? fullStopQuaryInfo,
    DateTime? currentTime,
  }) {
    return RouteQuaryInfo(
      routeId: routeId ?? this.routeId,
      routeHeadSign: routeHeadSign ?? this.routeHeadSign,
      shapeStr: shapeStr ?? this.shapeStr,
      stopQuaryInfo: stopQuaryInfo ?? this.stopQuaryInfo,
      fullStopQuaryInfo: fullStopQuaryInfo ?? this.fullStopQuaryInfo,
      dateTime: currentTime ?? this.dateTime,
    );
  }
}
