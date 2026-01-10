part of 'gratitude_wall_cubit.dart';

class GratitudeWallState extends Equatable {
  final List<GratitudeWallPost> posts;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final bool hasLoaded;
  final String? error;
  final DateTime? cursorCreatedAt;
  final String? cursorId;
  final int? totalPosts;

  const GratitudeWallState({
    required this.posts,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.hasLoaded,
    required this.totalPosts,
    this.error,
    this.cursorCreatedAt,
    this.cursorId,
  });

  const GratitudeWallState.initial()
    : posts = const [],
      isLoading = false,
      isLoadingMore = false,
      hasMore = true,
      hasLoaded = false,
      totalPosts = null,
      error = null,
      cursorCreatedAt = null,
      cursorId = null;

  GratitudeWallState copyWith({
    List<GratitudeWallPost>? posts,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    bool? hasLoaded,
    String? error,
    bool clearError = false,
    DateTime? cursorCreatedAt,
    String? cursorId,
    int? totalPosts,
  }) {
    return GratitudeWallState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      error: clearError ? null : (error ?? this.error),
      cursorCreatedAt: cursorCreatedAt ?? this.cursorCreatedAt,
      cursorId: cursorId ?? this.cursorId,
      totalPosts: totalPosts ?? this.totalPosts,
    );
  }

  @override
  List<Object?> get props => [
    posts,
    isLoading,
    isLoadingMore,
    hasMore,
    hasLoaded,
    error,
    cursorCreatedAt,
    cursorId,
    totalPosts,
  ];
}
