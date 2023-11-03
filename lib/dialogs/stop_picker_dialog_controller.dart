import 'package:flutter/foundation.dart' show immutable;

typedef CloseStopPicker = bool Function();

@immutable
class StopPickerController {
  final CloseStopPicker close;
  const StopPickerController({
    required this.close,
  });
}
