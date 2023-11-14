// bottom_nav_bar.dart
import 'package:flutter/material.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final String homeTitle = AppLocalizations.of(context)!.homeNavigationTitle;
    final String favoritesTitle =
        AppLocalizations.of(context)!.favoriteNavigationTitle;
    return BottomNavigationBar(
      currentIndex: index,
      onTap: onBottomNavBarTap,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: homeTitle,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.bookmark),
          label: favoritesTitle,
        ),
      ],
    );
  }
}
