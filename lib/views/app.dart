import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_be_gone/bloc/actions.dart';
import 'package:sun_be_gone/bloc/app_bloc.dart';
import 'package:sun_be_gone/bloc/app_state.dart';
import 'package:sun_be_gone/bloc/bookmarks_bloc.dart';
import 'package:sun_be_gone/bloc/bus_routes_bloc.dart';
import 'package:sun_be_gone/bloc/date_time_cubit.dart';
import 'package:sun_be_gone/bloc/nav_index_cubit.dart';
import 'package:sun_be_gone/dialogs/generic_dialog.dart';
import 'package:sun_be_gone/dialogs/loading_screen.dart';
import 'package:sun_be_gone/dialogs/stop_picker_dialog.dart';
import 'package:sun_be_gone/models/nav_index.dart';
import 'package:sun_be_gone/services/bus_extended_route_api.dart';
import 'package:sun_be_gone/services/bus_routes_api.dart';
import 'package:sun_be_gone/services/bus_shape_api.dart';
import 'package:sun_be_gone/services/bus_stops_api.dart';
import 'package:sun_be_gone/services/results_api.dart';
import 'package:sun_be_gone/services/server_connection_api.dart';
import 'package:sun_be_gone/views/main_app.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sun Be Gone',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => BusRotuesBloc(
              busRoutesApi: BusRoutesApi(),
              serverConnectionApi: ServerConnectionApi(),
            ),
          ),
          BlocProvider(
            create: (context) => AppBloc(
              busRoutesApi: BusRoutesApi(),
              extendedRoutesApi: ExtendedRouteApi(),
              busStopsApi: BusStopsApi(),
              busShapeApi: BusShapeApi(),
              resultsApi: ResultsApi(),
              serverConnectionApi: ServerConnectionApi(),
            ),
          ),
          BlocProvider(
            create: (context) => NavIndexCubit(),
          ),
          BlocProvider(
            create: (context) => DateTimeCubit(),
          ),
          BlocProvider(
            create: (context) => BookMarksCubit(),
          ),
          BlocProvider(
            create: (context) => RoutesHistoryCubit(),
          ),
        ],
        child: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, appState) {
        print('app stata: $appState');
        if (appState is ErrorState) {
          showGenericDialog<bool>(
            context: context,
            title: 'Error',
            content: appState.error.toString(),
            optionsBuilder: () => {'OK': true},
          );
        }

        if (appState is IsLoadingState) {
          print('is loading state');
          LoadingScreen.instance().show(
            context: context,
            text: 'please wait',
          );
        } else {
          print('is not loading state');
          LoadingScreen.instance().hide();
        }

        if (appState is InitState) {
          if (appState.isInitialized) {
            print('init state is init');
            context.read<NavIndexCubit>().setIndex(const NavIndex(Pages.home));
            //context.read<AppBloc>().add(const InitAppAction());
            //context.read<AppBloc>().add(const GetRoutesAction());
          } else {
            print('init state Not init from listener');
            LoadingScreen.instance().show(
              context: context,
              text: 'please wait',
            );
          }
        }

        if (appState is RoutesReadyState) {
          context.read<NavIndexCubit>().setIndex(NavIndex(Pages.search));
          //context.read<BusRotuesBloc>().add(const GetBusRoutesAction());
        }

        if ((appState is StopPickerState) && appState.isStopPickerDialogOpen) {
          int departureIndex = -1;
          int arrivalIndex = -1;
          StopPicker.instance().show(
              context: context,
              stops: appState.quaryInfo!.fullStopQuaryInfo!,
              setDepartureIndex: (index) => departureIndex = index,
              setDestinationIndex: (index) => arrivalIndex = index,
              onCancelButton: () {
                StopPicker.instance().hide();
              },
              onCloseButton: () {
                //context.read<AppBloc>().add(const NavigationAction(pageIndex: Pages.home2));
                StopPicker.instance().hide();
                context.read<AppBloc>().add(StopPickerClosedAction(
                    quaryInfo: appState.quaryInfo!,
                    departureIndex: departureIndex,
                    destinationIndex: arrivalIndex));
              });
        }

        if (appState is ResultsState) {
          context.read<NavIndexCubit>().setIndex(const NavIndex(Pages.results));
        }

        if (appState is BookmarksState) {
          context.read<BookMarksCubit>().init(appState.favoriteRoutes);
          context.read<RoutesHistoryCubit>().init(appState.hisrotyRoutes);
          context
              .read<NavIndexCubit>()
              .setIndex(const NavIndex(Pages.bookmarks));
          // context.read<RoutesHistoryCubit>().addHistory(value.toString());
        }
        if (appState is AddedFavoriteState) {
          context.read<BookMarksCubit>().addBookmark(appState.busRoute);
        }
        if (appState is AddedHistoryRouteState) {
          context.read<RoutesHistoryCubit>().addHistory(appState.busRoute);
        }
        if (appState is RemovedFavoriteState) {
          context.read<BookMarksCubit>().removeBookmark(appState.busRoute);
        }
      },
      builder: (context, appState) {
        return const MainApp();
      },
    );
  }
}
