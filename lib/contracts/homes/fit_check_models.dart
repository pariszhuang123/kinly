class FitCheckClaimResult {
  const FitCheckClaimResult({
    required this.draftId,
    required this.ownerUserId,
    required this.homeAttachmentRequired,
    required this.ownerHomeCount,
    required this.seedHouseNormsPrefillAvailable,
    required this.submissionCount,
    this.seedPreferencesPrefillAvailable = false,
    this.setupHandoffRecommended = false,
  });

  final String draftId;
  final String ownerUserId;
  final bool homeAttachmentRequired;
  final int ownerHomeCount;
  final bool seedHouseNormsPrefillAvailable;
  final bool seedPreferencesPrefillAvailable;
  final bool setupHandoffRecommended;
  final int submissionCount;

  factory FitCheckClaimResult.fromJson(Map<String, dynamic> json) {
    return FitCheckClaimResult(
      draftId: json['draft_id'] as String? ?? '',
      ownerUserId: json['owner_user_id'] as String? ?? '',
      homeAttachmentRequired: json['home_attachment_required'] as bool? ?? false,
      ownerHomeCount: (json['owner_home_count'] as num?)?.toInt() ?? 0,
      seedHouseNormsPrefillAvailable:
          json['seed_house_norms_prefill_available'] as bool? ?? false,
      seedPreferencesPrefillAvailable:
          json['seed_preferences_prefill_available'] as bool? ?? false,
      setupHandoffRecommended:
          json['setup_handoff_recommended'] as bool? ?? false,
      submissionCount: (json['submission_count'] as num?)?.toInt() ?? 0,
    );
  }
}

class FitCheckAttachResult {
  const FitCheckAttachResult({
    required this.draftId,
    required this.homeId,
    required this.setupPrefillReady,
    this.attachedAt,
  });

  final String draftId;
  final String homeId;
  final DateTime? attachedAt;
  final bool setupPrefillReady;

  factory FitCheckAttachResult.fromJson(Map<String, dynamic> json) {
    return FitCheckAttachResult(
      draftId: json['draft_id'] as String? ?? '',
      homeId: json['home_id'] as String? ?? '',
      attachedAt: _parseDate(json['attached_at']),
      setupPrefillReady: json['setup_prefill_ready'] as bool? ?? false,
    );
  }
}

class FitCheckShareTokenActionResult {
  const FitCheckShareTokenActionResult({
    required this.draftId,
    required this.shareTokenStatus,
    this.shareUrl,
    this.expiresAt,
  });

  final String draftId;
  final String shareTokenStatus;
  final String? shareUrl;
  final DateTime? expiresAt;

  factory FitCheckShareTokenActionResult.fromJson(Map<String, dynamic> json) {
    return FitCheckShareTokenActionResult(
      draftId: json['draft_id'] as String? ?? '',
      shareTokenStatus: json['share_token_status'] as String? ?? '',
      shareUrl: json['share_url'] as String?,
      expiresAt: _parseDate(json['expires_at']),
    );
  }
}

class FitCheckSubmissionPreview {
  const FitCheckSubmissionPreview({
    required this.submissionId,
    required this.displayName,
    required this.reviewLabel,
    required this.submittedAt,
    required this.topWatchouts,
    required this.summaryLabel,
    required this.shareGenerationId,
  });

  final String submissionId;
  final String displayName;
  final String reviewLabel;
  final DateTime? submittedAt;
  final List<String> topWatchouts;
  final String summaryLabel;
  final String shareGenerationId;

