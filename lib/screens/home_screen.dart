import 'package:flutter/material.dart';
import 'package:for_videos/widget/error_dialog.dart';
import 'package:for_videos/widget/match_card.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScheduleProvider>(context);
    final errors = provider.validateSchedule();
    final hasErrors = errors.values.any((e) => e);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Stadium Schedule'),
        actions: [
          if (hasErrors)
            IconButton(
              icon: const Icon(Icons.warning, color: Colors.red),
              onPressed: () => showErrorDialog(context, errors),
              tooltip: 'View errors',
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.matches.length,
              itemBuilder: (context, index) {
                final match = provider.matches[index];

                return MatchCard(
                  key: Key('${match.team1.name}_${match.team2.name}_$index'),
                  match: match,
                  index: index,
                  hasTimeConflict: errors['timeConflicts']!,
                );
              },
              onReorder: (oldIndex, newIndex) {
                provider.reorderMatches(oldIndex, newIndex);
              },
            ),
          ),
        ],
      ),
    );
  }
}
