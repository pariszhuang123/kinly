import 'dart:io';

import 'package:test/test.dart';

import '../../tool/check_preference_scenarios_headings.dart';

void main() {
  test('passes when headings match taxonomy ids', () async {
    final temp = await Directory.systemTemp.createTemp(
      'kinly_pref_scenarios_headings',
    );
    addTearDown(() => temp.deleteSync(recursive: true));

    final taxonomyFile = File('${temp.path}/preference_taxonomy_v1.md');
    taxonomyFile.writeAsStringSync('''
```preference-taxonomy-json
{
  "domains": ["one"],
  "items": [
    { "id": "alpha_one", "domain": "one" },
    { "id": "beta_one", "domain": "one" }
  ]
}
```
''');

    final scenariosFile = File('${temp.path}/preference_scenarios_v1.md');
    scenariosFile.writeAsStringSync('''
alpha_one
Scenario
Example text.

beta_one
Scenario
Example text.
''');

    final violations = validateScenarioHeadings(
      taxonomyPath: taxonomyFile.path,
      scenariosPath: scenariosFile.path,
    );
    expect(violations, isEmpty);
  });

  test('flags extra heading not in taxonomy', () async {
    final temp = await Directory.systemTemp.createTemp(
      'kinly_pref_scenarios_extra',
    );
    addTearDown(() => temp.deleteSync(recursive: true));

    final taxonomyFile = File('${temp.path}/preference_taxonomy_v1.md');
    taxonomyFile.writeAsStringSync('''
```preference-taxonomy-json
{
  "domains": ["one"],
  "items": [
    { "id": "alpha_one", "domain": "one" }
  ]
}
```
''');

    final scenariosFile = File('${temp.path}/preference_scenarios_v1.md');
    scenariosFile.writeAsStringSync('''
alpha_one
Scenario
Example text.

extra_heading
Scenario
Extra text.
''');

    final violations = validateScenarioHeadings(
      taxonomyPath: taxonomyFile.path,
      scenariosPath: scenariosFile.path,
    );
    expect(violations.map((v) => v.code), contains('extra_heading'));
  });
}
