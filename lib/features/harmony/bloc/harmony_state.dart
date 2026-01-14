part of 'harmony_cubit.dart';

class HarmonyState extends Equatable {
  final MoodScale? selectedMood;
  final String comment;
  final bool addToWall;
  final bool isSubmitting;
  final int submitSuccessTick;
  final String? submitError;
  final MoodSubmitResult? lastResult;
  final List<HomeMemberSummary> members;
  final Set<String> selectedMentions;
  final bool isLoadingMembers;
  final bool membersLoadFailed;

  const HarmonyState({
    this.selectedMood,
    this.comment = '',
    this.addToWall = false,
    this.isSubmitting = false,
    this.submitSuccessTick = 0,
    this.submitError,
    this.lastResult,
    this.members = const [],
    this.selectedMentions = const <String>{},
    this.isLoadingMembers = false,
    this.membersLoadFailed = false,
  });

  HarmonyState copyWith({
    MoodScale? selectedMood,
    bool clearSelectedMood = false,
    String? comment,
    bool? addToWall,
    bool? isSubmitting,
    int? submitSuccessTick,
    String? submitError,
    MoodSubmitResult? lastResult,
    List<HomeMemberSummary>? members,
    Set<String>? selectedMentions,
    bool? isLoadingMembers,
    bool? membersLoadFailed,
  }) {
    return HarmonyState(
      selectedMood:
          clearSelectedMood ? null : (selectedMood ?? this.selectedMood),
      comment: comment ?? this.comment,
      addToWall: addToWall ?? this.addToWall,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccessTick: submitSuccessTick ?? this.submitSuccessTick,
      submitError: submitError,
      lastResult: lastResult ?? this.lastResult,
      members: members ?? this.members,
      selectedMentions: selectedMentions ?? this.selectedMentions,
      isLoadingMembers: isLoadingMembers ?? this.isLoadingMembers,
      membersLoadFailed: membersLoadFailed ?? this.membersLoadFailed,
    );
  }

  @override
  List<Object?> get props => [
    selectedMood,
    comment,
    addToWall,
    isSubmitting,
    submitSuccessTick,
    submitError,
    lastResult,
    members,
    selectedMentions,
    isLoadingMembers,
    membersLoadFailed,
  ];
}
