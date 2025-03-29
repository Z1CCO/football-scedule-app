import 'package:flutter/material.dart';
import 'team.dart';

class Match {
  Team team1;
  Team team2;
  TimeOfDay startTime;
  TimeOfDay endTime;

  Match(this.team1, this.team2, this.startTime, this.endTime);
}
