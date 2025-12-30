import 'enums/leave_outcome.dart';
import '../time/timezone.dart';

export 'enums/leave_outcome.dart';

class LeaveResult {
  final LeaveOutcome outcome;
  final bool homeDeactivated;
  final int membersRemaining;
  final String? roleBefore;

  const LeaveResult({
    required this.outcome,
    required this.homeDeactivated,
    required this.membersRemaining,
    required this.roleBefore,
  });

  factory LeaveResult.fromJson(Map<String, dynamic> json) {
    final code = (json['code'] as String?)?.toUpperCase();
    final data = (json['data'] as Map?)?.cast<String, dynamic>() ?? const {};
    final deactivated =
        (data['home_deactivated'] as bool?) ??
        (data['homeDeactivated'] as bool?) ??
        false;
    final membersRemainingValue =
        data.containsKey('members_remaining')
            ? data['members_remaining']
            : data['membersRemaining'];
    final roleBeforeValue =
        data.containsKey('role_before')
            ? data['role_before']
            : data['roleBefore'];
    return LeaveResult(
      outcome:
          code == 'HOME_DEACTIVATED'
              ? LeaveOutcome.homeDeactivated
              : LeaveOutcome.leftOk,
      homeDeactivated: deactivated,
      membersRemaining: (membersRemainingValue as num?)?.toInt() ?? 0,
      roleBefore: roleBeforeValue as String?,
    );
  }
}

class CurrentMembership {
  final String userId;
  final String homeId;
  final String role;
  final DateTime validFrom;

  const CurrentMembership({
    required this.userId,
    required this.homeId,
    required this.role,
    required this.validFrom,
  });

  factory CurrentMembership.fromJson(Map<String, dynamic> json) {
    return CurrentMembership(
      userId: json['user_id'] as String,
      homeId: json['home_id'] as String,
      role: json['role'] as String,
      validFrom: parseTimestampToLocal(json['valid_from']) ??
          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
    );
  }
}

class HomeMemberSummary {
  final String userId;
  final String username;
  final String role;
  final DateTime validFrom;
  final String? avatarUrl;
  final bool canTransferTo;

  const HomeMemberSummary({
    required this.userId,
    required this.username,
    required this.role,
    required this.validFrom,
    this.avatarUrl,
    this.canTransferTo = false,
  });

  factory HomeMemberSummary.fromJson(Map<String, dynamic> json) {
    return HomeMemberSummary(
      userId: json['user_id'] as String,
      username: json['username'] as String? ?? '',
      role: json['role'] as String? ?? 'member',
      validFrom:
          parseTimestampToLocal(json['valid_from']) ??
          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
      avatarUrl: json['avatar_url'] as String?,
      canTransferTo: (json['can_transfer_to'] as bool?) ?? false,
    );
  }

  bool get isOwner => role.toLowerCase() == 'owner';
}

class HomeCreationResult {
  final String homeId;

  const HomeCreationResult({required this.homeId});

  factory HomeCreationResult.fromJson(Map<String, dynamic> json) {
    final home = (json['home'] as Map?)?.cast<String, dynamic>() ?? const {};
    final id = home['id'] as String? ?? '';
    return HomeCreationResult(homeId: id);
  }
}

class HomeJoinResult {
  final String homeId;
  final CurrentMembership? membership;

  const HomeJoinResult({required this.homeId, this.membership});

  factory HomeJoinResult.fromJson(Map<String, dynamic> json) {
    final homeFromPayload =
        (json['home'] as Map?)?.cast<String, dynamic>() ??
        (json['data'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};
    final membershipPayload =
        (json['membership'] as Map?)?.cast<String, dynamic>() ??
        (json['current_membership'] as Map?)?.cast<String, dynamic>();
    final homeId =
        json['home_id'] as String? ??
        json['homeId'] as String? ??
        homeFromPayload['id'] as String? ??
        '';
    return HomeJoinResult(
      homeId: homeId,
      membership:
          membershipPayload != null
              ? CurrentMembership.fromJson(membershipPayload)
              : null,
    );
  }
}

class HomeInvite {
  final String id;
  final String homeId;
  final String code;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? revokedAt;

  const HomeInvite({
    required this.id,
    required this.homeId,
    required this.code,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
    this.revokedAt,
  });

  bool get isActive => revokedAt == null;

  factory HomeInvite.fromJson(Map<String, dynamic> json) {
    return HomeInvite(
      id: json['id'] as String? ?? '',
      homeId: json['home_id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      createdBy: json['created_by'] as String? ?? '',
      createdAt:
          parseTimestampToLocal(json['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
      updatedAt: parseTimestampToLocal(json['updated_at']),
      revokedAt: parseTimestampToLocal(json['revoked_at']),
    );
  }
}
