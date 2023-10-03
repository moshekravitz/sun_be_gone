// bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_be_gone/bloc/navigation_bloc.dart';
import 'package:sun_be_gone/models/nav_index.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomNavBarBloc = BlocProvider.of<BottomNavBarBloc>(context);

    return BlocBuilder<BottomNavBarBloc, NavIndex>(
      builder: (context, currentNavIndex) {
         late final Pages navIndex;
          if(currentNavIndex.pageIndex == Pages.search) {
            navIndex = Pages.home;
          } else {
            navIndex = currentNavIndex.pageIndex;
          }

        return BottomNavigationBar(
          currentIndex: navIndex.index,
          onTap: (index) {
            bottomNavBarBloc.changeTab(Pages.values[index]);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        );
      },
    );
  }
}
