
import 'package:bloc/bloc.dart';
import 'package:sun_be_gone/models/nav_index.dart';

class NavIndexCubit extends Cubit<NavIndex> {
  NavIndexCubit() : super(const NavIndex(Pages.entry));

  void setIndex(NavIndex index) {
    emit(index);
  }
}
