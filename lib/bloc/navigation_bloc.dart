// counter_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:sun_be_gone/models/nav_index.dart';

class BottomNavBarBloc extends Cubit<NavIndex> {
  BottomNavBarBloc() : super(NavIndex(Pages.home)); // Initial index

  void changeTab(Pages pageIndex) {
    emit(NavIndex(pageIndex));
  }
}