  factory FitCheckSubmissionPreview.fromJson(Map<String, dynamic> json) {
    final previewRaw = json['preview'];
    final preview =
        previewRaw is Map
            ? previewRaw.cast<String, dynamic>()
            : const <String, dynamic>{};
    final topWatchoutsRaw = preview['top_watchouts'];
    final topWatchouts =
        topWatchoutsRaw is List
            ? topWatchoutsRaw.map((entry) => entry.toString()).toList(growable: false)
            : const <String>[];
    return FitCheckSubmissionPreview(
      submissionId: json['submission_id'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
      reviewLabel: json['review_label'] as String? ?? '',
      submittedAt: _parseDate(json['submitted_at']),
      topWatchouts: topWatchouts,
      summaryLabel: preview['summary_label'] as String? ?? '',
      shareGenerationId:
          json['share_generation_id'] as String? ??
          json['share_token_id'] as String? ??
          '',
    );
  }
}

class FitCheckShareGeneration {
  const FitCheckShareGeneration({
    required this.generationId,
    required this.shareTokenStatus,
    required this.isCurrent,
    required this.submissions,
    this.createdAt,
    this.endedAt,
  });

  final String generationId;
  final String shareTokenStatus;
  final bool isCurrent;
  final DateTime? createdAt;
  final DateTime? endedAt;
  final List<FitCheckSubmissionPreview> submissions;

  factory FitCheckShareGeneration.fromJson(Map<String, dynamic> json) {
    final submissionsRaw = json['submissions'];
    final submissions =
        submissionsRaw is List
            ? submissionsRaw
                .whereType<Map>()
                .map(
                  (entry) => FitCheckSubmissionPreview.fromJson(
                    entry.cast<String, dynamic>(),
                  ),
                )
                .toList()
            : <FitCheckSubmissionPreview>[];
    submissions.sort((left, right) {
      final leftTime = left.submittedAt;
      final rightTime = right.submittedAt;
      if (leftTime == null && rightTime == null) return 0;
      if (leftTime == null) return 1;
      if (rightTime == null) return -1;
      return rightTime.compareTo(leftTime);
    });
    final status = json['share_token_status'] as String? ?? '';
    return FitCheckShareGeneration(
      generationId:
          json['share_generation_id'] as String? ??
          json['share_token_id'] as String? ??
          json['generation_id'] as String? ??
          '',
      shareTokenStatus: status,
      isCurrent:
          json['is_current'] as bool? ??
          (status.toLowerCase() == 'active'),
      createdAt: _parseDate(json['created_at']),
      endedAt:
          _parseDate(json['revoked_at']) ??
          _parseDate(json['expired_at']) ??
          _parseDate(json['expires_at']),
      submissions: submissions,
    );
  }
}

class FitCheckOwnerReview {
  const FitCheckOwnerReview({
    required this.draftId,
    required this.ownerSummaryLabels,
    required this.shareGenerations,
    this.homeId,
  });

  final String draftId;
  final String? homeId;
  final List<String> ownerSummaryLabels;
  final List<FitCheckShareGeneration> shareGenerations;

  factory FitCheckOwnerReview.fromJson(Map<String, dynamic> json) {
    final summaryRaw = json['owner_summary'];
    final summary =
        summaryRaw is Map
            ? summaryRaw.cast<String, dynamic>()
            : const <String, dynamic>{};
    final labelsRaw = summary['labels'];
    final labels =
        labelsRaw is List
            ? labelsRaw.map((entry) => entry.toString()).toList(growable: false)
            : const <String>[];
    final shareGroupsRaw = json['share_groups'];
    final shareGenerations =
        shareGroupsRaw is List
            ? shareGroupsRaw
                .whereType<Map>()
                .map(
                  (entry) => FitCheckShareGeneration.fromJson(
                    entry.cast<String, dynamic>(),
                  ),
                )
                .toList()
            : _buildLegacyShareGenerations(json);
    shareGenerations.sort((left, right) {
      if (left.isCurrent != right.isCurrent) {
        return left.isCurrent ? -1 : 1;
      }
      final leftTime = left.createdAt;
      final rightTime = right.createdAt;
      if (leftTime == null && rightTime == null) return 0;
      if (leftTime == null) return 1;
      if (rightTime == null) return -1;
      return rightTime.compareTo(leftTime);
    });
    return FitCheckOwnerReview(
      draftId: json['draft_id'] as String? ?? '',
      homeId: json['home_id'] as String?,
      ownerSummaryLabels: labels,
      shareGenerations: shareGenerations,
    );
  }
}

class FitCheckWatchout {
  const FitCheckWatchout({
    required this.scenarioId,
    required this.distance,
    required this.direction,
    required this.questionTexts,
    required this.isPrimaryFocus,
    this.description,
  });

