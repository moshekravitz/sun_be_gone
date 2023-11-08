import 'package:intl/intl.dart';
import 'package:sun_be_gone/models/route_quary_info.dart';
import 'package:sun_business/sun_business.dart';

Iterable<Tuple<Point, DateTime>> createPointsTimeTuple(
    Iterable<StopQuaryInfo> stopQuaryInfo,
    StopQuaryInfo firstRouteStop,
    DateTime dateTime) {
  List<Tuple<Point, DateTime>> pointsTimeTuple = [];

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
      Tuple<Point, DateTime>(
        point,
        dateTime,
      ),
    );
  }

  DateTime firstPointTime = pointsTimeTuple.first.second;

  return pointsTimeTuple.map((e) {
    Duration timeDifference = e.second.difference(firstPointTime);
    return Tuple(e.first, dateTime.add(timeDifference));
  });
  //return pointsTimeTuple;
}
