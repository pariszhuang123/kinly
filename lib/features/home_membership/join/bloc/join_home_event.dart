part of 'join_home_bloc.dart';

abstract class JoinHomeEvent extends Equatable {
  const JoinHomeEvent();

  @override
  List<Object?> get props => [];
}

class JoinHomeCodeChanged extends JoinHomeEvent {
  const JoinHomeCodeChanged(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}

class JoinHomeSubmitted extends JoinHomeEvent {
  const JoinHomeSubmitted();
}

class JoinHomeReset extends JoinHomeEvent {
  const JoinHomeReset();
}
