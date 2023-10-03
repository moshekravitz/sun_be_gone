import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _selectedTabIndex = 0; // To keep track of the selected tab index

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //white space
        const SizedBox(height: 20),
        // Tabs for Directions, Lines, and Stations
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
                height: 35, width: 110, child: buildTabButton('Directions', 0)),
            SizedBox(
                height: 35, width: 110, child: buildTabButton('Lines', 1)),
            SizedBox(
                height: 35, width: 110, child: buildTabButton('Stations', 2)),
          ],
        ),
        // Content based on the selected tab
        Expanded(
          child: _selectedTabIndex == 0
              ? buildDirectionsSearch()
              : _selectedTabIndex == 1
                  ? buildLinesSearch()
                  : buildStationsSearch(),
        ),
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
            child:Center(child: Text(text)),
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
    return Center(
      child: Text('Directions Search Content'),
    );
  }

  Widget buildLinesSearch() {
    return Center(
      child: Text('Lines Search Content'),
    );
  }

  Widget buildStationsSearch() {
    return Center(
      child: Text('Stations Search Content'),
    );
  }
}
