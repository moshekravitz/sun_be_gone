import 'package:flutter/foundation.dart' show immutable;
import 'package:sun_be_gone/models/api_response.dart';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;
import 'package:sun_be_gone/models/extended_routes.dart';
import 'package:sun_be_gone/models/stop_info.dart';
import 'package:sun_be_gone/services/http_url.dart';
import 'package:sun_be_gone/utils/logger.dart';

@immutable
abstract class BusStopsApiProtocol {
  const BusStopsApiProtocol();
  Future<ApiResponse<Iterable<StopInfo>?>> getBusStops(
      ExtendedRoutes extendedRoutes);
}

@immutable
class MockBusStopsApi implements BusStopsApiProtocol {
  @override
  Future<ApiResponse<Iterable<StopInfo>?>> getBusStops(
      ExtendedRoutes extendedRoutes) //=>
  {
    logger.i('mocking api request');
    return Future.delayed(
      const Duration(seconds: 2),
      () => ApiResponse(statusCode: 200, data: mockStopInfo),
    );
  }
}

@immutable
class BusStopsApi implements BusStopsApiProtocol {
  @override
  Future<ApiResponse<Iterable<StopInfo>?>> getBusStops(
      ExtendedRoutes extendedRoutes) async {
    List<int> stopIds = extendedRoutes.stopTimes.map((e) => e.stopId).toList();
    String stopIdsComaSeparated = stopIds.join(',');
    var headers = {'APIKEY': HttpUrl.apiKey};
    var response = await http.get(
      Uri.parse(HttpUrl.serverUrl(
          '/api/stopInfo/idList?stopIdL=$stopIdsComaSeparated')),
      headers: headers,
    );
    //http.Request('GET', Uri.parse('http://localhost:5000/api/Routes'));

    //http.StreamedResponse response = await request.send();
    //var response = await request.send();

    if (response.statusCode == 200) {
      logger.i('status code for bus stops: ${response.statusCode}');
    } else {
      logger.i(response.statusCode);
      logger.i(response.reasonPhrase);
      return ApiResponse<Iterable<StopInfo>?>.bad(
          statusCode: response.statusCode, error: response.reasonPhrase);
    }

    Iterable<StopInfo>? stops = parseBusRoutes(response.body);
    stops = stops.map((e) => StopInfo(
          stopId: e.stopId,
          stopName: e.stopName.replaceAll(RegExp(r'\s+'), ' '),
          stopLat: e.stopLat,
          stopLon: e.stopLon,
        ));

    return ApiResponse<Iterable<StopInfo>?>(
        statusCode: response.statusCode, data: stops);
  }

  // A function that converts a response body into a List<BusRoutes>.
  List<StopInfo> parseBusRoutes(String responseBody) {
    final parsed =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

    return parsed.map<StopInfo>((json) => StopInfo.fromJson(json)).toList();
  }
}
