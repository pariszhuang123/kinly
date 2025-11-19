class FlowChoreOutcome {
  final String choreId;
  final bool isUpdate;
  final bool isDeleted;
  final bool isCompleted;

  const FlowChoreOutcome({
    required this.choreId,
    required this.isUpdate,
    this.isDeleted = false,
    this.isCompleted = false,
  });
}
