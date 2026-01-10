import 'dart:convert';
import 'dart:io';

class PreferenceTaxonomyViolation {
  const PreferenceTaxonomyViolation(this.code, this.message);
  final String code;
  final String message;
}

List<PreferenceTaxonomyViolation> validatePreferenceTaxonomy({
  String taxonomyPath = 'docs/contracts/preference_taxonomy_v1.md',
  String scenariosPath = 'docs/contracts/preference_scenarios_v1.md',
}) {
  final file = File(taxonomyPath);
  if (!file.existsSync()) {
    return [
      PreferenceTaxonomyViolation(
        'missing_taxonomy',
        'Taxonomy file not found at $taxonomyPath',
      ),
    ];
  }

  final content = file.readAsStringSync();
  final block = _extractBlock(content, 'preference-taxonomy-json');
  if (block == null) {
    return [
      const PreferenceTaxonomyViolation(
        'missing_block',
        'Missing preference-taxonomy-json block.',
      ),
    ];
  }

  Map<String, dynamic> json;
  try {
    json = jsonDecode(block) as Map<String, dynamic>;
  } catch (e) {
    return [
      PreferenceTaxonomyViolation(
        'invalid_json',
        'Invalid JSON in preference-taxonomy-json block: $e',
      ),
    ];
  }

  final violations = <PreferenceTaxonomyViolation>[];
  final domains = _readStringList(json['domains']);
  if (domains.isEmpty) {
    violations.add(
      const PreferenceTaxonomyViolation(
        'missing_domains',
        'No domains listed in preference-taxonomy-json.',
      ),
    );
  }

  final items = _readItemList(json['items']);
  if (items.isEmpty) {
    violations.add(
      const PreferenceTaxonomyViolation(
        'missing_items',
        'No items listed in preference-taxonomy-json.',
      ),
    );
  }

  final ids = <String, String>{};
  for (final item in items) {
    final id = item['id'];
    final domain = item['domain'];
    final valueKeys = item['value_keys'];
    if (id == null || id.isEmpty) {
      violations.add(
        const PreferenceTaxonomyViolation(
          'missing_id',
          'An item is missing an id.',
        ),
      );
      continue;
    }
    if (!_isSnakeCase(id)) {
      violations.add(
        PreferenceTaxonomyViolation(
          'invalid_id_format',
          'Preference id "$id" must be snake_case.',
        ),
      );
    }
    if (ids.containsKey(id)) {
      violations.add(
        PreferenceTaxonomyViolation(
          'duplicate_id',
          'Duplicate preference id "$id".',
        ),
      );
    } else {
      ids[id] = domain;
    }

    if (domain == null || domain.isEmpty) {
      violations.add(
        PreferenceTaxonomyViolation(
          'missing_domain',
          'Preference id "$id" is missing domain.',
        ),
      );
      continue;
    }
    if (!domains.contains(domain)) {
      violations.add(
        PreferenceTaxonomyViolation(
          'invalid_domain',
          'Preference id "$id" uses unknown domain "$domain".',
        ),
      );
    }

    if (valueKeys is! List || valueKeys.length != 3) {
      violations.add(
        PreferenceTaxonomyViolation(
          'invalid_value_keys',
          'Preference id "$id" must define value_keys with length 3.',
        ),
      );
    } else {
      for (final key in valueKeys) {
        if (key is! String || !_isSnakeCase(key)) {
          violations.add(
            PreferenceTaxonomyViolation(
              'invalid_value_key_format',
              'Preference id "$id" has invalid value_key "$key".',
            ),
          );
        }
      }
    }
  }

  violations.addAll(
    _validateScenarioMapping(taxonomyIds: ids, scenariosPath: scenariosPath),
  );

  return violations;
}

void main(List<String> args) {
  final path =
      _readArg(args, '--path=') ?? 'docs/contracts/preference_taxonomy_v1.md';
  final scenariosPath =
      _readArg(args, '--scenarios-path=') ??
      'docs/contracts/preference_scenarios_v1.md';
  final violations = validatePreferenceTaxonomy(
    taxonomyPath: path,
    scenariosPath: scenariosPath,
  );
  if (violations.isEmpty) {
    stdout.writeln('Preference taxonomy checks passed.');
    return;
  }

  stdout.writeln('Preference taxonomy checks failed (${violations.length}):');
  for (final v in violations) {
    stdout.writeln(' - ${v.code}: ${v.message}');
  }
  exitCode = 1;
}

