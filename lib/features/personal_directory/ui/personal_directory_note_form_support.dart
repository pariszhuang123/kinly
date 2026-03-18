import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/generated/l10n.dart';

CreatePersonalDirectoryNoteInput buildCreatePersonalDirectoryNoteInput({
  required PersonalDirectoryNoteType noteType,
  required String title,
  required String contactName,
  required String phoneNumber,
  required String? details,
}) {
  return CreatePersonalDirectoryNoteInput(
    noteType: noteType,
    label: _allergyLabel(noteType, title),
    customTitle: _otherTitle(noteType, title),
    contactName: _emergencyContactName(noteType, contactName),
    phoneNumber: _emergencyPhoneNumber(noteType, phoneNumber),
    details: details,
  );
}

UpdatePersonalDirectoryNoteInput buildUpdatePersonalDirectoryNoteInput({
  required String noteId,
  required PersonalDirectoryNoteType noteType,
  required String title,
  required String contactName,
  required String phoneNumber,
  required String? details,
}) {
  return UpdatePersonalDirectoryNoteInput(
    noteId: noteId,
    label: _allergyLabel(noteType, title),
    customTitle: _otherTitle(noteType, title),
    contactName: _emergencyContactName(noteType, contactName),
    phoneNumber: _emergencyPhoneNumber(noteType, phoneNumber),
    details: details,
  );
}

bool isValidPersonalDirectoryNoteForm({
  required PersonalDirectoryNoteType noteType,
  required String title,
  required String contactName,
  required String phoneNumber,
  required String details,
  required bool Function(String value) isValidPhoneNumber,
}) {
  return switch (noteType) {
    PersonalDirectoryNoteType.emergencyContact => _isValidEmergencyContact(
      contactName: contactName,
      phoneNumber: phoneNumber,
      details: details,
      isValidPhoneNumber: isValidPhoneNumber,
    ),
    PersonalDirectoryNoteType.allergy => _isValidAllergy(
      title: title,
      details: details,
    ),
    PersonalDirectoryNoteType.other => _isValidOther(
      title: title,
      details: details,
    ),
  };
}

String? trimPersonalDirectoryNoteDetails({
  required bool showsDetailsField,
  required String details,
}) {
  if (!showsDetailsField) return null;
  final trimmed = details.trim();
  return trimmed.isEmpty ? null : trimmed;
}

bool _isValidEmergencyContact({
  required String contactName,
  required String phoneNumber,
  required String details,
  required bool Function(String value) isValidPhoneNumber,
}) {
  return contactName.isNotEmpty &&
      contactName.length <= 120 &&
      phoneNumber.isNotEmpty &&
      phoneNumber.length <= 30 &&
      isValidPhoneNumber(phoneNumber) &&
      details.length <= 2000;
}

bool _isValidAllergy({required String title, required String details}) {
  return title.isNotEmpty && title.length <= 120 && details.isEmpty;
}

bool _isValidOther({required String title, required String details}) {
  return title.isNotEmpty && title.length <= 80 && details.length <= 2000;
}

String? _allergyLabel(PersonalDirectoryNoteType noteType, String title) {
  if (noteType != PersonalDirectoryNoteType.allergy) return null;
  return title;
}

String? _otherTitle(PersonalDirectoryNoteType noteType, String title) {
  if (noteType != PersonalDirectoryNoteType.other) return null;
  return title;
}

String? _emergencyContactName(
  PersonalDirectoryNoteType noteType,
  String contactName,
) {
  if (noteType != PersonalDirectoryNoteType.emergencyContact) return null;
  return contactName;
}

String? _emergencyPhoneNumber(
  PersonalDirectoryNoteType noteType,
  String phoneNumber,
) {
  if (noteType != PersonalDirectoryNoteType.emergencyContact) return null;
  return phoneNumber;
}

String existingPersonalDirectoryNoteTitle({
  required PersonalDirectoryNote? note,
  required S s,
}) {
  if (note == null) return s.personalDirectoryNotesTitle;
  return switch (note.noteType) {
    PersonalDirectoryNoteType.emergencyContact =>
      note.contactName ??
          note.customTitle ??
          note.label ??
          s.personalDirectoryNotesTitle,
    PersonalDirectoryNoteType.allergy => note.label ?? s.personalDirectoryNotesTitle,
    PersonalDirectoryNoteType.other =>
      note.customTitle ?? s.personalDirectoryNotesTitle,
  };
}

String personalDirectoryNoteTypeLabel(
  PersonalDirectoryNoteType noteType,
  S s,
) {
  return switch (noteType) {
    PersonalDirectoryNoteType.emergencyContact =>
      s.personalDirectoryEmergencyContactTitle,
    PersonalDirectoryNoteType.allergy => s.personalDirectoryAllergyTitle,
    PersonalDirectoryNoteType.other => s.personalDirectoryOtherTitle,
  };
}

String personalDirectoryNoteTypeDescription(
  PersonalDirectoryNoteType noteType,
  S s,
) {
  return switch (noteType) {
    PersonalDirectoryNoteType.emergencyContact =>
      s.personalDirectoryEmergencyContactHelp,
    PersonalDirectoryNoteType.allergy => s.personalDirectoryAllergyTypeHelp,
    PersonalDirectoryNoteType.other => s.personalDirectoryOtherTypeHelp,
  };
}
