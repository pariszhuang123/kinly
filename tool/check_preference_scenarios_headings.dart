import 'dart:convert';
import 'dart:io';

class ScenarioHeadingViolation {
  const ScenarioHeadingViolation(this.code, this.message);
  final String code;
  final String message;
}

List<ScenarioHeadingViolation> validateScenarioHeadings({
  String taxonomyPath = 'docs/contracts/preference_taxonomy_v1.md',
  String scenariosPath = 'docs/contracts/preference_scenarios_v1.md',
}) {
  final taxonomyFile = File(taxonomyPath);
  if (!taxonomyFile.existsSync()) {
    return [
      ScenarioHeadingViolation(
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
      const ScenarioHeadingViolation(
        'missing_taxonomy_block',
        'Missing preference-taxonomy-json block.',
      ),
    ];
  }

  final taxonomyIds = _readTaxonomyIds(taxonomyBlock);
  if (taxonomyIds.isEmpty) {
    return [
      const ScenarioHeadingViolation(
        'empty_taxonomy_ids',
        'No taxonomy ids found in preference-taxonomy-json block.',
      ),
    ];
  }

  final scenariosFile = File(scenariosPath);
  if (!scenariosFile.existsSync()) {
    return [
      ScenarioHeadingViolation(
        'missing_scenarios',
        'Scenarios file not found at $scenariosPath',
      ),
    ];
  }

  final scenarioContent = scenariosFile.readAsStringSync();
  final scenarioHeadings = _extractScenarioHeadings(scenarioContent);
  if (scenarioHeadings.isEmpty) {
    return [
      const ScenarioHeadingViolation(
        'missing_scenario_headings',
        'No scenario headings found in preference_scenarios_v1.md.',
      ),
    ];
  }

  final violations = <ScenarioHeadingViolation>[];
  final missing = taxonomyIds.difference(scenarioHeadings);
  final extra = scenarioHeadings.difference(taxonomyIds);

  for (final id in missing) {
    violations.add(
      ScenarioHeadingViolation(
        'missing_heading',
        'Scenario heading missing for taxonomy id "$id".',
      ),
    );
  }

  for (final id in extra) {
    violations.add(
      ScenarioHeadingViolation(
        'extra_heading',
        'Scenario heading "$id" is not present in taxonomy.',
      ),
    );
  }

  return violations;
}

void main(List<String> args) {
  final taxonomyPath =
      _readArg(args, '--taxonomy-path=') ??
      'docs/contracts/preference_taxonomy_v1.md';
  final scenariosPath =
      _readArg(args, '--scenarios-path=') ??
      'docs/contracts/preference_scenarios_v1.md';

  final violations = validateScenarioHeadings(
    taxonomyPath: taxonomyPath,
    scenariosPath: scenariosPath,
  );

  if (violations.isEmpty) {
    stdout.writeln('Preference scenario heading checks passed.');
    return;
  }

  stdout.writeln(
    'Preference scenario heading checks failed (${violations.length}):',
  );
  for (final v in violations) {
    stdout.writeln(' - ${v.code}: ${v.message}');
  }
  exitCode = 1;
}

Set<String> _readTaxonomyIds(String block) {
  Map<String, dynamic> json;
  try {
    json = jsonDecode(block) as Map<String, dynamic>;
  } catch (_) {
    return <String>{};
  }
  final items = json['items'];
  if (items is! List) return <String>{};
  final ids = <String>{};
  for (final entry in items) {
    if (entry is Map && entry['id'] is String) {
      ids.add(entry['id'] as String);
    }
  }
  return ids;
}

Set<String> _extractScenarioHeadings(String content) {
  final headings = <String>{};
  final lines = content.split('\n');
  var inCode = false;
  for (final raw in lines) {
    final line = raw.trim();
    if (line.startsWith('```')) {
      inCode = !inCode;
      continue;
    }
    if (inCode || line.isEmpty) continue;
    if (RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(line)) {
      headings.add(line);
    }
  }
  return headings;
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
