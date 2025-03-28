import 'package:flutter/material.dart';

import 'match.dart';
import 'team.dart';

class Schedule {
  static List<Match> generateMatches() {
    final teams = [
      Team(
        'Team A',
        TimeRange(
          TimeOfDay(hour: 14, minute: 0),
          TimeOfDay(hour: 18, minute: 0),
        ),
      ),
      Team(
        'Team B',
        TimeRange(
          TimeOfDay(hour: 13, minute: 0),
          TimeOfDay(hour: 16, minute: 0),
        ),
      ),
      Team(
        'Team C',
        TimeRange(
          TimeOfDay(hour: 15, minute: 0),
          TimeOfDay(hour: 20, minute: 0),
        ),
      ),
      Team(
        'Team D',
        TimeRange(
          TimeOfDay(hour: 14, minute: 0),
          TimeOfDay(hour: 19, minute: 0),
        ),
      ),
      Team(
        'Team E',
        TimeRange(
          TimeOfDay(hour: 13, minute: 30),
          TimeOfDay(hour: 17, minute: 30),
        ),
      ),
      Team(
        'Team F',
        TimeRange(
          TimeOfDay(hour: 16, minute: 0),
          TimeOfDay(hour: 21, minute: 0),
        ),
      ),
    ];

    return [
      Match(
        teams[1],
        teams[4],
        TimeOfDay(hour: 13, minute: 0),
        TimeOfDay(hour: 13, minute: 55),
      ),
      Match(
        teams[2],
        teams[3],
        TimeOfDay(hour: 14, minute: 10),
        TimeOfDay(hour: 15, minute: 5),
      ),
      Match(
        teams[0],
        teams[1],
        TimeOfDay(hour: 15, minute: 20),
        TimeOfDay(hour: 16, minute: 15),
      ),
      Match(
        teams[4],
        teams[5],
        TimeOfDay(hour: 16, minute: 30),
        TimeOfDay(hour: 17, minute: 25),
      ),
      Match(
        teams[0],
        teams[2],
        TimeOfDay(hour: 17, minute: 40),
        TimeOfDay(hour: 18, minute: 35),
      ),
      Match(
        teams[3],
        teams[5],
        TimeOfDay(hour: 18, minute: 50),
        TimeOfDay(hour: 19, minute: 45),
      ),
    ];
  }
}
