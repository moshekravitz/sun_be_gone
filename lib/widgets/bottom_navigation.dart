// bottom_nav_bar.dart
import 'package:flutter/material.dart';

typedef OnBottomNavBarTap = void Function(int);

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required this.index,
    required this.onBottomNavBarTap,
  }) : super(key: key);

  final int index;
  final OnBottomNavBarTap onBottomNavBarTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: onBottomNavBarTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Favorites',
        ),
      ],
    );
  }
}
