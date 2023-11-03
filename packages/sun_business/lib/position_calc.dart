// This file is available in electronic form at http://www.psa.es/sdg/sunpos.htm
import 'dart:math';
//import 'apis.dart';
import 'sunPosCalc.dart';

class cTime {
  int? iYear;
  int? iMonth;
  int? iDay;
  double? dHours;
  double? dMinutes;
  double? dSeconds;
  cTime.empty() {
    iYear = DateTime.now().year;
    iMonth = DateTime.now().month;
    iYear = DateTime.now().day;
    dHours = DateTime.now().hour as double;
    dMinutes = DateTime.now().minute as double;
    dSeconds = DateTime.now().second as double;
  }
  cTime(int y, int m, int d, double h, double mi, double s) {
    iYear = y;
    iMonth = m;
    iDay = d;
    dHours = h;
    dMinutes = mi;
    dSeconds = s;
  }
}

// class cLocation
// {
// 	double dLongitude ;
// 	double dLatitude;
//   cLocation(this.dLongitude,this.dLatitude);
//   set dLong(double value) => dLongitude = value;
//   set dlat(double value) => dLatitude = value;
// }

class Point {
  late double longitude;
  late double latitude;
  void setLong(double myLong) {
    longitude = myLong;
  }

  void setLat(double myLat) {
    latitude = myLat;
  }

  Point(this.longitude,
      this.latitude) {} //(double myLong,double myLat) //{setLong(myLong);setLat(myLat);}
  Point.copy(Point myP) {
    longitude = myP.longitude;
    latitude = myP.latitude;
  }
  Point.empty() {
    longitude = 0;
    latitude = 0;
  }
  @override
  String toString() {
    return 'long: $longitude, lat: $latitude\n';
  }

  bool isNull() {
    if (longitude == 0 && latitude == 0) {
      return true;
    }
    return false;
  }

  Point operator -(Point v) =>
      Point(longitude - v.longitude, latitude - v.latitude);
  double
      directionInAngle() //gets direction offset and returns the angle from the north pole
  {
    return (pi / 2 - atan2(latitude, longitude)) * (180.0 / pi);
  }

  double distance() {
    return sqrt(pow(longitude, 2) + pow(latitude, 2));
  }

  double distanceTo(Point p) {
    return sqrt(
        pow(longitude - p.longitude, 2) + pow(latitude - p.latitude, 2));
  }

  //find the closest point to the point in a list and return its index
  static int closestPoint(List<Point> points, Point point) {
    double minDistance = double.infinity;
    int index = 0;
    for (int i = 0; i < points.length; i++) {
      if (points[i].distanceTo(point) < minDistance) {
        minDistance = points[i].distanceTo(point);
        index = i;
      }
    }
    return index;
  }

//removes from a list of points  points that are up to departure
  static List<Point> removeIrelevent(
      List<Point> points, Point departure, Point destination) {
    int startIndex = closestPoint(points, departure);
    int endIndex = closestPoint(points, destination);
    print('departure: ${departure.toString()}');
    print('first point: ${points[startIndex].toString()}');
    print('start index: $startIndex, end index: $endIndex');
    List<Point> newPoints = [];
    for (int i = startIndex; i < endIndex; i++) {
      newPoints.add(points[i]);
    }
    return newPoints;
  }
}

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
