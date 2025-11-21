/// Per-debtor share payment status.
enum ExpenseShareStatus { unpaid, paid }

extension ExpenseShareStatusWire on ExpenseShareStatus {
  String get wireValue => name;

  static ExpenseShareStatus fromWire(String? wire) {
    if (wire == null) return ExpenseShareStatus.unpaid;
    return ExpenseShareStatus.values.firstWhere(
      (value) => value.wireValue == wire,
      orElse: () => ExpenseShareStatus.unpaid,
    );
  }
}
