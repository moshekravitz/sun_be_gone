import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_be_gone/bloc/actions.dart';
import 'package:sun_be_gone/bloc/app_bloc.dart';
import 'package:sun_be_gone/bloc/app_state.dart';
import 'package:sun_be_gone/bloc/nav_index_cubit.dart';
import 'package:sun_be_gone/models/nav_index.dart';
import 'package:sun_be_gone/views/bookmarks/bookmarks_page.dart';
import 'package:sun_be_gone/views/homescreen/home.dart';
import 'package:sun_be_gone/views/results/loading_result.dart';
import 'package:sun_be_gone/views/search/search_page.dart';
import 'package:sun_be_gone/widgets/bottom_navigation.dart';
import 'package:sun_be_gone/widgets/splash_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AppState appState = context.watch<AppBloc>().state;
    return BlocBuilder<NavIndexCubit, NavIndex>(
        buildWhen: (previous, current) =>
            previous.pageIndex != current.pageIndex,
        builder: (context, navIndex) {
          if (appState is InitState && !appState.isInitialized) {
            print('init state Not init');
            context.read<AppBloc>().add(const InitAppAction());
          }
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
                        onSearchTapped: () => context
                            .read<AppBloc>()
                            .add(const GetRoutesAction())),
                    Pages.bookmarks => BookmarksPage(
                        onSlidePressedRemoveFav: (value) => context
                            .read<AppBloc>()
                            .add(
                                RemoveRouteFromFavoritesAction(routeId: value)),
                        onSlidePressedAddFav: (value) => context
                            .read<AppBloc>()
                            .add(AddRouteToFavoritsAction(routeId: value)),
                        onRoutePicked: (value, dateTime) => context
                            .read<AppBloc>()
                            .add(GetStopsAction(
                                routeId: value, dateTime: dateTime)),
                      ),
                    Pages.search => SearchPage(
                        onSlidePressed: (value) => context
                            .read<AppBloc>()
                            .add(AddRouteToFavoritsAction(routeId: value)),
                        onRoutePicked: (value, dateTime) {
                          context.read<AppBloc>().add(GetStopsAction(
                              routeId: value, dateTime: dateTime));
                          //context.read<AppBloc>().add(AddRouteToHistoryAction(
                           //   routeId: value.toString()));
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
