import 'dart:io';

import 'package:test/test.dart';

import '../../tool/check_preference_taxonomy.dart';

void main() {
  test('passes with valid domains and ids', () async {
    final temp = await Directory.systemTemp.createTemp(
      'kinly_preference_taxonomy',
    );
    addTearDown(() => temp.deleteSync(recursive: true));

    final taxonomyFile = File('${temp.path}/preference_taxonomy_v1.md');
    taxonomyFile.writeAsStringSync('''
```preference-taxonomy-json
{
  "domains": ["one", "two"],
  "items": [
    { "id": "alpha_one", "domain": "one", "value_keys": ["a","b","c"] },
    { "id": "beta_two", "domain": "two", "value_keys": ["d","e","f"] }
  ]
}
```
''');

    final scenariosFile = File('${temp.path}/preference_scenarios_v1.md');
    scenariosFile.writeAsStringSync('''
```preference-scenarios-json
{
  "items": [
    {
      "id": "alpha_one",
      "domain": "one",
      "mapsToPreferenceId": "alpha_one"
    },
    {
      "id": "beta_two",
      "domain": "two",
      "mapsToPreferenceId": "beta_two"
    }
  ]
}
```
''');

    final violations = validatePreferenceTaxonomy(
      taxonomyPath: taxonomyFile.path,
      scenariosPath: scenariosFile.path,
    );
    expect(violations, isEmpty);
  });

  test('flags invalid domain', () async {
    final temp = await Directory.systemTemp.createTemp(
      'kinly_preference_taxonomy_domain',
    );
    addTearDown(() => temp.deleteSync(recursive: true));

    final taxonomyFile = File('${temp.path}/preference_taxonomy_v1.md');
    taxonomyFile.writeAsStringSync('''
```preference-taxonomy-json
{
  "domains": ["allowed"],
  "items": [
    { "id": "alpha_one", "domain": "not_allowed", "value_keys": ["a","b","c"] }
  ]
}
```
''');

    final scenariosFile = File('${temp.path}/preference_scenarios_v1.md');
    scenariosFile.writeAsStringSync('''
```preference-scenarios-json
{
  "items": [
    {
      "id": "alpha_one",
      "domain": "not_allowed",
      "mapsToPreferenceId": "alpha_one"
    }
  ]
}
```
''');

    final violations = validatePreferenceTaxonomy(
      taxonomyPath: taxonomyFile.path,
      scenariosPath: scenariosFile.path,
    );
    expect(violations.map((v) => v.code), contains('invalid_domain'));
  });

  test('flags invalid id format', () async {
    final temp = await Directory.systemTemp.createTemp(
      'kinly_preference_taxonomy_id',
    );
    addTearDown(() => temp.deleteSync(recursive: true));

    final taxonomyFile = File('${temp.path}/preference_taxonomy_v1.md');
    taxonomyFile.writeAsStringSync('''
```preference-taxonomy-json
{
  "domains": ["allowed"],
  "items": [
    { "id": "BadId", "domain": "allowed", "value_keys": ["a","b","c"] }
  ]
}
```
''');

    final scenariosFile = File('${temp.path}/preference_scenarios_v1.md');
    scenariosFile.writeAsStringSync('''
```preference-scenarios-json
{
  "items": [
    {
      "id": "BadId",
      "domain": "allowed",
      "mapsToPreferenceId": "BadId"
    }
  ]
}
```
''');

    final violations = validatePreferenceTaxonomy(
      taxonomyPath: taxonomyFile.path,
      scenariosPath: scenariosFile.path,
    );
    expect(violations.map((v) => v.code), contains('invalid_id_format'));
  });

  test('flags missing scenario mapping for taxonomy id', () async {
    final temp = await Directory.systemTemp.createTemp(
      'kinly_preference_taxonomy_missing_mapping',
    );
    addTearDown(() => temp.deleteSync(recursive: true));

    final taxonomyFile = File('${temp.path}/preference_taxonomy_v1.md');
    taxonomyFile.writeAsStringSync('''
```preference-taxonomy-json
{
  "domains": ["one"],
  "items": [
    { "id": "alpha_one", "domain": "one", "value_keys": ["a","b","c"] },
    { "id": "beta_one", "domain": "one", "value_keys": ["d","e","f"] }
  ]
}
```
''');

    final scenariosFile = File('${temp.path}/preference_scenarios_v1.md');
    scenariosFile.writeAsStringSync('''
```preference-scenarios-json
{
  "items": [
    {
      "id": "alpha_one",
      "domain": "one",
      "mapsToPreferenceId": "alpha_one"
    }
  ]
}
```
''');

    final violations = validatePreferenceTaxonomy(
      taxonomyPath: taxonomyFile.path,
      scenariosPath: scenariosFile.path,
    );
    expect(
      violations.map((v) => v.code),
      contains('missing_scenario_for_taxonomy'),
    );
  });

  test('flags scenario id mismatch', () async {
    final temp = await Directory.systemTemp.createTemp(
      'kinly_preference_taxonomy_id_mismatch',
    );
    addTearDown(() => temp.deleteSync(recursive: true));

    final taxonomyFile = File('${temp.path}/preference_taxonomy_v1.md');
    taxonomyFile.writeAsStringSync('''
```preference-taxonomy-json
{
  "domains": ["one"],
  "items": [
    { "id": "alpha_one", "domain": "one", "value_keys": ["a","b","c"] }
  ]
}
```
''');

    final scenariosFile = File('${temp.path}/preference_scenarios_v1.md');
    scenariosFile.writeAsStringSync('''
```preference-scenarios-json
{
  "items": [
    {
      "id": "alpha_scene",
      "domain": "one",
      "mapsToPreferenceId": "alpha_one"
    }
  ]
}
```
''');

    final violations = validatePreferenceTaxonomy(
      taxonomyPath: taxonomyFile.path,
      scenariosPath: scenariosFile.path,
    );
    expect(violations.map((v) => v.code), contains('scenario_id_mismatch'));
  });
}
