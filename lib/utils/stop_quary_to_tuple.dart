import 'package:intl/intl.dart';
import 'package:sun_be_gone/models/route_quary_info.dart';
import 'package:sun_business/sun_business.dart';

Iterable<(Point, DateTime)> createPointsTimeTuple(
    Iterable<StopQuaryInfo> stopQuaryInfo,
    StopQuaryInfo firstRouteStop,
    DateTime dateTime) {
  List<(Point, DateTime)> pointsTimeTuple = [];

  for (var item in stopQuaryInfo) {
    String stopInterval = item.stopInterval;
    String timeStr = stopInterval.substring(stopInterval.indexOf(';') + 1);

    Point point = Point(
      item.stopLon,
      item.stopLat,
    );
    //DateTime dateTime = DateTime.parse(stopInterval.elementAt(1));
    DateTime dateTime = DateFormat('HH:mm:ss').parse(timeStr);

    pointsTimeTuple.add(
      (point, dateTime),
    );
  }

  DateTime firstPointTime = pointsTimeTuple.first.$2;

  return pointsTimeTuple.map((e) {
    Duration timeDifference = e.$2.difference(firstPointTime);
    return (e.$1, dateTime.add(timeDifference));
  });
  //return pointsTimeTuple;
}
