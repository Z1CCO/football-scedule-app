import 'package:flutter/material.dart';

class Team {
  final String name;
  final TimeRange preferredTime;

  Team(this.name, this.preferredTime);
}

class TimeRange {
  final TimeOfDay start;
  final TimeOfDay end;

  TimeRange(this.start, this.end);
}
