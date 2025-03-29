import 'package:flutter/material.dart';
import 'package:for_videos/providers/match_card_provider.dart';
import 'package:for_videos/providers/schedule_provider.dart';
import 'package:for_videos/widget/bottom_sheet_dialog.dart';
import 'package:provider/provider.dart';
import '../models/match.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final int index;
  final bool hasTimeConflict;

  const MatchCard({
    super.key,
    required this.match,
    required this.index,
    this.hasTimeConflict = false,
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
    final provider = Provider.of<ScheduleProvider>(context, listen: false);
    final isBackToBack = provider.isBackToBackMatch(index);
    final Map<String, bool> errors = {
      'timeConflicts': hasTimeConflict,
      'teamTimeMismatch': !team1Valid || !team2Valid,
      'stadiumOverflow': false,
      'teamConflicts': isBackToBack,
    };
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: InkWell(
        splashColor: Colors.grey,
        onTap: () {
          showEditMenu(context, index, errors);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
                    style: TextStyle(
                      color: team1Valid ? Colors.green : Colors.red,
                    ),
                  ),
                  Text(
                    '${match.team2.name}: ${MatchCardProvider.getTimeRange(match.team2, context)}',
                    style: TextStyle(
                      color: team2Valid ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              if (hasTimeConflict || !team1Valid || !team2Valid || isBackToBack)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Icon(Icons.warning, color: Colors.red, size: 25),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
