import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_be_gone/models/nav_index.dart';

typedef OnSubmittedLine = void Function(String? value);

class LinesSearch extends StatefulWidget {
  LinesSearch({super.key, required this.onSubmittedLine});

  final OnSubmittedLine onSubmittedLine;

  @override
  State<LinesSearch> createState() => _LinesSearchState();
}

class _LinesSearchState extends State<LinesSearch> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => widget.onSubmittedLine(_controller.text));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              decoration: const InputDecoration(
                border: InputBorder.none, // Remove the default border
                hintText: 'line numbe',
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10), // Optional: Adjust text padding
              ),
              style: const TextStyle(
                  color: Colors.black), // Optional: Adjust text color
            ),
          ),
        ],
      ),
    );
  }
}
