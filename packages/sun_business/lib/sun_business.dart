library sun_business;

import 'package:flutter/foundation.dart' show compute;
import 'package:sun_business/models/point.dart';

import './position_calc.dart';
import './sunPosCalc.dart';

enum SittingPosition { left, right, both }

// class for whereToSit params
class Params {
  final String str;
  final Point departure;
  final Point destination;
  final DateTime dateTime;

  Params(this.str, this.departure, this.destination, this.dateTime);
}

class Tuple<A, B> {
  final A first;
  final B second;

  Tuple(this.first, this.second);

  @override
  String toString() => '($first, $second)';
}

class _SittingInfo {
  SittingPosition position;
  List<Tuple<double, SittingPosition>>? segments;
  int? protectionPercentage;
  _SittingInfo(
      {required this.position, this.protectionPercentage, this.segments});
}

class SittingInfo {
  SittingPosition position;
  List<Tuple<double, SittingPosition>>? segments;
  int? protectionPercentage;

  SittingInfo(
      {required this.position,
      required this.segments,
      required this.protectionPercentage});
}

/// A Calculator.
class SunBusiness {
  /// Returns [value] plus 1.

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

  SittingInfo _finalPosition(DateTime dateTime,
      List<Point> points) //, cTime theTime, Point sunPosition)
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
    Point currentPoint = Point.copy(it.current);

    while (it.moveNext()) {
      Point offsetToNext = it.current - currentPoint;
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
          ENUM1.SPA_ZA.index);

      int spaResult = spa_calculate(spa); //<<<<<<<<<<<<<throw error
      if (spaResult > 0) {
        print("error");
        print(spaResult);
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
      currentPoint = Point.copy(it.current);
    }

    List<Tuple<double, SittingPosition>> segments =
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

    if ((rightPercentage - leftPercentage).abs() == 0) {
      if (countRight == 0) {
        //no sun
        position = SittingPosition.both;
        protectionPercentage = 100;
      } else {
        protectionPercentage = 50;
        position = SittingPosition.both;
      }
    } else if (leftPercentage > rightPercentage) {
      //sit right
      position = SittingPosition.right;
      protectionPercentage = leftPercentage;
      print('protection percentage is $protectionPercentage');
    } else {
      //sit left
      position = SittingPosition.left;
      protectionPercentage = rightPercentage;

      print('protection percentage is $protectionPercentage');
    }

    return SittingInfo(
        position: position,
        segments: segments,
        protectionPercentage: protectionPercentage);
  }

  /// The final sitting place given a [str].
  //SittingInfo whereToSit({
  //   required String str,required Point departure,required Point destination,required DateTime dateTime}) {
  SittingInfo whereToSit(Params params) {
    Stopwatch stopwatch = Stopwatch()..start();
    List<Point> decodedPoints = _polylineDecode(params.str);
    List<Point> finalPointsList = Point.removeIrelevent(
        decodedPoints, params.departure, params.destination);
    SittingInfo sittingInfo = _finalPosition(params.dateTime, finalPointsList);

    stopwatch.stop();
    print('Time taken: ${stopwatch.elapsedMilliseconds} ms');

    return sittingInfo;
    //return Future(() => sittingInfo);
  }

  // whereToSit but with multiprocessing
  Future<SittingInfo> whereToSitMulti(
      String str, Point departure, Point destination, DateTime dateTime) {

    return compute(whereToSit, Params(str, departure, destination, dateTime));

  }

  List<Tuple<double, SittingPosition>> _fixSegments(List<double> leftSegments,
      List<double> rightSegments, List<double> noneSegments) {
    List<Tuple<double, SittingPosition>> segments1 = leftSegments
        .map((e) {
          return Tuple(e, SittingPosition.left);
        })
        .toList()
        .followedBy(rightSegments.map((e) {
          return Tuple(e, SittingPosition.right);
        }))
        .toList()
        .followedBy(noneSegments.map((e) {
          return Tuple(e, SittingPosition.both);
        }))
        .toList()
      ..sort((a, b) => a.first.compareTo(b.first));

    List<Tuple<double, SittingPosition>> segments = [segments1.first];

    for (int i = 1; i < segments1.length; i++) {
      if (segments1[i - 1].second != segments1[i].second) {
        segments.add(segments1[i]);
      }
    }

    segments.removeWhere((element) =>
        element.first == 0.0 && element.second != SittingPosition.both);

    var maxVal = segments.last.first;
    if (maxVal == 0.0) {
      return [
        Tuple(0.0, SittingPosition.both),
        Tuple(1.0, SittingPosition.both)
      ];
    }
    return segments.map((e) {
      double fixedValue = (e.first) / maxVal;
      return Tuple(fixedValue, e.second);
    }).toList();
  }
}
