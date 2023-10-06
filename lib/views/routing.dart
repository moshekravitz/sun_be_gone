import 'package:flutter/material.dart';
import 'package:sun_be_gone/models/nav_index.dart';
import 'package:sun_be_gone/views/homescreen/home.dart';
import 'package:sun_be_gone/views/search/search_page.dart';

class Routing {
  static Widget go(Pages index) {
    switch (index) {
      case Pages.home:
        return Home();
      case Pages.home2:
        return Home2();
      case Pages.search:
        return SearchPage();
      default:
        return Scaffold(
          body: Center(
            child: Text('No route defined for ${index.name}'),
          ),
        );
    }
  }
}
