import 'package:equatable/equatable.dart';

import 'shopping_models.dart';

enum HomeUnitType {
  personal('personal'),
  shared('shared');

  const HomeUnitType(this.wireValue);

  final String wireValue;

  static HomeUnitType fromWire(String? value) {
    switch ((value ?? '').trim().toLowerCase()) {
      case 'shared':
        return HomeUnitType.shared;
      case 'personal':
      default:
        return HomeUnitType.personal;
    }
  }
}

class HomeUnitSummary extends Equatable {
  const HomeUnitSummary({
    required this.unitId,
    required this.homeId,
    required this.name,
    required this.unitType,
    required this.memberUserIds,
  });

  final String unitId;
  final String homeId;
  final String name;
  final HomeUnitType unitType;
  final List<String> memberUserIds;

  factory HomeUnitSummary.fromJson(Map<String, dynamic> json) {
    final rawMemberUserIds =
        (json['member_user_ids'] as List?) ??
        (json['memberUserIds'] as List?) ??
        const <dynamic>[];
    return HomeUnitSummary(
      unitId: json['unit_id'] as String? ?? json['unitId'] as String? ?? '',
      homeId: json['home_id'] as String? ?? json['homeId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      unitType: HomeUnitType.fromWire(
        json['unit_type'] as String? ?? json['unitType'] as String?,
      ),
      memberUserIds: rawMemberUserIds
          .map((value) => value.toString())
          .toList(growable: false),
    );
  }
  @override
  List<Object?> get props => [unitId, homeId, name, unitType, memberUserIds];
}

class HomeUnitMemberCandidate extends Equatable {
  const HomeUnitMemberCandidate({
    required this.membershipId,
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    this.isOwner = false,
  });

  final String membershipId;
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final bool isOwner;

  factory HomeUnitMemberCandidate.fromJson(Map<String, dynamic> json) {
    return HomeUnitMemberCandidate(
      membershipId:
          json['membership_id'] as String? ??
          json['membershipId'] as String? ??
          '',
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      displayName:
          json['display_name'] as String? ??
          json['displayName'] as String? ??
          json['username'] as String? ??
          '',
      avatarUrl:
          json['avatar_url'] as String? ?? json['avatarUrl'] as String?,
      isOwner:
          json['is_owner'] as bool? ?? json['isOwner'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
    membershipId,
    userId,
    displayName,
    avatarUrl,
    isOwner,
  ];
}

class HomeUnitContext extends Equatable {
  const HomeUnitContext({
    required this.personalUnit,
    required this.activeSharedUnit,
    required this.allowedShoppingScopes,
  });

  final HomeUnitSummary personalUnit;
  final HomeUnitSummary? activeSharedUnit;
  final List<ShoppingItemScopeType> allowedShoppingScopes;

  factory HomeUnitContext.fromJson(Map<String, dynamic> json) {
    final personalUnitPayload =
        (json['personal_unit'] as Map?)?.cast<String, dynamic>() ??
        (json['personalUnit'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};
    final sharedUnitPayload =
        (json['active_shared_unit'] as Map?)?.cast<String, dynamic>() ??
        (json['activeSharedUnit'] as Map?)?.cast<String, dynamic>();
    final rawScopes =
        (json['allowed_shopping_scopes'] as List?) ??
        (json['allowedShoppingScopes'] as List?) ??
        const <dynamic>['house'];
    return HomeUnitContext(
      personalUnit: HomeUnitSummary.fromJson(personalUnitPayload),
      activeSharedUnit:
          sharedUnitPayload == null
              ? null
              : HomeUnitSummary.fromJson(sharedUnitPayload),
      allowedShoppingScopes: rawScopes
          .map((value) => ShoppingItemScopeType.fromWire(value.toString()))
          .toList(growable: false),
    );
  }
  @override
  List<Object?> get props => [
    personalUnit,
    activeSharedUnit,
    allowedShoppingScopes,
  ];
}

extension HomeUnitSummaryX on HomeUnitSummary {
  bool get isShared => unitType == HomeUnitType.shared;
  bool get isPersonal => unitType == HomeUnitType.personal;
}

extension HomeUnitContextX on HomeUnitContext {
  bool get hasSharedUnit => activeSharedUnit != null;

  HomeUnitSummary get shoppingAlternateUnit =>
      activeSharedUnit ?? personalUnit;
}
