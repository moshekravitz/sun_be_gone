import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_be_gone/bloc/actions.dart';
import 'package:sun_be_gone/bloc/app_bloc.dart';
import 'package:sun_be_gone/bloc/app_state.dart';
import 'package:sun_be_gone/models/nav_index.dart';
import 'package:sun_be_gone/views/homescreen/home.dart';
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
        create: (context) => AppBloc(),
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
      listener: (context, appState) {},
      builder: (context, appState) {
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
                    .add(const NavigationAction(pageIndex: Pages.search))),
            Pages.home2 => Home2(),
            Pages.search => SearchPage(
                onDirectionEditingComplete: () => context
                    .read<AppBloc>()
                    .add(const NavigationAction(pageIndex: Pages.home2)),
                onLineEditingComplete: () => context
                    .read<AppBloc>()
                    .add(const NavigationAction(pageIndex: Pages.home2)),
              ),
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
                Pages.home3 => 2,
                Pages.search => 0,
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
