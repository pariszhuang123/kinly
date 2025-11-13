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
    final deactivated = (data['homeDeactivated'] as bool?) ?? false;
    return LeaveResult(
      outcome: code == 'HOME_DEACTIVATED'
          ? LeaveOutcome.homeDeactivated
          : LeaveOutcome.leftOk,
      homeDeactivated: deactivated,
      membersRemaining: (data['membersRemaining'] as num?)?.toInt() ?? 0,
      roleBefore: data['roleBefore'] as String?,
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

