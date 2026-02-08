part of 'flow_chore_bloc.dart';

abstract class FlowChoreEvent extends Equatable {
  const FlowChoreEvent();

  @override
  List<Object?> get props => [];
}

class FlowChoreStarted extends FlowChoreEvent {
  const FlowChoreStarted();
}

class FlowChoreTitleChanged extends FlowChoreEvent {
  final String title;
  const FlowChoreTitleChanged(this.title);

  @override
  List<Object?> get props => [title];
}

class FlowChoreAssigneeChanged extends FlowChoreEvent {
  final String? assigneeUserId;
  const FlowChoreAssigneeChanged(this.assigneeUserId);

  @override
  List<Object?> get props => [assigneeUserId];
}

class FlowChoreStartDateChanged extends FlowChoreEvent {
  final DateTime startDate;
  const FlowChoreStartDateChanged(this.startDate);

  @override
  List<Object?> get props => [startDate];
}

class FlowChoreRecurrenceToggled extends FlowChoreEvent {
  final bool isRecurring;
  const FlowChoreRecurrenceToggled(this.isRecurring);

  @override
  List<Object?> get props => [isRecurring];
}

class FlowChoreRecurrenceEveryChanged extends FlowChoreEvent {
  final String value;
  const FlowChoreRecurrenceEveryChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class FlowChoreRecurrenceUnitChanged extends FlowChoreEvent {
  final ChoreRecurrenceUnit unit;
  const FlowChoreRecurrenceUnitChanged(this.unit);

  @override
  List<Object?> get props => [unit];
}

class FlowChoreNotesChanged extends FlowChoreEvent {
  final String notes;
  const FlowChoreNotesChanged(this.notes);

  @override
  List<Object?> get props => [notes];
}

class FlowChoreHowToChanged extends FlowChoreEvent {
  final String url;
  const FlowChoreHowToChanged(this.url);

  @override
  List<Object?> get props => [url];
}

class FlowChorePhotoChanged extends FlowChoreEvent {
  final String photoPath;
  const FlowChorePhotoChanged(this.photoPath);

  @override
  List<Object?> get props => [photoPath];
}

class FlowChorePhotoCaptureRequested extends FlowChoreEvent {
  const FlowChorePhotoCaptureRequested();
}

class FlowChorePhotoRecoveryRequested extends FlowChoreEvent {
  const FlowChorePhotoRecoveryRequested();
}

class FlowChoreSubmitted extends FlowChoreEvent {
  const FlowChoreSubmitted();
}

class FlowChoreDeleted extends FlowChoreEvent {
  const FlowChoreDeleted();
}

class FlowChorePaywallOpened extends FlowChoreEvent {
  final String requestId;
  const FlowChorePaywallOpened(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class FlowChorePaywallResolved extends FlowChoreEvent {
  final PaywallGateOutcome outcome;
  const FlowChorePaywallResolved(this.outcome);

  @override
  List<Object?> get props => [outcome];
}
