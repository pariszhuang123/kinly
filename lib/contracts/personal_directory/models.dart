import 'package:kinly/contracts/time/timezone.dart';

import 'enums/personal_directory_note_type.dart';

export 'enums/personal_directory_note_type.dart';

class PersonalDirectoryBankAccount {
  const PersonalDirectoryBankAccount({
    required this.id,
    required this.accountHolderName,
    required this.accountNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String accountHolderName;
  final String accountNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory PersonalDirectoryBankAccount.fromJson(Map<String, dynamic> json) {
    return PersonalDirectoryBankAccount(
      id: json['id'] as String? ?? '',
      accountHolderName: json['account_holder_name'] as String? ?? '',
      accountNumber: json['account_number'] as String? ?? '',
      createdAt:
          parseTimestampToLocal(json['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
      updatedAt:
          parseTimestampToLocal(json['updated_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
    );
  }
}

class PersonalDirectoryMemberSummary {
  const PersonalDirectoryMemberSummary({
    required this.userId,
    required this.username,
    required this.isHomeOwner,
    this.avatarUrl,
    this.avatarStoragePath,
    this.hasContent = false,
  });

  final String userId;
  final String username;
  final String? avatarUrl;
  final String? avatarStoragePath;
  final bool isHomeOwner;
  final bool hasContent;

  factory PersonalDirectoryMemberSummary.fromJson(Map<String, dynamic> json) {
    return PersonalDirectoryMemberSummary(
      userId: json['user_id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      avatarStoragePath: json['avatar_storage_path'] as String?,
      isHomeOwner: json['is_owner'] as bool? ?? false,
      hasContent: json['has_personal_directory_content'] as bool? ?? false,
    );
  }

  PersonalDirectoryMemberSummary copyWith({
    String? userId,
    String? username,
    Object? avatarUrl = _unset,
    Object? avatarStoragePath = _unset,
    bool? isHomeOwner,
    bool? hasContent,
  }) {
    return PersonalDirectoryMemberSummary(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarUrl: avatarUrl == _unset ? this.avatarUrl : avatarUrl as String?,
      avatarStoragePath:
          avatarStoragePath == _unset
              ? this.avatarStoragePath
              : avatarStoragePath as String?,
      isHomeOwner: isHomeOwner ?? this.isHomeOwner,
      hasContent: hasContent ?? this.hasContent,
    );
  }

  static const _unset = Object();
}

class PersonalDirectoryNote {
  const PersonalDirectoryNote({
    required this.id,
    required this.noteType,
    required this.createdAt,
    required this.updatedAt,
    this.label,
    this.customTitle,
    this.contactName,
    this.phoneNumber,
    this.details,
    this.photoPath,
  });

  final String id;
  final PersonalDirectoryNoteType noteType;
  final String? label;
  final String? customTitle;
  final String? contactName;
  final String? phoneNumber;
  final String? details;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory PersonalDirectoryNote.fromJson(Map<String, dynamic> json) {
    return PersonalDirectoryNote(
      id: json['id'] as String? ?? '',
      noteType: PersonalDirectoryNoteType.fromWire(
        json['note_type'] as String?,
      ),
      label: json['label'] as String?,
      customTitle: json['custom_title'] as String?,
      contactName: json['contact_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      details: json['details'] as String?,
      photoPath: json['photo_path'] as String?,
      createdAt:
          parseTimestampToLocal(json['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
      updatedAt:
          parseTimestampToLocal(json['updated_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
    );
  }
}

class UpsertPersonalDirectoryBankAccountInput {
  const UpsertPersonalDirectoryBankAccountInput({
    required this.accountHolderName,
    required this.accountNumber,
  });

  final String accountHolderName;
  final String accountNumber;
}

class CreatePersonalDirectoryNoteInput {
  const CreatePersonalDirectoryNoteInput({
    required this.noteType,
    this.label,
    this.customTitle,
    this.contactName,
    this.phoneNumber,
    this.details,
    this.photoPath,
  });

  final PersonalDirectoryNoteType noteType;
  final String? label;
  final String? customTitle;
  final String? contactName;
  final String? phoneNumber;
  final String? details;
  final String? photoPath;
}

class UpdatePersonalDirectoryNoteInput {
  const UpdatePersonalDirectoryNoteInput({
    required this.noteId,
    this.label,
    this.customTitle,
    this.contactName,
    this.phoneNumber,
    this.details,
    this.photoPath,
  });

  final String noteId;
  final String? label;
  final String? customTitle;
  final String? contactName;
  final String? phoneNumber;
  final String? details;
  final String? photoPath;
}

class PersonalDirectoryNudge {
  const PersonalDirectoryNudge({
    required this.show,
    required this.homeId,
    required this.missing,
  });

  final bool show;
  final String homeId;
  final List<String> missing;

  factory PersonalDirectoryNudge.fromJson(Map<String, dynamic> json) {
    final missingRaw = json['missing'] as List? ?? const <dynamic>[];
    return PersonalDirectoryNudge(
      show: json['show'] as bool? ?? false,
      homeId: json['home_id'] as String? ?? '',
      missing:
          missingRaw
              .whereType<String>()
              .map((entry) => entry.trim())
              .where((entry) => entry.isNotEmpty)
              .toList(growable: false),
    );
  }
}
