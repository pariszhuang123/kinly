import 'package:flutter/foundation.dart';

enum DopamineMilestone { flow, share, pulse, reflection }

enum DopamineStrength { low, medium, high }

@immutable
class DopamineMoment {
  final DopamineMilestone milestone;
  final DopamineStrength strength;
  final String affirmation;
  final String? echo;
  final bool reduceMotion;
  final bool hapticEnabled;

  const DopamineMoment({
    required this.milestone,
    required this.strength,
    required this.affirmation,
    this.echo,
    this.reduceMotion = false,
    this.hapticEnabled = true,
  });

  DopamineMoment copyWith({
    DopamineMilestone? milestone,
    DopamineStrength? strength,
    String? affirmation,
    String? echo,
    bool? reduceMotion,
    bool? hapticEnabled,
  }) {
    return DopamineMoment(
      milestone: milestone ?? this.milestone,
      strength: strength ?? this.strength,
      affirmation: affirmation ?? this.affirmation,
      echo: echo ?? this.echo,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
    );
  }
}
