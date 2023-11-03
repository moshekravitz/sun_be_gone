
//class for manageing the cache
import 'package:sun_be_gone/models/bus_routes.dart';

class AppCache {
  //singleton
  AppCache._sharedInstance();
  static late final AppCache _shared = AppCache._sharedInstance();
  factory AppCache.instance() => _shared;

  Iterable<BusRoutes>? _busRoutes;

  //check if _busRoutes is initialized

  Iterable<BusRoutes>? get busRoutes => _busRoutes;

  set busRoutes(Iterable<BusRoutes>? value) {
      if(_busRoutes != null) {
          print("Warning: busRoutes is already initialized");
      }
          
    _busRoutes = value;
  }

  void clear() {
      _busRoutes = null;
  }
}
