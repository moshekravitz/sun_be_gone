import 'package:flutter/material.dart';
import 'package:sun_be_gone/views/search/directions_search.dart';
import 'package:sun_be_gone/views/search/lines_search.dart';

class SearchPage extends StatefulWidget {
  OnDirectionEditingComplete onDirectionEditingComplete;
  OnLineEditingComplete onLineEditingComplete;
  SearchPage(
      {super.key,
      required this.onDirectionEditingComplete,
      required this.onLineEditingComplete});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _selectedTabIndex = 0; // To keep track of the selected tab index
  double _containerHeight = 350; // To set the height of the container

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _containerHeight,
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
                    height: 35, width: 110, child: buildTabButton('Lines', 1)),
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
          ],
        ),
      ),
    );
  }

  // Helper method to build tab buttons
  Widget buildTabButton(String text, int index) {
    return _selectedTabIndex == index
        ? ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedTabIndex = index;
                _selectedTabIndex == 0
                    ? _containerHeight = 350
                    : _containerHeight = 170;
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
                _selectedTabIndex == 0
                    ? _containerHeight = 350
                    : _containerHeight = 170;
              });
            },
            child: Center(child: Text(text)),
          );
  }

  // Placeholder widgets for different search content
  Widget buildDirectionsSearch() {
    return DirectoinsSearch(
        onDirectionEditingComplete: widget.onDirectionEditingComplete);
  }

  Widget buildLinesSearch() {
    return LinesSearch(onLineEditingComplete: widget.onLineEditingComplete);
  }
}
