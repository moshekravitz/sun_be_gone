import 'package:bloc/bloc.dart';
import 'package:sun_be_gone/data/persistent_data.dart';
import 'package:sun_be_gone/models/bus_routes.dart';

class BookMarksCubit extends Cubit<Iterable<BusRoutes>> {
  List<BusRoutes> _bookmarksBusRoutes = [];
  BookMarksCubit() : super([]);

  void init(List<BusRoutes> bookmarks) {
    _bookmarksBusRoutes = bookmarks;
    emit(_bookmarksBusRoutes);
  }

  void addBookmark(BusRoutes route) {
    print("addBookmark");
    _bookmarksBusRoutes.add(route);
    emit(_bookmarksBusRoutes);
  }

  void removeBookmark(BusRoutes route) {
    _bookmarksBusRoutes.remove(route);
    emit(_bookmarksBusRoutes);
  }
}

class RoutesHistoryCubit extends Cubit<Iterable<BusRoutes>> {
  List<BusRoutes> _historyBusRoutes = [];
  RoutesHistoryCubit() : super([]);

  init(List<BusRoutes> history) {
    _historyBusRoutes = history;
    emit(_historyBusRoutes);
  }

  void addHistory(BusRoutes route) {
    print("addHistory");
    _historyBusRoutes.add(route);
    emit(_historyBusRoutes);
  }
}
