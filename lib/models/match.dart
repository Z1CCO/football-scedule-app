import 'package:flutter/material.dart';
import 'team.dart';

class Match {
  final Team team1;
  final Team team2;
  TimeOfDay startTime;
  TimeOfDay endTime;

  Match(this.team1, this.team2, this.startTime, this.endTime);
}
