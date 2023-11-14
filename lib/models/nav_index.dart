import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Pages {
  entry,
  error,
  home,
  bookmarks,
  search,
  results,
}

class NavIndex {
  final Pages pageIndex;

  const NavIndex(this.pageIndex);

  int get index => pageIndex.index;
  //String get name => pageIndex.toString().split('.').last;
  String name(BuildContext context) {
    var locle = AppLocalizations.of(context)!;
    return switch (pageIndex) {
      Pages.entry => locle.homeTitle,
      Pages.error => locle.homeTitle,
      Pages.home => locle.homeTitle,
      Pages.bookmarks => locle.bookmarksTitle,
      Pages.search => locle.searchTitle,
      Pages.results => locle.resultsTitle,
      _ => pageIndex.toString().split('.').last,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavIndex &&
          runtimeType == other.runtimeType &&
          pageIndex == other.pageIndex;

  @override
  int get hashCode => pageIndex.hashCode;
}
