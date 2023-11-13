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

  factory StopQuaryInfo.fromJson(Map<String, dynamic> json) {
    return StopQuaryInfo(
      stopId: json['stopId'] as int,
      stopName: json['stopName'] as String,
      stopLat: json['stopLat'] as double,
      stopLon: json['stopLon'] as double,
      stopInterval: json['stopInterval'] as String,
    );
  }

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

  Map<String, dynamic> toMap() {
    return {
      'stopId': stopId,
      'stopName': stopName,
      'stopLat': stopLat,
      'stopLon': stopLon,
      'stopInterval': stopInterval,
    };
  }
}

class RouteQuaryInfo {
  int? routeId;
  String? routeHeadSign;
  int? shapeId;
  int? departureIndex;
  int? destinationIndex;
  Iterable<StopQuaryInfo>? fullStopQuaryInfo;
  DateTime? dateTime;
  bool? fromLocal;

  RouteQuaryInfo({
    required this.routeId,
    required this.routeHeadSign,
    required this.shapeId,
    required this.departureIndex,
    required this.destinationIndex,
    required this.fullStopQuaryInfo,
    required this.dateTime,
    required this.fromLocal,
  });

  RouteQuaryInfo.empty() {
    routeId = null;
    routeHeadSign = null;
    shapeId = null;
    departureIndex = null;
    destinationIndex = null;
    fullStopQuaryInfo = null;
    dateTime = null;
    fromLocal = null;
  }

  Map<String, dynamic> toMap() {
    return {
      'routeId': routeId,
      'routeHeadSign': routeHeadSign,
      'shapeId': shapeId,
      'departureIndex': departureIndex,
      'destinationIndex': destinationIndex,
      'fullStopQuaryInfo': fullStopQuaryInfo,
      'dateTime': dateTime,
      'fromLocal': fromLocal,
    };
  }

  @override
  String toString() {
    return 'RouteQuaryInfo{routeId: $routeId, routeHeadSign: $routeHeadSign, shapeStr: $shapeId, departureINdex: $departureIndex, destinationIndex $destinationIndex, fullStopQuaryInfo: $fullStopQuaryInfo, currentTime: $dateTime, fromLocal: $fromLocal}';
  }

  bool quaryInfoIsReady() {
    return (shapeId != null && fullStopQuaryInfo != null && dateTime != null);
  }

  RouteQuaryInfo copyWithObj({required RouteQuaryInfo quaryInfo}) {
    return RouteQuaryInfo(
      routeId: quaryInfo.routeId ?? routeId,
      routeHeadSign: quaryInfo.routeHeadSign ?? routeHeadSign,
      shapeId: quaryInfo.shapeId ?? shapeId,
      departureIndex: quaryInfo.departureIndex ?? departureIndex,
      destinationIndex: quaryInfo.destinationIndex ?? destinationIndex,
      fullStopQuaryInfo: quaryInfo.fullStopQuaryInfo ?? fullStopQuaryInfo,
      fromLocal: quaryInfo.fromLocal ?? fromLocal,
      dateTime: quaryInfo.dateTime ?? dateTime,
    );
  }

  // copy with
  RouteQuaryInfo copyWith({
    int? routeId,
    String? routeHeadSign,
    int? shapeId,
    int? departureIndex,
    int? destinationIndex,
    List<StopQuaryInfo>? fullStopQuaryInfo,
    DateTime? dateTime,
    bool? fromLocal,
  }) {
    return RouteQuaryInfo(
      routeId: routeId ?? this.routeId,
      routeHeadSign: routeHeadSign ?? this.routeHeadSign,
      shapeId: shapeId ?? this.shapeId,
      departureIndex: departureIndex ?? this.departureIndex,
      destinationIndex: destinationIndex ?? this.destinationIndex,
      fullStopQuaryInfo: fullStopQuaryInfo ?? this.fullStopQuaryInfo,
      dateTime: dateTime ?? this.dateTime,
      fromLocal: fromLocal ?? this.fromLocal,
    );
  }
}
