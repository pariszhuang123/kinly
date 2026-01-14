part of 'personal_gratitude_cubit.dart';

class PersonalGratitudeState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final bool hasLoaded;
  final List<PersonalGratitudeItem> items;
  final DateTime? cursorAt;
  final String? cursorId;
  final PersonalGratitudeStatus? status;
  final PersonalGratitudeStats? stats;
  final String? error;

  const PersonalGratitudeState({
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.hasLoaded,
    required this.items,
    this.cursorAt,
    this.cursorId,
    this.status,
    this.stats,
    this.error,
  });

  const PersonalGratitudeState.initial()
    : isLoading = false,
      isLoadingMore = false,
      hasMore = false,
      hasLoaded = false,
      items = const [],
      cursorAt = null,
      cursorId = null,
      status = null,
      stats = null,
      error = null;

  PersonalGratitudeState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    bool? hasLoaded,
    List<PersonalGratitudeItem>? items,
    DateTime? cursorAt,
    String? cursorId,
    PersonalGratitudeStatus? status,
    PersonalGratitudeStats? stats,
    String? error,
  }) {
    return PersonalGratitudeState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      items: items ?? this.items,
      cursorAt: cursorAt ?? this.cursorAt,
      cursorId: cursorId ?? this.cursorId,
      status: status ?? this.status,
      stats: stats ?? this.stats,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoadingMore,
    hasMore,
    hasLoaded,
    items,
    cursorAt,
    cursorId,
    status,
    stats,
    error,
  ];
}
