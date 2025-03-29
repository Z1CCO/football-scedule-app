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
    List<TimeOfDay> startTimes = matches.map((m) => m.startTime).toList();
    List<TimeOfDay> endTimes = matches.map((m) => m.endTime).toList();
    final match = matches.removeAt(oldIndex);
    matches.insert(newIndex, match);
    for (int i = 0; i < matches.length; i++) {
      matches[i] = Match(
        matches[i].team1,
        matches[i].team2,
        startTimes[i],
        endTimes[i],
      );
    }
    validateSchedule();

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

  bool isBackToBackMatch(int matchIndex) {
    final currentMatch = matches[matchIndex];

    bool checkPrevious =
        matchIndex > 0 &&
        (matches[matchIndex - 1].team1.name == currentMatch.team1.name ||
            matches[matchIndex - 1].team1.name == currentMatch.team2.name ||
            matches[matchIndex - 1].team2.name == currentMatch.team1.name ||
            matches[matchIndex - 1].team2.name == currentMatch.team2.name);

    bool checkNext =
        matchIndex < matches.length - 1 &&
        (matches[matchIndex + 1].team1.name == currentMatch.team1.name ||
            matches[matchIndex + 1].team1.name == currentMatch.team2.name ||
            matches[matchIndex + 1].team2.name == currentMatch.team1.name ||
            matches[matchIndex + 1].team2.name == currentMatch.team2.name);

    return checkPrevious || checkNext;
  }
}
