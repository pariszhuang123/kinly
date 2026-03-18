import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/contracts/personal_directory/ports/personal_directory_repository.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabasePersonalDirectoryRepository implements PersonalDirectoryRepository {
  SupabasePersonalDirectoryRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<PersonalDirectoryBankAccount?> getOwnBankAccount() async {
    try {
      final response = await _client.rpc('get_member_directory_bank_account');
      final map = _asMap(response);
      final bank = map['bank_account'];
      if (bank is! Map) return null;
      return PersonalDirectoryBankAccount.fromJson(bank.cast<String, dynamic>());
    } catch (error) {
      throw SupabaseErrorMapper.mapPersonalDirectory(error);
    }
  }

  @override
  Future<PersonalDirectoryBankAccount?> getMemberBankAccount({
    required String targetUserId,
  }) async {
    try {
      final response = await _client.rpc(
        'get_member_bank_account',
        params: {'p_target_user_id': targetUserId},
      );
      final map = _asMap(response);
      final bank = map['bank_account'];
      if (bank is! Map) return null;
      final merged = <String, dynamic>{
        ...bank.cast<String, dynamic>(),
        if (!bank.containsKey('created_at')) 'created_at': null,
        if (!bank.containsKey('updated_at')) 'updated_at': null,
      };
      return PersonalDirectoryBankAccount.fromJson(merged);
    } catch (error) {
      throw SupabaseErrorMapper.mapPersonalDirectory(error);
    }
  }

  @override
  Future<PersonalDirectoryBankAccount> upsertOwnBankAccount(
    UpsertPersonalDirectoryBankAccountInput input,
  ) async {
    try {
      final response = await _client.rpc(
        'upsert_member_directory_bank_account',
        params: {
          'p_account_holder_name': input.accountHolderName,
          'p_account_number': input.accountNumber,
        },
      );
      final map = _asMap(response);
      final bank = map['bank_account'];
      if (bank is! Map) {
        throw const FormatException('Missing bank account payload');
      }
      return PersonalDirectoryBankAccount.fromJson(bank.cast<String, dynamic>());
    } catch (error) {
      throw SupabaseErrorMapper.mapPersonalDirectory(error);
    }
  }

  @override
  Future<List<PersonalDirectoryNote>> getNotes({String? targetUserId}) async {
    try {
      final response = await _client.rpc(
        'get_member_directory_notes',
        params: {'p_target_user_id': targetUserId},
      );
      final map = _asMap(response);
      final rows = map['notes'] as List? ?? const <dynamic>[];
      return rows
          .whereType<Map>()
          .map(
            (entry) => PersonalDirectoryNote.fromJson(
              entry.cast<String, dynamic>(),
            ),
          )
          .toList(growable: false);
    } catch (error) {
      throw SupabaseErrorMapper.mapPersonalDirectory(error);
    }
  }

  @override
  Future<PersonalDirectoryNote> createNote(
    CreatePersonalDirectoryNoteInput input,
  ) async {
    try {
      final response = await _client.rpc(
        'create_member_directory_note',
        params: {
          'p_note_type': input.noteType.wireValue,
          'p_label': input.label,
          'p_custom_title': input.customTitle,
          'p_contact_name': input.contactName,
          'p_phone_number': input.phoneNumber,
          'p_details': input.details,
          'p_photo_path': input.photoPath,
        },
      );
      return _extractNote(response);
    } catch (error) {
      throw SupabaseErrorMapper.mapPersonalDirectory(error);
    }
  }

  @override
  Future<PersonalDirectoryNote> updateNote(
    UpdatePersonalDirectoryNoteInput input,
  ) async {
    try {
      final response = await _client.rpc(
        'update_member_directory_note',
        params: {
          'p_note_id': input.noteId,
          'p_label': input.label,
          'p_custom_title': input.customTitle,
          'p_contact_name': input.contactName,
          'p_phone_number': input.phoneNumber,
          'p_details': input.details,
          'p_photo_path': input.photoPath,
        },
      );
      return _extractNote(response);
    } catch (error) {
      throw SupabaseErrorMapper.mapPersonalDirectory(error);
    }
  }

  @override
  Future<void> archiveNote(String noteId) async {
    try {
      await _client.rpc(
        'archive_member_directory_note',
        params: {'p_note_id': noteId},
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapPersonalDirectory(error);
    }
  }

  @override
  Future<PersonalDirectoryNudge?> getNudge() async {
    try {
      final response = await _client.rpc('get_member_directory_nudge');
      final map = _asMap(response);
      if (map.isEmpty) return null;
      return PersonalDirectoryNudge.fromJson(map);
    } catch (error) {
      throw SupabaseErrorMapper.mapPersonalDirectory(error);
    }
  }

  @override
  Future<void> dismissNudge() async {
    try {
      await _client.rpc('dismiss_member_directory_nudge');
    } catch (error) {
      throw SupabaseErrorMapper.mapPersonalDirectory(error);
    }
  }

  PersonalDirectoryNote _extractNote(dynamic response) {
    final map = _asMap(response);
    final note = map['note'];
    if (note is! Map) {
      throw const FormatException('Missing note payload');
    }
    return PersonalDirectoryNote.fromJson(note.cast<String, dynamic>());
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.cast<String, dynamic>();
    return <String, dynamic>{};
  }
}
