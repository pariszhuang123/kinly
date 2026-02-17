import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class FormDraftStorage {
  static const int schemaVersionV1 = 1;

  static const String _personalPreferencesPrefix =
      'kinly_formdraft::personal_preferences';
  static const String _houseRulesPrefix = 'kinly_formdraft::house_rules';
  static const String _houseNormsPrefix = 'kinly_formdraft::house_norms';

  static String personalPreferencesKey({required String userId}) =>
      '$_personalPreferencesPrefix::$userId';

  static String houseRulesKey({required String homeId}) =>
      '$_houseRulesPrefix::$homeId';
  static String houseNormsKey({required String homeId}) =>
      '$_houseNormsPrefix::$homeId';

  static Future<void> clearPersonalPreferencesDraft(String userId) async {
    await HydratedBloc.storage.delete(personalPreferencesKey(userId: userId));
  }

  static Future<void> clearHouseRulesDraft(String homeId) async {
    await HydratedBloc.storage.delete(houseRulesKey(homeId: homeId));
  }

  static Future<void> clearHouseNormsDraft(String homeId) async {
    await HydratedBloc.storage.delete(houseNormsKey(homeId: homeId));
  }

  static String hashScope(String raw) =>
      sha256.convert(utf8.encode(raw)).toString();
}
