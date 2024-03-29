import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:sun_be_gone/utils/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DateTimePickerButton extends StatelessWidget {
  final DateTime dateTime;
  final Function(DateTime) onConfirm;

  const DateTimePickerButton(
      {super.key, required this.dateTime, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    //Widget buildTimePicker(Function(DateTime) onConfirm, DateTime dateTime) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: TextButton(
          onPressed: () => DatePicker.showDateTimePicker(
            context,
            showTitleActions: true,
            minTime: DateTime.now(),
            onConfirm: onConfirm,
            currentTime: dateTime,
          ),
          child: buildTimePicker(context),
        ),
      ),
    );
  }

  Widget buildTimePicker(BuildContext context) {
    final String departureStrLocle = AppLocalizations.of(context)!.departureAt;
    final String departureStr =
        '$departureStrLocle ${DateFormat.Hm().format(dateTime)}';
    final String departureStr2 =
        '$departureStrLocle ${DateFormat.MMMMd().add_Hm().format(dateTime)}';
    logger.i('building date time');
    if (dateTime.day == DateTime.now().day) {
      return Row(
        children: [
          Text(
            //'Departure at ${dateTime.hour}:${dateTime.minute} ',
            departureStr,
          ),
          const Icon(
            Icons.arrow_drop_down,
          ),
        ],
      );
    } else {
      return Text(
        //'Departure at ${dateTime.day}/${dateTime.month}, ${dateTime.hour}:${dateTime.minute} ',
        departureStr2,
      );
    }
  }
}
