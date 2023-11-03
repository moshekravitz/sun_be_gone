class HttpUrl {
  //HttpUrl(String path) {
  //   server_url = 'http://gtfsapi-production.up.railway.app' + path;
  //}
  static const String _serverUrl = 'https://gtfsapi-production.up.railway.app';

  //method for adding a path and returning the full url
  static String serverUrl(String path) => _serverUrl + path;
}
