import 'package:flutter/material.dart';
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sun_be_gone/views/homescreen/enter_search.dart';
import 'package:sun_be_gone/views/search/routes_list_view.dart';

class Home extends StatelessWidget {
  final OnSearchTapped onSearchTapped;

  const Home({super.key, required this.onSearchTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 250,
            child: Stack(
              children: <Widget>[
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.grey.withOpacity(
                        0.5), // Adjust the opacity to control the dimming effect
                    BlendMode
                        .dstATop, // This mode applies the filter on top of the image
                  ),
                  child: Image.asset(
                    'assets/maxresdefault-3375335936.jpg',
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 30,
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Where are you headed today?',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        EnterSearch(onSearchTapped: onSearchTapped),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Home2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Body
      body: Text('No routes found'),
    );
  }
}
