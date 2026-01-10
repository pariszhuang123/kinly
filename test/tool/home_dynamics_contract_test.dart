import 'dart:io';

import 'package:test/test.dart';

import '../../tool/check_home_dynamics_contract.dart';

void main() {
  test('flags vibe gating usage', () async {
    final temp = await Directory.systemTemp.createTemp('kinly_home_dynamics');
    addTearDown(() => temp.deleteSync(recursive: true));

    final libDir = Directory('${temp.path}/lib')..createSync(recursive: true);
    final file = File('${libDir.path}/vibe_gate.dart');
    file.writeAsStringSync(
      'void guard() { if (homeVibe.isStrict) { return; } // block }\n',
    );

    final violations = findHomeDynamicsViolations(rootPath: libDir.path);
    expect(violations.map((v) => v.ruleId), contains('vibe-gating'));
  });

  test('allows explicit allow marker', () async {
    final temp = await Directory.systemTemp.createTemp(
      'kinly_home_dynamics_allow',
    );
    addTearDown(() => temp.deleteSync(recursive: true));

    final libDir = Directory('${temp.path}/lib')..createSync(recursive: true);
    final file = File('${libDir.path}/vibe_allow.dart');
    file.writeAsStringSync(
      'void guard() { if (homeVibe.isStrict) { return; } '
      '// home-dynamics-allow block }\n',
    );

    final violations = findHomeDynamicsViolations(rootPath: libDir.path);
    expect(violations, isEmpty);
  });

  test('flags preferences enforcement usage', () async {
    final temp = await Directory.systemTemp.createTemp(
      'kinly_home_dynamics_prefs',
    );
    addTearDown(() => temp.deleteSync(recursive: true));

    final libDir = Directory('${temp.path}/lib')..createSync(recursive: true);
    final file = File('${libDir.path}/prefs_enforce.dart');
    file.writeAsStringSync('void enforce() { enforcePreferences(); }\n');

    final violations = findHomeDynamicsViolations(rootPath: libDir.path);
    expect(
      violations.map((v) => v.ruleId),
      contains('preferences-enforcement'),
    );
  });

  test('flags auto rules from vibe usage', () async {
    final temp = await Directory.systemTemp.createTemp(
      'kinly_home_dynamics_rules',
    );
    addTearDown(() => temp.deleteSync(recursive: true));

    final libDir = Directory('${temp.path}/lib')..createSync(recursive: true);
    final file = File('${libDir.path}/rules_from_vibe.dart');
    file.writeAsStringSync(
      'void update() { final ok = true; } // auto rules vibe\n',
    );

    final violations = findHomeDynamicsViolations(rootPath: libDir.path);
    expect(violations.map((v) => v.ruleId), contains('vibe-rules-derive'));
  });
}
