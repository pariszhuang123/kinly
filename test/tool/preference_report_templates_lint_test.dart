import 'dart:io';

import 'package:test/test.dart';

import '../../tool/check_preference_report_templates.dart';

void main() {
  test('passes when each taxonomy id has 3 variants', () async {
    final temp = await Directory.systemTemp.createTemp(
      'kinly_pref_report_template_pass',
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

    final reportFile = File('${temp.path}/preference_reports_v1.md');
    reportFile.writeAsStringSync('''
```preference-report-template-json
{
  "preferences": {
    "alpha_one": [
      { "value_key": "a", "title": "One", "text": "one" },
      { "value_key": "b", "title": "Two", "text": "two" },
      { "value_key": "c", "title": "Three", "text": "three" }
    ]
  }
}
```
''');

    final violations = checkPreferenceReportTemplate(
      taxonomyPath: taxonomyFile.path,
      reportPath: reportFile.path,
    );
    expect(violations, isEmpty);
  });

  test('flags missing or wrong variant count', () async {
    final temp = await Directory.systemTemp.createTemp(
      'kinly_pref_report_template_fail',
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

    final reportFile = File('${temp.path}/preference_reports_v1.md');
    reportFile.writeAsStringSync('''
```preference-report-template-json
{
  "preferences": {
    "alpha_one": [
      { "value_key": "a", "title": "One", "text": "one" },
      { "value_key": "b", "title": "Two", "text": "two" }
    ]
  }
}
```
''');

    final violations = checkPreferenceReportTemplate(
      taxonomyPath: taxonomyFile.path,
      reportPath: reportFile.path,
    );
    expect(
      violations.map((v) => v.code),
      contains('invalid_preference_variant_count'),
    );
  });
}
