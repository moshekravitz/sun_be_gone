import 'package:flutter/foundation.dart';
import 'package:sun_be_gone/models/nav_index.dart';

@immutable
class AppState {
  final bool isLoading;
  final NavIndex navIndex;

  const AppState({required this.isLoading, required this.navIndex});

  AppState.init()
      : isLoading = false,
        navIndex = NavIndex(Pages.home);
}
