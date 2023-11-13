import 'dart:convert';

import 'package:sun_be_gone/models/route_quary_info.dart';

class RoutesQuaryData {
  final int routeId;
  final List<StopQuaryInfo> fullStops;
  final int departureIndex;
  final int destinationIndex;
  final int shapeId;
  final String? shapeStr;

  RoutesQuaryData({
    required this.routeId,
    required this.departureIndex,
    required this.destinationIndex,
    required this.fullStops,
    required this.shapeId,
    required this.shapeStr,
  });

  factory RoutesQuaryData.fromJson(Map<String, dynamic> json) {
    return RoutesQuaryData(
      routeId: json['routeId'] as int,
      departureIndex: json['departureIndex'] as int,
      destinationIndex: json['destinationIndex'] as int,
      fullStops: (jsonDecode(json['fullStops']) as List<dynamic>)
          .map((e) => StopQuaryInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      shapeId: json['shapeId'] as int,
      shapeStr: json['shapeStr'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'routeId': routeId,
      'departureIndex': departureIndex,
      'destinationIndex': destinationIndex,
      'fullStops': fullStops.map((e) => e.toMap()).toList(),
      'shapeId': shapeId,
      'shapeStr': shapeStr,
    };
  }
}
