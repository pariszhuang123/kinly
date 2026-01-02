/// Response enums returned by chore_complete RPC.
enum ChoreCompletionStatus {
  nonRecurringCompleted('non_recurring_completed'),
  alreadyCompletedForCycle('already_completed_for_cycle'),
  // Note: SQL returns 'recurring completed' with a space.
  recurringCompleted('recurring completed');

  const ChoreCompletionStatus(this.wireValue);
  final String wireValue;

  static ChoreCompletionStatus fromWire(String? wire) {
    if (wire == null) return ChoreCompletionStatus.nonRecurringCompleted;
    return ChoreCompletionStatus.values.firstWhere(
      (value) => value.wireValue == wire,
      orElse: () => ChoreCompletionStatus.nonRecurringCompleted,
    );
  }
}
