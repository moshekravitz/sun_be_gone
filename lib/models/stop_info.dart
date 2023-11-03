class StopInfo {
  int stopId;
  String stopName;
  double stopLat;
  double stopLon;

  StopInfo({
    required this.stopId,
    required this.stopName,
    required this.stopLat,
    required this.stopLon,
  });

  @override
  String toString() {
    return 'StopInfo{stopId: $stopId, stopName: $stopName, stopLat: $stopLat, stopLon: $stopLon}';
  }

  factory StopInfo.fromJson(Map<String, dynamic> json) {
    return StopInfo(
      stopId: json['stopId'] as int,
      stopName: json['stopName'] as String,
      stopLat: json['stopLat'].toDouble(), //TODO change to: as double
      stopLon: json['stopLon'].toDouble(), //TODO change to: as double
    );
  }
}

final mockStopInfo = Iterable.generate(
  3,
  (i) => StopInfo(
    stopId: i,
    stopName: 'Stop number ${i + 1}',
    stopLat: 1.0,
    stopLon: 1.0,
  ),
);
