import 'package:kinly/contracts/house_directory/house_directory_photo_capture.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/contracts/house_directory/ports/house_directory_repository.dart';
import 'package:kinly/core/media/expectation_photo_service.dart';
import 'package:kinly/core/media/supabase_media_repository.dart';
import 'package:kinly/core/supabase/storage_path_resolver.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHouseDirectoryRepository implements HouseDirectoryRepository {
  SupabaseHouseDirectoryRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client,
      _storagePathResolver = StoragePathResolver(client: client),
      _photoService = ExpectationPhotoService(
        mediaRepository: SupabaseMediaRepository(client: client),
      );

  final SupabaseClient _client;
  final StoragePathResolver _storagePathResolver;
  final ExpectationPhotoService _photoService;

  @override
  Future<HouseDirectoryWifi?> getWifi({required String homeId}) async {
    try {
      final response = await _client.rpc(
        'get_home_directory_wifi',
        params: {'p_home_id': homeId},
      );
      final map = _asMap(response);
      final wifi = map['wifi'];
      if (wifi is! Map) return null;
      return HouseDirectoryWifi.fromJson(wifi.cast<String, dynamic>());
    } catch (error) {
      throw SupabaseErrorMapper.mapHouseDirectory(error);
    }
  }

  @override
  Future<HouseDirectoryWifi> upsertWifi(UpsertHouseDirectoryWifiInput input) async {
    try {
      final response = await _client.rpc(
        'upsert_home_directory_wifi',
        params: {
          'p_home_id': input.homeId,
          'p_ssid': input.ssid,
          'p_password': input.password,
        },
      );
      final map = _asMap(response);
      final wifi = map['wifi'];
      if (wifi is! Map) {
        throw const FormatException('Missing wifi payload');
      }
      return HouseDirectoryWifi.fromJson(wifi.cast<String, dynamic>());
    } catch (error) {
      throw SupabaseErrorMapper.mapHouseDirectory(error);
    }
  }

  @override
  Future<HouseDirectoryContent> getContent({required String homeId}) async {
    try {
      final response = await _client.rpc(
        'get_home_directory_content',
        params: {'p_home_id': homeId},
      );
      return HouseDirectoryContent.fromJson(_asMap(response));
    } catch (error) {
      throw SupabaseErrorMapper.mapHouseDirectory(error);
    }
  }

  @override
  Future<List<HouseDirectoryMemberCard>> getMemberCards() async {
    try {
      final response = await _client.rpc('get_home_directory_member_cards');
      final map = _asMap(response);
      final rows = map['members'] as List? ?? const <dynamic>[];
      return rows
          .whereType<Map>()
          .map((entry) {
            final json = entry.cast<String, dynamic>();
            final avatarStoragePath = json['avatar_storage_path'] as String?;
            return HouseDirectoryMemberCard.fromJson({
              ...json,
              'avatar_url': _storagePathResolver.toPublicUrl(avatarStoragePath),
            });
          })
          .toList(growable: false);
    } catch (error) {
      throw SupabaseErrorMapper.mapHouseDirectory(error);
    }
  }

  @override
  Future<HouseDirectoryService> upsertService(
    UpsertHouseDirectoryServiceInput input,
  ) async {
    try {
      final response = await _client.rpc(
        'upsert_home_directory_service',
        params: {
          'p_home_id': input.homeId,
          'p_service_id': input.serviceId,
          'p_service_type': input.serviceType.wireValue,
          'p_custom_label': input.customLabel,
          'p_provider_name': input.providerName,
          'p_account_reference': input.accountReference,
          'p_link_url': input.linkUrl,
          'p_term_start_date': _date(input.termStartDate),
          'p_term_end_date': _date(input.termEndDate),
          'p_renewal_reminder_offset_value': input.renewalReminderOffsetValue,
          'p_renewal_reminder_offset_unit':
              input.renewalReminderOffsetUnit?.wireValue,
          'p_notes': input.notes,
        },
      );
      final map = _asMap(response);
      final service = map['service'];
      if (service is! Map) {
        throw const FormatException('Missing service payload');
      }
      final combined = service.cast<String, dynamic>();
      final reminder = map['reminder'];
      if (reminder is Map) {
        combined['reminder'] = reminder.cast<String, dynamic>();
      }
      return HouseDirectoryService.fromJson(combined);
    } catch (error) {
      throw SupabaseErrorMapper.mapHouseDirectory(error);
    }
  }

  @override
  Future<void> archiveService({
    required String homeId,
    required String serviceId,
  }) async {
    try {
      await _client.rpc(
        'archive_home_directory_service',
        params: {'p_home_id': homeId, 'p_service_id': serviceId},
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapHouseDirectory(error);
    }
  }

  @override
  Future<HouseDirectoryNote> upsertNote(UpsertHouseDirectoryNoteInput input) async {
    try {
      final response = await _client.rpc(
        'upsert_home_directory_note',
        params: {
          'p_home_id': input.homeId,
          'p_note_id': input.noteId,
          'p_title': input.title,
          'p_details': input.details,
          'p_reference_url': input.referenceUrl,
          'p_photo_path': input.photoPath,
        },
      );
      final map = _asMap(response);
      final note = map['note'];
      if (note is! Map) {
        throw const FormatException('Missing note payload');
      }
      return HouseDirectoryNote.fromJson(note.cast<String, dynamic>());
    } catch (error) {
      throw SupabaseErrorMapper.mapHouseDirectory(error);
    }
  }

  @override
  Future<void> archiveNote({
    required String homeId,
    required String noteId,
  }) async {
    try {
      await _client.rpc(
        'archive_home_directory_note',
        params: {'p_home_id': homeId, 'p_note_id': noteId},
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapHouseDirectory(error);
    }
  }

  @override
  Future<String?> captureAndUploadNotePhoto({required String homeId}) async {
    try {
      final upload = await _photoService.captureAndUpload(
        homeId: homeId,
        rootSegment: 'house_directory',
        featureSegment: 'notes',
      );
      return _withHouseholdsPrefix(upload.storagePath);
    } on CameraPermissionException catch (error) {
      throw HouseDirectoryPhotoCaptureException(
        kind: HouseDirectoryPhotoCaptureErrorKind.permission,
        message: 'Camera permission is required to add a note photo.',
        permanentlyDenied: error.permanentlyDenied,
      );
    } on CameraCaptureCancelled {
      return null;
    } catch (_) {
      throw const HouseDirectoryPhotoCaptureException(
        kind: HouseDirectoryPhotoCaptureErrorKind.upload,
        message: 'Could not upload the note photo.',
      );
    }
  }

  @override
  String? toPublicPhotoUrl(String? photoPath) {
    return _storagePathResolver.toPublicUrl(photoPath);
  }

  @override
  Future<List<HouseDirectoryReminder>> listDueReminders({
    required String homeId,
  }) async {
    try {
      final response = await _client.rpc(
        'list_due_home_directory_reminders',
        params: {'p_home_id': homeId},
      );
      final map = _asMap(response);
      final rows = map['due_reminders'] as List? ?? const <dynamic>[];
      return rows
          .whereType<Map>()
          .map((entry) => HouseDirectoryReminder.fromJson(
            entry.cast<String, dynamic>(),
          ))
          .toList(growable: false);
    } catch (error) {
      throw SupabaseErrorMapper.mapHouseDirectory(error);
    }
  }

  @override
  Future<void> acknowledgeReminder({
    required String homeId,
    required String reminderId,
  }) async {
    try {
      await _client.rpc(
        'acknowledge_home_directory_reminder',
        params: {'p_home_id': homeId, 'p_reminder_id': reminderId},
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapHouseDirectory(error);
    }
  }

  @override
  Future<void> dismissReminder({
    required String homeId,
    required String reminderId,
  }) async {
    try {
      await _client.rpc(
        'dismiss_home_directory_reminder',
        params: {'p_home_id': homeId, 'p_reminder_id': reminderId},
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapHouseDirectory(error);
    }
  }

  Map<String, dynamic> _asMap(dynamic response) {
    return response is Map ? response.cast<String, dynamic>() : <String, dynamic>{};
  }

  String? _date(DateTime? value) {
    if (value == null) return null;
    final year = value.year.toString().padLeft(4, '0');
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static String _withHouseholdsPrefix(String path) {
    final trimmed = path.trim();
    if (trimmed.startsWith('households/')) return trimmed;
    return 'households/$trimmed';
  }
}
