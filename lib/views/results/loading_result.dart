
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingResult extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: LoadingAnimationWidget.twoRotatingArc(color: Colors.green, size: 100,)),
    );
  }
}
