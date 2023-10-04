
import 'package:flutter/material.dart';
import 'package:sun_be_gone/bloc/navigation_bloc.dart';
import 'package:sun_be_gone/models/nav_index.dart';

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
