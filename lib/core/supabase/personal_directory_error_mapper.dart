import 'package:supabase_flutter/supabase_flutter.dart';

import 'enums/personal_directory_error_code.dart';

class PersonalDirectoryException implements Exception {
  final PersonalDirectoryErrorCode code;
  final String message;
  final Map<String, dynamic>? details;

  const PersonalDirectoryException(this.code, this.message, {this.details});

  @override
  String toString() => 'PersonalDirectoryException($code): $message';
}

PersonalDirectoryException mapPersonalDirectoryError(
  Object error, {
  required String Function(PostgrestException error) parseCode,
  required String Function(PostgrestException error) parseMessage,
  required Map<String, dynamic>? Function(PostgrestException error) parseDetails,
}) {
  if (error is AuthException) {
    return PersonalDirectoryException(
      PersonalDirectoryErrorCode.unauthorized,
      error.message,
    );
  }
  if (error is PostgrestException) {
    final code = parseCode(error);
    return PersonalDirectoryException(
      _personalDirectoryCodeMap[code] ?? PersonalDirectoryErrorCode.unknown,
      parseMessage(error),
      details: parseDetails(error),
    );
  }
  return PersonalDirectoryException(
    PersonalDirectoryErrorCode.unknown,
    error.toString(),
  );
}

const _personalDirectoryCodeMap = <String, PersonalDirectoryErrorCode>{
  'UNAUTHORIZED': PersonalDirectoryErrorCode.unauthorized,
  'NOT_HOME_MEMBER': PersonalDirectoryErrorCode.notHomeMember,
  'MEMBER_DIRECTORY_INVALID_ENUM': PersonalDirectoryErrorCode.invalidEnum,
  'MEMBER_DIRECTORY_INVALID_INPUT': PersonalDirectoryErrorCode.invalidInput,
  'MEMBER_DIRECTORY_BANK_ACCOUNT_REQUIRED_FIELDS':
      PersonalDirectoryErrorCode.bankAccountRequiredFields,
  'MEMBER_DIRECTORY_ALLERGY_LABEL_REQUIRED':
      PersonalDirectoryErrorCode.allergyLabelRequired,
  'MEMBER_DIRECTORY_ALLERGY_LABEL_FORBIDDEN':
      PersonalDirectoryErrorCode.allergyLabelForbidden,
  'MEMBER_DIRECTORY_EMERGENCY_CONTACT_REQUIRED_FIELDS':
      PersonalDirectoryErrorCode.emergencyContactRequiredFields,
  'MEMBER_DIRECTORY_OTHER_TITLE_REQUIRED':
      PersonalDirectoryErrorCode.otherTitleRequired,
  'MEMBER_DIRECTORY_OTHER_TITLE_FORBIDDEN':
      PersonalDirectoryErrorCode.otherTitleForbidden,
  'MEMBER_DIRECTORY_CONTACT_FIELDS_FORBIDDEN':
      PersonalDirectoryErrorCode.contactFieldsForbidden,
  'MEMBER_DIRECTORY_DETAILS_FORBIDDEN':
      PersonalDirectoryErrorCode.detailsForbidden,
  'MEMBER_DIRECTORY_INVALID_PHONE_NUMBER':
      PersonalDirectoryErrorCode.invalidPhoneNumber,
  'MEMBER_DIRECTORY_NOTE_TYPE_CONFLICT':
      PersonalDirectoryErrorCode.noteTypeConflict,
  'MEMBER_DIRECTORY_OTHER_NOTE_LIMIT_REACHED':
      PersonalDirectoryErrorCode.otherNoteLimitReached,
  'MEMBER_DIRECTORY_NOTE_NOT_FOUND':
      PersonalDirectoryErrorCode.noteNotFound,
  'MEMBER_DIRECTORY_NOTE_INVALID_PHOTO_PATH':
      PersonalDirectoryErrorCode.noteInvalidPhotoPath,
};
