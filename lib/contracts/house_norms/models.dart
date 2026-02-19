import 'package:kinly/generated/l10n.dart';

class HouseNormScenarioDefinition {
  const HouseNormScenarioDefinition({
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

class HouseNormSummary {
  const HouseNormSummary({
    required this.title,
    required this.subtitle,
    required this.framing,
    this.titleKey,
    this.subtitleKey,
  });

  final String title;
  final String subtitle;
  final String framing;
  final String? titleKey;
  final String? subtitleKey;

  factory HouseNormSummary.fromJson(Map<String, dynamic> json) {
    final titleKey = json['title_key'] as String?;
    final subtitleKey = json['subtitle_key'] as String?;
    return HouseNormSummary(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      framing: json['framing'] as String? ?? '',
      titleKey: titleKey,
      subtitleKey: subtitleKey,
    );
  }
}

class HouseNormSection {
  const HouseNormSection({
    required this.sectionKey,
    required this.title,
    required this.text,
    this.titleKey,
  });

  final String sectionKey;
  final String title;
  final String text;
  final String? titleKey;

  factory HouseNormSection.fromJson(
    Map<String, dynamic> json, {
    String? fallbackSectionKey,
  }) {
    final titleKey = json['title_key'] as String?;
    return HouseNormSection(
      sectionKey:
          json['section_key'] as String? ??
          json['id'] as String? ??
          json['key'] as String? ??
          fallbackSectionKey ??
          '',
      title: json['title'] as String? ?? '',
      text: json['text'] as String? ?? '',
      titleKey: titleKey,
    );
  }
}

class HouseNormContent {
  const HouseNormContent({
    required this.summary,
    required this.context,
    required this.sections,
  });

  final HouseNormSummary summary;
  final String context;
  final List<HouseNormSection> sections;

  factory HouseNormContent.fromJson(Map<String, dynamic> json) {
    final summaryRaw = json['summary'];
    final summaryMap =
        summaryRaw is Map
            ? summaryRaw.cast<String, dynamic>()
            : const <String, dynamic>{};
    final contextRaw = json['context'];
    final contextValue =
        contextRaw is String
            ? contextRaw
            : contextRaw is Map
            ? (contextRaw['line'] as String? ?? contextRaw['text'] as String? ?? '')
            : '';
    final sectionsRaw = json['sections'];
    final sections = <HouseNormSection>[
      if (sectionsRaw is List)
        ...sectionsRaw.whereType<Map>().map(
          (entry) => HouseNormSection.fromJson(entry.cast<String, dynamic>()),
        ),
      if (sectionsRaw is Map)
        ...sectionsRaw.entries
            .where((entry) {
              return entry.key is String && entry.value is Map;
            })
            .map(
              (entry) => HouseNormSection.fromJson(
                (entry.value as Map).cast<String, dynamic>(),
                fallbackSectionKey: entry.key as String,
              ),
            ),
    ];
    return HouseNormContent(
      summary: HouseNormSummary.fromJson(summaryMap),
      context: contextValue,
      sections: List<HouseNormSection>.unmodifiable(sections),
    );
  }
}

class HouseNormDocument {
  const HouseNormDocument({
    required this.homeId,
    required this.templateKey,
    required this.status,
    required this.inputs,
    required this.draftContent,
    required this.draftUpdatedAt,
    required this.publishedContent,
    required this.publishedAt,
    required this.publishedVersion,
    required this.isPublished,
    required this.hasUnpublishedChanges,
    required this.lastEditedAt,
    required this.lastEditedBy,
    required this.homePublicId,
    required this.publicUrl,
    required this.showPublishButton,
    required this.showRepublishButton,
    required this.showPublicUrl,
  });

  final String homeId;
  final String templateKey;
  final String status;
  final Map<String, int> inputs;
  final HouseNormContent? draftContent;
  final DateTime? draftUpdatedAt;
  final HouseNormContent? publishedContent;
  final DateTime? publishedAt;
  final String? publishedVersion;
  final bool isPublished;
  final bool hasUnpublishedChanges;
  final DateTime? lastEditedAt;
  final String? lastEditedBy;
  final String? homePublicId;
  final String? publicUrl;
  final bool showPublishButton;
  final bool showRepublishButton;
  final bool showPublicUrl;

  factory HouseNormDocument.fromJson({
    required String homeId,
    required Map<String, dynamic> json,
  }) {
    final rawInputs = json['inputs'];
    final parsedInputs = <String, int>{};
    if (rawInputs is Map) {
      for (final entry in rawInputs.entries) {
        final key = entry.key;
        if (key is! String) continue;
        final value = entry.value;
        if (value is int) {
          parsedInputs[key] = value;
        } else if (value is num) {
          parsedInputs[key] = value.toInt();
        }
      }
    }

    final draftContentRaw = json['draft_content'];
    final publishedContentRaw = json['published_content'];
    return HouseNormDocument(
      homeId: homeId,
      templateKey: json['template_key'] as String? ?? 'house_norms_v1',
      status: json['status'] as String? ?? 'out_of_date',
      inputs: parsedInputs,
      draftContent:
          draftContentRaw is Map
              ? HouseNormContent.fromJson(draftContentRaw.cast<String, dynamic>())
              : null,
      draftUpdatedAt: _parseDate(json['draft_updated_at']),
      publishedContent:
          publishedContentRaw is Map
              ? HouseNormContent.fromJson(publishedContentRaw.cast<String, dynamic>())
              : null,
      publishedAt: _parseDate(json['published_at']),
      publishedVersion: json['published_version'] as String?,
      isPublished: json['is_published'] as bool? ?? false,
      hasUnpublishedChanges: json['has_unpublished_changes'] as bool? ?? false,
      lastEditedAt: _parseDate(json['last_edited_at']),
      lastEditedBy: json['last_edited_by'] as String?,
      homePublicId: json['home_public_id'] as String?,
      publicUrl: json['public_url'] as String?,
      showPublishButton: json['show_publish_button'] as bool? ?? false,
      showRepublishButton: json['show_republish_button'] as bool? ?? false,
      showPublicUrl: json['show_public_url'] as bool? ?? false,
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
