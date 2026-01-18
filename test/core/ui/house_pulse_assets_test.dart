import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/contracts/mood/enums/house_pulse_state.dart';
import 'package:kinly/core/ui/house_pulse_assets.dart';

void main() {
  test('prefers provided imageKey and contractVersion', () {
    final path = resolveHousePulseAssetPath(
      contractVersion: 'v1',
      imageKey: 'pulse_custom_key',
      pulseState: HousePulseState.sunnyCalm,
    );
    expect(path, 'assets/house_pulse_v1/pulse_custom_key.webp');
  });

  test('falls back to pulse state key when imageKey empty', () {
    final path = resolveHousePulseAssetPath(
      contractVersion: 'v1',
      imageKey: '',
      pulseState: HousePulseState.cloudyTense,
    );
    expect(path, 'assets/house_pulse_v1/pulse_cloudy_tense.webp');
  });

  test('falls back to forming when state is null', () {
    final path = resolveHousePulseAssetPath(
      contractVersion: 'v1',
      imageKey: '',
      pulseState: null,
    );
    expect(path, 'assets/house_pulse_v1/pulse_forming.webp');
  });

  test('sanitizes contract version for path safety', () {
    final path = resolveHousePulseAssetPath(
      contractVersion: 'v1-alpha',
      imageKey: 'pulse_forming',
      pulseState: HousePulseState.forming,
    );
    expect(path, 'assets/house_pulse_v1alpha/pulse_forming.webp');
  });
}
