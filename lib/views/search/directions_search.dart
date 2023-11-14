import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef OnDepartureEditingComplete = void Function(String? text);
typedef OnDirectionEditingComplete = void Function(String? , String?);

@immutable
class DirectoinsSearch extends StatefulWidget {
  const DirectoinsSearch({
    super.key,
    required this.onDirectionEditingComplete,
    required this.onDepartureEditingComplete,
  });

  final OnDirectionEditingComplete onDirectionEditingComplete;
  final OnDepartureEditingComplete onDepartureEditingComplete;

  @override
  State<DirectoinsSearch> createState() => _DirectoinsSearchState();
}

class _DirectoinsSearchState extends State<DirectoinsSearch> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => widget.onDepartureEditingComplete(_controller.text));
    _controller2.addListener(() => widget.onDirectionEditingComplete(_controller.text, _controller2.text));
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String departureHint = AppLocalizations.of(context)!.departureHint;
    final String destinationHint = AppLocalizations.of(context)!.destinationHint;
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
                //onChanged: widget.onDepartureEditingComplete,
                decoration: InputDecoration(
                  border: InputBorder.none, // Remove the default border
                  hintText: departureHint,
                  contentPadding: const EdgeInsets.symmetric(
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
                //onChanged: widget.onDirectionEditingComplete,
                decoration: InputDecoration(
                  border: InputBorder.none, // Remove the default border
                  hintText: destinationHint,
                  contentPadding: const EdgeInsets.symmetric(
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
