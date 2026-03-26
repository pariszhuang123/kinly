class FlowChorePrefill {
  const FlowChorePrefill({
    this.title,
    this.assigneeUserId,
    this.startDate,
    this.notes,
    this.howToVideoUrl,
  });

  final String? title;
  final String? assigneeUserId;
  final DateTime? startDate;
  final String? notes;
  final String? howToVideoUrl;
}
