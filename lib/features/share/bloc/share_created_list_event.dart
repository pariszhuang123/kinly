part of 'share_created_list_bloc.dart';

abstract class ShareCreatedListEvent extends Equatable {
  const ShareCreatedListEvent();

  @override
  List<Object?> get props => const [];
}

class ShareCreatedListRequested extends ShareCreatedListEvent {
  const ShareCreatedListRequested();
}

class ShareCreatedListRefreshed extends ShareCreatedListEvent {
  const ShareCreatedListRefreshed();
}
