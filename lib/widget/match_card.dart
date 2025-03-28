import 'package:flutter/material.dart';
import 'package:for_videos/providers/match_card_provider.dart';
import '../models/match.dart';
import 'time_picker_dialog.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final int index;
  final bool hasTimeConflict;
  final bool hasTeamConflict;

  const MatchCard({
    super.key,
    required this.match,
    required this.index,
    this.hasTimeConflict = false,
    this.hasTeamConflict = false,
  });

  @override
  Widget build(BuildContext context) {
    final team1Valid = MatchCardProvider.isTimeInRange(
      match.startTime,
      match.team1.preferredTime,
    );
    final team2Valid = MatchCardProvider.isTimeInRange(
      match.startTime,
      match.team2.preferredTime,
    );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: MatchCardProvider.getCardColor(hasTimeConflict, hasTeamConflict),
      child: InkWell(
        splashColor: Colors.grey,
        onTap: () => _showEditMenu(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${match.team1.name} vs ${match.team2.name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Start: ${match.startTime.format(context)}'),
              Text(
                'End: ${MatchCardProvider.calculateEndTime(match.startTime).format(context)}',
              ),
              const SizedBox(height: 8),
              Text(
                '${match.team1.name}: ${MatchCardProvider.getTimeRange(match.team1, context)}',
                style: TextStyle(color: team1Valid ? Colors.green : Colors.red),
              ),
              Text(
                '${match.team2.name}: ${MatchCardProvider.getTimeRange(match.team2, context)}',
                style: TextStyle(color: team2Valid ? Colors.green : Colors.red),
              ),
              if (hasTimeConflict ||
                  hasTeamConflict ||
                  !team1Valid ||
                  !team2Valid)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Attention! There is an error in the table.",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (ctx) => SizedBox(
            height: 80,
            child: Center(
              child: ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Change time'),
                onTap: () {
                  Navigator.pop(ctx);
                  showTimePickerDialog(context, index);
                },
              ),
            ),
          ),
    );
  }
}
