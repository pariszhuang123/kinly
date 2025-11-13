part of 'start_home_bloc.dart';

sealed class StartHomeEvent {
  const StartHomeEvent();
}

class StartHomeCreateRequested extends StartHomeEvent {
  const StartHomeCreateRequested();
}
