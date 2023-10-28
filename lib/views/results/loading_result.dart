import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sun_be_gone/animations/results_animation.dart';
import 'package:sun_business/sun_business.dart' show SittingInfo;

class LoadingResult extends StatelessWidget {
  final SittingInfo sittingInfo;

  const LoadingResult({super.key, required this.sittingInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: AnimatedCurvedProgressBar(
        sittingInfo: sittingInfo,
      )),
    );
  }
}
