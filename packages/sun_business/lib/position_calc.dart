// This file is available in electronic form at http://www.psa.es/sdg/sunpos.htm
import 'dart:math';
//import 'apis.dart';
import 'package:sun_business/models/point.dart';

import 'sunPosCalc.dart';

//this function receves a string and decodes it to a list of locations (that makes a route)
List<Point> polylineDecode(String str) {
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

List finalPosition(List<Point> points) //, cTime theTime, Point sunPosition)
{
  //List<Point> listOfSunAngles = [];
  //double left = 0, right = 0;
  //Point last = Point(0,0);
  double countLeft = 0, countRight = 0;
  var it = points.iterator;
  it.moveNext();
  Point currentPoint = Point.copy(it.current);

  while (it.moveNext()) {
    Point offsetToNext = it.current - currentPoint;
    //cLocation pointLocation = cLocation(it.current.longitude,it.current.latitude);
    SpaStruct spa = SpaStruct(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second.toDouble(),
        DateTime.now().timeZoneOffset.inHours.toDouble(),
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

    double myZenith = offsetToNext.directionInAngle();

    double offsetOfSunAndDirection = spa.azimuth! - myZenith;
    //claculating where the sun will be relative to me at current point at current direction
    if (offsetOfSunAndDirection > 0 &&
        offsetOfSunAndDirection < 180 &&
        spa.zenith! < 87 &&
        spa.zenith! > 0) {
      countRight += offsetToNext.distance();
    } else if ((offsetOfSunAndDirection < 0 || offsetOfSunAndDirection > 180) &&
        spa.zenith! < 87 &&
        spa.zenith! > 0) {
      countLeft += offsetToNext.distance();
    }
    currentPoint = Point.copy(it.current);
  }
  // TwoIntergers result = TwoIntergers(countright,countleft);
  // return result;

  // bool a = false;
  late int returning;
  if (countRight == countLeft) {
    if (countRight == 0) {
      print("sit Where ever you want!");
      returning = 4;
    }
    returning = 3;
  } else if (countLeft > countRight) {
    print("sit Right");
    returning = 1;
  } //left
  else
    print("sit Left");
  returning = 2; //right
  return [points, returning];
}

List whereToSit(String str) {
  return finalPosition(polylineDecode(str));
}
