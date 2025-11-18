part of 'flow_list_bloc.dart';

abstract class FlowListEvent extends Equatable {
  const FlowListEvent();

  @override
  List<Object?> get props => [];
}

class FlowListRequested extends FlowListEvent {
  const FlowListRequested();
}

class FlowListRefreshed extends FlowListEvent {
  const FlowListRefreshed();
}
