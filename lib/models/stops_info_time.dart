import 'package:sun_be_gone/models/stop_info.dart';

class StopInfoTime {
  int stopId;
  String stopName;
  double stopLat;
  double stopLon;
  DateTime time;

  StopInfoTime(StopInfo stopInfo, DateTime dateTime)
      : stopId = stopInfo.stopId,
        stopName = stopInfo.stopName,
        stopLat = stopInfo.stopLat,
        stopLon = stopInfo.stopLon,
        time = dateTime;

 @override
 String toString() {
   return 'StopInfoTime: $stopId, $stopName, $stopLat, $stopLon, $time';
 }
}
