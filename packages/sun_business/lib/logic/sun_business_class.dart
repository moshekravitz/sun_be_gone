import 'package:flutter/foundation.dart' show compute;
import 'package:sun_business/models/point.dart';
import 'package:sun_business/models/sitting_info.dart';
import 'package:sun_business/logic/sun_pos_calc.dart';

// class for whereToSit params
class _Params {
  final String str;
  final List<(Point, DateTime)> stops;
  final DateTime dateTime;

  _Params(this.str, this.stops, this.dateTime);
}

/// the main class of the sun business logic
/// the following functions are exposed:
/// 1. [whereToSit] - returns a [SittingInfo] object that contains the sitting position and the segments of the route
/// 2. [whereToSitMulti] - is the same as [whereToSit] but it is a compute function that runs on a separate thread
class SunBusiness {
  /// The final sitting place given a [str].
  SittingInfo whereToSit({
    required String str,
    required List<(Point, DateTime)> stops,
    required DateTime dateTime,
  }) {
    return _whereToSit(_Params(str, stops, dateTime));
  }

  // whereToSit but with multiprocessing
  Future<SittingInfo> whereToSitMulti(
      String str, List<(Point, DateTime)> stops, DateTime dateTime) {
    return compute(_whereToSit, _Params(str, stops, dateTime));
  }

  SittingInfo _whereToSit(_Params params) {
    Stopwatch stopwatch = Stopwatch()..start();
    List<Point> decodedPoints = _polylineDecode(params.str);

    List<Point> finalPointsList = Point.removeIrelevent(
        decodedPoints, params.stops.first.$1, params.stops.last.$1);

    List<(Point, DateTime)> finalPoints;
    finalPoints = _addTimeToPoint(finalPointsList, params.stops);

    SittingInfo sittingInfo = _finalPosition(finalPoints);

    stopwatch.stop();
    print('Time taken: ${stopwatch.elapsedMilliseconds} ms');

    return sittingInfo;
    //return Future(() => sittingInfo);
  }

//this function receves a string and decodes it to a list of locations (that makes a route)
  List<Point> _polylineDecode(String str) {
    int strLength = str.length;
    var asciiValues = [];
    for (int i = 0; i < strLength; i++) {
      int b = str.codeUnitAt(i) - 63;
      asciiValues.add(b);
    }

    List<Point> points = [];
    int i = 0;
    bool flag =
        true; //flag for telling if current number we fetch from the string is the longitude or latitude
    double tempLongitude = 0, tempLatitude = 0;
    while (i < strLength) {
      List<int> num = [];
      //getting each set of numbers that makes a single angle by stoping when a number is smaller then 32
      while (i < strLength && asciiValues[i] >= 32) {
        int temp = asciiValues[i] & 0x1f;
        num.add(temp);
        i++;
      }
      //  int temp = asciiValues[i] & 0x1f;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      num.add(asciiValues[i] & 0x1f);
      i++;
      //now we take all the numbers in num array and concatenate them to make one number
      int actualNumber = 0;
      for (int i = 0; i < num.length; i++) {
        actualNumber += (num[i] << 5 * i);
      }
      if (actualNumber % 2 == 1) {
        actualNumber = ~actualNumber;
      }
      actualNumber = actualNumber >> 1;
      double finalNumber = actualNumber / 100000;
      //now the number is in the currect format i.e. a degree and now we need to pair every two number and put them in a list of points

      if (flag == true) {
        tempLatitude = finalNumber;
        flag = false;
      } else {
        tempLongitude = finalNumber;
        if (points.isNotEmpty) {
          tempLongitude += points.last.longitude;
          tempLatitude += points.last.latitude;
        }
        Point newPoint = Point(double.parse((tempLongitude).toStringAsFixed(5)),
            double.parse((tempLatitude).toStringAsFixed(5)));
        points.add(newPoint);
        flag = true;
      }
    }
    //print(points);//<<<<<<<<<<<<<<<<<<<<<
    return points;
  }

