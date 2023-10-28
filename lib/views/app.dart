import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_be_gone/bloc/actions.dart';
import 'package:sun_be_gone/bloc/app_bloc.dart';
import 'package:sun_be_gone/bloc/app_state.dart';
import 'package:sun_be_gone/dialogs/loading_screen.dart';
import 'package:sun_be_gone/dialogs/stop_picker_dialog.dart';
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sun_be_gone/models/nav_index.dart';
import 'package:sun_be_gone/services/bus_extended_route_api.dart';
import 'package:sun_be_gone/services/bus_routes_api.dart';
import 'package:sun_be_gone/services/bus_shape_api.dart';
import 'package:sun_be_gone/services/bus_stops_api.dart';
import 'package:sun_be_gone/services/results_api.dart';
import 'package:sun_be_gone/services/server_connection_api.dart';
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
      home: BlocProvider(
        lazy: false,
        create: (context) => AppBloc(
          busRoutesApi: BusRoutesApi(),
          extendedRoutesApi: ExtendedRouteApi(),
          busStopsApi: BusStopsApi(),
          busShapeApi: BusShapeApi(),
          resultsApi: ResultsApi(),
          serverConnectionApi: ServerConnectionApi(),
        ),
        child: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  //int currentPageIndex = 0;
  //var pagesNames = ['Home', 'Home2', 'Home3', 'Search'];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, appState) {
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
        if ((appState is StopPickerState) && appState.isStopPickerDialogOpen) {
          StopPicker.instance().show(
              context: context,
              stops: appState.stops!,
              onCloseButton: () {
                //context.read<AppBloc>().add(const NavigationAction(pageIndex: Pages.home2));
                StopPicker.instance().hide();
                context.read<AppBloc>().add(const StopPickerClosedAction());
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
            Pages.home2 => Home2(),
            Pages.search => SearchPage(
            routes: (appState as DataState).routes,
                onRoutePicked: (value) =>
                    context.read<AppBloc>().add(GetStopsAction(routeId: value)),
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
              Pages.home2 => 1,
              Pages.search => 0,
              Pages.results => 0,
            },
            onBottomNavBarTap: (index) => context
                .read<AppBloc>()
                .add(NavigationAction(pageIndex: Pages.values[index])),
          ),
        );
      },
    );
  }
}
