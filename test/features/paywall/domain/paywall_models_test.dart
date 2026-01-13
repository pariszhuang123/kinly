import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/features/paywall/domain/paywall_models.dart';

void main() {
  group('PaywallLimit', () {
    test('fromJson parses correctly', () {
      final json = {'metric': 'active_chores', 'max_value': 5};
      final limit = PaywallLimit.fromJson(json);
      expect(limit.metric, 'active_chores');
      expect(limit.maxValue, 5);
    });

    test('fromJson handles numeric max_value', () {
      final json = {'metric': 'chore_photos', 'max_value': 10.0};
      final limit = PaywallLimit.fromJson(json);
      expect(limit.maxValue, 10);
    });
  });

  group('PaywallUsage', () {
    test('fromJson parses all fields', () {
      final json = {
        'active_chores': 3,
        'chore_photos': 2,
        'active_members': 4,
        'active_expenses': 5,
        'updated_at': '2024-06-15T10:30:00Z',
      };
      final usage = PaywallUsage.fromJson(json);
      expect(usage.activeChores, 3);
      expect(usage.chorePhotos, 2);
      expect(usage.activeMembers, 4);
      expect(usage.activeExpenses, 5);
      expect(usage.updatedAt, DateTime.utc(2024, 6, 15, 10, 30));
    });

    test('fromJson handles numeric values as doubles', () {
      final json = {
        'active_chores': 3.0,
        'chore_photos': 2.0,
        'active_members': 4.0,
        'active_expenses': 5.0,
        'updated_at': '2024-01-01T00:00:00Z',
      };
      final usage = PaywallUsage.fromJson(json);
      expect(usage.activeChores, 3);
      expect(usage.chorePhotos, 2);
    });
  });

  group('PaywallStatus', () {
    final usageJson = {
      'active_chores': 1,
      'chore_photos': 0,
      'active_members': 2,
      'active_expenses': 3,
      'updated_at': '2024-06-15T10:30:00Z',
    };

    test('fromJson parses nested usage and limits', () {
      final json = {
        'plan': 'premium',
        'expires_at': '2025-12-31T23:59:59Z',
        'usage': usageJson,
        'limits': [
          {'metric': 'active_chores', 'max_value': 10},
          {'metric': 'chore_photos', 'max_value': 5},
        ],
      };
      final status = PaywallStatus.fromJson(json);
      expect(status.plan, 'premium');
      expect(status.expiresAt, DateTime.utc(2025, 12, 31, 23, 59, 59));
      expect(status.usage.activeChores, 1);
      expect(status.limits, hasLength(2));
      expect(status.limits[0].metric, 'active_chores');
    });

    test('fromJson handles null expiresAt', () {
      final json = {
        'plan': 'free',
        'expires_at': null,
        'usage': usageJson,
        'limits': <dynamic>[],
      };
      final status = PaywallStatus.fromJson(json);
      expect(status.expiresAt, isNull);
    });

    test('fromJson handles missing limits', () {
      final json = {
        'plan': 'free',
        'expires_at': null,
        'usage': usageJson,
      };
      final status = PaywallStatus.fromJson(json);
      expect(status.limits, isEmpty);
    });

    test('isPremium returns true when plan is premium and not expired', () {
      final futureDate = DateTime.now().add(const Duration(days: 30));
      final status = PaywallStatus(
        plan: 'premium',
        expiresAt: futureDate,
        usage: PaywallUsage(
          activeChores: 0,
          chorePhotos: 0,
          activeMembers: 1,
          activeExpenses: 0,
          updatedAt: DateTime.now(),
        ),
        limits: const [],
      );
      expect(status.isPremium, isTrue);
    });

    test('isPremium returns true when plan is premium and expiresAt is null',
        () {
      final status = PaywallStatus(
        plan: 'premium',
        expiresAt: null,
        usage: PaywallUsage(
          activeChores: 0,
          chorePhotos: 0,
          activeMembers: 1,
          activeExpenses: 0,
          updatedAt: DateTime.now(),
        ),
        limits: const [],
      );
      expect(status.isPremium, isTrue);
    });

    test('isPremium returns false when plan is not premium', () {
      final status = PaywallStatus(
        plan: 'free',
        expiresAt: null,
        usage: PaywallUsage(
          activeChores: 0,
          chorePhotos: 0,
          activeMembers: 1,
          activeExpenses: 0,
          updatedAt: DateTime.now(),
        ),
        limits: const [],
      );
      expect(status.isPremium, isFalse);
    });

    test('isPremium returns false when expired', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 1));
      final status = PaywallStatus(
        plan: 'premium',
        expiresAt: pastDate,
        usage: PaywallUsage(
          activeChores: 0,
          chorePhotos: 0,
          activeMembers: 1,
          activeExpenses: 0,
          updatedAt: DateTime.now(),
        ),
        limits: const [],
      );
      expect(status.isPremium, isFalse);
    });
  });
}
