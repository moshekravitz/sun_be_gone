import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_be_gone/bloc/actions.dart';
import 'package:sun_be_gone/bloc/app_bloc.dart';
import 'package:sun_be_gone/bloc/app_state.dart';
import 'package:sun_be_gone/bloc/bus_routes_bloc.dart';
import 'package:sun_be_gone/data/app_cache.dart';
import 'package:sun_be_gone/data/persistent_data.dart';
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
import 'package:sun_be_gone/views/bookmarks/bookmarks_page.dart';
import 'package:sun_be_gone/views/homescreen/home.dart';
import 'package:sun_be_gone/views/results/loading_result.dart';
import 'package:sun_be_gone/views/search/search_page.dart';
import 'package:sun_be_gone/widgets/bottom_navigation.dart';

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
        ],
        child: MainScreen(),
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
        if (appState is DataState && (appState as DataState).error != null) {
          showGenericDialog<bool>(
            context: context,
            title: 'Error',
            content: (appState as DataState).error!.toString(),
            optionsBuilder: () => {'OK': true},
          );
        }
        if (appState.isLoading) {
          LoadingScreen.instance().show(
            context: context,
            text: 'please wait',
          );
        } else {
          LoadingScreen.instance().hide();
        }
        if (appState.isInitialized == false) {
          context.read<AppBloc>().add(const InitAppAction());
        }
        if (appState.navIndex == NavIndex(Pages.search) &&
            AppCache.instance().busRoutes == null) {
          context.read<BusRotuesBloc>().add(const GetBusRoutesAction());
        }
        if ((appState is StopPickerState) && appState.isStopPickerDialogOpen) {
          int departureIndex = -1;
          int arrivalIndex = -1;
          StopPicker.instance().show(
              context: context,
              stops: appState.quaryInfo!.fullStopQuaryInfo!,
              setDepartureIndex: (index) => departureIndex = index,
              setDestinationIndex: (index) => arrivalIndex = index,
              onCloseButton: () {
                //context.read<AppBloc>().add(const NavigationAction(pageIndex: Pages.home2));
                StopPicker.instance().hide();
                context.read<AppBloc>().add(StopPickerClosedAction(
                    departureIndex: departureIndex,
                    destinationIndex: arrivalIndex));
              });
        }
      },
      builder: (context, appState) {
        if (appState.isInitialized == false) {
          context.read<AppBloc>().add(const InitAppAction());
        }
        return Scaffold(
          appBar: AppBar(
            title: Center(
              //child: Text(pagesNames[navIndex.index]),
              child: Text(appState.navIndex.name),
            ),
          ),
          body: switch (appState.navIndex.pageIndex) {
            Pages.home => Home(
                onSearchTapped: () => context
                    .read<AppBloc>()
                    .add(const GetRoutesAction(pageIndex: Pages.search))),
            Pages.bookmarks => BookmarksPage(
                historyRoutes: (appState as BookmarksState).historyRoutes,
                bookmarkedRoutes: (appState as BookmarksState).bookmarksRoutes,
                onRoutePicked: (value) =>
                    context.read<AppBloc>().add(GetStopsAction(routeId: value)),
              ),
            Pages.search => SearchPage(
                onRoutePicked: (value) {
                  AppData.addHistory(value.toString());
                  context.read<AppBloc>().add(GetStopsAction(routeId: value));
                },
                selectedTime: (appState is DataState &&
                        (appState as DataState).quaryInfo != null)
                    ? (appState as DataState).quaryInfo!.dateTime ??
                        DateTime.now()
                    : DateTime.now(),
              ),
            Pages.results => LoadingResult(
                sittingInfo: (appState as ResultsState).sittingInfo!),
            (_) => Scaffold(
                body: Center(
                  child: Text(
                      'No route defined for ${appState.navIndex.pageIndex.name}'),
                ),
              ),
          },
          bottomNavigationBar: BottomNavBar(
              index: switch (appState.navIndex.pageIndex) {
                Pages.home => 0,
                Pages.bookmarks => 1,
                Pages.search => 0,
                Pages.results => 0,
              },
              onBottomNavBarTap: (index) {
                if (index == 0) {
                  context
                      .read<AppBloc>()
                      .add(NavigationAction(pageIndex: Pages.values[index]));
                }

                if (index == 1) {
                  context
                      .read<AppBloc>()
                      .add(const NavigatedToBookmarksAction());
                }
              }),
        );
      },
    );
  }
}
