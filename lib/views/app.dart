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
import 'package:sun_be_gone/views/bookmarks/bookmarks_page.dart';
import 'package:sun_be_gone/views/homescreen/home.dart';
import 'package:sun_be_gone/views/results/loading_result.dart';
import 'package:sun_be_gone/views/search/search_page.dart';
import 'package:sun_be_gone/widgets/bottom_navigation.dart';
import 'package:sun_be_gone/widgets/splash_screen.dart';

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
        if (appState is ErrorState) {
          showGenericDialog<bool>(
            context: context,
            title: 'Error',
            content: appState.error.toString(),
            optionsBuilder: () => {'OK': true},
          );
        }

        if (appState is IsLoadingState) {
          LoadingScreen.instance().show(
            context: context,
            text: 'please wait',
          );
        } else {
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
        if(appState is RemovedFavoriteState){
          context.read<BookMarksCubit>().removeBookmark(appState.busRoute);
        }
      },
      builder: (context, appState) {
        return const MainApp();
      },
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AppState appState = context.watch<AppBloc>().state;
    late AppState myState;
    return BlocBuilder<NavIndexCubit, NavIndex>(buildWhen: (previous, current) {
      print(
          'past page: ${previous.pageIndex} current page: ${current.pageIndex}');
      bool mainArg = previous.pageIndex != current.pageIndex;
      //bool bookmarksArg = current.pageIndex == Pages.bookmarks && appState is BookmarksState;
      //bool dontBuildIfBookmarksWasBuiltInThePast = current.pageIndex == Pages.bookmarks && myState is BookmarksState;
      return mainArg; // || dontBuildIfBookmarksWasBuiltInThePast;
    }, builder: (context, navIndex) {
      if (appState is InitState && !appState.isInitialized) {
        print('init state Not init');
        context.read<AppBloc>().add(const InitAppAction());
      }
      if (appState is ResultsState || appState is BookmarksState) {
        print('3 from listener app state: $appState');
        myState = appState;
      }
      print('building main with state: $appState');
      return navIndex.pageIndex == Pages.notFound
          ? const SplashScreen()
          : Scaffold(
              appBar: AppBar(
                title: Center(
                  //child: Text(pagesNames[navIndex.index]),
                  child: Text(navIndex.name),
                ),
              ),
              body: switch (navIndex.pageIndex) {
                Pages.home => Home(
                    onSearchTapped: () =>
                        context.read<AppBloc>().add(const GetRoutesAction())),
                Pages.bookmarks => BookmarksPage(
                    onSlidePressedRemoveFav: (value) => context
                        .read<AppBloc>()
                        .add(RemoveRouteFromFavoritesAction(routeId: value)),
                    onSlidePressedAddFav: (value) => context
                        .read<AppBloc>()
                        .add(AddRouteToFavoritsAction(routeId: value)),
                    onRoutePicked: (value, dateTime) => context
                        .read<AppBloc>()
                        .add(
                            GetStopsAction(routeId: value, dateTime: dateTime)),
                  ),
                Pages.search => SearchPage(
                    onSlidePressed: (value) => context
                        .read<AppBloc>()
                        .add(AddRouteToFavoritsAction(routeId: value)),
                    onRoutePicked: (value, dateTime) {
                      context.read<AppBloc>().add(
                          AddRouteToHistoryAction(routeId: value.toString()));
                      context.read<AppBloc>().add(
                          GetStopsAction(routeId: value, dateTime: dateTime));
                    },
                  ),
                Pages.results => LoadingResult(
                    sittingInfo: (appState as ResultsState).sittingInfo!),
                (_) => Scaffold(
                    body: Center(
                      child: Text(
                          'No route defined for ${navIndex.pageIndex.name}'),
                    ),
                  ),
              },
              bottomNavigationBar: BottomNavBar(
                  index: switch (navIndex.pageIndex) {
                    Pages.notFound => 0,
                    Pages.home => 0,
                    Pages.bookmarks => 1,
                    Pages.search => 0,
                    Pages.results => 0,
                  },
                  onBottomNavBarTap: (index) {
                    if (index == 0) {
                      context
                          .read<NavIndexCubit>()
                          .setIndex(const NavIndex(Pages.home));
                    }

                    if (index == 1) {
                      context
                          .read<AppBloc>()
                          .add(const NavigatedToBookmarksAction());
                    }
                  }),
            );
    });
  }
}
