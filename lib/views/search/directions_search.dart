import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_be_gone/bloc/navigation_bloc.dart';
import 'package:sun_be_gone/models/nav_index.dart';

class DirectoinsSearch extends StatelessWidget {
    DirectoinsSearch({super.key});

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
  final bottomNavBarBloc = BlocProvider.of<BottomNavBarBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 3,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 160,
              width: 23,
              alignment: Alignment.topCenter,
              child: Image.asset('assets/nodes.png'),
            ),
          ],
        ),
        Column(
          children: [
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
                decoration: const InputDecoration(
                  border: InputBorder.none, // Remove the default border
                  hintText: 'Departure',
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10), // Optional: Adjust text padding
                ),
                style: const TextStyle(
                    color: Colors.white), // Optional: Adjust text color
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 350,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                    8.0), // Optional: To add rounded corners
              ),
              child: TextField(
                controller: _controller2,
                textInputAction: TextInputAction.go,
                onEditingComplete: () => bottomNavBarBloc.changeTab(Pages.home2),
                decoration: const InputDecoration(
                  border: InputBorder.none, // Remove the default border
                  hintText: 'destination',
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10), // Optional: Adjust text padding
                ),
                style: const TextStyle(
                    color: Colors.white), // Optional: Adjust text color
              ),
            ),
          ],
        ),
      ],
    );
  }
}
