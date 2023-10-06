import 'package:bloc/bloc.dart';
import 'package:sun_be_gone/bloc/actions.dart';
import 'package:sun_be_gone/bloc/app_state.dart';
import 'package:sun_be_gone/models/nav_index.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  AppBloc() : super(AppState.init()) {
    on<NavigationAction>((event, emit) => emit(AppState(
          isLoading: false,
          navIndex: NavIndex(event.pageIndex),
        )));
  }
}
