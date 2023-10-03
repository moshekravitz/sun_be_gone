import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_be_gone/bloc/navigation_bloc.dart';
import 'package:sun_be_gone/models/nav_index.dart';

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

class EnterSearch extends StatelessWidget {
  const EnterSearch({
    super.key,
    required this.bottomNavBarBloc,
  });

  final BottomNavBarBloc bottomNavBarBloc;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => bottomNavBarBloc.changeTab(Pages.search),
        child: Container(
          width: 333.0,
          height: 52.0,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2), // Color with opacity
                offset: Offset(5, 5), // Horizontal and vertical offset
                blurRadius: 5.0, // Blur radius
                spreadRadius: 0.0, // Spread radius
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(
                color: const Color(0x79797900),
                width: 1.0,
                style: BorderStyle.solid),
          ),
          child: const Row(
            children: [
              Expanded(
                child: Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              Icon(
                Icons.search,
                size: 30.0,
                color: Colors.blue,
              ),
            ],
          ),
        ),
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
