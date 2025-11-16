import 'package:equatable/equatable.dart';

/// A minimal representation of a task shown on the Today page.
/// This is a *view model* for the Today feature –
/// the Flow feature can have a richer FlowTask entity if needed.
class TodayFlowTask extends Equatable {
  final String id;
  final String title;
  final bool isNewToday;

  const TodayFlowTask({
    required this.id,
    required this.title,
    this.isNewToday = false,
  });

  TodayFlowTask copyWith({String? id, String? title, bool? isNewToday}) {
    return TodayFlowTask(
      id: id ?? this.id,
      title: title ?? this.title,
      isNewToday: isNewToday ?? this.isNewToday,
    );
  }

  @override
  List<Object?> get props => [id, title, isNewToday];
}

/// A minimal representation of an expense shown on the Today page.
/// Again, this is a Today-facing model; the Share feature
/// can use a more detailed domain entity if it wants.
class TodayShareExpense extends Equatable {
  final String id;
  final String title;
  final double amount;
  final bool isUpcoming;

  const TodayShareExpense({
    required this.id,
    required this.title,
    required this.amount,
    this.isUpcoming = false,
  });

  TodayShareExpense copyWith({
    String? id,
    String? title,
    double? amount,
    bool? isUpcoming,
  }) {
    return TodayShareExpense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      isUpcoming: isUpcoming ?? this.isUpcoming,
    );
  }

  @override
  List<Object?> get props => [id, title, amount, isUpcoming];
}
