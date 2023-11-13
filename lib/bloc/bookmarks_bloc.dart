import 'package:bloc/bloc.dart';
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sun_be_gone/utils/logger.dart';

class BookMarksCubit extends Cubit<Iterable<BusRoutes>> {
  late List<BusRoutes> _bookmarksBusRoutes;
  //flag for if init has been called 
  bool _initCalled = false;

  BookMarksCubit() : super([]);

  void init(Iterable<BusRoutes> busRoutes) async {
    _bookmarksBusRoutes = busRoutes.toList();
    logger.i("init bookmarks");
    _initCalled = true;
    emit(_bookmarksBusRoutes);
  }

  void addBookmark(BusRoutes route) async {
    logger.i("addBookmark route: $route");
    if (!_initCalled) _bookmarksBusRoutes = [route];
    if (_bookmarksBusRoutes.contains(route)) return;
    _bookmarksBusRoutes.add(route);

    emit(_bookmarksBusRoutes);
  }

  void removeBookmark(BusRoutes route) async {
    logger.i("removeBookmark route: $route");
    _bookmarksBusRoutes.remove(route);

    emit(_bookmarksBusRoutes);
  }
}

class RoutesHistoryCubit extends Cubit<Iterable<BusRoutes>> {
  List<BusRoutes> _historyBusRoutes = [];
  RoutesHistoryCubit() : super([]);

  init(Iterable<BusRoutes> busRoutes) async {
    _historyBusRoutes = busRoutes.toList();
    logger.i("init history");

    emit(_historyBusRoutes);
  }

  void addHistory(BusRoutes route) async {
    logger.i("addHistory route: $route");
    _historyBusRoutes.add(route);

    emit(_historyBusRoutes);
  }
}
