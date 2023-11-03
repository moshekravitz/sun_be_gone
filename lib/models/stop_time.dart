
class StopTime {
  int stopId;
  String stopInterval;
  StopTime({required this.stopId, required this.stopInterval});

  @override
  String toString() {
    return 'StopTime{stopId: $stopId, stopInterval: $stopInterval}';
  }

  factory StopTime.fromJson(Map<String, dynamic> json) {
    return StopTime(
      stopId: json['stopId'] as int,
      stopInterval: json['stopInterval'] as String,
    );
  }
}

