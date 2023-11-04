
//class for manageing the cache
import 'package:sun_be_gone/models/bus_routes.dart';

class AppCache {
  //singleton
  AppCache._sharedInstance();
  static late final AppCache _shared = AppCache._sharedInstance();
  factory AppCache.instance() => _shared;

  Iterable<BusRoutes>? _busRoutes;
  Iterable<BusRoutes>? _historyBusRoutes;
  Iterable<BusRoutes>? _bookmarksBusRoutes;

  //check if _busRoutes is initialized

  Iterable<BusRoutes>? get busRoutes => _busRoutes;
  //Iterable<BusRoutes>? get historyBusRoutes => _historyBusRoutes;
  //Iterable<BusRoutes>? get bookmarksBusRoutes => _bookmarksBusRoutes;

  set busRoutes(Iterable<BusRoutes>? value) {
      if(_busRoutes != null) {
          print("Warning: busRoutes is already initialized");
      }
          
    _busRoutes = value;
  }

/*
  set historyBusRoutes(Iterable<BusRoutes>? value) {
      if(_historyBusRoutes != null) {
          print("Warning: historyBusRoutes is already initialized");
      }
          
    _historyBusRoutes = value;
  }

  set bookmarksBusRoutes(Iterable<BusRoutes>? value) {
      if(_bookmarksBusRoutes != null) {
          print("Warning: bookmarksBusRoutes is already initialized");
      }
          
    _bookmarksBusRoutes = value;
  }
  */

  void clear() {
      _busRoutes = null;
  }
}