  final String scenarioId;
  final int distance;
  final String direction;
  final String? description;
  final List<String> questionTexts;
  final bool isPrimaryFocus;

  factory FitCheckWatchout.fromJson(Map<String, dynamic> json) {
    final questionTexts = <String>[
      ..._coerceStringList(json['question_texts']),
      ..._coerceStringList(json['question_keys']),
    ];
    return FitCheckWatchout(
      scenarioId: json['scenario_id'] as String? ?? '',
      distance: (json['distance'] as num?)?.toInt() ?? 0,
      direction: json['direction'] as String? ?? '',
      description:
          json['description'] as String? ??
          json['watchout_text'] as String? ??
          json['watchout_key'] as String?,
      questionTexts: questionTexts,
      isPrimaryFocus: json['is_primary_focus'] as bool? ?? false,
    );
  }
}

class FitCheckOwnerBriefing {
  const FitCheckOwnerBriefing({
    required this.submissionId,
    required this.draftId,
    required this.displayName,
    required this.submittedAt,
    required this.answers,
    required this.alignments,
    required this.watchouts,
    this.contextText,
    this.alignmentPreviewText,
    this.limitationText,
    this.focusText,
  });

  final String submissionId;
  final String draftId;
  final String displayName;
  final DateTime? submittedAt;
  final Map<String, int> answers;
  final List<String> alignments;
  final List<FitCheckWatchout> watchouts;
  final String? contextText;
  final String? alignmentPreviewText;
  final String? limitationText;
  final String? focusText;

  factory FitCheckOwnerBriefing.fromJson(Map<String, dynamic> json) {
    final candidateRaw = json['candidate'];
    final candidate =
        candidateRaw is Map
            ? candidateRaw.cast<String, dynamic>()
            : const <String, dynamic>{};
    final answers = _coerceIntMap(candidate['answers']);
    final briefingRaw = json['briefing'];
    final briefing =
        briefingRaw is Map
            ? briefingRaw.cast<String, dynamic>()
            : const <String, dynamic>{};
    final alignmentsRaw = briefing['alignments'];
    final alignments =
        alignmentsRaw is List
            ? alignmentsRaw
                .map((entry) {
                  if (entry is String) return entry;
                  if (entry is Map) {
                    return entry['scenario_id']?.toString() ?? '';
                  }
                  return '';
                })
                .where((entry) => entry.isNotEmpty)
                .toList(growable: false)
            : const <String>[];
    final watchoutsRaw = briefing['watchouts'];
    final watchouts =
        watchoutsRaw is List
            ? watchoutsRaw
                .whereType<Map>()
                .map(
                  (entry) => FitCheckWatchout.fromJson(
                    entry.cast<String, dynamic>(),
                  ),
                )
                .toList(growable: false)
            : const <FitCheckWatchout>[];
    return FitCheckOwnerBriefing(
      submissionId: json['submission_id'] as String? ?? '',
      draftId: json['draft_id'] as String? ?? '',
      displayName: candidate['display_name'] as String? ?? '',
      submittedAt: _parseDate(candidate['submitted_at']),
      answers: answers,
      alignments: alignments,
      watchouts: watchouts,
      contextText:
          briefing['context_text'] as String? ??
          briefing['context_key'] as String?,
      alignmentPreviewText:
          briefing['alignment_preview_text'] as String? ??
          briefing['alignment_preview_key'] as String?,
      limitationText:
          briefing['limitation_text'] as String? ??
          briefing['limitation_key'] as String?,
      focusText:
          briefing['focus_text'] as String? ?? briefing['focus_key'] as String?,
    );
  }
}

List<FitCheckShareGeneration> _buildLegacyShareGenerations(
  Map<String, dynamic> json,
) {
  final submissionsRaw = json['submissions'];
  final submissions =
      submissionsRaw is List
          ? submissionsRaw
              .whereType<Map>()
              .map(
                (entry) => FitCheckSubmissionPreview.fromJson(
                  entry.cast<String, dynamic>(),
                ),
              )
              .toList()
          : <FitCheckSubmissionPreview>[];
  submissions.sort((left, right) {
    final leftTime = left.submittedAt;
    final rightTime = right.submittedAt;
    if (leftTime == null && rightTime == null) return 0;
    if (leftTime == null) return 1;
    if (rightTime == null) return -1;
    return rightTime.compareTo(leftTime);
  });
  final shareRaw = json['share'];
  final share =
      shareRaw is Map
          ? shareRaw.cast<String, dynamic>()
          : const <String, dynamic>{};
  final status = share['share_token_status'] as String? ?? 'active';
  return [
    FitCheckShareGeneration(
      generationId:
          share['share_generation_id'] as String? ??
          share['share_token_id'] as String? ??
          'current',
      shareTokenStatus: status,
      isCurrent: status.toLowerCase() == 'active',
      createdAt: _parseDate(share['created_at']),
      endedAt:
          _parseDate(share['revoked_at']) ??
          _parseDate(share['expired_at']) ??
          _parseDate(share['expires_at']),
      submissions: submissions,
    ),
  ];
}

class FitCheckPrefillPayload {
  const FitCheckPrefillPayload({
    required this.draftId,
    required this.houseNormInitialResponses,
    required this.preferenceInitialResponses,
  });

