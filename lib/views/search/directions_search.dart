import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_be_gone/models/nav_index.dart';

typedef OnDepartureEditingComplete = void Function(String? text);
typedef OnDirectionEditingComplete = void Function(String? text);

class DirectoinsSearch extends StatelessWidget {
  DirectoinsSearch({
    super.key,
    required this.onDirectionEditingComplete,
    required this.onDepartureEditingComplete,
  });

  final OnDirectionEditingComplete onDirectionEditingComplete;
  final OnDepartureEditingComplete onDepartureEditingComplete;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              height: 90,
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
                onChanged: onDepartureEditingComplete,
                decoration: const InputDecoration(
                  border: InputBorder.none, // Remove the default border
                  hintText: 'Departure',
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10), // Optional: Adjust text padding
                ),
                style: const TextStyle(
                    color: Colors.black), // Optional: Adjust text color
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
                onChanged: onDirectionEditingComplete,
                decoration: const InputDecoration(
                  border: InputBorder.none, // Remove the default border
                  hintText: 'destination',
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10), // Optional: Adjust text padding
                ),
                style: const TextStyle(
                    color: Colors.black), // Optional: Adjust text color
              ),
            ),
          ],
        ),
      ],
    );
  }
}
