class PaywallLimit {
  final String metric;
  final int maxValue;

  const PaywallLimit({required this.metric, required this.maxValue});

  factory PaywallLimit.fromJson(Map<String, dynamic> json) {
    return PaywallLimit(
      metric: json['metric'] as String,
      maxValue: (json['max_value'] as num).toInt(),
    );
  }
}

class PaywallUsage {
  final int activeChores;
  final int chorePhotos;
  final int activeMembers;
  final int activeExpenses;
  final int expensePhotos;
  final DateTime updatedAt;

  const PaywallUsage({
    required this.activeChores,
    required this.chorePhotos,
    required this.activeMembers,
    required this.activeExpenses,
    required this.expensePhotos,
    required this.updatedAt,
  });

  factory PaywallUsage.fromJson(Map<String, dynamic> json) {
    return PaywallUsage(
      activeChores: (json['active_chores'] as num?)?.toInt() ?? 0,
      chorePhotos: (json['chore_photos'] as num?)?.toInt() ?? 0,
      activeMembers: (json['active_members'] as num?)?.toInt() ?? 0,
      activeExpenses: (json['active_expenses'] as num?)?.toInt() ?? 0,
      expensePhotos: (json['expense_photos'] as num?)?.toInt() ?? 0,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class PaywallStatus {
  final String plan;
  final DateTime? expiresAt;
  final PaywallUsage usage;
  final List<PaywallLimit> limits;

  const PaywallStatus({
    required this.plan,
    required this.expiresAt,
    required this.usage,
    required this.limits,
  });

  bool get isPremium =>
      plan == 'premium' &&
      (expiresAt == null || expiresAt!.isAfter(DateTime.now()));

  factory PaywallStatus.fromJson(Map<String, dynamic> json) {
    final limits = (json['limits'] as List<dynamic>? ?? [])
        .map((e) => PaywallLimit.fromJson((e as Map).cast<String, dynamic>()))
        .toList(growable: false);

    final usage = PaywallUsage.fromJson(
      (json['usage'] as Map).cast<String, dynamic>(),
    );

    final expiresRaw = json['expires_at'];

    return PaywallStatus(
      plan: json['plan'] as String,
      expiresAt:
          expiresRaw == null ? null : DateTime.parse(expiresRaw as String),
      usage: usage,
      limits: limits,
    );
  }
}
