import 'package:flutter/material.dart';
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sun_be_gone/views/search/directions_search.dart';
import 'package:sun_be_gone/views/search/lines_search.dart';
import 'package:sun_be_gone/views/search/routes_list_view.dart';

class SearchPage extends StatefulWidget {
  OnRoutePicked onRoutePicked;
  Iterable<BusRoutes?>? routes;
  SearchPage({
    super.key,
    required this.onRoutePicked,
    required this.routes,
  });
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _selectedTabIndex = 0; // To keep track of the selected tab index

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey, // Shadow color
                offset: Offset(
                    5, 0), // Offset controls the direction (right in this case)
                blurRadius: 5, // Adjust the blur radius as needed
              ),
            ],
          ),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //white space
                const SizedBox(height: 20),
                // Tabs for Directions, Lines, and Stations
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 20),
                    SizedBox(
                        height: 35,
                        width: 110,
                        child: buildTabButton('Directions', 0)),
                    const SizedBox(width: 10),
                    SizedBox(
                        height: 35,
                        width: 110,
                        child: buildTabButton('Lines', 1)),
                  ],
                ),
                const SizedBox(height: 20),
                // Content based on the selected tab
                //Expanded(
                //echild:
                Column(
                  children: <Widget>[
                    SizedBox(
                        child: _selectedTabIndex == 0
                            ? buildDirectionsSearch()
                            : buildLinesSearch())
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (widget.routes != null)
          Expanded(
            child: RoutesListView(
              routes: widget.routes!,
              onRoutePicked: widget.onRoutePicked,
            ),
          ),
        if (widget.routes == null) const Text('No routes found'),
      ],
    );
  }

  // Helper method to build tab buttons
  Widget buildTabButton(String text, int index) {
    return _selectedTabIndex == index
        ? ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: null,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Center(child: Text(text)),
          )
        : GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            child: Center(child: Text(text)),
          );
  }

  // Placeholder widgets for different search content
  Widget buildDirectionsSearch() {
    return DirectoinsSearch(
        onDepartureEditingComplete: (value) => setState(() {
              widget.routes = widget.routes!
                  .where((route) => route!.routeDeparture!.contains(value!));
            }),
        onDirectionEditingComplete: (value) => setState(() {
              widget.routes = widget.routes!
                  .where((route) => route!.routeDestination!.contains(value!));
            }));
  }

  Widget buildLinesSearch() {
    return LinesSearch(
      onSubmittedLine: (value) => setState(() {
        widget.routes = widget.routes!
            .where((route) => route!.routeShortName.contains(value!));
      }),
    );
  }
}
