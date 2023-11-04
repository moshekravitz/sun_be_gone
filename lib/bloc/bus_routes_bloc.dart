import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_be_gone/data/app_cache.dart';
import 'package:sun_be_gone/models/bus_routes.dart' show BusRoutes;
import 'package:sun_be_gone/services/bus_routes_api.dart';
import 'package:sun_be_gone/services/server_connection_api.dart';

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
  final BusRoutesApiProtocol busRoutesApi;
  final ServerConnectionApiProtocol serverConnectionApi;

  BusRotuesBloc({
    required this.busRoutesApi,
    required this.serverConnectionApi,
  }) : super(BusRoutesState(
          busRoutes: AppCache.instance().busRoutes ?? [],
        )) {
    on<GetBusRoutesAction>((event, emit) async {
      print('BusRoutesAction get called');
      if (AppCache.instance().busRoutes != null) {
        print('getting routes from cache');
        emit(BusRoutesState(
          busRoutes: AppCache.instance().busRoutes!,
        ));
        return;
      }
      print('getting routes from server');
      try {
        final busRoutesResponse = await busRoutesApi.getBusRoutes();
        AppCache.instance().busRoutes = busRoutesResponse.data;

        if (busRoutesResponse.data == null) {
          emit(const BusRoutesState(
            busRoutes: [],
          ));
          return;
        }

        emit(BusRoutesState(
          busRoutes: busRoutesResponse.data!,
        ));
      } catch (e) {
        emit(BusRoutesState(
          error: e as Error,
          busRoutes: [],
        ));
      }
    });

    on<FilterBusRoutesAction>((event, emit) async {
      print('FilterBusRoutesAction filterCalled called');
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
