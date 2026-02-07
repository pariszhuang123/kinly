enum MoodSubmitErrorCode {
  invalidHome,
  invalidMood,
  notPositiveMood,
  mentionLimitExceeded,
  duplicateMentions,
  selfMentionNotAllowed,
  mentionNotHomeMember,
  invalidMentionUser,
  commentRequiredForMention,
  singleMentionRequired,
  commentRequiredForPublicWall,
  complaintTooShort,
  complaintTooBrief,
  complaintNeedsSentence,
  moodAlreadySubmitted,
  unauthorized,
  forbidden,
  unknown,
}

class MoodSubmitException implements Exception {
  final MoodSubmitErrorCode code;
  final String message;
  final Map<String, dynamic>? details;

  const MoodSubmitException(this.code, this.message, {this.details});

  @override
  String toString() => 'MoodSubmitException($code): $message';
}
