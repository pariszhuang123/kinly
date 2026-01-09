import 'dart:convert';
import 'dart:io';

class TemplateViolation {
  const TemplateViolation(this.code, this.message);
  final String code;
  final String message;
}

List<TemplateViolation> checkPreferenceReportTemplate({
  String taxonomyPath = 'docs/contracts/preference_taxonomy_v1.md',
  String reportPath = 'docs/contracts/preference_reports_v1.md',
}) {
  final taxonomyFile = File(taxonomyPath);
  if (!taxonomyFile.existsSync()) {
    return [
      TemplateViolation(
        'missing_taxonomy',
        'Taxonomy file not found at $taxonomyPath',
      ),
    ];
  }

  final taxonomyContent = taxonomyFile.readAsStringSync();
  final taxonomyBlock = _extractBlock(
    taxonomyContent,
    'preference-taxonomy-json',
  );
  if (taxonomyBlock == null) {
    return [
      const TemplateViolation(
        'missing_taxonomy_block',
        'Missing preference-taxonomy-json block.',
      ),
    ];
  }

  final taxonomyDefs = _readTaxonomyDefs(taxonomyBlock);
  if (taxonomyDefs.isEmpty) {
    return [
      const TemplateViolation(
        'empty_taxonomy_ids',
        'No taxonomy ids found in preference-taxonomy-json block.',
      ),
    ];
  }

  final reportFile = File(reportPath);
  if (!reportFile.existsSync()) {
    return [
      TemplateViolation(
        'missing_report_contract',
        'Report contract not found at $reportPath',
      ),
    ];
  }

  final reportContent = reportFile.readAsStringSync();
  final templateBlock = _extractBlock(
    reportContent,
    'preference-report-template-json',
  );
  if (templateBlock == null) {
    return [
      const TemplateViolation(
        'missing_template_block',
        'Missing preference-report-template-json block.',
      ),
    ];
  }

  Map<String, dynamic> templateJson;
  try {
    templateJson = jsonDecode(templateBlock) as Map<String, dynamic>;
  } catch (e) {
    return [
      TemplateViolation(
        'invalid_template_json',
        'Invalid JSON in preference-report-template-json block: $e',
      ),
    ];
  }

  final prefs = templateJson['preferences'];
  if (prefs is! Map) {
    return [
      const TemplateViolation(
        'missing_preferences',
        'Template JSON missing "preferences" object.',
      ),
    ];
  }

  final violations = <TemplateViolation>[];
  for (final entry in taxonomyDefs.entries) {
    final id = entry.key;
    final expectedKeys = entry.value;
    if (!prefs.containsKey(id)) {
      violations.add(
        TemplateViolation(
          'missing_preference_variant',
          'Template missing variants for "$id".',
        ),
      );
      continue;
    }

    final value = prefs[id];
    if (value is! List) {
      violations.add(
        TemplateViolation(
          'invalid_preference_variants',
          'Template variants for "$id" must be an array.',
        ),
      );
      continue;
    }
    if (value.length != 3) {
      violations.add(
        TemplateViolation(
          'invalid_preference_variant_count',
          'Template variants for "$id" must have exactly 3 options.',
        ),
      );
      continue;
    }
    for (var i = 0; i < value.length; i++) {
      final option = value[i];
      if (option is! Map) {
        violations.add(
          TemplateViolation(
            'invalid_preference_variant_object',
            'Template variants for "$id" must be objects.',
          ),
        );
        continue;
      }
      final valueKey = option['value_key'];
      final title = option['title'];
      final text = option['text'];
      if (valueKey is! String || valueKey.trim().isEmpty) {
        violations.add(
          TemplateViolation(
            'invalid_preference_variant_value_key',
            'Template variants for "$id" must include value_key.',
          ),
        );
      } else if (i < expectedKeys.length && valueKey != expectedKeys[i]) {
        violations.add(
          TemplateViolation(
            'mismatched_value_key',
            'Template value_key for "$id" index $i must be "${expectedKeys[i]}".',
          ),
        );
      }
      if (title is! String || title.trim().isEmpty) {
        violations.add(
          TemplateViolation(
            'invalid_preference_variant_title',
            'Template variants for "$id" must include title.',
          ),
        );
      }
      if (text is! String || text.trim().isEmpty) {
        violations.add(
          TemplateViolation(
            'invalid_preference_variant_text',
            'Template variants for "$id" must include text.',
          ),
        );
      }
    }
  }

  for (final key in prefs.keys) {
    if (key is String && !taxonomyDefs.containsKey(key)) {
      violations.add(
        TemplateViolation(
          'extra_preference_variant',
          'Template includes unknown preference id "$key".',
        ),
      );
    }
  }

  return violations;
}

void main(List<String> args) {
  final taxonomyPath = _readArg(args, '--taxonomy-path=') ??
      'docs/contracts/preference_taxonomy_v1.md';
  final reportPath = _readArg(args, '--report-path=') ??
      'docs/contracts/preference_reports_v1.md';

  final violations = checkPreferenceReportTemplate(
    taxonomyPath: taxonomyPath,
    reportPath: reportPath,
  );

  if (violations.isEmpty) {
    stdout.writeln('Preference report template checks passed.');
    return;
  }

  stdout.writeln(
    'Preference report template checks failed (${violations.length}):',
  );
  for (final v in violations) {
    stdout.writeln(' - ${v.code}: ${v.message}');
  }
  exitCode = 1;
}

Map<String, List<String>> _readTaxonomyDefs(String block) {
  Map<String, dynamic> json;
  try {
    json = jsonDecode(block) as Map<String, dynamic>;
  } catch (_) {
    return <String, List<String>>{};
  }
  final items = json['items'];
  if (items is! List) return <String, List<String>>{};
  final defs = <String, List<String>>{};
  for (final entry in items) {
    if (entry is Map && entry['id'] is String) {
      final id = entry['id'] as String;
      final valueKeys = entry['value_keys'];
      if (valueKeys is List) {
        defs[id] = valueKeys.whereType<String>().toList();
      } else {
        defs[id] = const <String>[];
      }
    }
  }
  return defs;
}

String? _extractBlock(String content, String fence) {
  final start = RegExp('^```$fence\\s*\$', multiLine: true);
  final end = RegExp(r'^```\s*$', multiLine: true);
  final s = start.firstMatch(content);
  if (s == null) return null;
  final after = content.substring(s.end);
  final e = end.firstMatch(after);
  if (e == null) return null;
  return after.substring(0, e.start).trim();
}

String? _readArg(List<String> args, String prefix) {
  for (final arg in args) {
    if (arg.startsWith(prefix)) {
      return arg.substring(prefix.length);
    }
  }
  return null;
}
