
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_business/sun_business.dart';

void main() {
  test('addTimeToPoint should add DateTime to points based on stops', () {
    // Define some sample data
    List<Point> points = [
      Point(0, 0),
      Point(1, 1),
      Point(2, 2),
      Point(3, 3),
      Point(4, 4),
      Point(5, 5),
    ];

    List<Tuple<Point, DateTime>> stops = [
      Tuple(Point(0, 0), DateTime(2023, 11, 8, 10, 0, 0)),
      Tuple(Point(2.2, 2.2), DateTime(2023, 11, 8, 10, 30, 0)),
      Tuple(Point(3.5, 3.5), DateTime(2023, 11, 8, 11, 0, 0)),
      Tuple(Point(5,5), DateTime(2023, 11, 8, 11, 30, 0)),
    ];

    SunBusiness sunBusiness = SunBusiness();

    // Call the function to add time to points
    //List<Tuple<Point, DateTime>> result = sunBusiness._addTimeToPoint(points, stops);

    // Assert the result
    //expect(result.length, 6);

  });
}
