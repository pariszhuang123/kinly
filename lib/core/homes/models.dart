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

