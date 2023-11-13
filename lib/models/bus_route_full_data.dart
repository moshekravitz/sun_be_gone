import 'dart:convert';

import 'package:sun_be_gone/models/route_quary_info.dart';

class RoutesQuaryData {
  final int routeId;
  final List<StopQuaryInfo>? stops;
  final List<StopQuaryInfo> fullStops;
  final int shapeId;
  final String? shapeStr;

  RoutesQuaryData({
    required this.routeId,
    required this.stops,
    required this.fullStops,
    required this.shapeId,
    required this.shapeStr,
  });

  factory RoutesQuaryData.fromJson(Map<String, dynamic> json) {
    print('json stops: ${json['stops']}');
    print('json decoded stops: ${jsonDecode(json['stops'])}');
    var stops = json['stops'];
    print('stops: $stops');
    return RoutesQuaryData(
      routeId: json['routeId'] as int,
      stops: (stops is List<dynamic>)
          ? (jsonDecode(json['stops']) as List<dynamic>)
              .map((e) => StopQuaryInfo.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
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
      'stops': stops?.map((e) => e.toMap()).toList(),
      'fullStops': fullStops.map((e) => e.toMap()).toList(),
      'shapeId': shapeId,
      'shapeStr': shapeStr,
    };
  }
}
