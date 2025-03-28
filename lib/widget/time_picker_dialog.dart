import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';

void showTimePickerDialog(BuildContext context, int index) async {
  final provider = Provider.of<ScheduleProvider>(context, listen: false);
  final newTime = await showTimePicker(
    context: context,
    initialTime: provider.matches[index].startTime,
  );
  if (newTime != null) {
    provider.updateMatchTime(index, newTime);
  }
}
