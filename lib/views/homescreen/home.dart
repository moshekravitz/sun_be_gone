import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_be_gone/bloc/navigation_bloc.dart';
import 'package:sun_be_gone/models/nav_index.dart';
import 'package:sun_be_gone/views/homescreen/enter_search.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bottomNavBarBloc = BlocProvider.of<BottomNavBarBloc>(context);
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
                        EnterSearch(bottomNavBarBloc: bottomNavBarBloc),
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
    return Scaffold(
      // Body
      body: Center(
        child: Text("Home Page 2"),
      ),
    );
  }
}
