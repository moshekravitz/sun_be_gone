import 'package:flutter/material.dart';
import 'package:sun_be_gone/data/app_cache.dart';
import 'package:sun_be_gone/data/persistent_data.dart';
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sun_be_gone/views/search/routes_list_view.dart';

class BookmarksPage extends StatelessWidget {
  final Iterable<BusRoutes> historyRoutes;
  final Iterable<BusRoutes> bookmarkedRoutes;
  final OnRoutePicked onRoutePicked;

  BookmarksPage({
    super.key,
    required this.onRoutePicked,
    required this.historyRoutes,
    required this.bookmarkedRoutes,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.history, color: Colors.black)),
              Tab(icon: Icon(Icons.star, color: Colors.black)),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(children: [
              RoutesListView(
                routes: historyRoutes,
                onRoutePicked: onRoutePicked,
              ),
              RoutesListView(
                routes: bookmarkedRoutes,
                onRoutePicked: onRoutePicked,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
