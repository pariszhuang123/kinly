import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/contracts/homes/home_units_models.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';

void main() {
  group('HomeUnitSummary.fromJson', () {
    test('parses snake_case payload', () {
      final result = HomeUnitSummary.fromJson({
        'unit_id': 'unit-shared',
        'home_id': 'home-1',
        'name': 'Alex + Sam',
        'unit_type': 'shared',
        'member_user_ids': ['user-1', 'user-2'],
      });

      expect(result.unitId, 'unit-shared');
      expect(result.homeId, 'home-1');
      expect(result.name, 'Alex + Sam');
      expect(result.unitType, HomeUnitType.shared);
      expect(result.memberUserIds, ['user-1', 'user-2']);
    });

    test('parses camelCase payload', () {
      final result = HomeUnitSummary.fromJson({
        'unitId': 'unit-personal',
        'homeId': 'home-1',
        'name': 'Personal',
        'unitType': 'personal',
        'memberUserIds': ['user-1'],
      });

      expect(result.unitId, 'unit-personal');
      expect(result.unitType, HomeUnitType.personal);
      expect(result.memberUserIds, ['user-1']);
    });
  });

  group('HomeUnitContext.fromJson', () {
    test('parses snake_case payload', () {
      final result = HomeUnitContext.fromJson({
        'personal_unit': {
          'unit_id': 'unit-personal',
          'home_id': 'home-1',
          'name': 'Personal',
          'unit_type': 'personal',
          'member_user_ids': ['user-1'],
        },
        'active_shared_unit': {
          'unit_id': 'unit-shared',
          'home_id': 'home-1',
          'name': 'Alex + Sam',
          'unit_type': 'shared',
          'member_user_ids': ['user-1', 'user-2'],
        },
        'allowed_shopping_scopes': ['house', 'unit'],
      });

      expect(result.personalUnit.unitId, 'unit-personal');
      expect(result.activeSharedUnit?.unitId, 'unit-shared');
      expect(
        result.allowedShoppingScopes,
        [ShoppingItemScopeType.house, ShoppingItemScopeType.unit],
      );
      expect(result.hasSharedUnit, isTrue);
      expect(result.shoppingAlternateUnit.unitId, 'unit-shared');
    });

    test('parses camelCase payload without shared unit', () {
      final result = HomeUnitContext.fromJson({
        'personalUnit': {
          'unitId': 'unit-personal',
          'homeId': 'home-1',
          'name': 'Personal',
          'unitType': 'personal',
          'memberUserIds': ['user-1'],
        },
        'activeSharedUnit': null,
        'allowedShoppingScopes': ['house'],
      });

      expect(result.personalUnit.unitId, 'unit-personal');
      expect(result.activeSharedUnit, isNull);
      expect(result.allowedShoppingScopes, [ShoppingItemScopeType.house]);
      expect(result.hasSharedUnit, isFalse);
      expect(result.shoppingAlternateUnit.unitId, 'unit-personal');
    });
  });
}
