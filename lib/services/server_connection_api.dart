import 'package:flutter/foundation.dart' show immutable;

///import 'package:sun_be_gone/models/bus_routes.dart';
import 'dart:convert' show jsonDecode;

import 'package:http/http.dart' as http;
import 'package:sun_be_gone/models/api_response.dart';
import 'package:sun_be_gone/services/http_url.dart' show HttpUrl;

@immutable
abstract class ServerConnectionApiProtocol {
  const ServerConnectionApiProtocol();
  Future<ApiResponse<String>> checkLive();
  Future<ApiResponse<String>> checkHealth();
}

@immutable
class MockServerConnectionApi implements ServerConnectionApiProtocol {
  @override
  Future<ApiResponse<String>> checkLive() {
    print('mocking check live api request');
    return Future.delayed(
      const Duration(seconds: 2),
      () => ApiResponse(
        statusCode: 200,
        data: 'mocked response',
        error: 'mocked error',
      ),
    );
  }

  Future<ApiResponse<String>> checkHealth() {
    print('mocking ckeck health api request');
    return Future.delayed(
      const Duration(seconds: 2),
      () => ApiResponse(
        statusCode: 200,
        data: 'mocked response',
        error: 'mocked error',
      ),
    );
  }
}

@immutable
class ServerConnectionApi implements ServerConnectionApiProtocol {
  @override
  Future<ApiResponse<String>> checkLive() async {
    var response = await http.get(
      Uri.parse(HttpUrl.serverUrl('/health/live')),
    );

    if (response.statusCode == 200) {
      print('status code for live check: ${response.statusCode}');
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
    }

    return ApiResponse(
      statusCode: response.statusCode,
      data: response.body,
      error: response.reasonPhrase,
    );
  }

  Future<ApiResponse<String>> checkHealth() async {
    var response = await http.get(
      Uri.parse(HttpUrl.serverUrl('/health/ready')),
    );

    if (response.statusCode == 200) {
      print('status code for ready check: ${response.statusCode}');
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
    }

    final parsed = jsonDecode(response.body);

    return ApiResponse(
      statusCode: response.statusCode,
      data: parsed['status'],
      error: response.reasonPhrase,
    );
  }
}
