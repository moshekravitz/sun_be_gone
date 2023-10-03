import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_be_gone/widgets/bottom_navigation.dart';
import 'package:sun_be_gone/bloc/navigation_bloc.dart';
import 'package:sun_be_gone/views/homescreen/home.dart';
import 'package:sun_be_gone/views/router.dart';
import 'package:sun_be_gone/models/nav_index.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return AppNav();
  }
}

class AppNav extends StatefulWidget {
  const AppNav({super.key});

  @override
  State<AppNav> createState() => _AppNavState();
}

class _AppNavState extends State<AppNav> {
  final BottomNavBarBloc bottomNavBarBloc = BottomNavBarBloc();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sun Be Gone',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: BlocProvider(
        create: (context) => bottomNavBarBloc,
        child: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  //int currentPageIndex = 0;
  //var pagesNames = ['Home', 'Home2', 'Home3', 'Search'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarBloc, NavIndex>(
      builder: (context, navIndex) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
              //child: Text(pagesNames[navIndex.index]),
              child: Text(navIndex.name),
            ),
          ),
          body: Routing.go(navIndex.pageIndex),
          bottomNavigationBar: BottomNavBar(),
        );
      },
    );
  }
}
