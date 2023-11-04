import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class DateTimePickerButton extends StatelessWidget {
  final DateTime dateTime;
  final Function(DateTime) onConfirm;

  const DateTimePickerButton({super.key, required this.dateTime, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
  //Widget buildTimePicker(Function(DateTime) onConfirm, DateTime dateTime) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: TextButton(
          onPressed: () => DatePicker.showDateTimePicker(
            context,
            showTitleActions: true,
            minTime: DateTime.now(),
            onConfirm: onConfirm,
            currentTime: dateTime,
          ),
          child: buildTimePicker(dateTime),
        ),
      ),
    );
  }


  Widget buildTimePicker(DateTime dateTime) {
    print('building date time');
    if (dateTime.day == DateTime.now().day) {
      return Row(
        children: [
          Text(
            'Departure at ${dateTime.hour}:${dateTime.minute} ',
          ),
          const Icon(
            Icons.arrow_drop_down,
          ),
        ],
      );
    } else {
      return Text(
        'Departure at ${dateTime.day}/${dateTime.month}, ${dateTime.hour}:${dateTime.minute} ',
      );
    }
  }
}
