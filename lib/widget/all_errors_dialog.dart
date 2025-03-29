import 'package:flutter/material.dart';

void allErrorsDialog(BuildContext context, Map<String, bool> errors) {
  showDialog(
    context: context,
    builder:
        (ctx) => AlertDialog(
          title: const Text('Errors in the table'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (errors['timeConflicts']!)
                  const ListTile(
                    leading: Icon(Icons.error, color: Colors.red),
                    title: Text('The times are coinciding.'),
                    subtitle: Text(
                      'There should be at least 15 minutes between games.',
                    ),
                  ),
                if (errors['teamTimeMismatch']!)
                  const ListTile(
                    leading: Icon(Icons.error, color: Colors.red),
                    title: Text('Teams are not playing at their best time.'),
                    subtitle: Text(
                      'All teams must play within the allotted time frame.',
                    ),
                  ),
                if (errors['stadiumOverflow']!)
                  const ListTile(
                    leading: Icon(Icons.error, color: Colors.red),
                    title: Text('Stadium out of hours'),
                    subtitle: Text('Games should be between 13:00-21:00'),
                  ),
                if (errors['teamConflicts'] == true)
                  const ListTile(
                    leading: Icon(Icons.error, color: Colors.red),
                    title: Text('Teams are playing back-to-back.'),
                    subtitle: Text(
                      'There should be a break between each team\'s games.',
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Understandable'),
            ),
          ],
        ),
  );
}
