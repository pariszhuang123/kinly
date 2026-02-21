import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/paywall/enums/paywall_event_type.dart';
import 'package:kinly/contracts/paywall/enums/paywall_gate_status.dart';
import 'package:kinly/contracts/paywall/enums/paywall_retry_action.dart';
import 'package:kinly/contracts/paywall/enums/paywall_trigger.dart';

void main() {
  group('PaywallEventType', () {
    test('has 4 values', () {
      expect(PaywallEventType.values.length, 4);
    });

    test('impression is a value', () {
      expect(PaywallEventType.values, contains(PaywallEventType.impression));
    });

    test('ctaClick is a value', () {
      expect(PaywallEventType.values, contains(PaywallEventType.ctaClick));
    });

    test('dismiss is a value', () {
      expect(PaywallEventType.values, contains(PaywallEventType.dismiss));
    });

    test('restoreAttempt is a value', () {
      expect(
        PaywallEventType.values,
        contains(PaywallEventType.restoreAttempt),
      );
    });
  });

  group('PaywallGateStatus', () {
    test('has 3 values', () {
      expect(PaywallGateStatus.values.length, 3);
    });

    test('granted is a value', () {
      expect(PaywallGateStatus.values, contains(PaywallGateStatus.granted));
    });

    test('cancelled is a value', () {
      expect(PaywallGateStatus.values, contains(PaywallGateStatus.cancelled));
    });

    test('failed is a value', () {
      expect(PaywallGateStatus.values, contains(PaywallGateStatus.failed));
    });
  });

  group('PaywallRetryAction', () {
    test('has 1 value', () {
      expect(PaywallRetryAction.values.length, 1);
    });

    test('submit is a value', () {
      expect(PaywallRetryAction.values, contains(PaywallRetryAction.submit));
    });
  });

  group('PaywallTrigger', () {
    test('has 6 values', () {
      expect(PaywallTrigger.values.length, 6);
    });

    test('flowActiveCap is a value', () {
      expect(PaywallTrigger.values, contains(PaywallTrigger.flowActiveCap));
    });

    test('flowPhotosCap is a value', () {
      expect(PaywallTrigger.values, contains(PaywallTrigger.flowPhotosCap));
    });

    test('shoppingPhotosCap is a value', () {
      expect(PaywallTrigger.values, contains(PaywallTrigger.shoppingPhotosCap));
    });

    test('expenseActiveCap is a value', () {
      expect(PaywallTrigger.values, contains(PaywallTrigger.expenseActiveCap));
    });

    test('expensePhotosCap is a value', () {
      expect(PaywallTrigger.values, contains(PaywallTrigger.expensePhotosCap));
    });

    test('membersCap is a value', () {
      expect(PaywallTrigger.values, contains(PaywallTrigger.membersCap));
    });
  });
}
