import 'package:equatable/equatable.dart';

import 'package:kinly/contracts/mood/enums/house_pulse_state.dart';
import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/time/timezone.dart';

class HousePulseSnapshot extends Equatable {
  const HousePulseSnapshot({
    required this.homeId,
    required this.isoWeekYear,
    required this.isoWeek,
    required this.contractVersion,
    required this.memberCount,
    required this.reflectionCount,
    required this.carePresent,
    required this.frictionPresent,
    required this.complexityPresent,
    required this.pulseState,
    required this.computedAt,
    this.weatherDisplay,
  });

  final String homeId;
  final int isoWeekYear;
  final int isoWeek;
  final String contractVersion;
  final int memberCount;
  final int reflectionCount;
  final bool carePresent;
  final bool frictionPresent;
  final bool complexityPresent;
  final HousePulseState pulseState;
  final DateTime computedAt;
  final MoodScale? weatherDisplay;

  factory HousePulseSnapshot.fromJson(Map<String, dynamic> json) {
    final state = HousePulseState.maybeFromWire(
      json['pulse_state'] as String?,
    );
    final parsedComputedAt = parseTimestampToLocal(json['computed_at']) ??
        DateTime.fromMillisecondsSinceEpoch(0);
    return HousePulseSnapshot(
      homeId: json['home_id'] as String? ?? '',
      isoWeekYear: (json['iso_week_year'] as num?)?.toInt() ?? 0,
      isoWeek: (json['iso_week'] as num?)?.toInt() ?? 0,
      contractVersion: json['contract_version'] as String? ?? 'v1',
      memberCount: (json['member_count'] as num?)?.toInt() ?? 0,
      reflectionCount: (json['reflection_count'] as num?)?.toInt() ?? 0,
      carePresent: (json['care_present'] as bool?) ?? false,
      frictionPresent: (json['friction_present'] as bool?) ?? false,
      complexityPresent: (json['complexity_present'] as bool?) ?? false,
      pulseState: state ?? HousePulseState.forming,
      computedAt: parsedComputedAt,
      weatherDisplay: _parseMoodScale(json['weather_display']),
    );
  }

  @override
  List<Object?> get props => [
        homeId,
        isoWeekYear,
        isoWeek,
        contractVersion,
        memberCount,
        reflectionCount,
        carePresent,
        frictionPresent,
        complexityPresent,
        pulseState,
        computedAt,
        weatherDisplay,
      ];
}

class HousePulseLabel extends Equatable {
  const HousePulseLabel({
    required this.contractVersion,
    required this.pulseState,
    required this.titleKey,
    required this.summaryKey,
    required this.imageKey,
    required this.ui,
  });

  final String contractVersion;
  final HousePulseState pulseState;
  final String titleKey;
  final String summaryKey;
  final String imageKey;
  final Map<String, dynamic> ui;

  factory HousePulseLabel.fromJson(Map<String, dynamic> json) {
    final state = HousePulseState.maybeFromWire(
      json['pulse_state'] as String?,
    );
    final uiRaw = json['ui'];
    final uiMap = uiRaw is Map
        ? uiRaw.cast<String, dynamic>()
        : const <String, dynamic>{};
    return HousePulseLabel(
      contractVersion: json['contract_version'] as String? ?? 'v1',
      pulseState: state ?? HousePulseState.forming,
      titleKey: json['title_key'] as String? ?? '',
      summaryKey: json['summary_key'] as String? ?? '',
      imageKey: json['image_key'] as String? ?? '',
      ui: uiMap,
    );
  }

  @override
  List<Object?> get props => [
        contractVersion,
        pulseState,
        titleKey,
        summaryKey,
        imageKey,
        ui,
      ];
}

class HousePulseRead extends Equatable {
  const HousePulseRead({
    required this.homeId,
    required this.userId,
    required this.isoWeekYear,
    required this.isoWeek,
    required this.contractVersion,
    required this.lastSeenPulseState,
    required this.lastSeenComputedAt,
    required this.seenAt,
  });

  final String homeId;
  final String userId;
  final int isoWeekYear;
  final int isoWeek;
  final String contractVersion;
  final HousePulseState lastSeenPulseState;
  final DateTime lastSeenComputedAt;
  final DateTime seenAt;

  factory HousePulseRead.fromJson(Map<String, dynamic> json) {
    final state = HousePulseState.maybeFromWire(
      json['last_seen_pulse_state'] as String?,
    );
    final lastSeenAt = parseTimestampToLocal(
          json['last_seen_computed_at'],
        ) ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final seenAt = parseTimestampToLocal(json['seen_at']) ??
        DateTime.fromMillisecondsSinceEpoch(0);
    return HousePulseRead(
      homeId: json['home_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      isoWeekYear: (json['iso_week_year'] as num?)?.toInt() ?? 0,
      isoWeek: (json['iso_week'] as num?)?.toInt() ?? 0,
      contractVersion: json['contract_version'] as String? ?? 'v1',
      lastSeenPulseState: state ?? HousePulseState.forming,
      lastSeenComputedAt: lastSeenAt,
      seenAt: seenAt,
    );
  }

  @override
  List<Object?> get props => [
        homeId,
        userId,
        isoWeekYear,
        isoWeek,
        contractVersion,
        lastSeenPulseState,
        lastSeenComputedAt,
        seenAt,
      ];
}

class HousePulsePayload extends Equatable {
  const HousePulsePayload({
    required this.pulse,
    required this.label,
    required this.seen,
  });

  final HousePulseSnapshot pulse;
  final HousePulseLabel label;
  final HousePulseRead? seen;

  factory HousePulsePayload.fromJson(Map<String, dynamic> json) {
    final pulseRaw = json['pulse'];
    final labelRaw = json['label'];
    final seenRaw = json['seen'];
    final pulseMap = pulseRaw is Map
        ? pulseRaw.cast<String, dynamic>()
        : const <String, dynamic>{};
    final labelMap = labelRaw is Map
        ? labelRaw.cast<String, dynamic>()
        : const <String, dynamic>{};
    final seenMap =
        seenRaw is Map ? seenRaw.cast<String, dynamic>() : null;

    return HousePulsePayload(
      pulse: HousePulseSnapshot.fromJson(pulseMap),
      label: HousePulseLabel.fromJson(labelMap),
      seen: seenMap != null ? HousePulseRead.fromJson(seenMap) : null,
    );
  }

  HousePulsePayload copyWith({HousePulseRead? seen}) {
    return HousePulsePayload(
      pulse: pulse,
      label: label,
      seen: seen ?? this.seen,
    );
  }

  @override
  List<Object?> get props => [pulse, label, seen];
}

MoodScale? _parseMoodScale(Object? raw) {
  if (raw == null) return null;
  try {
    return MoodScale.fromWire(raw.toString());
  } catch (_) {
    return null;
  }
}
