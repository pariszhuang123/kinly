import 'package:kinly/contracts/time/timezone.dart';

import 'enums/house_directory_reminder_kind.dart';
import 'enums/house_directory_reminder_offset_unit.dart';
import 'enums/house_directory_reminder_status.dart';
import 'enums/house_directory_service_type.dart';

export 'enums/house_directory_reminder_kind.dart';
export 'enums/house_directory_reminder_offset_unit.dart';
export 'enums/house_directory_reminder_status.dart';
export 'enums/house_directory_service_type.dart';

class HouseDirectoryWifi {
  const HouseDirectoryWifi({
    required this.id,
    required this.homeId,
    required this.ssid,
    required this.qrPayload,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String homeId;
  final String ssid;
  final String qrPayload;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory HouseDirectoryWifi.fromJson(Map<String, dynamic> json) {
    return HouseDirectoryWifi(
      id: json['id'] as String? ?? '',
      homeId: json['home_id'] as String? ?? '',
      ssid: json['ssid'] as String? ?? '',
      qrPayload: json['qr_payload'] as String? ?? '',
      createdAt:
          parseTimestampToLocal(json['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
      updatedAt:
          parseTimestampToLocal(json['updated_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
    );
  }
}

class HouseDirectoryReminder {
  const HouseDirectoryReminder({
    required this.id,
    required this.serviceId,
    required this.kind,
    required this.status,
    required this.termStartDate,
    required this.termEndDate,
    required this.dueAt,
    required this.providerName,
    required this.serviceType,
    this.customLabel,
  });

  final String id;
  final String serviceId;
  final HouseDirectoryReminderKind kind;
  final HouseDirectoryReminderStatus status;
  final DateTime termStartDate;
  final DateTime termEndDate;
  final DateTime dueAt;
  final String providerName;
  final HouseDirectoryServiceType serviceType;
  final String? customLabel;

  factory HouseDirectoryReminder.fromJson(Map<String, dynamic> json) {
    return HouseDirectoryReminder(
      id: json['id'] as String? ?? '',
      serviceId: json['service_id'] as String? ?? '',
      kind: HouseDirectoryReminderKind.fromWire(
        json['reminder_kind'] as String?,
      ),
      status: HouseDirectoryReminderStatus.fromWire(json['status'] as String?),
      termStartDate:
          parseDateToLocal(json['term_start_date']) ??
          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
      termEndDate:
          parseDateToLocal(json['term_end_date']) ??
          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
      dueAt:
          parseDateToLocal(json['due_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
      providerName: json['provider_name'] as String? ?? '',
      serviceType: HouseDirectoryServiceType.fromWire(
        json['service_type'] as String?,
      ),
      customLabel: json['custom_label'] as String?,
    );
  }
}

class HouseDirectoryService {
  const HouseDirectoryService({
    required this.id,
    required this.homeId,
    required this.serviceType,
    required this.providerName,
    required this.createdAt,
    required this.updatedAt,
    this.customLabel,
    this.accountReference,
    this.linkUrl,
    this.termStartDate,
    this.termEndDate,
    this.renewalReminderOffsetValue,
    this.renewalReminderOffsetUnit,
    this.notes,
    this.reminder,
  });

  final String id;
  final String homeId;
  final HouseDirectoryServiceType serviceType;
  final String providerName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? customLabel;
  final String? accountReference;
  final String? linkUrl;
  final DateTime? termStartDate;
  final DateTime? termEndDate;
  final int? renewalReminderOffsetValue;
  final HouseDirectoryReminderOffsetUnit? renewalReminderOffsetUnit;
  final String? notes;
  final HouseDirectoryReminder? reminder;

  factory HouseDirectoryService.fromJson(Map<String, dynamic> json) {
    final reminderRaw = json['reminder'];
    return HouseDirectoryService(
      id: json['id'] as String? ?? '',
      homeId: json['home_id'] as String? ?? '',
      serviceType: HouseDirectoryServiceType.fromWire(
        json['service_type'] as String?,
      ),
      providerName: json['provider_name'] as String? ?? '',
      customLabel: json['custom_label'] as String?,
      accountReference: json['account_reference'] as String?,
      linkUrl: json['link_url'] as String?,
      termStartDate: parseDateToLocal(json['term_start_date']),
      termEndDate: parseDateToLocal(json['term_end_date']),
      renewalReminderOffsetValue:
          (json['renewal_reminder_offset_value'] as num?)?.toInt(),
      renewalReminderOffsetUnit:
          HouseDirectoryReminderOffsetUnit.fromWireNullable(
            json['renewal_reminder_offset_unit'] as String?,
          ),
      notes: json['notes'] as String?,
      createdAt:
          parseTimestampToLocal(json['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
      updatedAt:
          parseTimestampToLocal(json['updated_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
      reminder:
          reminderRaw is Map
              ? HouseDirectoryReminder.fromJson(
                reminderRaw.cast<String, dynamic>(),
              )
              : null,
    );
  }
}

class HouseDirectoryNote {
  const HouseDirectoryNote({
    required this.id,
    required this.homeId,
    required this.title,
    required this.details,
    required this.createdAt,
    required this.updatedAt,
    this.referenceUrl,
    this.photoPath,
  });

  final String id;
  final String homeId;
  final String title;
  final String details;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? referenceUrl;
  final String? photoPath;

  factory HouseDirectoryNote.fromJson(Map<String, dynamic> json) {
    return HouseDirectoryNote(
      id: json['id'] as String? ?? '',
      homeId: json['home_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      details: json['details'] as String? ?? '',
      referenceUrl: json['reference_url'] as String?,
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

class HouseDirectoryContent {
  const HouseDirectoryContent({
    required this.services,
    required this.notes,
  });

  final List<HouseDirectoryService> services;
  final List<HouseDirectoryNote> notes;

  factory HouseDirectoryContent.fromJson(Map<String, dynamic> json) {
    final servicesRaw = json['services'] as List? ?? const <dynamic>[];
    final notesRaw = json['notes'] as List? ?? const <dynamic>[];
    return HouseDirectoryContent(
      services:
          servicesRaw
              .whereType<Map>()
              .map((entry) => HouseDirectoryService.fromJson(
                entry.cast<String, dynamic>(),
              ))
              .toList(growable: false),
      notes:
          notesRaw
              .whereType<Map>()
              .map((entry) => HouseDirectoryNote.fromJson(
                entry.cast<String, dynamic>(),
              ))
              .toList(growable: false),
    );
  }
}

class UpsertHouseDirectoryWifiInput {
  const UpsertHouseDirectoryWifiInput({
    required this.homeId,
    required this.ssid,
    this.password,
  });

  final String homeId;
  final String ssid;
  final String? password;
}

class UpsertHouseDirectoryServiceInput {
  const UpsertHouseDirectoryServiceInput({
    required this.homeId,
    required this.serviceType,
    required this.providerName,
    this.serviceId,
    this.customLabel,
    this.accountReference,
    this.linkUrl,
    this.termStartDate,
    this.termEndDate,
    this.renewalReminderOffsetValue,
    this.renewalReminderOffsetUnit,
    this.notes,
  });

  final String homeId;
  final String? serviceId;
  final HouseDirectoryServiceType serviceType;
  final String providerName;
  final String? customLabel;
  final String? accountReference;
  final String? linkUrl;
  final DateTime? termStartDate;
  final DateTime? termEndDate;
  final int? renewalReminderOffsetValue;
  final HouseDirectoryReminderOffsetUnit? renewalReminderOffsetUnit;
  final String? notes;
}

class UpsertHouseDirectoryNoteInput {
  const UpsertHouseDirectoryNoteInput({
    required this.homeId,
    required this.title,
    required this.details,
    this.noteId,
    this.referenceUrl,
    this.photoPath,
  });

  final String homeId;
  final String? noteId;
  final String title;
  final String details;
  final String? referenceUrl;
  final String? photoPath;
}
