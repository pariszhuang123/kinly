class FlowChoreOutcome {
  final String choreId;
  final bool isUpdate;
  final bool isDeleted;

  const FlowChoreOutcome({
    required this.choreId,
    required this.isUpdate,
    this.isDeleted = false,
  });
}
