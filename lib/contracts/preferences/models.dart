class PreferenceReportSummary {
  const PreferenceReportSummary({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  factory PreferenceReportSummary.fromJson(Map<String, dynamic> json) {
    return PreferenceReportSummary(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
    );
  }
}

class PreferenceReportSection {
  const PreferenceReportSection({
    required this.sectionKey,
    required this.title,
    required this.text,
  });

  final String sectionKey;
  final String title;
  final String text;

  factory PreferenceReportSection.fromJson(Map<String, dynamic> json) {
    return PreferenceReportSection(
      sectionKey: json['section_key'] as String? ?? '',
      title: json['title'] as String? ?? '',
      text: json['text'] as String? ?? '',
    );
  }
}

class PreferenceReportContent {
  const PreferenceReportContent({
    required this.summary,
    required this.sections,
  });

  final PreferenceReportSummary summary;
  final List<PreferenceReportSection> sections;

  factory PreferenceReportContent.fromJson(Map<String, dynamic> json) {
    final summaryRaw = json['summary'];
    final summaryMap =
        summaryRaw is Map
            ? summaryRaw.cast<String, dynamic>()
            : const <String, dynamic>{};
    final sectionsRaw = json['sections'];
    final sections =
        sectionsRaw is List
            ? sectionsRaw
                .whereType<Map>()
                .map(
                  (entry) => PreferenceReportSection.fromJson(
                    entry.cast<String, dynamic>(),
                  ),
                )
                .toList(growable: false)
            : const <PreferenceReportSection>[];
    return PreferenceReportContent(
      summary: PreferenceReportSummary.fromJson(summaryMap),
      sections: sections,
    );
  }
}

class PreferenceReport {
  const PreferenceReport({
    required this.id,
    required this.subjectUserId,
    required this.templateKey,
    required this.locale,
    required this.publishedAt,
    required this.content,
    required this.lastEditedAt,
    required this.lastEditedBy,
  });

  final String id;
  final String subjectUserId;
  final String templateKey;
  final String locale;
  final DateTime? publishedAt;
  final PreferenceReportContent content;
  final DateTime? lastEditedAt;
  final String? lastEditedBy;

  factory PreferenceReport.fromJson(Map<String, dynamic> json) {
    final contentRaw = json['published_content'];
    final contentMap =
        contentRaw is Map
            ? contentRaw.cast<String, dynamic>()
            : const <String, dynamic>{};
    return PreferenceReport(
      id: json['id'] as String? ?? '',
      subjectUserId: json['subject_user_id'] as String? ?? '',
      templateKey: json['template_key'] as String? ?? '',
      locale: json['locale'] as String? ?? '',
      publishedAt: _parseDate(json['published_at']),
      content: PreferenceReportContent.fromJson(contentMap),
      lastEditedAt: _parseDate(json['last_edited_at']),
      lastEditedBy: json['last_edited_by'] as String?,
    );
  }
}

DateTime? _parseDate(dynamic value) {
  if (value is DateTime) return value;
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}

class PreferenceReportGenerationResult {
  const PreferenceReportGenerationResult({
    required this.status,
    required this.unresolvedPreferenceIds,
  });

  final String status;
  final List<String> unresolvedPreferenceIds;

  factory PreferenceReportGenerationResult.fromJson(Map<String, dynamic> json) {
    final unresolvedRaw = json['unresolved_pref_ids'];
    final unresolved =
        unresolvedRaw is List
            ? unresolvedRaw.map((entry) => entry.toString()).toList()
            : const <String>[];
    return PreferenceReportGenerationResult(
      status: json['status'] as String? ?? 'unknown',
      unresolvedPreferenceIds: unresolved,
    );
  }
}

class PreferenceReportListItem {
  const PreferenceReportListItem({
    required this.reportId,
    required this.subjectUserId,
    required this.publishedAt,
    required this.lastEditedAt,
  });

  final String reportId;
  final String subjectUserId;
  final DateTime? publishedAt;
  final DateTime? lastEditedAt;

  factory PreferenceReportListItem.fromJson(Map<String, dynamic> json) {
    return PreferenceReportListItem(
      reportId: json['report_id'] as String? ?? '',
      subjectUserId: json['subject_user_id'] as String? ?? '',
      publishedAt: _parseDate(json['published_at']),
      lastEditedAt: _parseDate(json['last_edited_at']),
    );
  }
}

class PreferenceTemplateResolution {
  const PreferenceTemplateResolution({
    required this.templateKey,
    required this.requestedLocale,
    required this.resolvedLocale,
  });

  final String templateKey;
  final String? requestedLocale;
  final String resolvedLocale;

  factory PreferenceTemplateResolution.fromJson(Map<String, dynamic> json) {
    return PreferenceTemplateResolution(
      templateKey: json['template_key'] as String? ?? '',
      requestedLocale: json['requested_locale'] as String?,
      resolvedLocale: json['resolved_locale'] as String? ?? 'en',
    );
  }
}

class HouseVibeCoverage {
  const HouseVibeCoverage({required this.answered, required this.total});

  final int answered;
  final int total;

  factory HouseVibeCoverage.fromJson(Map<String, dynamic> json) {
    return HouseVibeCoverage(
      answered: json['answered'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
    );
  }
}

class HouseVibePayload {
  const HouseVibePayload({
    required this.homeId,
    required this.mappingVersion,
    required this.labelId,
    required this.titleKey,
    required this.summaryKey,
    required this.imageKey,
    required this.ui,
    required this.coverage,
  });

  final String homeId;
  final String mappingVersion;
  final String labelId;
  final String titleKey;
  final String summaryKey;
  final String imageKey;
  final Map<String, dynamic> ui;
  final HouseVibeCoverage coverage;

  factory HouseVibePayload.fromJson(Map<String, dynamic> json) {
    final coverageRaw = json['coverage'];
    final coverageMap =
        coverageRaw is Map
            ? coverageRaw.cast<String, dynamic>()
            : const <String, dynamic>{};
    final uiRaw = json['ui'];
    final uiMap =
        uiRaw is Map ? uiRaw.cast<String, dynamic>() : const <String, dynamic>{};

    return HouseVibePayload(
      homeId: json['home_id'] as String? ?? '',
      mappingVersion: json['mapping_version'] as String? ?? '',
      labelId: json['label_id'] as String? ?? '',
      titleKey: json['title_key'] as String? ?? '',
      summaryKey: json['summary_key'] as String? ?? '',
      imageKey: json['image_key'] as String? ?? '',
      ui: uiMap,
      coverage: HouseVibeCoverage.fromJson(coverageMap),
    );
  }
}
