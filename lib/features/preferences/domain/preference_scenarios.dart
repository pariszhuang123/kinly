import '../../../generated/l10n.dart';

class PreferenceScenarioDefinition {
  const PreferenceScenarioDefinition({
    required this.id,
    required this.domain,
    required this.question,
    required this.options,
  });

  final String id;
  final String domain;
  final String Function(S) question;
  final List<String Function(S)> options;
}

List<PreferenceScenarioDefinition> preferenceScenarios() {
  return [
    PreferenceScenarioDefinition(
      id: 'environment_noise_tolerance',
      domain: 'environment',
      question: (s) => s.preferenceScenarioEnvironmentNoiseQuestion,
      options: [
        (s) => s.preferenceScenarioEnvironmentNoiseOption1,
        (s) => s.preferenceScenarioEnvironmentNoiseOption2,
        (s) => s.preferenceScenarioEnvironmentNoiseOption3,
      ],
    ),
    PreferenceScenarioDefinition(
      id: 'environment_light_preference',
      domain: 'environment',
      question: (s) => s.preferenceScenarioEnvironmentLightQuestion,
      options: [
        (s) => s.preferenceScenarioEnvironmentLightOption1,
        (s) => s.preferenceScenarioEnvironmentLightOption2,
        (s) => s.preferenceScenarioEnvironmentLightOption3,
      ],
    ),
    PreferenceScenarioDefinition(
      id: 'environment_scent_sensitivity',
      domain: 'environment',
      question: (s) => s.preferenceScenarioEnvironmentScentQuestion,
      options: [
        (s) => s.preferenceScenarioEnvironmentScentOption1,
        (s) => s.preferenceScenarioEnvironmentScentOption2,
        (s) => s.preferenceScenarioEnvironmentScentOption3,
      ],
    ),
    PreferenceScenarioDefinition(
      id: 'schedule_quiet_hours_preference',
      domain: 'schedule',
      question: (s) => s.preferenceScenarioScheduleQuietHoursQuestion,
      options: [
        (s) => s.preferenceScenarioScheduleQuietHoursOption1,
        (s) => s.preferenceScenarioScheduleQuietHoursOption2,
        (s) => s.preferenceScenarioScheduleQuietHoursOption3,
      ],
    ),
    PreferenceScenarioDefinition(
      id: 'schedule_sleep_timing',
      domain: 'schedule',
      question: (s) => s.preferenceScenarioScheduleSleepTimingQuestion,
      options: [
        (s) => s.preferenceScenarioScheduleSleepTimingOption1,
        (s) => s.preferenceScenarioScheduleSleepTimingOption2,
        (s) => s.preferenceScenarioScheduleSleepTimingOption3,
      ],
    ),
    PreferenceScenarioDefinition(
      id: 'communication_channel',
      domain: 'communication',
      question: (s) => s.preferenceScenarioCommunicationChannelQuestion,
      options: [
        (s) => s.preferenceScenarioCommunicationChannelOption1,
        (s) => s.preferenceScenarioCommunicationChannelOption2,
        (s) => s.preferenceScenarioCommunicationChannelOption3,
      ],
    ),
    PreferenceScenarioDefinition(
      id: 'communication_directness',
      domain: 'communication',
      question: (s) => s.preferenceScenarioCommunicationDirectnessQuestion,
      options: [
        (s) => s.preferenceScenarioCommunicationDirectnessOption1,
        (s) => s.preferenceScenarioCommunicationDirectnessOption2,
        (s) => s.preferenceScenarioCommunicationDirectnessOption3,
      ],
    ),
    PreferenceScenarioDefinition(
      id: 'cleanliness_shared_space_tolerance',
      domain: 'cleanliness',
      question: (s) => s.preferenceScenarioCleanlinessSharedSpaceQuestion,
      options: [
        (s) => s.preferenceScenarioCleanlinessSharedSpaceOption1,
        (s) => s.preferenceScenarioCleanlinessSharedSpaceOption2,
        (s) => s.preferenceScenarioCleanlinessSharedSpaceOption3,
      ],
    ),
    PreferenceScenarioDefinition(
      id: 'privacy_room_entry',
      domain: 'privacy',
      question: (s) => s.preferenceScenarioPrivacyRoomEntryQuestion,
      options: [
        (s) => s.preferenceScenarioPrivacyRoomEntryOption1,
        (s) => s.preferenceScenarioPrivacyRoomEntryOption2,
        (s) => s.preferenceScenarioPrivacyRoomEntryOption3,
      ],
    ),
    PreferenceScenarioDefinition(
      id: 'privacy_notifications',
      domain: 'privacy',
      question: (s) => s.preferenceScenarioPrivacyNotificationsQuestion,
      options: [
        (s) => s.preferenceScenarioPrivacyNotificationsOption1,
        (s) => s.preferenceScenarioPrivacyNotificationsOption2,
        (s) => s.preferenceScenarioPrivacyNotificationsOption3,
      ],
    ),
    PreferenceScenarioDefinition(
      id: 'social_hosting_frequency',
      domain: 'social',
      question: (s) => s.preferenceScenarioSocialHostingQuestion,
      options: [
        (s) => s.preferenceScenarioSocialHostingOption1,
        (s) => s.preferenceScenarioSocialHostingOption2,
        (s) => s.preferenceScenarioSocialHostingOption3,
      ],
    ),
    PreferenceScenarioDefinition(
      id: 'social_togetherness',
      domain: 'social',
      question: (s) => s.preferenceScenarioSocialTogethernessQuestion,
      options: [
        (s) => s.preferenceScenarioSocialTogethernessOption1,
        (s) => s.preferenceScenarioSocialTogethernessOption2,
        (s) => s.preferenceScenarioSocialTogethernessOption3,
      ],
    ),
    PreferenceScenarioDefinition(
      id: 'routine_planning_style',
      domain: 'routine',
      question: (s) => s.preferenceScenarioRoutinePlanningQuestion,
      options: [
        (s) => s.preferenceScenarioRoutinePlanningOption1,
        (s) => s.preferenceScenarioRoutinePlanningOption2,
        (s) => s.preferenceScenarioRoutinePlanningOption3,
      ],
    ),
    PreferenceScenarioDefinition(
      id: 'conflict_resolution_style',
      domain: 'conflict',
      question: (s) => s.preferenceScenarioConflictResolutionQuestion,
      options: [
        (s) => s.preferenceScenarioConflictResolutionOption1,
        (s) => s.preferenceScenarioConflictResolutionOption2,
        (s) => s.preferenceScenarioConflictResolutionOption3,
      ],
    ),
  ];
}
