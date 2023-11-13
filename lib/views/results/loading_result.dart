import 'package:flutter/material.dart';
import 'package:sun_be_gone/animations/results_animation.dart';
import 'package:sun_be_gone/dialogs/generic_dialog.dart';
import 'package:sun_business/sun_business.dart' show SittingInfo;

class LoadingResult extends StatelessWidget {
  final SittingInfo sittingInfo;

  const LoadingResult({super.key, required this.sittingInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //button in top right corner
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.help),
              onPressed: () => showGenericDialog<bool>(
                context: context,
                title: 'Info',
                content:
                    'Left means sit on the drivers side of the bus, right means sit at the side of the doors.',
                optionsBuilder: () => {'OK': true},
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: AnimatedCurvedProgressBar(
                sittingInfo: sittingInfo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
