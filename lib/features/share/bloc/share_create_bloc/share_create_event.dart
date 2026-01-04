part of 'share_create_bloc.dart';

abstract class ShareCreateEvent extends Equatable {
  const ShareCreateEvent();

  @override
  List<Object?> get props => [];
}

class ShareCreateParticipantsRequested extends ShareCreateEvent {
  const ShareCreateParticipantsRequested();
}

class ShareCreateDescriptionChanged extends ShareCreateEvent {
  const ShareCreateDescriptionChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class ShareCreateAmountChanged extends ShareCreateEvent {
  const ShareCreateAmountChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class ShareCreateSplitModeChanged extends ShareCreateEvent {
  const ShareCreateSplitModeChanged(this.mode);

  /// Nullable to allow "no split selected" in KinlyTabBar.
  final ShareSplitMode? mode;

  @override
  List<Object?> get props => [mode];
}

class ShareCreateNotesChanged extends ShareCreateEvent {
  const ShareCreateNotesChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class ShareCreateStartDateChanged extends ShareCreateEvent {
  const ShareCreateStartDateChanged(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

class ShareCreateRecurrenceToggled extends ShareCreateEvent {
  const ShareCreateRecurrenceToggled(this.isRecurring);

  final bool isRecurring;

  @override
  List<Object?> get props => [isRecurring];
}

class ShareCreateRecurrenceEveryChanged extends ShareCreateEvent {
  const ShareCreateRecurrenceEveryChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class ShareCreateRecurrenceUnitChanged extends ShareCreateEvent {
  const ShareCreateRecurrenceUnitChanged(this.unit);

  final ExpenseRecurrenceUnit unit;

  @override
  List<Object?> get props => [unit];
}

class ShareCreateParticipantToggled extends ShareCreateEvent {
  const ShareCreateParticipantToggled(this.userId, this.isSelected);

  final String userId;
  final bool isSelected;

  @override
  List<Object?> get props => [userId, isSelected];
}

class ShareCreateCustomAmountChanged extends ShareCreateEvent {
  const ShareCreateCustomAmountChanged(this.userId, this.amount);

  final String userId;
  final String amount;

  @override
  List<Object?> get props => [userId, amount];
}

class ShareCreateSubmitted extends ShareCreateEvent {
  const ShareCreateSubmitted();
}

class ShareCreateDeleted extends ShareCreateEvent {
  const ShareCreateDeleted();
}

class ShareCreatePlanTerminationRequested extends ShareCreateEvent {
  const ShareCreatePlanTerminationRequested();
}

class ShareCreatePaywallOpened extends ShareCreateEvent {
  final String requestId;
  const ShareCreatePaywallOpened(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class ShareCreatePaywallResolved extends ShareCreateEvent {
  final PaywallGateOutcome outcome;
  const ShareCreatePaywallResolved(this.outcome);

  @override
  List<Object?> get props => [outcome];
}