  SittingInfo _finalPosition(
      List<(Point, DateTime)> points) //, cTime theTime, Point sunPosition)
  {
    //List<Point> listOfSunAngles = [];
    //double left = 0, right = 0;
    //Point last = Point(0,0);
    ///[countLeft] is the count of the distance the sun is on the left side of the route
    double countLeft = 0;

    ///[countRight] is the count of the distance the sun is on the right side of the route
    double countRight = 0;
    double countNone = 0;
    //SittingPosition lastPosition = SittingPosition.both;
    //List<Point> flippedPoints = [
    // points.first
    //]; //points where the position has changed
    List<double> leftSegments = [0];
    List<double> rightSegments = [0];
    List<double> noneSegments = [0];
    var it = points.iterator;
    it.moveNext();
    Point currentPoint = Point.copy(it.current.$1);

    while (it.moveNext()) {
      Point offsetToNext = it.current.$1 - currentPoint;
      DateTime dateTime = it.current.$2;
      //cLocation pointLocation = cLocation(it.current.longitude,it.current.latitude);
      SpaStruct spa = SpaStruct(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second.toDouble(),
          dateTime.timeZoneOffset.inHours.toDouble(),
          0,
          67,
          currentPoint.longitude,
          currentPoint.latitude,
          20,
          820,
          11,
          30,
          -10,
          0.5667,
          ENUM1.SPA_ZA_RTS.index);

      int spaResult = spa_calculate(spa); //<<<<<<<<<<<<<throw error
      if (spaResult > 0) {
        print("error");
        print(spaResult);
      }

      double currentFractionalHour = dateTime.hour.toDouble() +
          (dateTime.minute.toDouble() / 60) +
          (dateTime.second.toDouble() / 3600);
      if (spa.sunset! < currentFractionalHour ||
          spa.sunrise! > currentFractionalHour) {
        noneSegments.add(offsetToNext.distance() +
            [
              leftSegments.last,
              rightSegments.last,
              noneSegments.last,
            ].reduce((a, b) => a > b ? a : b));
        countNone += offsetToNext.distance();
        currentPoint = Point.copy(it.current.$1);
        continue;
      }

      double myAzimuth = offsetToNext.directionInAngle();

      double offsetOfSunAndDirection = spa.azimuth! - myAzimuth;
      double newSegment = offsetToNext.distance() +
          [
            leftSegments.last,
            rightSegments.last,
            noneSegments.last,
          ].reduce((a, b) => a > b ? a : b);

      //claculating where the sun will be relative to me at current point at current direction
      if (offsetOfSunAndDirection > 0 &&
          offsetOfSunAndDirection < 180 &&
          spa.zenith! < 87 &&
          spa.zenith! > 0) {
        countRight += offsetToNext.distance();

        rightSegments.add(newSegment);
      } else if ((offsetOfSunAndDirection < 0 ||
              offsetOfSunAndDirection > 180) &&
          spa.zenith! < 87 &&
          spa.zenith! > 0) {
        countLeft += offsetToNext.distance();

        leftSegments.add(newSegment);
      } else {
        countNone += offsetToNext.distance();
        noneSegments.add(newSegment);
      }
      currentPoint = Point.copy(it.current.$1);
    }

    List<(double, SittingPosition)> segments =
        _fixSegments(leftSegments, rightSegments, noneSegments);

    // TwoIntergers result = TwoIntergers(countright,countleft);
    // return result;

    // bool a = false;
    late SittingPosition position;
    int protectionPercentage;
    print('countLeft is $countLeft');
    print('countRight is $countRight');
    print('countNone is $countNone');
    if (countRight == 0.0 && countLeft == 0.0) {
      position = SittingPosition.both;
      protectionPercentage = 100;
      return SittingInfo(
          position: position,
          segments: segments,
          protectionPercentage: protectionPercentage);
    }
    int rightPercentage =
        (countRight / (countRight + countLeft + countNone) * 100).round();
    int leftPercentage =
        (countLeft / (countRight + countLeft + countNone) * 100).round();
    int nonePercentage =
        (countNone / (countRight + countLeft + countNone) * 100).round();

    if ((rightPercentage - leftPercentage).abs() == 0) {
      if (countNone == 0) {
        //no sun
        protectionPercentage = 50;
        position = SittingPosition.both;
      } else {
        position = SittingPosition.both;
        protectionPercentage = nonePercentage +
            leftPercentage; // left and right both give the same percentage
      }
    } else if (leftPercentage > rightPercentage) {
      //sit right
      position = SittingPosition.right;
      protectionPercentage = leftPercentage + nonePercentage;
      print('protection percentage is $protectionPercentage');
    } else {
      //sit left
      position = SittingPosition.left;
      protectionPercentage = rightPercentage + nonePercentage;

      print('protection percentage is $protectionPercentage');
    }

    return SittingInfo(
        position: position,
        segments: segments,
        protectionPercentage: protectionPercentage);
  }

