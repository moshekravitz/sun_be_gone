import 'dart:convert' show jsonDecode;
import 'package:flutter/foundation.dart' show immutable;
import 'package:sun_be_gone/models/api_response.dart';
import 'package:sun_be_gone/models/bus_routes.dart';

import 'package:http/http.dart' as http;
import 'package:sun_be_gone/services/http_url.dart';
import 'package:sun_be_gone/utils/logger.dart';

@immutable
abstract class BusRoutesApiProtocol {
  const BusRoutesApiProtocol();
  Future<ApiResponse<Iterable<BusRoutes>?>> getBusRoutes();
}

@immutable
class MockBusRoutesApi implements BusRoutesApiProtocol {
  @override
  Future<ApiResponse<Iterable<BusRoutes>?>> getBusRoutes() //=>
  {
    logger.i('mocking api request');
    return Future.delayed(
      const Duration(seconds: 2),
      () => ApiResponse<Iterable<BusRoutes>?>(statusCode: 200, data: mockBusRoutes),
    );
  }
}

@immutable
class BusRoutesApi implements BusRoutesApiProtocol {
  @override
  Future<ApiResponse<Iterable<BusRoutes>?>> getBusRoutes() async {

    var headers = {'APIKEY': '1234'};
    var response = await http.get(
      Uri.parse(HttpUrl.serverUrl('/api/Routes')),
      headers: headers,
    );
    //http.Request('GET', Uri.parse('http://localhost:5000/api/Routes'));

    //http.StreamedResponse response = await request.send();
    //var response = await request.send();

    if (response.statusCode == 200) {
      logger.i('status code for routes: ${response.statusCode}');
    } else {
      logger.i(response.statusCode);
      logger.i(response.reasonPhrase);
      return ApiResponse<Iterable<BusRoutes>?>.bad(statusCode: response.statusCode, error: response.reasonPhrase);
    }

    List<BusRoutes> parsedBusRoutes =  parseBusRoutes(response.body);
    return ApiResponse<Iterable<BusRoutes>?>(statusCode: response.statusCode, data: parsedBusRoutes);
  }

  // A function that converts a response body into a List<BusRoutes>.
  List<BusRoutes> parseBusRoutes(String responseBody) {
    final parsed =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

    return parsed.map<BusRoutes>((json) => BusRoutes.fromJson(json)).toList();
  }
}
