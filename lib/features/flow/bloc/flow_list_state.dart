part of 'flow_list_bloc.dart';

enum FlowListStatus { initial, loading, success, failure }

class FlowListState extends Equatable {
  final FlowListStatus status;
  final List<ChoreListEntry> items;
  final bool isRefreshing;
  final String? errorMessage;
  final DateTime? lastUpdated;

  const FlowListState({
    this.status = FlowListStatus.initial,
    this.items = const [],
    this.isRefreshing = false,
    this.errorMessage,
    this.lastUpdated,
  });

  FlowListState copyWith({
    FlowListStatus? status,
    List<ChoreListEntry>? items,
    bool? isRefreshing,
    String? errorMessage,
    bool clearError = false,
    DateTime? lastUpdated,
  }) {
    return FlowListState(
      status: status ?? this.status,
      items: items ?? this.items,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  bool get isEmpty => status == FlowListStatus.success && items.isEmpty;

  @override
  List<Object?> get props => [
    status,
    items,
    isRefreshing,
    errorMessage,
    lastUpdated,
  ];
}
