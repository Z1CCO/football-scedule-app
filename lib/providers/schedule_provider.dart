import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../models/match.dart';
import '../models/team.dart';

class ScheduleProvider with ChangeNotifier {
  List<Match> matches = Schedule.generateMatches();
  Match? _lastRemovedMatch;
  int? _lastRemovedIndex;

  void reorderMatches(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex--;
    final match = matches.removeAt(oldIndex);
    matches.insert(newIndex, match);
    notifyListeners();
  }

  void updateMatchTime(int index, TimeOfDay newTime) {
    matches[index].startTime = newTime;
    notifyListeners();
  }

  void removeMatch(int index) {
    _lastRemovedMatch = matches[index];
    _lastRemovedIndex = index;
    matches.removeAt(index);
    notifyListeners();
  }

  void undoRemove() {
    if (_lastRemovedMatch != null && _lastRemovedIndex != null) {
      matches.insert(_lastRemovedIndex!, _lastRemovedMatch!);
      _lastRemovedMatch = null;
      _lastRemovedIndex = null;
      notifyListeners();
    }
  }

  Map<String, bool> validateSchedule() {
    final errors = {
      'timeConflicts': false,
      'teamConflicts': false,
      'stadiumOverflow': false,
      'teamTimeMismatch': false,
    };

    for (int i = 0; i < matches.length - 1; i++) {
      final currentEnd = _calculateEndTime(matches[i].startTime);
      final nextStart = matches[i + 1].startTime;

      if ((nextStart.hour * 60 + nextStart.minute) -
              (currentEnd.hour * 60 + currentEnd.minute) <
          15) {
        errors['timeConflicts'] = true;
        break;
      }
    }

    for (final match in matches) {
      if (!_isTimeInRange(match.startTime, match.team1.preferredTime) ||
          !_isTimeInRange(match.startTime, match.team2.preferredTime)) {
        errors['teamTimeMismatch'] = true;
        break;
      }
    }

    if (matches.isNotEmpty) {
      final firstMatch = matches.first;
      final lastMatch = matches.last;
      final lastEnd = _calculateEndTime(lastMatch.startTime);

      if (firstMatch.startTime.hour < 13 || lastEnd.hour >= 21) {
        errors['stadiumOverflow'] = true;
      }
    }

    final teamMatches = <String, List<Match>>{};
    for (final match in matches) {
      teamMatches[match.team1.name] = [
        ...teamMatches[match.team1.name] ?? [],
        match,
      ];
      teamMatches[match.team2.name] = [
        ...teamMatches[match.team2.name] ?? [],
        match,
      ];
    }

    for (final entry in teamMatches.entries) {
      entry.value.sort((a, b) => a.startTime.hour.compareTo(b.startTime.hour));
      for (int i = 0; i < entry.value.length - 1; i++) {
        final currentEnd = _calculateEndTime(entry.value[i].startTime);
        final nextStart = entry.value[i + 1].startTime;

        if ((nextStart.hour * 60 + nextStart.minute) -
                (currentEnd.hour * 60 + currentEnd.minute) <
            15) {
          errors['teamConflicts'] = true;
          break;
        }
      }
    }

    return errors;
  }

  TimeOfDay _calculateEndTime(TimeOfDay start) {
    int minutes = start.minute + 55;
    int hours = start.hour + minutes ~/ 60;
    minutes %= 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }

  bool _isTimeInRange(TimeOfDay time, TimeRange range) {
    final totalMinutes = time.hour * 60 + time.minute;
    final start = range.start.hour * 60 + range.start.minute;
    final end = range.end.hour * 60 + range.end.minute;
    return totalMinutes >= start && totalMinutes <= end;
  }

  bool hasTeamConflict(Match match) {
    final teamMatches =
        matches
            .where(
              (m) =>
                  m.team1.name == match.team1.name ||
                  m.team2.name == match.team1.name ||
                  m.team1.name == match.team2.name ||
                  m.team2.name == match.team2.name,
            )
            .toList();

    teamMatches.sort((a, b) => a.startTime.hour.compareTo(b.startTime.hour));

    for (int i = 0; i < teamMatches.length - 1; i++) {
      final currentEnd = _calculateEndTime(teamMatches[i].startTime);
      final nextStart = teamMatches[i + 1].startTime;

      if ((nextStart.hour * 60 + nextStart.minute) -
              (currentEnd.hour * 60 + currentEnd.minute) <
          15) {
        return true;
      }
    }
    return false;
  }
}
