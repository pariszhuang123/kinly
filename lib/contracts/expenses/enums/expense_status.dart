/// Top-level expense lifecycle state.
enum ExpenseStatus { draft, active, cancelled }

extension ExpenseStatusWire on ExpenseStatus {
  String get wireValue => name;

  static ExpenseStatus fromWire(String? wire) {
    if (wire == null) return ExpenseStatus.draft;
    return ExpenseStatus.values.firstWhere(
      (value) => value.wireValue == wire,
      orElse: () => ExpenseStatus.draft,
    );
  }
}
