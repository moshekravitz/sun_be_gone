import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_be_gone/data/app_cache.dart';
import 'package:sun_be_gone/models/bus_routes.dart' show BusRoutes;
import 'package:sun_be_gone/utils/logger.dart';

@immutable
class BusRoutesAction {
  const BusRoutesAction();
}

class GetBusRoutesAction extends BusRoutesAction {
  const GetBusRoutesAction();
}

@immutable
class FilterBusRoutesAction extends BusRoutesAction {
  final bool Function(BusRoutes?) filterFunction;

  const FilterBusRoutesAction({
    required this.filterFunction,
  });
}

@immutable
class BusRoutesState {
  final Error? error;
  final Iterable<BusRoutes> busRoutes;

  const BusRoutesState({
    this.error,
    required this.busRoutes,
  });

  factory BusRoutesState.init() => const BusRoutesState(
        busRoutes: [],
      );
}

class BusRotuesBloc extends Bloc<BusRoutesAction, BusRoutesState> {
  BusRotuesBloc()
      : super(BusRoutesState(
          busRoutes: AppCache.instance().busRoutes ?? [],
        )) {
    on<GetBusRoutesAction>((event, emit) async {
      logger.i('BusRoutesAction get called');
      if (AppCache.instance().busRoutesIsNotComplete) {
        logger.e('bus routes didnt get from server in busRoutesBloc');
      }
      logger.i('getting routes from cache');
      try {
        Iterable<BusRoutes> routes = AppCache.instance().busRoutes!;
        emit(BusRoutesState(
          busRoutes: routes,
        ));
        return;
      } catch (e) {
        logger.e('error in getting routes from cache');
        emit(BusRoutesState(
          error: e as Error,
          busRoutes: const [],
        ));
      }
    });

    on<FilterBusRoutesAction>((event, emit) async {
      logger.i('FilterBusRoutesAction filterCalled called');
      if (AppCache.instance().busRoutes == null) {
        emit(const BusRoutesState(
          busRoutes: [],
        ));
        return;
      }
      final filteredRoutes =
          AppCache.instance().busRoutes!.where(event.filterFunction);
      emit(BusRoutesState(
        busRoutes: filteredRoutes,
      ));
    });
  }
}
