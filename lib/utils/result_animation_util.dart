import 'package:flutter/material.dart' show Colors, MaterialColor;
import 'package:sun_business/sun_business.dart' show SittingPosition;

class ResultAnimationUtil {
  static MaterialColor determinColor(SittingPosition position) {
    return switch (position) {
      SittingPosition.left => Colors.blue,
      SittingPosition.right => Colors.green,
      SittingPosition.both => Colors.grey,
    };
  }
}
