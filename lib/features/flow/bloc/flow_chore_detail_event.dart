part of 'flow_chore_detail_bloc.dart';

abstract class FlowChoreDetailEvent extends Equatable {
  const FlowChoreDetailEvent();

  @override
  List<Object?> get props => [];
}

class FlowChoreDetailStarted extends FlowChoreDetailEvent {
  const FlowChoreDetailStarted();
}

class FlowChoreDetailCompletionRequested extends FlowChoreDetailEvent {
  const FlowChoreDetailCompletionRequested();
}
