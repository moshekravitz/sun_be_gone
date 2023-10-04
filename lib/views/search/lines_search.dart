import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_be_gone/bloc/navigation_bloc.dart';
import 'package:sun_be_gone/models/nav_index.dart';

class LinesSearch extends StatelessWidget {
  const LinesSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavBarBloc = BlocProvider.of<BottomNavBarBloc>(context);
    final TextEditingController _controller = TextEditingController();

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          //white space
          const SizedBox(height: 20),
          Container(
            width: 350,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(
                  8.0), // Optional: To add rounded corners
            ),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.go,
              onEditingComplete: () => bottomNavBarBloc.changeTab(Pages.home2),
              decoration: const InputDecoration(
                border: InputBorder.none, // Remove the default border
                hintText: 'line numbe',
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10), // Optional: Adjust text padding
              ),
              style: const TextStyle(
                  color: Colors.white), // Optional: Adjust text color
            ),
          ),
        ],
      ),
    );
  }
}
