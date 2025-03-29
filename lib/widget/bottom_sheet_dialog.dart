import 'package:flutter/material.dart';
import 'package:for_videos/widget/all_errors_dialog.dart';
import 'package:for_videos/widget/conflict_resolution.dart';
import 'package:for_videos/widget/time_picker_dialog.dart';

void showEditMenu(BuildContext context, int index, Map<String, bool> errors) {
  bool hasError = errors.containsValue(true);
  bool hasConflict =
      errors['hasTimeConflict'] == true || errors['teamTimeMismatch'] == true;

  showModalBottomSheet(
    context: context,
    builder:
        (ctx) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Change time'),
              onTap: () {
                Navigator.pop(context);
                showTimePickerDialog(context, index);
              },
            ),
            if (hasError)
              ListTile(
                leading: const Icon(Icons.error),
                title: const Text('Show errors'),
                onTap: () {
                  Navigator.pop(context);
                  allErrorsDialog(context, errors);
                },
              ),
            if (hasConflict)
              ListTile(
                leading: const Icon(Icons.handyman_rounded),
                title: const Text('Error correction'),
                onTap: () {
                  Navigator.pop(context);
                  showConflictResolutionDialog(context, index);
                },
              ),
            const SizedBox(height: 12),
          ],
        ),
  );
}