List<PreferenceTaxonomyViolation> _validateScenarioMapping({
  required Map<String, String> taxonomyIds,
  required String scenariosPath,
}) {
  final file = File(scenariosPath);
  if (!file.existsSync()) {
    return [
      PreferenceTaxonomyViolation(
        'missing_scenarios',
        'Scenarios file not found at $scenariosPath',
      ),
    ];
  }

  final content = file.readAsStringSync();
  final block = _extractBlock(content, 'preference-scenarios-json');
  if (block == null) {
    return [
      const PreferenceTaxonomyViolation(
        'missing_scenarios_block',
        'Missing preference-scenarios-json block.',
      ),
    ];
  }

  Map<String, dynamic> json;
  try {
    json = jsonDecode(block) as Map<String, dynamic>;
  } catch (e) {
    return [
      PreferenceTaxonomyViolation(
        'invalid_scenarios_json',
        'Invalid JSON in preference-scenarios-json block: $e',
      ),
    ];
  }

  final scenarios = _readScenarioList(json['items']);
  final violations = <PreferenceTaxonomyViolation>[];

  if (scenarios.isEmpty) {
    violations.add(
      const PreferenceTaxonomyViolation(
        'missing_scenarios_items',
        'No items listed in preference-scenarios-json.',
      ),
    );
    return violations;
  }

  final scenarioIds = <String>{};
  final mappedIds = <String, String>{};
  for (final scenario in scenarios) {
    final id = scenario['id'] ?? '';
    final domain = scenario['domain'] ?? '';
    final mapsTo = scenario['mapsToPreferenceId'] ?? '';
    if (id.isEmpty) {
      violations.add(
        const PreferenceTaxonomyViolation(
          'missing_scenario_id',
          'A scenario is missing an id.',
        ),
      );
      continue;
    }
    if (scenarioIds.contains(id)) {
      violations.add(
        PreferenceTaxonomyViolation(
          'duplicate_scenario_id',
          'Duplicate scenario id "$id".',
        ),
      );
    } else {
      scenarioIds.add(id);
    }

    if (mapsTo.isEmpty) {
      violations.add(
        PreferenceTaxonomyViolation(
          'missing_scenario_mapping',
          'Scenario "$id" is missing mapsToPreferenceId.',
        ),
      );
      continue;
    }

    if (mappedIds.containsKey(mapsTo)) {
      violations.add(
        PreferenceTaxonomyViolation(
          'duplicate_scenario_mapping',
          'Preference id "$mapsTo" is mapped by multiple scenarios.',
        ),
      );
    } else {
      mappedIds[mapsTo] = id;
    }

    if (!taxonomyIds.containsKey(mapsTo)) {
      violations.add(
        PreferenceTaxonomyViolation(
          'scenario_mapping_unknown',
          'Scenario "$id" maps to unknown preference id "$mapsTo".',
        ),
      );
      continue;
    }

    if (id != mapsTo) {
      violations.add(
        PreferenceTaxonomyViolation(
          'scenario_id_mismatch',
          'Scenario id "$id" must match mapped preference id "$mapsTo".',
        ),
      );
    }

    final expectedDomain = taxonomyIds[mapsTo];
    if (domain.isEmpty) {
      violations.add(
        PreferenceTaxonomyViolation(
          'missing_scenario_domain',
          'Scenario "$id" is missing domain.',
        ),
      );
    } else if (expectedDomain != null && domain != expectedDomain) {
      violations.add(
        PreferenceTaxonomyViolation(
          'scenario_domain_mismatch',
          'Scenario "$id" domain "$domain" does not match taxonomy domain "$expectedDomain".',
        ),
      );
    }
  }

  final taxonomySet = taxonomyIds.keys.toSet();
  final mappedSet = mappedIds.keys.toSet();
  final missing = taxonomySet.difference(mappedSet);
  final extra = mappedSet.difference(taxonomySet);
  for (final id in missing) {
    violations.add(
      PreferenceTaxonomyViolation(
        'missing_scenario_for_taxonomy',
        'Preference id "$id" has no scenario mapping.',
      ),
    );
  }
  for (final id in extra) {
    violations.add(
      PreferenceTaxonomyViolation(
        'extra_scenario_mapping',
        'Scenario mapping includes unknown preference id "$id".',
      ),
    );
  }

  return violations;
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

List<String> _readStringList(dynamic v) {
  if (v is List) {
    return v.whereType<String>().toList();
  }
  return const <String>[];
}

List<Map<String, dynamic>> _readItemList(dynamic v) {
  if (v is! List) return const <Map<String, String>>[];
  final items = <Map<String, dynamic>>[];
  for (final entry in v) {
    if (entry is Map) {
      final id = entry['id'];
      final domain = entry['domain'];
      final valueKeys = entry['value_keys'];
      items.add({
        'id': id is String ? id : '',
        'domain': domain is String ? domain : '',
        'value_keys': valueKeys is List ? valueKeys : const <dynamic>[],
      });
    }
  }
  return items;
}

List<Map<String, String>> _readScenarioList(dynamic v) {
  if (v is! List) return const <Map<String, String>>[];
  final items = <Map<String, String>>[];
  for (final entry in v) {
    if (entry is Map) {
      final id = entry['id'];
      final domain = entry['domain'];
      final mapsTo = entry['mapsToPreferenceId'];
      items.add({
        'id': id is String ? id : '',
        'domain': domain is String ? domain : '',
        'mapsToPreferenceId': mapsTo is String ? mapsTo : '',
      });
    }
  }
  return items;
}

bool _isSnakeCase(String value) {
  return RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(value);
}

String? _readArg(List<String> args, String prefix) {
  for (final arg in args) {
    if (arg.startsWith(prefix)) {
      return arg.substring(prefix.length);
    }
  }
  return null;
}
