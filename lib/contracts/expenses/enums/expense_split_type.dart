/// Supported split strategies for expenses.
enum ExpenseSplitType { equal, custom }

extension ExpenseSplitTypeWire on ExpenseSplitType {
  String get wireValue => name;

  static ExpenseSplitType? fromWire(String? wire) {
    if (wire == null) return null;
    return ExpenseSplitType.values.firstWhere(
      (value) => value.wireValue == wire,
      orElse: () => ExpenseSplitType.equal,
    );
  }
}