  final String draftId;
  final Map<String, int> houseNormInitialResponses;
  final Map<String, int> preferenceInitialResponses;

  factory FitCheckPrefillPayload.fromJson(Map<String, dynamic> json) {
    final seedRaw = json['onboarding_seed'];
    final seed =
        seedRaw is Map
            ? seedRaw.cast<String, dynamic>()
            : const <String, dynamic>{};
    final houseNormRaw = seed['house_norms'];
    final houseNorm =
        houseNormRaw is Map
            ? houseNormRaw.cast<String, dynamic>()
            : const <String, dynamic>{};
    final preferencesRaw = seed['preferences'];
    final preferences =
        preferencesRaw is Map
            ? preferencesRaw.cast<String, dynamic>()
            : const <String, dynamic>{};
    return FitCheckPrefillPayload(
      draftId: json['draft_id'] as String? ?? '',
      houseNormInitialResponses: _coerceIntMap(houseNorm['initial_responses']),
      preferenceInitialResponses: _coerceIntMap(
        preferences['initial_responses'],
      ),
    );
  }
}

Map<String, int> _coerceIntMap(Object? raw) {
  if (raw is! Map) {
    return const <String, int>{};
  }
  final coerced = <String, int>{};
  for (final entry in raw.entries) {
    final key = entry.key;
    final value = entry.value;
    if (key is! String) continue;
    if (value is int) {
      coerced[key] = value;
      continue;
    }
    if (value is num) {
      coerced[key] = value.toInt();
    }
  }
  return coerced;
}

List<String> _coerceStringList(Object? raw) {
  if (raw is! List) {
    return const <String>[];
  }
  return raw.map((entry) => entry.toString()).toList(growable: false);
}

DateTime? _parseDate(Object? raw) {
  if (raw is! String || raw.isEmpty) {
    return null;
  }
  return DateTime.tryParse(raw);
}

List<FitCheckSubmissionPreview> fitCheckReviewSubmissions(
  FitCheckOwnerReview review,
) {
  return review.shareGenerations
      .expand((generation) => generation.submissions)
      .toList(growable: false);
}

FitCheckShareGeneration? fitCheckCurrentShareGeneration(
  FitCheckOwnerReview review,
) {
  for (final generation in review.shareGenerations) {
    if (generation.isCurrent) return generation;
  }
  return null;
}

bool fitCheckHasHouseNormSeed(FitCheckPrefillPayload payload) {
  return payload.houseNormInitialResponses.isNotEmpty;
}

bool fitCheckHasPreferenceSeed(FitCheckPrefillPayload payload) {
  return payload.preferenceInitialResponses.isNotEmpty;
}
