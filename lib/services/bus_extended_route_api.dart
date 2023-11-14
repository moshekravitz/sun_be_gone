import 'package:flutter/foundation.dart' show immutable;
import 'package:sun_be_gone/models/api_response.dart';
import 'dart:convert' show jsonDecode;

import 'package:http/http.dart' as http;
import 'package:sun_be_gone/models/extended_routes.dart';
import 'package:sun_be_gone/services/http_url.dart';
import 'package:sun_be_gone/utils/logger.dart';

@immutable
abstract class ExtendedRouteApiProtocol {
  const ExtendedRouteApiProtocol();
  Future<ApiResponse<ExtendedRoutes?>> getExtendedRoutes(int routeId);
}

@immutable
class MockExtendedRouteApi implements ExtendedRouteApiProtocol {
  @override
  Future<ApiResponse<ExtendedRoutes?>> getExtendedRoutes(int routeId) //=>
  {
      logger.i('mocking api request');
      return Future.delayed(
        const Duration(seconds: 2),
        () => ApiResponse<ExtendedRoutes>(statusCode: 200, data: mockExtendedRoute),
      );
  }
}

@immutable
class ExtendedRouteApi implements ExtendedRouteApiProtocol {
  @override
  Future<ApiResponse<ExtendedRoutes?>> getExtendedRoutes(int routeId) async {
    var headers = {'APIKEY': HttpUrl.apiKey};
    var response = await http.get(
      Uri.parse(HttpUrl.serverUrl('/api/ExtendedRoutes/id?routeId=$routeId')),
      headers: headers,
    );
    //http.Request('GET', Uri.parse('http://localhost:5000/api/Routes'));

    //http.StreamedResponse response = await request.send();
    //var response = await request.send();

    if (response.statusCode == 200) {
      logger.i('status code for extendedRoutes: ${response.statusCode}');
    } else {
      logger.i(response.statusCode);
      logger.i(response.reasonPhrase);
      return ApiResponse<ExtendedRoutes?>.bad(statusCode: response.statusCode, error: response.reasonPhrase);
    }

    var parsedExtendedRoutes = parseExtendedRoutes(response.body);
    return ApiResponse<ExtendedRoutes?>(statusCode: response.statusCode, data: parsedExtendedRoutes);
  }

  ExtendedRoutes parseExtendedRoutes(String responseBody) {

    return ExtendedRoutes.fromJson(jsonDecode(responseBody));
  }
}
