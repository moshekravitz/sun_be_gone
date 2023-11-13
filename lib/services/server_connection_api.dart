import 'package:flutter/foundation.dart' show immutable;

///import 'package:sun_be_gone/models/bus_routes.dart';
import 'dart:convert' show json, jsonDecode;

import 'package:http/http.dart' as http;
import 'package:sun_be_gone/models/api_response.dart';
import 'package:sun_be_gone/services/http_url.dart' show HttpUrl;
import 'package:sun_be_gone/utils/logger.dart';

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
    logger.i('mocking check live api request');
    return Future.delayed(
      const Duration(seconds: 2),
      () => ApiResponse(
        statusCode: 200,
        data: 'mocked response',
        error: 'mocked error',
      ),
    );
  }

  @override
  Future<ApiResponse<String>> checkHealth() {
    logger.i('mocking ckeck health api request');
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
      logger.i('status code for live check: ${response.statusCode}');
    } else {
      logger.i(response.statusCode);
      logger.i(response.reasonPhrase);
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
      logger.i('status code for ready check: ${response.statusCode}');
    } else {
      logger.i(response.statusCode);
      logger.i(response.reasonPhrase);
    }

    final parsed = jsonDecode(response.body);

    return ApiResponse(
      statusCode: response.statusCode,
      data: parsed['status'],
      error: response.reasonPhrase,
    );
  }

  static void sendErrorToServer(
      dynamic error, StackTrace? stackTrace, String? logs) {
    final url = Uri.parse(HttpUrl.serverUrl('/error'));
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final body = <String, dynamic>{
      'error': error.toString(),
      'stack_trace': stackTrace.toString(),
      'logs': logs,
    };

    // Send a POST request to your logging server
    http.post(url, headers: headers, body: json.encode(body));
  }
}
