import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpUrl {
  //HttpUrl(String path) {
  //   server_url = 'http://gtfsapi-production.up.railway.app' + path;
  //}
  static final String _serverUrl = dotenv.env['SERVER_URL']!;

  static String get apiKey => dotenv.env['APIKEY']!;

  //method for adding a path and returning the full url
  static String serverUrl(String path) => _serverUrl + path;

}
