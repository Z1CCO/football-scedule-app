import 'package:flutter/material.dart';
import '../models/team.dart';

class MatchCardProvider {
  static TimeOfDay calculateEndTime(TimeOfDay start) {
    int minutes = start.minute + 55;
    int hours = start.hour + minutes ~/ 60;
    minutes %= 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }

  static String getTimeRange(Team team, BuildContext context) {
    return '${team.preferredTime.start.format(context)}-${team.preferredTime.end.format(context)}';
  }

  static bool isTimeInRange(TimeOfDay time, TimeRange range) {
    final totalMinutes = time.hour * 60 + time.minute;
    final start = range.start.hour * 60 + range.start.minute;
    final end = range.end.hour * 60 + range.end.minute;
    return totalMinutes >= start && totalMinutes <= end;
  }

  static Color? getCardColor(bool hasTimeConflict, bool hasTeamConflict) {
    if (hasTimeConflict) return Colors.red[100];
    if (hasTeamConflict) return Colors.orange[100];
    return null;
  }
}
