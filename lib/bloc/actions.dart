import 'package:flutter/foundation.dart' show immutable;
import 'package:sun_be_gone/models/nav_index.dart';

@immutable
abstract class AppAction {
  const AppAction();
}

@immutable
class NavigationAction extends AppAction {
    final Pages pageIndex;

  const NavigationAction({required this.pageIndex});

}
