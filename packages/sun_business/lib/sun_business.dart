library sun_business;

import './position_calc.dart';
import './sunPosCalc.dart';

enum SittingPosition { left, right, both }

class _SittingInfo {
  SittingPosition position;
  List<Point>? points;
  int? protectionPercentage;
  _SittingInfo(
      {required this.position, this.protectionPercentage, this.points});
}

class SittingInfo {
  SittingPosition position;
  List<double>? segments;
  int? protectionPercentage;
  SittingInfo({required _SittingInfo sittingInfo, this.segments})
      : position = sittingInfo.position,
        protectionPercentage = sittingInfo.protectionPercentage;
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

  _SittingInfo _finalPosition(
  DateTime dateTime,
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
    SittingPosition lastPosition = SittingPosition.both;
    List<Point> flippedPoints = [
      points.first
    ]; //points where the position has changed
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
      //claculating where the sun will be relative to me at current point at current direction
      if (offsetOfSunAndDirection > 0 &&
          offsetOfSunAndDirection < 180 &&
          spa.zenith! < 87 &&
          spa.zenith! > 0) {
        countRight += offsetToNext.distance();

        if (lastPosition == SittingPosition.left) {
          flippedPoints.add(currentPoint);
        }
        lastPosition = SittingPosition.right;
      } else if ((offsetOfSunAndDirection < 0 ||
              offsetOfSunAndDirection > 180) &&
          spa.zenith! < 87 &&
          spa.zenith! > 0) {
        countLeft += offsetToNext.distance();

        if (lastPosition == SittingPosition.right) {
          flippedPoints.add(currentPoint);
        }
        lastPosition = SittingPosition.left;
      }
      else {
          countNone += offsetToNext.distance();
      }
      currentPoint = Point.copy(it.current);
    }
    flippedPoints.add(points.last);
    // TwoIntergers result = TwoIntergers(countright,countleft);
    // return result;

    // bool a = false;
    late SittingPosition position;
    int protectionPercentage;
    print('countLeft is $countLeft');
    print('countRight is $countRight');
    print('countNone is $countNone');
    if(countRight == 0.0 && countLeft == 0.0)
    {
        position = SittingPosition.both;
        protectionPercentage = 100;
        return _SittingInfo(position: position, points: flippedPoints..add(points.last), protectionPercentage: protectionPercentage);
    }
    int rightPercentage = (countRight / (countRight + countLeft + countNone) * 100).round();
    int leftPercentage = (countLeft / (countRight + countLeft + countNone) * 100).round();
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
    } 
    else {
      //sit left
      position = SittingPosition.left;
      protectionPercentage = rightPercentage;
          
      print('protection percentage is $protectionPercentage');
    }

    return _SittingInfo(
        position: position,
        points: flippedPoints,
        protectionPercentage: protectionPercentage);
  }

  /// The final sitting place given a [str].
  Future<SittingInfo> whereToSit(String str, Point departure, Point destination, DateTime dateTime) {
      List<Point> decodedPoints = _polylineDecode(str);
      print ('points count is ${decodedPoints.length}');
      List<Point> finalPointsList = Point.removeIrelevent(decodedPoints, departure, destination);
      print ('points count after removing is ${finalPointsList.length}');
    _SittingInfo sittingInfo = _finalPosition(dateTime ,finalPointsList);

    List<Point> points = sittingInfo.points!;
    List<double> segments = [];
    Point firstPoint = points.first;

    var totalDistance = points.last.distanceTo(points.first);

    var it = sittingInfo.points!.iterator;
    it.moveNext();
    while (it.moveNext()) {
      double milestone = it.current.distanceTo(firstPoint) / totalDistance;
      segments.add(milestone);
    }
    segments.add(1);
    return Future(() => SittingInfo(sittingInfo: sittingInfo, segments: segments));
  }

  /// The final sitting place given a [str].
  Future<SittingInfo> whereToSitP(List<Point> shapePoints, Point departure, Point destination, DateTime dateTime) {
      //List<Point> decodedPoints = _polylineDecode(str);
      //print ('points count is ${decodedPoints.length}');
      List<Point> decodedPoints = Point.removeIrelevent(shapePoints, departure, destination);
      //print ('points count after removing is ${decodedPoints.length}');
    _SittingInfo sittingInfo = _finalPosition(dateTime, decodedPoints);

    List<Point> points = sittingInfo.points!;
    List<double> segments = [];
    Point firstPoint = points.first;

    var totalDistance = points.last.distanceTo(points.first);

    var it = sittingInfo.points!.iterator;
    it.moveNext();
    while (it.moveNext()) {
      double milestone = it.current.distanceTo(firstPoint) / totalDistance;
      segments.add(milestone);
    }
    segments.add(1);
    return Future(() => SittingInfo(sittingInfo: sittingInfo, segments: segments));
  }
}
