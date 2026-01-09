import 'dart:io';

import 'package:test/test.dart';

import '../../tool/check_preference_reports_language.dart';

void main() {
  test('passes when report copy has no enforcement language', () async {
    final temp = await Directory.systemTemp.createTemp(
      'kinly_pref_report_lang_pass',
    );
    addTearDown(() => temp.deleteSync(recursive: true));

    final file = File('${temp.path}/preference_reports_v1.md');
    file.writeAsStringSync('''
```preference-report-copy
Summary: I prefer calm evenings.
Environment: I prefer softer lighting.
```
''');

    final violations = checkPreferenceReportLanguage(docPath: file.path);
    expect(violations, isEmpty);
  });

  test('flags enforcement language in report copy', () async {
    final temp = await Directory.systemTemp.createTemp(
      'kinly_pref_report_lang_fail',
    );
    addTearDown(() => temp.deleteSync(recursive: true));

    final file = File('${temp.path}/preference_reports_v1.md');
    file.writeAsStringSync('''
```preference-report-copy
Summary: You must keep the kitchen quiet.
```
''');

    final violations = checkPreferenceReportLanguage(docPath: file.path);
    expect(violations.map((v) => v.term), contains('must'));
  });
}
