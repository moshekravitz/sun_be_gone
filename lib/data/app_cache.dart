//class for manageing the cache
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sun_be_gone/utils/logger.dart';

class AppCache {
  //singleton
  AppCache._sharedInstance();
  static final AppCache _shared = AppCache._sharedInstance();
  factory AppCache.instance() => _shared;

  Iterable<BusRoutes>? _busRoutes;
  bool _busRoutesIsComplete = false;

  Iterable<BusRoutes>? get busRoutes => _busRoutes;

  set busRoutes(Iterable<BusRoutes>? value) {
    if (_busRoutesIsComplete) {
      logger.w("Warning: busRoutes is already initialized");
    }
    _busRoutes = value;
  }

  bool get busRoutesIsComplete => _busRoutesIsComplete;
  bool get busRoutesIsNotComplete => !_busRoutesIsComplete;

  set busRoutesIsComplete(bool value) {
    if (_busRoutes == null) {
      logger.w("Warning: busRoutes is not initialized");
      return;
    }
    if (_busRoutesIsComplete) {
      logger.w("Warning: isBusRoutesInitialized is already initialized");
    }
    _busRoutesIsComplete = value;
  }

  void clear() {
    _busRoutes = null;
  }
}
