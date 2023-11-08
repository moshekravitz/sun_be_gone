// This file is available in electronic form at http://www.psa.es/sdg/sunpos.htm

import 'dart:math';

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
    return 'long: $longitude, lat: $latitude';
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
  static int closestPoint(List<Point> points, Point point,
      [int startIndex = 0]) {
    if (startIndex >= points.length) {
        print('startIndex is bigger than points length');
        return points.length - 1;
    }
    double minDistance = double.infinity;
    int index = 0;
    for (int i = startIndex; i < points.length; i++) {
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
