import 'package:flutter/foundation.dart' show immutable;

///import 'package:sun_be_gone/models/bus_routes.dart';
import 'dart:convert' show jsonDecode;

import 'package:http/http.dart' as http;
import 'package:sun_be_gone/models/api_response.dart';
import 'package:sun_be_gone/services/http_url.dart';
import 'package:sun_business/position_calc.dart' show Point;

@immutable
abstract class BusShapeApiProtocol {
  const BusShapeApiProtocol();
  Future<ApiResponse<String>> getShapes(int shapeId);
}

@immutable
class MockShapeApi implements BusShapeApiProtocol {
  @override
  Future<ApiResponse<String>> getShapes(int shapeId) //=>
  {
    print('mocking api request');
    return Future.delayed(
        const Duration(seconds: 2),
        () => ApiResponse<String>(
            statusCode: 200,
            data: 'Mocked data for shapeId: ${shapeId.toString()}',
            ));
  }
}

@immutable
class BusShapeApi implements BusShapeApiProtocol {
  @override
  Future<ApiResponse<String>> getShapes(int shapeId) async {
    var headers = {'APIKEY': '1234'};
    var response = await http.get(
      Uri.parse(HttpUrl.serverUrl('/api/Shapes/id?shapeId=$shapeId')),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('status code for shape: ${response.statusCode}');
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      return ApiResponse.bad(
          statusCode: response.statusCode, error: response.reasonPhrase);
    }

    print('shapeId: ' + shapeId.toString());
    final parsed = jsonDecode(response.body);
    //print('shapecoords: ' + parsed['shapeCoords']);

/*
    List<Point> points = (parsed['shapeCoords'] as List)
        .map((e) => Point(
              e['shapeLon'].toDouble(),
              e['shapeLat'].toDouble(),
            ))
        .toList();
        */

    return ApiResponse(statusCode: response.statusCode, data: parsed['shapeStr']);
  }
}
