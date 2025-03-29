import 'package:flutter/material.dart';
import 'package:for_videos/widget/time_picker_dialog.dart';

void showConflictResolutionDialog(BuildContext context, int index) {
  showDialog(
    context: context,
    builder:
        (ctx) => AlertDialog(
          title: Text("Dispute resolution"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text("Offer a new time"),
                onTap: () {
                  Navigator.pop(context);
                  showTimePickerDialog(context, index);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
          ],
        ),
  );
}
