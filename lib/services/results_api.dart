import 'package:flutter/foundation.dart' show immutable;
import 'package:sun_be_gone/models/api_response.dart';
import 'package:sun_business/models/point.dart';
import 'package:sun_business/sun_business.dart' show SunBusiness, SittingInfo;

@immutable
abstract class ResultsApiProtocol {
  const ResultsApiProtocol();

  Future<ApiResponse<SittingInfo>> getSittingResults(
      String shapeStr, Point departure, Point destination, DateTime dateTime);
}

class ResultsApi implements ResultsApiProtocol {
  ResultsApi();

  @override
  Future<ApiResponse<SittingInfo>> getSittingResults(String shapeStr,
      Point departure, Point destination, DateTime dateIme) async {
    SunBusiness sunBusiness = SunBusiness();
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      SittingInfo result = await sunBusiness.whereToSitMulti(
          shapeStr, departure, destination, dateIme);
      stopwatch.stop();
      print('Time taken in resultsApi: ${stopwatch.elapsedMilliseconds} ms');
      return ApiResponse<SittingInfo>(statusCode: 200, data: result);
    } catch (e) {
      return ApiResponse<SittingInfo>.bad(statusCode: 500, error: e.toString());
    }
  }
}
