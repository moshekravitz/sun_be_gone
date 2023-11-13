import 'package:flutter/material.dart';
import 'package:sun_be_gone/dialogs/stop_picker_dialog_controller.dart';
import 'package:sun_be_gone/dialogs/stops_list_view.dart';
import 'package:sun_be_gone/models/route_quary_info.dart';
import 'package:sun_be_gone/models/stop_info.dart';

typedef ButtonPressedCallback = void Function();

class StopPicker {
  // singleton pattern
  StopPicker._sharedInstance();
  static final StopPicker _shared = StopPicker._sharedInstance();
  factory StopPicker.instance() => _shared;

  late StopPickerController? _controller;
  late ButtonPressedCallback onCloseButton;
  late ButtonPressedCallback onCancelButton;
  late Function(int) setDepartureIndex;
  late Function(int) setDestinationIndex;

  late Iterable<StopQuaryInfo> stops;

  void show({
    required BuildContext context,
    required Iterable<StopQuaryInfo> stops,
    required ButtonPressedCallback onCloseButton,
    required ButtonPressedCallback onCancelButton,
    required Function(int) setDepartureIndex,
    required Function(int) setDestinationIndex,
  }) {
    _controller = _showOverlay(
      context: context,
      stops: stops,
      onCloseButton: onCloseButton,
      onCancelButton: onCancelButton,
      setDepartureIndex: setDepartureIndex,
      setDestinationIndex: setDestinationIndex,
    );
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  StopPickerController _showOverlay({
    required BuildContext context,
    required Iterable<StopQuaryInfo> stops,
    required ButtonPressedCallback onCloseButton,
    required ButtonPressedCallback onCancelButton,
    required Function(int) setDepartureIndex,
    required Function(int) setDestinationIndex,
  }) {
    // get the size

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: StopsListView(
                        stops: stops,
                        setDepartureIndex: setDepartureIndex,
                        setDestinationIndex: setDestinationIndex,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: onCancelButton,
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 5),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: onCloseButton,
                          child: const Text('Go'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    state.insert(overlay);

    return StopPickerController(
      close: () {
        overlay.remove();
        return true;
      },
    );
  }
}