  List<(double, SittingPosition)> _fixSegments(List<double> leftSegments,
      List<double> rightSegments, List<double> noneSegments) {
    //leftSegments means sit right and RightSegments mean sit left
    List<(double, SittingPosition)> segments1 = leftSegments
        .map((e) {
          return (e, SittingPosition.right);
        })
        .toList()
        .followedBy(rightSegments.map((e) {
          return (e, SittingPosition.left);
        }))
        .toList()
        .followedBy(noneSegments.map((e) {
          return (e, SittingPosition.both);
        }))
        .toList()
      ..sort((a, b) => a.$1.compareTo(b.$1));

    List<(double, SittingPosition)> segments = [segments1.first];

    for (int i = 1; i < segments1.length; i++) {
      if (segments1[i - 1].$2 == segments1[i].$2) {
        segments.removeLast();
      }
      segments.add(segments1[i]);
    }

    segments.removeWhere((element) =>
        element.$1 == 0.0 && element.$2 != SittingPosition.both);

    var maxVal = segments.last.$1;
    if (maxVal == 0.0) {
      return [
        (0.0, SittingPosition.both),
        (1.0, SittingPosition.both)
      ];
    }
    return segments.map((e) {
      double fixedValue = (e.$1) / maxVal;
      return (fixedValue, e.$2);
    }).toList();
  }

  /// puts a date time to each point based on the distance between the two points its between
  List<(Point, DateTime)> _addTimeToPoint(
      List<Point> points, List<(Point, DateTime)> stops) {
    List<(Point, DateTime)?> finalPoints = [];

    int lastPointIndex = Point.closestPoint(points, stops.first.$1);
    (Point, DateTime) lastReferencePoint = stops.first;

    for (int i = 1; i < stops.length; i++) {
      (Point, DateTime) currentReferencePoint = stops[i];

      int pointIndex = Point.closestPoint(
          points, currentReferencePoint.$1, lastPointIndex + 1);
      if (pointIndex <= lastPointIndex && pointIndex == points.length - 1) {
        break;
      }

      List<Point> pointsBetween = points.sublist(lastPointIndex, pointIndex);

      if (lastReferencePoint.$1.distanceTo(points[pointIndex]) <=
          lastReferencePoint.$1.distanceTo(currentReferencePoint.$1)) {
        pointsBetween.add(points[pointIndex]);
        pointIndex++;
      }

      double distanceBetween =
          currentReferencePoint.$1.distanceTo(lastReferencePoint.$1);
      Duration timeBetween =
          currentReferencePoint.$2.difference(lastReferencePoint.$2);

      finalPoints.addAll(pointsBetween.map((e) {
        if (finalPoints.any((element) => element?.$1 == e)) {
          return null;
        }

        double distanceToLastPoint = e.distanceTo(lastReferencePoint.$1);
        double percentage = distanceToLastPoint / distanceBetween;

        Duration timeToLastPoint =
            Duration(seconds: (timeBetween.inSeconds * percentage).round());

        return (e, lastReferencePoint.$2.add(timeToLastPoint));
      }));

      lastPointIndex = pointIndex;
      lastReferencePoint = currentReferencePoint;
    }

    return finalPoints.where((element) => element != null).toList().cast();
  }
}
