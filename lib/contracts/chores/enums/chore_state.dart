/// DB-backed state for chores.
enum ChoreState { draft, active, completed, cancelled }

extension ChoreStateWire on ChoreState {
  String get wireValue => name;

  static ChoreState fromWire(String? wire) {
    if (wire == null) return ChoreState.draft;
    return ChoreState.values.firstWhere(
      (value) => value.wireValue == wire,
      orElse: () => ChoreState.draft,
    );
  }
}
