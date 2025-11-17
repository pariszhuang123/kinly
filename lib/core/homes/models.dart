enum LeaveOutcome { leftOk, homeDeactivated }

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
      validFrom: DateTime.parse(json['valid_from'] as String),
    );
  }
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
