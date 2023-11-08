//correctTimes but is a extension
import 'package:sun_business/models/point.dart';
import 'package:sun_business/models/sitting_info.dart';

extension PointTimeList on List<Tuple<Point, DateTime>> {
  List<Tuple<Point, DateTime>> correctTimes(DateTime dateTime) {
    DateTime firstPointTime = first.second;
    return map((e) {
      Duration timeDifference = e.second.difference(firstPointTime);
      return Tuple(e.first, dateTime.add(timeDifference));
    }).toList();
  }
}

/*
  List<Tuple<Point, DateTime>> correctTimes(
      List<Tuple<Point, DateTime>> points, DateTime dateTime) {
    DateTime firstPointTime = points.first.second;
    return points.map((e) {
      Duration timeDifference = e.second.difference(firstPointTime);
      return Tuple(e.first, dateTime.add(timeDifference));
    }).toList();
  }
  */



/*
  List<Tuple<Point, DateTime>> addTimeToPoint(
      List<Point> points, List<Tuple<Point, DateTime>> stops) {
    print('here 4');
    /*for(var item in stops){
      print(item);
    }*/
    print('points count: ${points.length}');
    print('stops count: ${stops.length}');
    List<Tuple<Point, DateTime>?> finalPoints = [];

    int lastPointIndex = Point.closestPoint(points, stops.first.first);
    Tuple<Point, DateTime> lastReferencePoint = stops.first;

    print('here 5');
    /*for(var item in stops){
      print(item);
    }
    */
    int place = 0; //TODO remove print counter
    for (int i = 1; i < stops.length; i++) {
      Tuple<Point, DateTime> currentReferencePoint = stops[i];

      int pointIndex = Point.closestPoint(points, currentReferencePoint.first);
      //Tuple<Point, DateTime> point = Tuple(points[pointIndex], stops[i].second);
      //print('lastPointIndex is $lastPointIndex');
      //print('pointIndex is $pointIndex');
      List<Point> pointsBetween;
      try {
        pointsBetween = points.sublist(lastPointIndex, pointIndex);
        if (lastReferencePoint.first.distanceTo(points[pointIndex]) <=
            lastReferencePoint.first.distanceTo(currentReferencePoint.first)) {
          pointsBetween.add(points[pointIndex]);
         pointIndex++;
        }
      } catch (e) {
        print('stop index is $i, stop: ${stops[i]}');

        print(
            'lastPointIndex is $lastPointIndex, point: ${points[lastPointIndex]}');

        print(e);
        throw e;
      }
      //pointsBetween.forEach((element) => print(element));
      double distanceBetween =
          currentReferencePoint.first.distanceTo(lastReferencePoint.first);
      Duration timeBetween =
          currentReferencePoint.second.difference(lastReferencePoint.second);

      finalPoints.addAll(pointsBetween.map((e) {
        if (finalPoints.any((element) => element?.first == e)) {
          return null;
        }
        print('point ${place++}: ${e}');

        double distanceToLastPoint = e.distanceTo(lastReferencePoint.first);
        //print('distanceToLastPoint is $distanceToLastPoint');
        double percentage = distanceToLastPoint / distanceBetween;
        //print('percentage is $percentage');

        Duration timeToLastPoint =
            Duration(seconds: (timeBetween.inSeconds * percentage).round());
        //print('timeToLastPoint is $timeToLastPoint\n');

        DateTime asdf = lastReferencePoint.second.add(timeToLastPoint);
        // print('time is ${asdf}');
        return Tuple(e, lastReferencePoint.second.add(timeToLastPoint));
      }));

      lastPointIndex = pointIndex;
      lastReferencePoint = currentReferencePoint;
    }
    print('here 6');
    return finalPoints.where((element) => element != null).toList().cast();
  }
  */
