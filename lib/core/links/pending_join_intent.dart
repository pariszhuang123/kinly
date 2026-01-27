import 'dart:convert';

class PendingJoinIntent {
  const PendingJoinIntent({
    required this.inviteCode,
    required this.receivedAt,
    this.source,
    this.userId,
  });

  final String inviteCode;
  final DateTime receivedAt;
  final String? source;
  final String? userId;

  PendingJoinIntent bindUser(String? user) =>
      user == null ? this : copyWith(userId: user);

  PendingJoinIntent copyWith({
    String? inviteCode,
    DateTime? receivedAt,
    String? source,
    String? userId,
  }) {
    return PendingJoinIntent(
      inviteCode: inviteCode ?? this.inviteCode,
      receivedAt: receivedAt ?? this.receivedAt,
      source: source ?? this.source,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() => {
    'invite_code': inviteCode,
    'received_at': receivedAt.toIso8601String(),
    if (source != null) 'source': source,
    if (userId != null) 'user_id': userId,
  };

  String toEncoded() => jsonEncode(toJson());

  factory PendingJoinIntent.fromJson(Map<String, dynamic> json) {
    return PendingJoinIntent(
      inviteCode: (json['invite_code'] as String? ?? '').trim(),
      receivedAt:
          DateTime.tryParse(json['received_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      source: json['source'] as String?,
      userId: json['user_id'] as String?,
    );
  }

  factory PendingJoinIntent.fromEncoded(String encoded) {
    return PendingJoinIntent.fromJson(
      (jsonDecode(encoded) as Map).cast<String, dynamic>(),
    );
  }
}
