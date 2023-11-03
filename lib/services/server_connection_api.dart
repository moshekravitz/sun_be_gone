
import 'package:flutter/foundation.dart' show immutable;
///import 'package:sun_be_gone/models/bus_routes.dart';
import 'dart:convert' show jsonDecode;

import 'package:http/http.dart' as http;
import 'package:sun_be_gone/services/http_url.dart' show HttpUrl;

@immutable
abstract class ServerConnectionApiProtocol {
  const ServerConnectionApiProtocol();
  Future<String> checkLive();
  Future<String> checkHealth();
}

@immutable
class MockServerConnectionApi implements ServerConnectionApiProtocol {
  @override
  Future<String> checkLive() {
      print('mocking check live api request');
      return Future.delayed(
        const Duration(seconds: 2),
        () => 'mocked response',
      );
  }

  Future<String> checkHealth() {
      print('mocking ckeck health api request');
      return Future.delayed(
        const Duration(seconds: 2),
        () => 'mocked response',
      );
  }
}

@immutable
class ServerConnectionApi implements ServerConnectionApiProtocol {
  @override
  Future<String> checkLive() async {
    var response = await http.get(
      Uri.parse(HttpUrl.serverUrl('/health/live')),
    );

    if (response.statusCode == 200) {
      print('status code for live check: ${response.statusCode}');
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
    }

    return response.body;
  }

  Future<String> checkHealth()  async {
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

    return parsed['status'];
  }
}
