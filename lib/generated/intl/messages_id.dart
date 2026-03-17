// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a id locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'id';

  static String m0(env) => "Memulai Kinly (${env})";

  static String m1(time) => "Dijadwalkan pada ${time}";

  static String m2(current) => "Akses demo: ${current} dari 7 ketukan";

  static String m3(appName) =>
      "Dibuat dengan ${appName} - Bersama terasa lebih ringan";

  static String m4(link) =>
      "Beberapa ucapan terima kasih dari rumah Kinly kami. Unduh aplikasinya: ${link}";

  static String m5(weeks) =>
      "${Intl.plural(weeks, zero: 'Minggu ini', one: '# minggu lalu', other: '# minggu lalu')}";

  static String m6(partOfDay, name) => "Selamat ${partOfDay}, ${name}";

  static String m7(answered, total) =>
      "Berdasarkan ${answered} dari ${total} anggota";

  static String m30(start, end) => "${start} sampai ${end}";

  static String m8(current, total) => "${current}/${total}";

  static String m9(link) =>
      "Membagikan pulse rumah Kinly kami. Unduh aplikasinya: ${link}";

  static String m10(date) => "Diperbarui ${date}";

  static String m11(link) =>
      "Membagikan suasana rumah Kinly kami. Unduh aplikasinya: ${link}";

  static String m12(link) =>
      "Buat hidup bersama lebih mudah dengan Kinly: ${link}";

  static String m13(code, link) =>
      "Gabung ke rumah Kinly kami dengan kode undangan ini: ${code}\n\nUnduh Kinly: ${link}";

  static String m14(code) => "Berhasil bergabung ke rumahmu.";

  static String m15(price) => "${price} per bulan";

  static String m16(current, total) => "${current}/${total}";

  static String m17(period) => "Berlaku untuk ${period}";

  static String m18(total, included, difference) =>
      "Pembagian tidak cocok. Total: ${total}. Termasuk: ${included}. Selisih: ${difference}.";

  static String m19(paidAmount, totalAmount) =>
      "${paidAmount} dari ${totalAmount} sudah terkumpul";

  static String m20(paid, total) => "${paid} dari ${total} sudah dibayar";

  static String m21(count) =>
      "${Intl.plural(count, one: '${count} item untuk dibeli', other: '${count} item untuk dibeli')}";

  static String m22(name) => "Hai ${name}";

  static String m23(count) =>
      "Lihat semua ${Intl.plural(count, one: '(#)', other: '(#)')}";

  static String m31(date) => "Pengingat untuk ${date}";

  static String m24(name) => "Tidak dapat menyelesaikan permintaan ${name}.";

  static String m25(name) => "${name} bergabung ke rumahmu.";

  static String m26(name) => "${name} bergabung ke rumah lain.";

  static String m27(names) =>
      "${names} ingin bergabung ke rumahmu. Upgrade untuk anggota tanpa batas.";

  static String m28(count) =>
      "${Intl.plural(count, one: '${count} pembayaran menunggu', other: '${count} untuk diselesaikan')}";

  static String m29(count) =>
      "${Intl.plural(count, one: '${count} pembayaran baru untukmu', other: '${count} pembayaran baru untukmu')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("Kinly"),
    "authMembershipLoadFailed": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat ulang keanggotaan rumahmu.",
    ),
    "bootstrap_initializing": m0,
    "close": MessageLookupByLibrary.simpleMessage("Tutup"),
    "connectionNotificationsPermissionBlocked":
        MessageLookupByLibrary.simpleMessage(
          "Aktifkan notifikasi di pengaturan ponselmu terlebih dahulu.",
        ),
    "connectionNotificationsTimeLabel": MessageLookupByLibrary.simpleMessage(
      "Waktu pengingat",
    ),
    "connectionNotificationsTimeSubtitle": m1,
    "connectionNotificationsToggleSubtitleOff":
        MessageLookupByLibrary.simpleMessage(
          "Aktifkan pengingat untuk rumahmu.",
        ),
    "connectionNotificationsToggleSubtitleOn":
        MessageLookupByLibrary.simpleMessage(
          "Dapatkan satu pengingat setiap hari.",
        ),
    "connectionNotificationsToggleTitle": MessageLookupByLibrary.simpleMessage(
      "Pengingat harian",
    ),
    "connectionSettingsGenericError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memperbarui pengaturan notifikasi.",
    ),
    "connectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Atur pengingat harian dan waktunya.",
    ),
    "connectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Notifikasi",
    ),
    "create_failed_generic": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat membuat rumah.",
    ),
    "demoAccess": MessageLookupByLibrary.simpleMessage("Akses Demo"),
    "demoAccessEmail": MessageLookupByLibrary.simpleMessage("Email"),
    "demoAccessError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat masuk. Periksa kredensialmu.",
    ),
    "demoAccessPassword": MessageLookupByLibrary.simpleMessage("Kata sandi"),
    "demoAccessSubmit": MessageLookupByLibrary.simpleMessage("Masuk"),
    "demoAccessTapHint": m2,
    "exploreFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "Lihat apa yang perlu dilakukan dan siapa yang melakukannya.",
    ),
    "exploreIntroSubtitle": MessageLookupByLibrary.simpleMessage(
      "Jaga hal-hal bersama tetap jelas.",
    ),
    "exploreShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "Lihat semua tagihan yang kamu buat dan pantau penagihan.",
    ),
    "exploreShoppingSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Daftar belanja",
    ),
    "exploreShoppingSubtitle": MessageLookupByLibrary.simpleMessage(
      "Lihat dan kelola item belanja bersama.",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage(
      "Siapa yang mengerjakan ini?",
    ),
    "flowChoreCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "Tugas dibuat.",
    ),
    "flowChoreCreateTitle": MessageLookupByLibrary.simpleMessage(
      "Tambah Tugas",
    ),
    "flowChoreDeleteButton": MessageLookupByLibrary.simpleMessage(
      "Hapus Tugas",
    ),
    "flowChoreDeleteConfirm": MessageLookupByLibrary.simpleMessage("Hapus"),
    "flowChoreDeleteDialogMessage": MessageLookupByLibrary.simpleMessage(
      "Ini akan menghapus tugas untuk semua orang di rumahmu.",
    ),
    "flowChoreDeleteDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Hapus tugas ini?",
    ),
    "flowChoreDetailCompleteButton": MessageLookupByLibrary.simpleMessage(
      "Tandai selesai",
    ),
    "flowChoreDetailCompletionError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat menyelesaikan tugas ini.",
    ),
    "flowChoreDetailCompletionSuccess": MessageLookupByLibrary.simpleMessage(
      "Tugas selesai.",
    ),
    "flowChoreDetailMoreInfoTitle": MessageLookupByLibrary.simpleMessage(
      "Detail tambahan",
    ),
    "flowChoreDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Detail tugas",
    ),
    "flowChoreDetailUnassigned": MessageLookupByLibrary.simpleMessage(
      "Belum ditugaskan",
    ),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage("Edit Tugas"),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "Orang itu bukan bagian dari rumah ini saat ini.",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "Kamu tidak punya izin untuk mengubah tugas ini.",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat menyimpan tugas ini.",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "Foto itu bukan milik rumah ini.",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "Pilih tanggal mulai yang valid.",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "Tugas ini tidak dapat diedit saat ini.",
    ),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "Kamu sudah mencapai batas gratis untuk tugas aktif. Upgrade untuk lebih banyak.",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "Kamu sudah mencapai batas gratis untuk foto tugas. Upgrade untuk lebih banyak.",
    ),
    "flowChoreExpectationPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Foto referensi",
    ),
    "flowChoreHowToHint": MessageLookupByLibrary.simpleMessage(
      "Tambahkan tautan jika ada cara tertentu",
    ),
    "flowChoreHowToLabel": MessageLookupByLibrary.simpleMessage(
      "Cara melakukannya (opsional)",
    ),
    "flowChoreHowToLaunchError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat membuka tautan itu.",
    ),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat tugas ini.",
    ),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage(
      "mis. malam buang sampah, bersihkan kulkas, siram tanaman",
    ),
    "flowChoreNameLabel": MessageLookupByLibrary.simpleMessage(
      "Apa yang perlu dilakukan?",
    ),
    "flowChoreNotesHint": MessageLookupByLibrary.simpleMessage(
      "Apa pun yang membantu orang lain melakukannya",
    ),
    "flowChoreNotesLabel": MessageLookupByLibrary.simpleMessage(
      "Kenapa ini penting",
    ),
    "flowChorePhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Seperti apa hasil yang baik",
    ),
    "flowChorePhotoLoadError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat foto.",
    ),
    "flowChorePhotoPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "Izinkan akses kamera untuk mengambil foto.",
    ),
    "flowChorePhotoPermissionOpenSettings":
        MessageLookupByLibrary.simpleMessage("Buka pengaturan"),
    "flowChorePhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Tambahkan foto agar semua tetap selaras",
    ),
    "flowChorePhotoUploadError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat mengunggah foto.",
    ),
    "flowChoreRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "Seberapa sering ini terjadi?",
    ),
    "flowChoreRecurrenceNone": MessageLookupByLibrary.simpleMessage(
      "Satu kali",
    ),
    "flowChoreRetry": MessageLookupByLibrary.simpleMessage("Coba lagi"),
    "flowChoreStartLabel": MessageLookupByLibrary.simpleMessage(
      "Kapan ini akan dilakukan?",
    ),
    "flowChoreSubmitCreate": MessageLookupByLibrary.simpleMessage("Buat tugas"),
    "flowChoreSubmitUpdate": MessageLookupByLibrary.simpleMessage(
      "Simpan perubahan",
    ),
    "flowChoreUpdateSuccess": MessageLookupByLibrary.simpleMessage(
      "Tugas diperbarui.",
    ),
    "flowChoreValidationAssignee": MessageLookupByLibrary.simpleMessage(
      "Pilih seseorang.",
    ),
    "flowChoreValidationDate": MessageLookupByLibrary.simpleMessage(
      "Pilih tanggal dalam satu tahun ke depan.",
    ),
    "flowChoreValidationHowToUrl": MessageLookupByLibrary.simpleMessage(
      "Masukkan tautan valid yang dimulai dengan http atau https.",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage(
      "Masukkan nama tugas.",
    ),
    "flowChoreViewTitle": MessageLookupByLibrary.simpleMessage("Lihat Tugas"),
    "flowListDraftLabel": MessageLookupByLibrary.simpleMessage("Draf"),
    "flowListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Tugas membantu semua orang tetap selaras.",
    ),
    "flowListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Belum ada apa-apa di sini",
    ),
    "flowListError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat tugas. Tarik untuk menyegarkan.",
    ),
    "flowListOverdueLabel": MessageLookupByLibrary.simpleMessage(
      "Perlu perhatian",
    ),
    "flowListTabCurrent": MessageLookupByLibrary.simpleMessage("Saat ini"),
    "flowListTabFuture": MessageLookupByLibrary.simpleMessage("Akan datang"),
    "force_update_body": MessageLookupByLibrary.simpleMessage(
      "Versi Kinly ini sudah tidak didukung. Perbarui untuk melanjutkan.",
    ),
    "force_update_button": MessageLookupByLibrary.simpleMessage(
      "Perbarui Kinly",
    ),
    "force_update_title": MessageLookupByLibrary.simpleMessage(
      "Pembaruan diperlukan",
    ),
    "friendDefaultName": MessageLookupByLibrary.simpleMessage("teman"),
    "gratitudeWallEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Tambahkan ucapan terima kasih dari minggu ini.",
    ),
    "gratitudeWallEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Belum ada ucapan terima kasih",
    ),
    "gratitudeWallErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat ucapan terima kasih saat ini.",
    ),
    "gratitudeWallFooter": m3,
    "gratitudeWallHouseTab": MessageLookupByLibrary.simpleMessage("Rumah"),
    "gratitudeWallPersonalSummary": MessageLookupByLibrary.simpleMessage(
      "Tempat pribadi untuk ucapan terima kasih singkat.",
    ),
    "gratitudeWallPersonalTab": MessageLookupByLibrary.simpleMessage(
      "Milik saya",
    ),
    "gratitudeWallPersonalTitle": MessageLookupByLibrary.simpleMessage(
      "Ucapan Terima Kasih Saya",
    ),
    "gratitudeWallRetry": MessageLookupByLibrary.simpleMessage("Coba lagi"),
    "gratitudeWallShareCta": MessageLookupByLibrary.simpleMessage("Bagikan"),
    "gratitudeWallShareError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat membagikan sekarang.",
    ),
    "gratitudeWallShareMessage": m4,
    "gratitudeWallShareTitle": MessageLookupByLibrary.simpleMessage(
      "Ucapan terima kasih rumah",
    ),
    "gratitudeWallStatsHomes": MessageLookupByLibrary.simpleMessage("Rumah"),
    "gratitudeWallStatsMentions": MessageLookupByLibrary.simpleMessage(
      "Ucapan terima kasih",
    ),
    "gratitudeWallStatsPeople": MessageLookupByLibrary.simpleMessage("Orang"),
    "gratitudeWallWeeksAgo": m5,
    "greetingPartOfDay": m6,
    "harmonyCommentHint": MessageLookupByLibrary.simpleMessage(
      "Tambahkan konteks jika membantu",
    ),
    "harmonyCommentLabel": MessageLookupByLibrary.simpleMessage(
      "Catatan opsional",
    ),
    "harmonyErrorAlreadySubmitted": MessageLookupByLibrary.simpleMessage(
      "Kamu sudah mengirim minggu ini.",
    ),
    "harmonyErrorCommentRequiredForMention":
        MessageLookupByLibrary.simpleMessage(
          "Tambahkan catatan singkat sebelum mengirim sebutan ini.",
        ),
    "harmonyErrorCommentRequiredForPublicWall":
        MessageLookupByLibrary.simpleMessage(
          "Tambahkan catatan singkat sebelum memposting ucapan terima kasih ini.",
        ),
    "harmonyErrorComplaintNeedsSentence": MessageLookupByLibrary.simpleMessage(
      "Tambahkan kalimat yang jelas.",
    ),
    "harmonyErrorComplaintTooBrief": MessageLookupByLibrary.simpleMessage(
      "Tulis kalimat singkat agar jelas.",
    ),
    "harmonyErrorComplaintTooShort": MessageLookupByLibrary.simpleMessage(
      "Tambahkan sedikit detail lagi.",
    ),
    "harmonyErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "Umpan balik mingguan tidak tersedia saat ini.",
    ),
    "harmonyErrorSingleMentionRequired": MessageLookupByLibrary.simpleMessage(
      "Pilih satu orang untuk catatan ini.",
    ),
    "harmonyErrorUnknown": MessageLookupByLibrary.simpleMessage(
      "Terjadi kesalahan.",
    ),
    "harmonyFeedbackSingleHousemateHint": MessageLookupByLibrary.simpleMessage(
      "Ketik @ untuk menyebut 1 teman serumah.",
    ),
    "harmonyMoodCloudy": MessageLookupByLibrary.simpleMessage("Berawan"),
    "harmonyMoodPartiallySunny": MessageLookupByLibrary.simpleMessage(
      "Cerah sebagian",
    ),
    "harmonyMoodRainy": MessageLookupByLibrary.simpleMessage("Hujan"),
    "harmonyMoodSunny": MessageLookupByLibrary.simpleMessage("Cerah"),
    "harmonyMoodThunderstorm": MessageLookupByLibrary.simpleMessage(
      "Badai petir",
    ),
    "harmonyQuestion": MessageLookupByLibrary.simpleMessage(
      "Apa yang berjalan baik atau perlu disesuaikan minggu ini?",
    ),
    "harmonyShareLabel": MessageLookupByLibrary.simpleMessage(
      "Terlihat oleh semua orang di rumah",
    ),
    "harmonySubmitCta": MessageLookupByLibrary.simpleMessage("Simpan"),
    "harmonySubmitSuccess": MessageLookupByLibrary.simpleMessage("Tersimpan"),
    "homeVibeCoverage": m7,
    "homeVibeTitle": MessageLookupByLibrary.simpleMessage("Suasana Rumah"),
    "houseDirectoryAccountReferenceHint": MessageLookupByLibrary.simpleMessage(
      "Tambahkan nomor akun atau ID pelanggan",
    ),
    "houseDirectoryAccountReferenceLabel": MessageLookupByLibrary.simpleMessage(
      "Referensi akun",
    ),
    "houseDirectoryActionFailed": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat menyimpan perubahan itu.",
    ),
    "houseDirectoryAddNote": MessageLookupByLibrary.simpleMessage(
      "Tambah catatan",
    ),
    "houseDirectoryAddService": MessageLookupByLibrary.simpleMessage(
      "Tambah layanan",
    ),
    "houseDirectoryAddWifi": MessageLookupByLibrary.simpleMessage(
      "Tambah wifi",
    ),
    "houseDirectoryArchiveConfirm": MessageLookupByLibrary.simpleMessage(
      "Arsipkan",
    ),
    "houseDirectoryArchiveNoteBody": MessageLookupByLibrary.simpleMessage(
      "Ini akan menghapusnya dari tampilan Direktori rumahmu.",
    ),
    "houseDirectoryArchiveNoteTitle": MessageLookupByLibrary.simpleMessage(
      "Arsipkan catatan ini?",
    ),
    "houseDirectoryArchiveServiceBody": MessageLookupByLibrary.simpleMessage(
      "Ini akan menghapusnya dari tampilan Direktori rumahmu.",
    ),
    "houseDirectoryArchiveServiceTitle": MessageLookupByLibrary.simpleMessage(
      "Arsipkan layanan ini?",
    ),
    "houseDirectoryCustomLabel": MessageLookupByLibrary.simpleMessage(
      "Label khusus",
    ),
    "houseDirectoryCustomLabelHint": MessageLookupByLibrary.simpleMessage(
      "Gunakan nama yang jelas seperti pembersih, parkir, atau penyimpanan",
    ),
    "houseDirectoryDateUnknown": MessageLookupByLibrary.simpleMessage(
      "Tidak diketahui",
    ),
    "houseDirectoryDelete": MessageLookupByLibrary.simpleMessage("Arsipkan"),
    "houseDirectoryEdit": MessageLookupByLibrary.simpleMessage("Edit"),
    "houseDirectoryEditNote": MessageLookupByLibrary.simpleMessage(
      "Edit catatan",
    ),
    "houseDirectoryEditService": MessageLookupByLibrary.simpleMessage(
      "Edit layanan",
    ),
    "houseDirectoryEditWifi": MessageLookupByLibrary.simpleMessage("Edit wifi"),
    "houseDirectoryEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Simpan wifi, sewa, layanan, dan catatan rumah di sini.",
    ),
    "houseDirectoryEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Detail rumah bersama ada di sini.",
    ),
    "houseDirectoryEndDate": MessageLookupByLibrary.simpleMessage(
      "Tanggal berakhir",
    ),
    "houseDirectoryLinkLabel": MessageLookupByLibrary.simpleMessage(
      "Tautan penyedia",
    ),
    "houseDirectoryLoadError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat Direktori rumah.",
    ),
    "houseDirectoryNoteArchived": MessageLookupByLibrary.simpleMessage(
      "Catatan diarsipkan.",
    ),
    "houseDirectoryNoteDetailsHint": MessageLookupByLibrary.simpleMessage(
      "Tambahkan detail yang jelas untuk rumah",
    ),
    "houseDirectoryNoteDetailsLabel": MessageLookupByLibrary.simpleMessage(
      "Detail",
    ),
    "houseDirectoryNotePhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Foto",
    ),
    "houseDirectoryNotePhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Tambahkan foto untuk catatan ini",
    ),
    "houseDirectoryNotePhotoReplaceLabel": MessageLookupByLibrary.simpleMessage(
      "Ganti foto",
    ),
    "houseDirectoryNotePhotoUploadError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat mengunggah foto itu.",
    ),
    "houseDirectoryNoteSaved": MessageLookupByLibrary.simpleMessage(
      "Catatan tersimpan.",
    ),
    "houseDirectoryNoteTitleHint": MessageLookupByLibrary.simpleMessage(
      "Beri nama catatan agar semua orang tahu isinya",
    ),
    "houseDirectoryNoteUrlHint": MessageLookupByLibrary.simpleMessage(
      "Opsional. Tempel alamat web terkait jika catatan ini mengarah ke sana",
    ),
    "houseDirectoryNoteUrlLabel": MessageLookupByLibrary.simpleMessage(
      "URL referensi",
    ),
    "houseDirectoryNotes": MessageLookupByLibrary.simpleMessage("Catatan"),
    "houseDirectoryNotesEmpty": MessageLookupByLibrary.simpleMessage(
      "Belum ada catatan ditambahkan.",
    ),
    "houseDirectoryNotesHint": MessageLookupByLibrary.simpleMessage(
      "Tambahkan detail yang membantu, seperti tanggal tagihan atau langkah menghubungi",
    ),
    "houseDirectoryNotesSearchEmpty": MessageLookupByLibrary.simpleMessage(
      "Tidak ada catatan yang cocok dengan pencarian itu.",
    ),
    "houseDirectoryNotesTitle": MessageLookupByLibrary.simpleMessage(
      "Catatan rumah",
    ),
    "houseDirectoryOpenLink": MessageLookupByLibrary.simpleMessage(
      "Buka tautan",
    ),
    "houseDirectoryOpenLinkError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat membuka tautan itu.",
    ),
    "houseDirectoryPasswordHelper": MessageLookupByLibrary.simpleMessage(
      "Biarkan kosong untuk menyimpan sebagai jaringan terbuka.",
    ),
    "houseDirectoryPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "Kata sandi",
    ),
    "houseDirectoryPhotoViewerTitle": MessageLookupByLibrary.simpleMessage(
      "Foto",
    ),
    "houseDirectoryProviderHint": MessageLookupByLibrary.simpleMessage(
      "Siapa yang menjalankan layanan ini, misalnya perusahaan listrikmu",
    ),
    "houseDirectoryProviderLabel": MessageLookupByLibrary.simpleMessage(
      "Nama penyedia",
    ),
    "houseDirectoryProviderLinkHint": MessageLookupByLibrary.simpleMessage(
      "Tempel tautan login, portal, atau pembayaran untuk layanan ini",
    ),
    "houseDirectoryReminderAcknowledged": MessageLookupByLibrary.simpleMessage(
      "Pengingat dikonfirmasi.",
    ),
    "houseDirectoryReminderDismissed": MessageLookupByLibrary.simpleMessage(
      "Pengingat ditutup.",
    ),
    "houseDirectoryReminderOffset": MessageLookupByLibrary.simpleMessage(
      "Jeda pengingat",
    ),
    "houseDirectoryReminderOffsetUnit": MessageLookupByLibrary.simpleMessage(
      "Satuan jeda",
    ),
    "houseDirectoryRentTitle": MessageLookupByLibrary.simpleMessage("Sewa"),
    "houseDirectorySave": MessageLookupByLibrary.simpleMessage("Simpan"),
    "houseDirectorySearchHint": MessageLookupByLibrary.simpleMessage(
      "Temukan layanan atau catatan",
    ),
    "houseDirectorySearchLabel": MessageLookupByLibrary.simpleMessage(
      "Cari detail rumah",
    ),
    "houseDirectoryServiceArchived": MessageLookupByLibrary.simpleMessage(
      "Layanan diarsipkan.",
    ),
    "houseDirectoryServiceOther": MessageLookupByLibrary.simpleMessage(
      "Lainnya",
    ),
    "houseDirectoryServiceSaved": MessageLookupByLibrary.simpleMessage(
      "Layanan tersimpan.",
    ),
    "houseDirectoryServiceTypeLabel": MessageLookupByLibrary.simpleMessage(
      "Jenis layanan",
    ),
    "houseDirectoryServicesEmpty": MessageLookupByLibrary.simpleMessage(
      "Belum ada layanan ditambahkan.",
    ),
    "houseDirectoryServicesSearchEmpty": MessageLookupByLibrary.simpleMessage(
      "Tidak ada layanan yang cocok dengan pencarian itu.",
    ),
    "houseDirectoryServicesTitle": MessageLookupByLibrary.simpleMessage(
      "Utilitas dan layanan",
    ),
    "houseDirectorySsidLabel": MessageLookupByLibrary.simpleMessage("SSID"),
    "houseDirectoryStartDate": MessageLookupByLibrary.simpleMessage(
      "Tanggal mulai",
    ),
    "houseDirectoryTermLabel": MessageLookupByLibrary.simpleMessage(
      "Masa berlaku",
    ),
    "houseDirectoryTermRange": m30,
    "houseDirectoryTitle": MessageLookupByLibrary.simpleMessage(
      "Direktori rumah",
    ),
    "houseDirectoryTitleLabel": MessageLookupByLibrary.simpleMessage("Judul"),
    "houseDirectoryValidationCustomLabel": MessageLookupByLibrary.simpleMessage(
      "Masukkan label khusus.",
    ),
    "houseDirectoryValidationDateRange": MessageLookupByLibrary.simpleMessage(
      "Pilih tanggal akhir setelah tanggal mulai.",
    ),
    "houseDirectoryValidationNoteFields": MessageLookupByLibrary.simpleMessage(
      "Masukkan judul dan detail.",
    ),
    "houseDirectoryValidationProvider": MessageLookupByLibrary.simpleMessage(
      "Masukkan nama penyedia.",
    ),
    "houseDirectoryValidationReminderOffset":
        MessageLookupByLibrary.simpleMessage(
          "Masukkan jeda pengingat yang valid.",
        ),
    "houseDirectoryValidationRentDates": MessageLookupByLibrary.simpleMessage(
      "Sewa memerlukan tanggal mulai dan tanggal berakhir.",
    ),
    "houseDirectoryValidationUrl": MessageLookupByLibrary.simpleMessage(
      "Masukkan URL http atau https yang valid.",
    ),
    "houseDirectoryWifiMemberEmpty": MessageLookupByLibrary.simpleMessage(
      "Detail wifi belum ditambahkan.",
    ),
    "houseDirectoryWifiOwnerEmpty": MessageLookupByLibrary.simpleMessage(
      "Tambahkan wifi rumahmu agar semua orang bisa menemukannya di sini.",
    ),
    "houseDirectoryWifiSaved": MessageLookupByLibrary.simpleMessage(
      "Detail wifi tersimpan.",
    ),
    "houseDirectoryWifiTitle": MessageLookupByLibrary.simpleMessage("Wifi"),
    "houseNormCopyUrlCta": MessageLookupByLibrary.simpleMessage("Salin URL"),
    "houseNormDoneCta": MessageLookupByLibrary.simpleMessage("Selesai"),
    "houseNormEditTitle": MessageLookupByLibrary.simpleMessage(
      "Edit norma rumah",
    ),
    "houseNormGenerationFailed": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat membuat norma rumah saat ini.",
    ),
    "houseNormOnboardingBack": MessageLookupByLibrary.simpleMessage("Kembali"),
    "houseNormOnboardingProgress": m8,
    "houseNormOnboardingSubmit": MessageLookupByLibrary.simpleMessage("Buat"),
    "houseNormOnboardingTitle": MessageLookupByLibrary.simpleMessage(
      "Suasana rumah",
    ),
    "houseNormOpenUrlCta": MessageLookupByLibrary.simpleMessage("Buka URL"),
    "houseNormOpenUrlError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat membuka URL itu.",
    ),
    "houseNormPromptCta": MessageLookupByLibrary.simpleMessage("Buat"),
    "houseNormPromptSubtitle": MessageLookupByLibrary.simpleMessage(
      "Ubah jawabanmu menjadi panduan bersama.",
    ),
    "houseNormPromptTitle": MessageLookupByLibrary.simpleMessage(
      "Buat norma rumah",
    ),
    "houseNormPublishCta": MessageLookupByLibrary.simpleMessage(
      "Publikasikan ke web",
    ),
    "houseNormReportEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Buat norma rumah untuk melihatnya.",
    ),
    "houseNormReportEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Norma rumah belum siap",
    ),
    "houseNormReportErrorBody": MessageLookupByLibrary.simpleMessage(
      "Silakan coba lagi.",
    ),
    "houseNormReportErrorTitle": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat norma rumah",
    ),
    "houseNormReportTitle": MessageLookupByLibrary.simpleMessage("Norma rumah"),
    "houseNormRepublishCta": MessageLookupByLibrary.simpleMessage(
      "Publikasikan ulang",
    ),
    "houseNormScenarioGuestsOption1": MessageLookupByLibrary.simpleMessage(
      "Tanya dulu",
    ),
    "houseNormScenarioGuestsOption2": MessageLookupByLibrary.simpleMessage(
      "Kasih tahu dulu",
    ),
    "houseNormScenarioGuestsOption3": MessageLookupByLibrary.simpleMessage(
      "Sangat normal",
    ),
    "houseNormScenarioGuestsQuestion": MessageLookupByLibrary.simpleMessage(
      "Membawa tamu?",
    ),
    "houseNormScenarioHomeIdentityOption1":
        MessageLookupByLibrary.simpleMessage("Rumah tenang"),
    "houseNormScenarioHomeIdentityOption2":
        MessageLookupByLibrary.simpleMessage("Rumah seimbang"),
    "houseNormScenarioHomeIdentityOption3":
        MessageLookupByLibrary.simpleMessage("Rumah sosial"),
    "houseNormScenarioHomeIdentityQuestion":
        MessageLookupByLibrary.simpleMessage("Deskripsi terbaik?"),
    "houseNormScenarioPropertyContextOption1":
        MessageLookupByLibrary.simpleMessage("Milik sendiri"),
    "houseNormScenarioPropertyContextOption2":
        MessageLookupByLibrary.simpleMessage("Sewa seluruh rumah"),
    "houseNormScenarioPropertyContextOption3":
        MessageLookupByLibrary.simpleMessage("Sewa kamar"),
    "houseNormScenarioPropertyContextQuestion":
        MessageLookupByLibrary.simpleMessage("Rumah ini adalah:"),
    "houseNormScenarioRelationshipModelOption1":
        MessageLookupByLibrary.simpleMessage("Teman serumah"),
    "houseNormScenarioRelationshipModelOption2":
        MessageLookupByLibrary.simpleMessage("Keluarga"),
    "houseNormScenarioRelationshipModelOption3":
        MessageLookupByLibrary.simpleMessage("Campuran"),
    "houseNormScenarioRelationshipModelQuestion":
        MessageLookupByLibrary.simpleMessage("Siapa yang tinggal di sini?"),
    "houseNormScenarioRepairOption1": MessageLookupByLibrary.simpleMessage(
      "Bicarakan lebih awal",
    ),
    "houseNormScenarioRepairOption2": MessageLookupByLibrary.simpleMessage(
      "Pilih waktunya",
    ),
    "houseNormScenarioRepairOption3": MessageLookupByLibrary.simpleMessage(
      "Biarkan hal kecil lewat",
    ),
    "houseNormScenarioRepairQuestion": MessageLookupByLibrary.simpleMessage(
      "Ketegangan?",
    ),
    "houseNormScenarioResponsibilityOption1":
        MessageLookupByLibrary.simpleMessage("Kesepakatan yang jelas"),
    "houseNormScenarioResponsibilityOption2":
        MessageLookupByLibrary.simpleMessage("Siapa yang melihat duluan"),
    "houseNormScenarioResponsibilityOption3":
        MessageLookupByLibrary.simpleMessage("Semua urus miliknya sendiri"),
    "houseNormScenarioResponsibilityQuestion":
        MessageLookupByLibrary.simpleMessage("Tugas rumah kecil?"),
    "houseNormScenarioRhythmOption1": MessageLookupByLibrary.simpleMessage(
      "Mulai tenang",
    ),
    "houseNormScenarioRhythmOption2": MessageLookupByLibrary.simpleMessage(
      "Tergantung",
    ),
    "houseNormScenarioRhythmOption3": MessageLookupByLibrary.simpleMessage(
      "Semua melakukan urusannya sendiri",
    ),
    "houseNormScenarioRhythmQuestion": MessageLookupByLibrary.simpleMessage(
      "Di malam hari?",
    ),
    "houseNormScenarioSharedSpacesOption1":
        MessageLookupByLibrary.simpleMessage("Bersih"),
    "houseNormScenarioSharedSpacesOption2":
        MessageLookupByLibrary.simpleMessage("Terlihat dipakai"),
    "houseNormScenarioSharedSpacesOption3":
        MessageLookupByLibrary.simpleMessage("Berantakan tidak masalah"),
    "houseNormScenarioSharedSpacesQuestion":
        MessageLookupByLibrary.simpleMessage("Dapur di malam hari?"),
    "houseNormSectionEditLabel": MessageLookupByLibrary.simpleMessage(
      "Edit bagian ini",
    ),
    "houseNormSectionEmptyError": MessageLookupByLibrary.simpleMessage(
      "Tambahkan teks sebelum menyimpan.",
    ),
    "houseNormSectionFallbackTitle": MessageLookupByLibrary.simpleMessage(
      "Bagian",
    ),
    "houseNormSectionGuestsSocialTitle": MessageLookupByLibrary.simpleMessage(
      "Tamu dan alur sosial",
    ),
    "houseNormSectionHomeIdentityTitle": MessageLookupByLibrary.simpleMessage(
      "Identitas rumah",
    ),
    "houseNormSectionRepairStyleTitle": MessageLookupByLibrary.simpleMessage(
      "Gaya memperbaiki hubungan",
    ),
    "houseNormSectionResponsibilityFlowTitle":
        MessageLookupByLibrary.simpleMessage("Alur tanggung jawab"),
    "houseNormSectionRhythmQuietTitle": MessageLookupByLibrary.simpleMessage(
      "Ritme dan ketenangan",
    ),
    "houseNormSectionSaveCta": MessageLookupByLibrary.simpleMessage("Simpan"),
    "houseNormSectionSaveFailed": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat menyimpan pembaruan itu.",
    ),
    "houseNormSectionSaveSuccess": MessageLookupByLibrary.simpleMessage(
      "Bagian diperbarui.",
    ),
    "houseNormSectionSharedSpacesTitle": MessageLookupByLibrary.simpleMessage(
      "Ruang bersama",
    ),
    "houseNormShareSubject": MessageLookupByLibrary.simpleMessage(
      "Norma rumah kami",
    ),
    "houseNormShareUrlCta": MessageLookupByLibrary.simpleMessage("Bagikan URL"),
    "houseNormSummaryFramingLabel": MessageLookupByLibrary.simpleMessage(
      "Ringkasan",
    ),
    "houseNormSummarySubtitle": MessageLookupByLibrary.simpleMessage(
      "Panduan, bukan buku aturan.",
    ),
    "houseNormSummaryTitle": MessageLookupByLibrary.simpleMessage(
      "Norma rumah",
    ),
    "houseNormUrlCopied": MessageLookupByLibrary.simpleMessage(
      "URL norma rumah disalin.",
    ),
    "houseNormViewTitle": MessageLookupByLibrary.simpleMessage(
      "Lihat norma rumah",
    ),
    "housePulseCardHeader": MessageLookupByLibrary.simpleMessage(
      "Pulse rumah mingguan",
    ),
    "housePulseShareCta": MessageLookupByLibrary.simpleMessage("Bagikan pulse"),
    "housePulseShareMessage": m9,
    "housePulseShareTitle": MessageLookupByLibrary.simpleMessage(
      "Membagikan pulse rumah Kinly kami",
    ),
    "housePulseUpdatedOn": m10,
    "houseVibeShareCta": MessageLookupByLibrary.simpleMessage(
      "Bagikan suasana",
    ),
    "houseVibeShareError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat membagikan sekarang.",
    ),
    "houseVibeShareMessage": m11,
    "houseVibeShareTitle": MessageLookupByLibrary.simpleMessage(
      "Suasana rumah",
    ),
    "hubCardGratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "Ucapan terima kasih singkat dari rumahmu.",
    ),
    "hubCardGratitudeWallTitle": MessageLookupByLibrary.simpleMessage(
      "Ucapan terima kasih",
    ),
    "hubCodeCopied": MessageLookupByLibrary.simpleMessage(
      "Kode undangan disalin",
    ),
    "hubError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat Pusat Rumah.",
    ),
    "hubHouseDirectorySubtitle": MessageLookupByLibrary.simpleMessage(
      "Wifi, layanan, catatan, dan pengingat perpanjangan.",
    ),
    "hubHouseDirectoryTitle": MessageLookupByLibrary.simpleMessage(
      "Direktori rumah",
    ),
    "hubHouseNormsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Panduan untuk cara rumah ini berjalan.",
    ),
    "hubHouseNormsTitle": MessageLookupByLibrary.simpleMessage("Norma rumah"),
    "hubInviteCta": MessageLookupByLibrary.simpleMessage("Undang"),
    "hubInviteUnavailable": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat undangan.",
    ),
    "hubMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "Belum ada anggota aktif.",
    ),
    "hubPreferencesSubtitle": MessageLookupByLibrary.simpleMessage(
      "Bagaimana tiap orang ingin hidup bersama berjalan.",
    ),
    "hubPreferencesTitle": MessageLookupByLibrary.simpleMessage("Preferensi"),
    "hubQrSubtitle": MessageLookupByLibrary.simpleMessage(
      "Pindai untuk mengunduh Kinly",
    ),
    "hubQrTitle": MessageLookupByLibrary.simpleMessage("Bagikan aplikasi"),
    "hubRetry": MessageLookupByLibrary.simpleMessage("Coba lagi"),
    "hubRotateError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memperbarui undangan.",
    ),
    "hubRotateInvite": MessageLookupByLibrary.simpleMessage(
      "Putar ulang undangan",
    ),
    "hubRotateSuccess": MessageLookupByLibrary.simpleMessage(
      "Undangan diperbarui",
    ),
    "hubShareAppBody": m12,
    "hubShareAppCta": MessageLookupByLibrary.simpleMessage("Bagikan Kinly"),
    "hubShareAppTitle": MessageLookupByLibrary.simpleMessage("Dapatkan Kinly"),
    "hubShareInviteBody": m13,
    "hubShareInviteTitle": MessageLookupByLibrary.simpleMessage(
      "Undang ke rumah Kinly saya",
    ),
    "join_blocked_body": MessageLookupByLibrary.simpleMessage(
      "Kami sudah memberi tahu pemilik rumah.",
    ),
    "join_blocked_cta": MessageLookupByLibrary.simpleMessage("Selesai"),
    "join_blocked_title": MessageLookupByLibrary.simpleMessage(
      "Rumah ini sedang tidak menerima anggota baru",
    ),
    "join_error_already_in_other_home": MessageLookupByLibrary.simpleMessage(
      "Keluar dari rumahmu saat ini terlebih dahulu.",
    ),
    "join_error_forbidden": MessageLookupByLibrary.simpleMessage(
      "Kamu tidak punya izin untuk bergabung ke rumah ini.",
    ),
    "join_error_inactive_invite": MessageLookupByLibrary.simpleMessage(
      "Undangan itu sudah kedaluwarsa. Minta pemilik rumah untuk membuat yang baru.",
    ),
    "join_error_invalid_code": MessageLookupByLibrary.simpleMessage(
      "Kode undangan itu tampaknya salah.",
    ),
    "join_error_paywall_limit": MessageLookupByLibrary.simpleMessage(
      "Rumah ini sudah mencapai batas anggota. Minta pemilik rumah untuk upgrade atau menghapus seseorang.",
    ),
    "join_error_unauthorized": MessageLookupByLibrary.simpleMessage(
      "Masuk untuk bergabung ke rumah ini.",
    ),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat bergabung ke rumah ini.",
    ),
    "join_hint": MessageLookupByLibrary.simpleMessage(
      "Masukkan kode undangan (mis. ABC123)",
    ),
    "join_submit": MessageLookupByLibrary.simpleMessage("Gabung"),
    "join_success": m14,
    "join_title": MessageLookupByLibrary.simpleMessage("Gabung ke Rumah"),
    "login_consent_connector": MessageLookupByLibrary.simpleMessage(" & "),
    "login_consent_prefix": MessageLookupByLibrary.simpleMessage(
      "Saya menyetujui ",
    ),
    "login_privacy": MessageLookupByLibrary.simpleMessage("Kebijakan Privasi"),
    "login_tagline": MessageLookupByLibrary.simpleMessage(
      "Bersama terasa lebih ringan",
    ),
    "login_terms": MessageLookupByLibrary.simpleMessage("Syarat Layanan"),
    "login_with_apple": MessageLookupByLibrary.simpleMessage(
      "Lanjutkan dengan Apple",
    ),
    "login_with_google": MessageLookupByLibrary.simpleMessage(
      "Lanjutkan dengan Google",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("Keluar"),
    "membership_status_active": MessageLookupByLibrary.simpleMessage(
      "Kamu terhubung ke sebuah rumah.",
    ),
    "membership_status_checking": MessageLookupByLibrary.simpleMessage(
      "Menghubungkan ke rumahmu...",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "Buat atau gabung ke rumah.",
    ),
    "mentionFieldHint": MessageLookupByLibrary.simpleMessage(
      "Ketik @ untuk menyebut seseorang",
    ),
    "navExplore": MessageLookupByLibrary.simpleMessage("Kelola"),
    "navHub": MessageLookupByLibrary.simpleMessage("Pusat Rumah"),
    "navToday": MessageLookupByLibrary.simpleMessage("Hari ini"),
    "npsCannotSkip": MessageLookupByLibrary.simpleMessage(
      "Pilih skor untuk melanjutkan.",
    ),
    "npsDescription": MessageLookupByLibrary.simpleMessage(
      "0 berarti sama sekali tidak. 10 berarti benar-benar memberi perbedaan.",
    ),
    "npsEmailSubject": MessageLookupByLibrary.simpleMessage(
      "Bagaimana Kinly bisa lebih mendukung rumahmu?",
    ),
    "npsLaunchError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat membuka langkah berikutnya.",
    ),
    "npsScaleHighLabel": MessageLookupByLibrary.simpleMessage(
      "10 Sangat membantu",
    ),
    "npsScaleLowLabel": MessageLookupByLibrary.simpleMessage(
      "0 Sama sekali tidak",
    ),
    "npsSubmitErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "Masukan tidak tersedia saat ini.",
    ),
    "npsSubmitErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat mengirim masukanmu.",
    ),
    "npsSubmitErrorInvalidScore": MessageLookupByLibrary.simpleMessage(
      "Pilih angka antara 0 dan 10.",
    ),
    "npsSubmitErrorNotRequired": MessageLookupByLibrary.simpleMessage(
      "Kamu tidak perlu membagikan masukan sekarang.",
    ),
    "npsTitle": MessageLookupByLibrary.simpleMessage(
      "Apakah Kinly membantu rumahmu berjalan lebih lancar?",
    ),
    "offline_body": MessageLookupByLibrary.simpleMessage(
      "Tidak ada koneksi internet. Coba lagi.",
    ),
    "offline_retry": MessageLookupByLibrary.simpleMessage("Coba lagi"),
    "offline_title": MessageLookupByLibrary.simpleMessage(
      "Kamu sedang offline",
    ),
    "paywallBulletFlows": MessageLookupByLibrary.simpleMessage(
      "Tugas tanpa batas",
    ),
    "paywallBulletMembers": MessageLookupByLibrary.simpleMessage(
      "Anggota tanpa batas",
    ),
    "paywallBulletPhotos": MessageLookupByLibrary.simpleMessage(
      "Foto tugas tanpa batas",
    ),
    "paywallBulletShares": MessageLookupByLibrary.simpleMessage(
      "Tagihan tanpa batas",
    ),
    "paywallBulletShoppingPhotos": MessageLookupByLibrary.simpleMessage(
      "Foto belanja tanpa batas",
    ),
    "paywallErrorTitle": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat paywall.",
    ),
    "paywallFeatureUnlimitedSharedExpensePhotos":
        MessageLookupByLibrary.simpleMessage("Foto tagihan tanpa batas"),
    "paywallPriceCaption": MessageLookupByLibrary.simpleMessage(
      "Satu paket rumah. Tanpa tingkatan tersembunyi.",
    ),
    "paywallPricePerMonth": m15,
    "paywallPriceUnavailable": MessageLookupByLibrary.simpleMessage(
      "Harga belum tersedia saat ini.",
    ),
    "paywallPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "Upgrade ke Premium",
    ),
    "paywallPurchaseFailed": MessageLookupByLibrary.simpleMessage(
      "Pembelian tidak selesai.",
    ),
    "paywallPurchaseSuccess": MessageLookupByLibrary.simpleMessage(
      "Kamu sekarang menggunakan Kinly Premium.",
    ),
    "paywallRestoreCta": MessageLookupByLibrary.simpleMessage(
      "Pulihkan pembelian",
    ),
    "paywallRetryLabel": MessageLookupByLibrary.simpleMessage("Coba lagi"),
    "paywallSecondaryCta": MessageLookupByLibrary.simpleMessage(
      "Tetap di paket gratis",
    ),
    "paywallSubtitle": MessageLookupByLibrary.simpleMessage(
      "Kurang dari 0,5% dari sewa rumahmu.",
    ),
    "paywallTitle": MessageLookupByLibrary.simpleMessage(
      "Bantu rumahmu tetap berjalan lancar",
    ),
    "personalMentionsTitle": MessageLookupByLibrary.simpleMessage(
      "Sebutan pribadi",
    ),
    "personalProfileLoadError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat profil pribadimu.",
    ),
    "personalProfileMentions": MessageLookupByLibrary.simpleMessage(
      "Sebutan pribadi",
    ),
    "personalProfilePreferences": MessageLookupByLibrary.simpleMessage(
      "Preferensi pribadi",
    ),
    "personalProfileTitle": MessageLookupByLibrary.simpleMessage("Profilmu"),
    "planFreeLabel": MessageLookupByLibrary.simpleMessage("Upgrade ke Premium"),
    "planPremiumActiveBody": MessageLookupByLibrary.simpleMessage(
      "Nikmati akses tanpa batas ke semua fitur.",
    ),
    "planPremiumActiveTitle": MessageLookupByLibrary.simpleMessage(
      "Kamu menggunakan Premium",
    ),
    "planPremiumLabel": MessageLookupByLibrary.simpleMessage("Premium"),
    "preferenceOnboardingBack": MessageLookupByLibrary.simpleMessage("Kembali"),
    "preferenceOnboardingProgress": m16,
    "preferenceOnboardingSubmit": MessageLookupByLibrary.simpleMessage(
      "Simpan",
    ),
    "preferenceOnboardingTitle": MessageLookupByLibrary.simpleMessage(
      "Suasanamu",
    ),
    "preferencePromptCta": MessageLookupByLibrary.simpleMessage("Mulai"),
    "preferencePromptSubtitle": MessageLookupByLibrary.simpleMessage(
      "Bantu rumahmu memahami apa yang cocok untukmu.",
    ),
    "preferencePromptTitle": MessageLookupByLibrary.simpleMessage(
      "Atur suasanamu",
    ),
    "preferenceReportDoneCta": MessageLookupByLibrary.simpleMessage("Selesai"),
    "preferenceReportEditCta": MessageLookupByLibrary.simpleMessage("Edit"),
    "preferenceReportEditError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat menyimpan pembaruan itu.",
    ),
    "preferenceReportEditSectionDone": MessageLookupByLibrary.simpleMessage(
      "Selesai",
    ),
    "preferenceReportEditSectionHint": MessageLookupByLibrary.simpleMessage(
      "Tulis yang terasa paling tepat",
    ),
    "preferenceReportEditSectionPrompt": MessageLookupByLibrary.simpleMessage(
      "Edit bagian ini.",
    ),
    "preferenceReportEditTitle": MessageLookupByLibrary.simpleMessage(
      "Edit preferensi",
    ),
    "preferenceReportEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Lengkapi preferensimu untuk membuat laporan.",
    ),
    "preferenceReportEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Preferensi belum siap",
    ),
    "preferenceReportErrorBody": MessageLookupByLibrary.simpleMessage(
      "Silakan coba lagi.",
    ),
    "preferenceReportErrorTitle": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat laporan",
    ),
    "preferenceReportGenerationFailed": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat menyelesaikan refleksi preferensimu. Kembali dan coba lagi.",
    ),
    "preferenceReportGenerationMissing": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat menyelesaikan refleksi preferensimu. Coba lagi nanti.",
    ),
    "preferenceReportReadOnlyNote": MessageLookupByLibrary.simpleMessage(
      "Ini menunjukkan apa yang terasa nyaman bagi mereka.",
    ),
    "preferenceReportTitle": MessageLookupByLibrary.simpleMessage(
      "Preferensimu",
    ),
    "preferenceReportViewTitle": MessageLookupByLibrary.simpleMessage(
      "Lihat preferensi",
    ),
    "preferenceScenarioCleanlinessSharedSpaceOption1":
        MessageLookupByLibrary.simpleMessage("Jaga tetap rapi"),
    "preferenceScenarioCleanlinessSharedSpaceOption2":
        MessageLookupByLibrary.simpleMessage("Sedikit berantakan"),
    "preferenceScenarioCleanlinessSharedSpaceOption3":
        MessageLookupByLibrary.simpleMessage("Berantakan tidak masalah"),
    "preferenceScenarioCleanlinessSharedSpaceQuestion":
        MessageLookupByLibrary.simpleMessage("Ruang bersama?"),
    "preferenceScenarioCommunicationChannelOption1":
        MessageLookupByLibrary.simpleMessage("Pesan"),
    "preferenceScenarioCommunicationChannelOption2":
        MessageLookupByLibrary.simpleMessage("Langsung"),
    "preferenceScenarioCommunicationChannelOption3":
        MessageLookupByLibrary.simpleMessage("Telepon"),
    "preferenceScenarioCommunicationChannelQuestion":
        MessageLookupByLibrary.simpleMessage("Cara terbaik menghubungimu?"),
    "preferenceScenarioCommunicationDirectnessOption1":
        MessageLookupByLibrary.simpleMessage("Lembut saja"),
    "preferenceScenarioCommunicationDirectnessOption2":
        MessageLookupByLibrary.simpleMessage("Tergantung"),
    "preferenceScenarioCommunicationDirectnessOption3":
        MessageLookupByLibrary.simpleMessage("Langsung saja"),
    "preferenceScenarioCommunicationDirectnessQuestion":
        MessageLookupByLibrary.simpleMessage("Saat ada yang salah?"),
    "preferenceScenarioConflictResolutionOption1":
        MessageLookupByLibrary.simpleMessage("Tenang dulu"),
    "preferenceScenarioConflictResolutionOption2":
        MessageLookupByLibrary.simpleMessage("Cek lagi nanti"),
    "preferenceScenarioConflictResolutionOption3":
        MessageLookupByLibrary.simpleMessage("Bicarakan lebih awal"),
    "preferenceScenarioConflictResolutionQuestion":
        MessageLookupByLibrary.simpleMessage("Kalau ada yang tidak beres?"),
    "preferenceScenarioEnvironmentLightOption1":
        MessageLookupByLibrary.simpleMessage("Lembut"),
    "preferenceScenarioEnvironmentLightOption2":
        MessageLookupByLibrary.simpleMessage("Seimbang"),
    "preferenceScenarioEnvironmentLightOption3":
        MessageLookupByLibrary.simpleMessage("Terang"),
    "preferenceScenarioEnvironmentLightQuestion":
        MessageLookupByLibrary.simpleMessage("Pencahayaan?"),
    "preferenceScenarioEnvironmentNoiseOption1":
        MessageLookupByLibrary.simpleMessage("Tolong tenang"),
    "preferenceScenarioEnvironmentNoiseOption2":
        MessageLookupByLibrary.simpleMessage("Bising normal"),
    "preferenceScenarioEnvironmentNoiseOption3":
        MessageLookupByLibrary.simpleMessage("Ramai tidak masalah"),
    "preferenceScenarioEnvironmentNoiseQuestion":
        MessageLookupByLibrary.simpleMessage("Tingkat kebisingan?"),
    "preferenceScenarioEnvironmentScentOption1":
        MessageLookupByLibrary.simpleMessage("Sensitif"),
    "preferenceScenarioEnvironmentScentOption2":
        MessageLookupByLibrary.simpleMessage("Netral"),
    "preferenceScenarioEnvironmentScentOption3":
        MessageLookupByLibrary.simpleMessage("Tidak mengganggu saya"),
    "preferenceScenarioEnvironmentScentQuestion":
        MessageLookupByLibrary.simpleMessage("Bau yang kuat?"),
    "preferenceScenarioPrivacyNotificationsOption1":
        MessageLookupByLibrary.simpleMessage("Tolong jangan"),
    "preferenceScenarioPrivacyNotificationsOption2":
        MessageLookupByLibrary.simpleMessage("Hanya yang penting"),
    "preferenceScenarioPrivacyNotificationsOption3":
        MessageLookupByLibrary.simpleMessage("Kapan saja"),
    "preferenceScenarioPrivacyNotificationsQuestion":
        MessageLookupByLibrary.simpleMessage("Pesan malam hari?"),
    "preferenceScenarioPrivacyRoomEntryOption1":
        MessageLookupByLibrary.simpleMessage("Ketuk dulu"),
    "preferenceScenarioPrivacyRoomEntryOption2":
        MessageLookupByLibrary.simpleMessage("Biasanya ketuk"),
    "preferenceScenarioPrivacyRoomEntryOption3":
        MessageLookupByLibrary.simpleMessage("Buka pintu saja"),
    "preferenceScenarioPrivacyRoomEntryQuestion":
        MessageLookupByLibrary.simpleMessage("Masuk ke kamarmu?"),
    "preferenceScenarioRoutinePlanningOption1":
        MessageLookupByLibrary.simpleMessage("Terstruktur"),
    "preferenceScenarioRoutinePlanningOption2":
        MessageLookupByLibrary.simpleMessage("Sedikit terstruktur"),
    "preferenceScenarioRoutinePlanningOption3":
        MessageLookupByLibrary.simpleMessage("Mengalir saja"),
    "preferenceScenarioRoutinePlanningQuestion":
        MessageLookupByLibrary.simpleMessage("Kehidupan sehari-hari?"),
    "preferenceScenarioScheduleQuietHoursOption1":
        MessageLookupByLibrary.simpleMessage("Malam tenang"),
    "preferenceScenarioScheduleQuietHoursOption2":
        MessageLookupByLibrary.simpleMessage("Tergantung"),
    "preferenceScenarioScheduleQuietHoursOption3":
        MessageLookupByLibrary.simpleMessage("Aktif tidak masalah"),
    "preferenceScenarioScheduleQuietHoursQuestion":
        MessageLookupByLibrary.simpleMessage("Malam hari?"),
    "preferenceScenarioScheduleSleepTimingOption1":
        MessageLookupByLibrary.simpleMessage("Bangun pagi"),
    "preferenceScenarioScheduleSleepTimingOption2":
        MessageLookupByLibrary.simpleMessage("Di tengah-tengah"),
    "preferenceScenarioScheduleSleepTimingOption3":
        MessageLookupByLibrary.simpleMessage("Begadang"),
    "preferenceScenarioScheduleSleepTimingQuestion":
        MessageLookupByLibrary.simpleMessage("Gaya tidur?"),
    "preferenceScenarioSocialHostingOption1":
        MessageLookupByLibrary.simpleMessage("Jarang"),
    "preferenceScenarioSocialHostingOption2":
        MessageLookupByLibrary.simpleMessage("Kadang-kadang"),
    "preferenceScenarioSocialHostingOption3":
        MessageLookupByLibrary.simpleMessage("Sering"),
    "preferenceScenarioSocialHostingQuestion":
        MessageLookupByLibrary.simpleMessage("Tamu?"),
    "preferenceScenarioSocialTogethernessOption1":
        MessageLookupByLibrary.simpleMessage("Kebanyakan sendiri"),
    "preferenceScenarioSocialTogethernessOption2":
        MessageLookupByLibrary.simpleMessage("Campuran keduanya"),
    "preferenceScenarioSocialTogethernessOption3":
        MessageLookupByLibrary.simpleMessage("Sering kumpul"),
    "preferenceScenarioSocialTogethernessQuestion":
        MessageLookupByLibrary.simpleMessage("Energi rumah?"),
    "profileActionConfirm": MessageLookupByLibrary.simpleMessage(
      "Keluar dari rumah",
    ),
    "profileActionConfirmDelete": MessageLookupByLibrary.simpleMessage(
      "Hapus akun",
    ),
    "profileConfirmDeleteMessage": MessageLookupByLibrary.simpleMessage(
      "Ini akan menghapus akunmu dan mengeluarkanmu. Ini bersifat permanen.",
    ),
    "profileConfirmDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "Hapus akunmu?",
    ),
    "profileConfirmLeaveMessage": MessageLookupByLibrary.simpleMessage(
      "Kamu akan kehilangan akses ke tugas, riwayat, dan undangan.",
    ),
    "profileConfirmLeaveTitle": MessageLookupByLibrary.simpleMessage(
      "Keluar dari rumah ini?",
    ),
    "profileConnectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Kelola pengingat dan pemberitahuan.",
    ),
    "profileConnectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Notifikasi",
    ),
    "profileContactEmailSubject": MessageLookupByLibrary.simpleMessage(
      "Hubungi kami",
    ),
    "profileContactLaunchError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat membuka aplikasi emailmu.",
    ),
    "profileContactUsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Kirim email ke support@makinglifeeasie.com",
    ),
    "profileContactUsTitle": MessageLookupByLibrary.simpleMessage(
      "Hubungi kami",
    ),
    "profileDeleteAccountSubtitle": MessageLookupByLibrary.simpleMessage(
      "Hapus akun dan data Kinly-mu.",
    ),
    "profileDeleteAccountTitle": MessageLookupByLibrary.simpleMessage(
      "Hapus akun",
    ),
    "profileDeleteSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Akunmu akan segera dihapus. Kami akan mengeluarkanmu.",
    ),
    "profileGenericError": MessageLookupByLibrary.simpleMessage(
      "Terjadi kesalahan.",
    ),
    "profileIdentityAvatarEmpty": MessageLookupByLibrary.simpleMessage(
      "Tidak ada avatar yang tersedia saat ini.",
    ),
    "profileIdentityAvatarSectionDescription":
        MessageLookupByLibrary.simpleMessage(
          "Gunakan avatar berbeda untuk tiap orang di rumahmu.",
        ),
    "profileIdentityAvatarSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Pilih avatar",
    ),
    "profileIdentityLoadError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat profilmu.",
    ),
    "profileIdentityRetry": MessageLookupByLibrary.simpleMessage("Coba lagi"),
    "profileIdentitySaveButton": MessageLookupByLibrary.simpleMessage(
      "Simpan perubahan",
    ),
    "profileIdentitySubtitle": MessageLookupByLibrary.simpleMessage(
      "Pilih nama pengguna dan avatar.",
    ),
    "profileIdentitySuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Profil diperbarui.",
    ),
    "profileIdentityTitle": MessageLookupByLibrary.simpleMessage("Edit profil"),
    "profileIdentityUsernameEmptyError": MessageLookupByLibrary.simpleMessage(
      "Masukkan nama pengguna.",
    ),
    "profileIdentityUsernameFormatError": MessageLookupByLibrary.simpleMessage(
      "Gunakan 3-30 huruf kecil atau angka. Titik dan garis bawah boleh di tengah.",
    ),
    "profileIdentityUsernameHint": MessageLookupByLibrary.simpleMessage(
      "huruf, angka, . atau _",
    ),
    "profileIdentityUsernameLabel": MessageLookupByLibrary.simpleMessage(
      "Nama pengguna",
    ),
    "profileIdentityUsernamePreviewFallback":
        MessageLookupByLibrary.simpleMessage("nama penggunamu"),
    "profileIdentityUsernameTakenError": MessageLookupByLibrary.simpleMessage(
      "Nama pengguna itu sudah dipakai.",
    ),
    "profileInfoHubLoadError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat Pusat Info. Periksa koneksimu.",
    ),
    "profileInfoHubSubtitle": MessageLookupByLibrary.simpleMessage(
      "Buka pusat Notion Kinly di dalam aplikasi.",
    ),
    "profileInfoHubTitle": MessageLookupByLibrary.simpleMessage("Pusat Info"),
    "profileKickActionConfirm": MessageLookupByLibrary.simpleMessage(
      "Hapus anggota",
    ),
    "profileKickMemberSubtitle": MessageLookupByLibrary.simpleMessage(
      "Pilih siapa yang kehilangan akses ke rumah ini.",
    ),
    "profileKickMemberTitle": MessageLookupByLibrary.simpleMessage(
      "Hapus anggota",
    ),
    "profileKickNoMembers": MessageLookupByLibrary.simpleMessage(
      "Tidak ada anggota lain untuk dihapus saat ini.",
    ),
    "profileKickOwnerOnly": MessageLookupByLibrary.simpleMessage(
      "Hanya pemilik rumah yang bisa menghapus anggota.",
    ),
    "profileKickSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "Pilih anggota yang ingin dihapus. Mereka akan langsung kehilangan akses.",
    ),
    "profileKickSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Hapus anggota",
    ),
    "profileKickSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Mereka tidak lagi punya akses ke rumah ini.",
    ),
    "profileLeaveEligibilityError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat anggota rumahmu.",
    ),
    "profileLeaveEligibilityLoading": MessageLookupByLibrary.simpleMessage(
      "Memeriksa anggota rumah...",
    ),
    "profileLeaveHomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Kamu akan keluar dari ruang bersama Kinly ini.",
    ),
    "profileLeaveHomeTitle": MessageLookupByLibrary.simpleMessage(
      "Keluar dari rumah",
    ),
    "profileLeaveOwnerNoEligibleMembers": MessageLookupByLibrary.simpleMessage(
      "Tidak ada orang lain yang bisa mengambil alih kepemilikan saat ini.",
    ),
    "profileLeaveOwnerSoloMessage": MessageLookupByLibrary.simpleMessage(
      "Kamu adalah anggota terakhir. Jika keluar, rumah ini akan dinonaktifkan.",
    ),
    "profileLeaveSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Kamu telah keluar dari rumahmu.",
    ),
    "profileLeaveTransferSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "Pilih siapa yang akan menjadi pemilik baru sebelum kamu keluar.",
    ),
    "profileLeaveTransferSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Alihkan kepemilikan",
    ),
    "profileLeaveTransferSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Kepemilikan dialihkan. Menyelesaikan proses keluar...",
    ),
    "profileLogoutSubtitle": MessageLookupByLibrary.simpleMessage(
      "Keluar dari Kinly di perangkat ini.",
    ),
    "profileLogoutTitle": MessageLookupByLibrary.simpleMessage("Keluar"),
    "profileMissingHomeError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat menemukan rumahmu saat ini.",
    ),
    "profileSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Kelola akunmu dan akses rumah.",
    ),
    "profileSettingsTitle": MessageLookupByLibrary.simpleMessage("Profil"),
    "profile_deactivated_message": MessageLookupByLibrary.simpleMessage(
      "Profilmu dinonaktifkan. Masuk dengan email lain.",
    ),
    "pulseCloudySteadySummary": MessageLookupByLibrary.simpleMessage(
      "Beberapa hal berjalan baik. Beberapa tidak.",
    ),
    "pulseCloudySteadyTitle": MessageLookupByLibrary.simpleMessage("Campuran"),
    "pulseCloudyTenseSummary": MessageLookupByLibrary.simpleMessage(
      "Ada sedikit ketegangan minggu ini.",
    ),
    "pulseCloudyTenseTitle": MessageLookupByLibrary.simpleMessage(
      "Perlu perhatian",
    ),
    "pulseFormingSummary": MessageLookupByLibrary.simpleMessage(
      "Beberapa check-in lagi akan memberi gambaran yang lebih jelas.",
    ),
    "pulseFormingTitle": MessageLookupByLibrary.simpleMessage(
      "Masih terbentuk",
    ),
    "pulsePartlySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "Sebagian besar stabil, dengan sedikit ruang untuk perbaikan.",
    ),
    "pulsePartlySupportedTitle": MessageLookupByLibrary.simpleMessage(
      "Cukup baik secara keseluruhan",
    ),
    "pulseRainySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "Mungkin sudah waktunya untuk reset kecil.",
    ),
    "pulseRainySupportedTitle": MessageLookupByLibrary.simpleMessage(
      "Disarankan reset",
    ),
    "pulseRainyUnsupportedSummary": MessageLookupByLibrary.simpleMessage(
      "Ada gesekan yang cukup terasa sekarang.",
    ),
    "pulseRainyUnsupportedTitle": MessageLookupByLibrary.simpleMessage(
      "Perlu reset",
    ),
    "pulseSunnyBumpySummary": MessageLookupByLibrary.simpleMessage(
      "Sebagian besar lancar, dengan beberapa hambatan kecil.",
    ),
    "pulseSunnyBumpyTitle": MessageLookupByLibrary.simpleMessage(
      "Sebagian besar lancar",
    ),
    "pulseSunnyCalmSummary": MessageLookupByLibrary.simpleMessage(
      "Semuanya terasa lancar minggu ini.",
    ),
    "pulseSunnyCalmTitle": MessageLookupByLibrary.simpleMessage(
      "Berjalan lancar",
    ),
    "pulseThunderstormSummary": MessageLookupByLibrary.simpleMessage(
      "Ketegangan tinggi. Segera lakukan reset.",
    ),
    "pulseThunderstormTitle": MessageLookupByLibrary.simpleMessage(
      "Ketegangan tinggi",
    ),
    "quick_add_flow_subtitle": MessageLookupByLibrary.simpleMessage(
      "Buat tugas",
    ),
    "quick_add_flow_title": MessageLookupByLibrary.simpleMessage("Tugas"),
    "quick_add_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "Tambah tagihan",
    ),
    "quick_add_share_title": MessageLookupByLibrary.simpleMessage("Tagihan"),
    "quick_add_title": MessageLookupByLibrary.simpleMessage("Tambah Cepat"),
    "reflectiveAcknowledgementTitle": MessageLookupByLibrary.simpleMessage(
      "Baik.",
    ),
    "reflectiveGenericPrimary": MessageLookupByLibrary.simpleMessage(
      "Menyusun ini dengan penuh perhatian.",
    ),
    "reflectiveGenericSecondary": MessageLookupByLibrary.simpleMessage(
      "Jeda sebentar sebelum kami menampilkannya.",
    ),
    "reflectiveHouseNormsPrimary": MessageLookupByLibrary.simpleMessage(
      "Merefleksikan apa yang dibagikan rumah ini.",
    ),
    "reflectiveHouseNormsSecondary": MessageLookupByLibrary.simpleMessage(
      "Panduan bersama, bukan buku aturan.",
    ),
    "reflectiveHousePrimary": MessageLookupByLibrary.simpleMessage(
      "Menuangkan harapan rumahmu ke dalam kata-kata.",
    ),
    "reflectiveHouseSecondary": MessageLookupByLibrary.simpleMessage(
      "Agar harapan menjadi jelas.",
    ),
    "reflectivePersonalPrimary": MessageLookupByLibrary.simpleMessage(
      "Merefleksikan apa yang kamu bagikan.",
    ),
    "reflectivePersonalSecondary": MessageLookupByLibrary.simpleMessage(
      "Agar orang lain memahami apa yang terasa nyaman untukmu.",
    ),
    "shareCreateAmountHint": MessageLookupByLibrary.simpleMessage("0.00"),
    "shareCreateAmountLabel": MessageLookupByLibrary.simpleMessage("Jumlah"),
    "shareCreateCustomAmountLabel": MessageLookupByLibrary.simpleMessage(
      "Jumlah",
    ),
    "shareCreateCustomHelper": MessageLookupByLibrary.simpleMessage(
      "Masukkan bagian tiap orang. Total harus sama dengan jumlah di atas.",
    ),
    "shareCreateCyclePeriod": m17,
    "shareCreateDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "mis. Belanja bahan makanan",
    ),
    "shareCreateDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "Deskripsi",
    ),
    "shareCreateErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "Kamu tidak punya izin untuk membuat ini sekarang.",
    ),
    "shareCreateErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat membuat tagihan.",
    ),
    "shareCreateErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "Kamu sudah mencapai batas gratis untuk tagihan aktif. Upgrade untuk lebih banyak.",
    ),
    "shareCreateErrorRecurrenceDraft": MessageLookupByLibrary.simpleMessage(
      "Draf tidak berulang sampai kamu menambahkan pembagian.",
    ),
    "shareCreateLoadError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat anggota rumahmu.",
    ),
    "shareCreateNotesHint": MessageLookupByLibrary.simpleMessage(
      "Catatan opsional yang bisa dilihat semua orang",
    ),
    "shareCreateNotesLabel": MessageLookupByLibrary.simpleMessage("Catatan"),
    "shareCreateParticipantsEmpty": MessageLookupByLibrary.simpleMessage(
      "Kamu memerlukan setidaknya dua anggota rumah untuk berbagi tagihan.",
    ),
    "shareCreateRecurrenceEveryLabel": MessageLookupByLibrary.simpleMessage(
      "Setiap",
    ),
    "shareCreateRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "Ulangi",
    ),
    "shareCreateRecurrenceToggleLabel": MessageLookupByLibrary.simpleMessage(
      "Berulang",
    ),
    "shareCreateRecurrenceUnitDay": MessageLookupByLibrary.simpleMessage(
      "Hari",
    ),
    "shareCreateRecurrenceUnitMonth": MessageLookupByLibrary.simpleMessage(
      "Bulan",
    ),
    "shareCreateRecurrenceUnitWeek": MessageLookupByLibrary.simpleMessage(
      "Minggu",
    ),
    "shareCreateRecurrenceUnitYear": MessageLookupByLibrary.simpleMessage(
      "Tahun",
    ),
    "shareCreateRetry": MessageLookupByLibrary.simpleMessage("Coba lagi"),
    "shareCreateSplitCustom": MessageLookupByLibrary.simpleMessage(
      "Pilih jumlah",
    ),
    "shareCreateSplitEqual": MessageLookupByLibrary.simpleMessage("Bagi rata"),
    "shareCreateSplitLabel": MessageLookupByLibrary.simpleMessage(
      "Bagaimana kamu ingin membaginya?",
    ),
    "shareCreateStartLabel": MessageLookupByLibrary.simpleMessage(
      "Kapan ini berlaku?",
    ),
    "shareCreateSubmit": MessageLookupByLibrary.simpleMessage("Buat"),
    "shareCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "Tagihan dibuat.",
    ),
    "shareCreateTitle": MessageLookupByLibrary.simpleMessage("Tambah Tagihan"),
    "shareCreateValidationAmount": MessageLookupByLibrary.simpleMessage(
      "Masukkan jumlah yang lebih besar dari nol.",
    ),
    "shareCreateValidationCustomAmounts": MessageLookupByLibrary.simpleMessage(
      "Masukkan jumlah yang valid untuk setiap orang yang dipilih.",
    ),
    "shareCreateValidationCustomParticipants":
        MessageLookupByLibrary.simpleMessage(
          "Pilih setidaknya satu orang untuk tagihan ini.",
        ),
    "shareCreateValidationCustomSinglePayer":
        MessageLookupByLibrary.simpleMessage(
          "Tambahkan setidaknya satu orang lain.",
        ),
    "shareCreateValidationCustomSum": MessageLookupByLibrary.simpleMessage(
      "Pastikan pembagian sesuai dengan jumlah total.",
    ),
    "shareCreateValidationCustomSumBreakdown": m18,
    "shareCreateValidationDescription": MessageLookupByLibrary.simpleMessage(
      "Masukkan deskripsi.",
    ),
    "shareCreateValidationEqualParticipants":
        MessageLookupByLibrary.simpleMessage(
          "Pilih setidaknya satu orang untuk membagi tagihan ini.",
        ),
    "shareCreateValidationRecurrence": MessageLookupByLibrary.simpleMessage(
      "Pilih seberapa sering ini berulang.",
    ),
    "shareCreateValidationRecurrenceSplit":
        MessageLookupByLibrary.simpleMessage(
          "Pilih pembagian sebelum menjadikan ini berulang.",
        ),
    "shareCreateValidationStartDate": MessageLookupByLibrary.simpleMessage(
      "Pilih tanggal mulai.",
    ),
    "shareCreateValidationStartDateRange": MessageLookupByLibrary.simpleMessage(
      "Pilih tanggal dalam rentang yang diizinkan.",
    ),
    "shareCreatedListActiveAmount": m19,
    "shareCreatedListActiveSubtitle": m20,
    "shareCreatedListDraftBadge": MessageLookupByLibrary.simpleMessage(
      "Belum ditugaskan",
    ),
    "shareCreatedListDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "Bagikan dulu sebelum dipublikasikan agar semua orang tahu bagiannya.",
    ),
    "shareCreatedListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Tagihan membantu urusan uang tetap jelas.",
    ),
    "shareCreatedListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Belum ada tagihan",
    ),
    "shareCreatedListError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat tagihanmu. Tarik untuk menyegarkan.",
    ),
    "shareCreatedListPaidBadge": MessageLookupByLibrary.simpleMessage("Lunas"),
    "shareCreatedListRetry": MessageLookupByLibrary.simpleMessage("Coba lagi"),
    "shareCreatedListTitle": MessageLookupByLibrary.simpleMessage("Tagihanmu"),
    "shareEditClose": MessageLookupByLibrary.simpleMessage("Tutup"),
    "shareEditDeleteButton": MessageLookupByLibrary.simpleMessage("Hapus"),
    "shareEditDeleteConfirm": MessageLookupByLibrary.simpleMessage("Hapus"),
    "shareEditDeleteConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "Ini akan menghapus draf untuk semua orang.",
    ),
    "shareEditDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Hapus tagihan?",
    ),
    "shareEditDeleteError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat menghapus tagihan.",
    ),
    "shareEditDeleteSuccess": MessageLookupByLibrary.simpleMessage(
      "Tagihan dihapus.",
    ),
    "shareEditDisabledActive": MessageLookupByLibrary.simpleMessage(
      "Tagihan aktif tidak dapat diedit.",
    ),
    "shareEditDisabledConverted": MessageLookupByLibrary.simpleMessage(
      "Tagihan ini sekarang menjadi rencana dan tidak bisa diedit di sini.",
    ),
    "shareEditDisabledGeneric": MessageLookupByLibrary.simpleMessage(
      "Tagihan ini tidak dapat diedit saat ini.",
    ),
    "shareEditDisabledRecurringCycle": MessageLookupByLibrary.simpleMessage(
      "Siklus berulang tidak dapat diedit di sini.",
    ),
    "shareEditLoadError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat draf itu.",
    ),
    "shareEditNotAllowed": MessageLookupByLibrary.simpleMessage(
      "Ini tetap terkunci sampai seseorang mengambil tagihan ini.",
    ),
    "shareEditSplitsLocked": MessageLookupByLibrary.simpleMessage(
      "Pembagian terkunci karena seseorang sudah membayar. Kamu masih bisa memperbarui deskripsi dan catatan.",
    ),
    "shareEditSubmit": MessageLookupByLibrary.simpleMessage("Perbarui"),
    "shareEditSuccess": MessageLookupByLibrary.simpleMessage(
      "Tagihan diperbarui.",
    ),
    "shareEditTerminateError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat mengakhiri rencana.",
    ),
    "shareEditTerminatePlan": MessageLookupByLibrary.simpleMessage(
      "Akhiri rencana",
    ),
    "shareEditTerminatePlanBusy": MessageLookupByLibrary.simpleMessage(
      "Mengakhiri...",
    ),
    "shareEditTerminatePlanConfirm": MessageLookupByLibrary.simpleMessage(
      "Akhiri rencana",
    ),
    "shareEditTerminatePlanMessage": MessageLookupByLibrary.simpleMessage(
      "Ini akan menghentikan siklus tagihan berikutnya.",
    ),
    "shareEditTerminatePlanTitle": MessageLookupByLibrary.simpleMessage(
      "Akhiri rencana berulang?",
    ),
    "shareEditTerminateSuccess": MessageLookupByLibrary.simpleMessage(
      "Rencana diakhiri.",
    ),
    "shareEditTitle": MessageLookupByLibrary.simpleMessage("Edit Tagihan"),
    "shareOwedDetailEmpty": MessageLookupByLibrary.simpleMessage(
      "Kamu sudah beres dengan orang ini.",
    ),
    "shareOwedDetailError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat menandai pembayaran ini sebagai selesai.",
    ),
    "shareOwedDetailPaid": MessageLookupByLibrary.simpleMessage(
      "Tandai selesai",
    ),
    "shareOwedDetailSuccess": MessageLookupByLibrary.simpleMessage(
      "Ditandai selesai.",
    ),
    "shareOwedDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Untuk diselesaikan",
    ),
    "sharePaidDetailAcknowledge": MessageLookupByLibrary.simpleMessage(
      "Konfirmasi penerimaan",
    ),
    "sharePaidDetailAcknowledgeError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat mengonfirmasi pembayaran ini.",
    ),
    "sharePaidDetailAcknowledging": MessageLookupByLibrary.simpleMessage(
      "Mengonfirmasi...",
    ),
    "shoppingAllItemsBought": MessageLookupByLibrary.simpleMessage(
      "Semua sudah dibeli",
    ),
    "shoppingAmountHint": MessageLookupByLibrary.simpleMessage("mis. 2 kotak"),
    "shoppingAmountLabel": MessageLookupByLibrary.simpleMessage("Jumlah"),
    "shoppingArchiveCta": MessageLookupByLibrary.simpleMessage(
      "Item yang sudah dibeli",
    ),
    "shoppingArchiveDraftBillCreated": MessageLookupByLibrary.simpleMessage(
      "Draf tagihan dibuat",
    ),
    "shoppingArchiveItemsBought": MessageLookupByLibrary.simpleMessage(
      "Item ditandai sudah dibeli dan dihapus",
    ),
    "shoppingArchiveShareNo": MessageLookupByLibrary.simpleMessage("Tidak"),
    "shoppingArchiveSharePromptBody": MessageLookupByLibrary.simpleMessage(
      "Buat draf tagihan dari item-item ini?",
    ),
    "shoppingArchiveSharePromptTitle": MessageLookupByLibrary.simpleMessage(
      "Buat tagihan?",
    ),
    "shoppingArchiveShareYes": MessageLookupByLibrary.simpleMessage("Ya"),
    "shoppingCardSubtitle": m21,
    "shoppingCardTitle": MessageLookupByLibrary.simpleMessage("Daftar belanja"),
    "shoppingContextHint": MessageLookupByLibrary.simpleMessage(
      "Merek, ukuran, atau catatan",
    ),
    "shoppingContextLabel": MessageLookupByLibrary.simpleMessage("Catatan"),
    "shoppingCreateTitle": MessageLookupByLibrary.simpleMessage(
      "Tambah item belanja",
    ),
    "shoppingDelete": MessageLookupByLibrary.simpleMessage("Hapus item"),
    "shoppingDeleteConfirmBody": MessageLookupByLibrary.simpleMessage(
      "Ini akan menghapusnya dari daftar belanja bersama.",
    ),
    "shoppingDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Hapus item ini?",
    ),
    "shoppingDetailTitle": MessageLookupByLibrary.simpleMessage("Item belanja"),
    "shoppingEditTitle": MessageLookupByLibrary.simpleMessage(
      "Edit item belanja",
    ),
    "shoppingEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Belum ada item belanja.",
    ),
    "shoppingErrorItemAlreadyCompletedByOther":
        MessageLookupByLibrary.simpleMessage(
          "Seseorang sudah menandai item ini sebagai dibeli.",
        ),
    "shoppingListTitle": MessageLookupByLibrary.simpleMessage("Daftar belanja"),
    "shoppingMarkCompleteCta": MessageLookupByLibrary.simpleMessage(
      "Tandai sudah dibeli",
    ),
    "shoppingNameHint": MessageLookupByLibrary.simpleMessage("mis. Susu"),
    "shoppingNameLabel": MessageLookupByLibrary.simpleMessage("Nama"),
    "shoppingPhotoLabel": MessageLookupByLibrary.simpleMessage("Tambah foto"),
    "shoppingPhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Tambah foto",
    ),
    "shoppingPhotoReplaceLabel": MessageLookupByLibrary.simpleMessage(
      "Bantu orang lain membeli item yang tepat",
    ),
    "shoppingSubmitAdd": MessageLookupByLibrary.simpleMessage("Tambah item"),
    "shoppingSubmitEdit": MessageLookupByLibrary.simpleMessage(
      "Simpan perubahan",
    ),
    "shoppingTabPending": MessageLookupByLibrary.simpleMessage("Untuk dibeli"),
    "shoppingValidationName": MessageLookupByLibrary.simpleMessage(
      "Masukkan nama item.",
    ),
    "startReturningSubtitle": MessageLookupByLibrary.simpleMessage(
      "Apa yang ingin kamu lakukan?",
    ),
    "startReturningTitle": m22,
    "todayAddSheetFlow": MessageLookupByLibrary.simpleMessage("Tambah Tugas"),
    "todayAddSheetShare": MessageLookupByLibrary.simpleMessage(
      "Tambah Tagihan",
    ),
    "todayAddSheetShopping": MessageLookupByLibrary.simpleMessage(
      "Tambah Item Belanja",
    ),
    "todayAddSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Tambahkan ke rumahmu",
    ),
    "todayEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Tidak ada yang perlu perhatianmu saat ini.",
    ),
    "todayEmptyCardBadge": MessageLookupByLibrary.simpleMessage(
      "Istirahat sejenak",
    ),
    "todayEmptyCardTitle": MessageLookupByLibrary.simpleMessage(
      "Semua sudah beres",
    ),
    "todayFlatmateInviteSubtitle": MessageLookupByLibrary.simpleMessage(
      "Tetap selaras dan berbagi tanggung jawab.",
    ),
    "todayFlatmateInviteTitle": MessageLookupByLibrary.simpleMessage(
      "Undang teman serumahmu",
    ),
    "todayFlowBadgeNew": MessageLookupByLibrary.simpleMessage("baru hari ini"),
    "todayFlowSectionTitle": MessageLookupByLibrary.simpleMessage("Tugas"),
    "todayFlowSeeAll": m23,
    "todayFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "Ini yang perlu diperhatikan hari ini.",
    ),
    "todayFlowTabActive": MessageLookupByLibrary.simpleMessage("Aktif"),
    "todayFlowTabDrafts": MessageLookupByLibrary.simpleMessage("Draf"),
    "todayGratitudeHouseCta": MessageLookupByLibrary.simpleMessage(
      "Ucapan terima kasih rumah",
    ),
    "todayGratitudePersonalCta": MessageLookupByLibrary.simpleMessage(
      "Ucapan terima kasih saya",
    ),
    "todayGratitudeSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Ucapan terima kasih",
    ),
    "todayGratitudeUnreadBody": MessageLookupByLibrary.simpleMessage(
      "Ada ucapan terima kasih baru menunggumu.",
    ),
    "todayHouseDirectoryAcknowledgeCta": MessageLookupByLibrary.simpleMessage(
      "Konfirmasi",
    ),
    "todayHouseDirectoryDismissCta": MessageLookupByLibrary.simpleMessage(
      "Tutup",
    ),
    "todayHouseDirectoryOpenCta": MessageLookupByLibrary.simpleMessage(
      "Buka direktori",
    ),
    "todayHouseDirectoryReminderDue": m31,
    "todayHouseDirectoryRemindersTitle": MessageLookupByLibrary.simpleMessage(
      "Pengingat perpanjangan",
    ),
    "todayInviteFriendsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Bagikan Kinly kepada teman-teman.",
    ),
    "todayInviteFriendsTitle": MessageLookupByLibrary.simpleMessage(
      "Undang teman ke Kinly",
    ),
    "todayInviteNotNow": MessageLookupByLibrary.simpleMessage("Nanti saja"),
    "todayInviteShareCta": MessageLookupByLibrary.simpleMessage(
      "Bagikan undangan",
    ),
    "todayMemberCapPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "Upgrade rumah",
    ),
    "todayMemberCapResolutionFailed": m24,
    "todayMemberCapResolutionJoined": m25,
    "todayMemberCapResolutionSuperseded": m26,
    "todayMemberCapResolutionUnknownName": MessageLookupByLibrary.simpleMessage(
      "Seseorang",
    ),
    "todayMemberCapSecondaryCta": MessageLookupByLibrary.simpleMessage(
      "Abaikan",
    ),
    "todayMemberCapSubtitle": m27,
    "todayMemberCapSubtitleGeneric": MessageLookupByLibrary.simpleMessage(
      "Upgrade untuk menambah lebih banyak orang.",
    ),
    "todayMemberCapTitle": MessageLookupByLibrary.simpleMessage(
      "Seseorang ingin bergabung ke rumahmu",
    ),
    "todayShareActiveSubtitle": m28,
    "todayShareError": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat memuat ulang tagihan saat ini.",
    ),
    "todaySharePaidSubtitle": MessageLookupByLibrary.simpleMessage(
      "Jumlah yang sudah diselesaikan",
    ),
    "todaySharePaidUnseen": m29,
    "todayShareSectionTitle": MessageLookupByLibrary.simpleMessage("Tagihan"),
    "todayShareTabActive": MessageLookupByLibrary.simpleMessage(
      "Perlu diselesaikan",
    ),
    "todayShareTabDrafts": MessageLookupByLibrary.simpleMessage("Draf"),
    "todayShareTabPaidToMe": MessageLookupByLibrary.simpleMessage("Selesai"),
    "vibeCozySocialSummary": MessageLookupByLibrary.simpleMessage(
      "Rumahmu terasa nyaman dan tenang bersama.",
    ),
    "vibeCozySocialTitle": MessageLookupByLibrary.simpleMessage(
      "Sosial nyaman",
    ),
    "vibeDefaultSummary": MessageLookupByLibrary.simpleMessage(
      "Rumahmu terasa seimbang.",
    ),
    "vibeDefaultTitle": MessageLookupByLibrary.simpleMessage("Rumah seimbang"),
    "vibeEasygoingSummary": MessageLookupByLibrary.simpleMessage(
      "Rumahmu terasa santai dan fleksibel.",
    ),
    "vibeEasygoingTitle": MessageLookupByLibrary.simpleMessage("Alur santai"),
    "vibeIndependentSummary": MessageLookupByLibrary.simpleMessage(
      "Rumahmu menghargai ruang dan ketenangan.",
    ),
    "vibeIndependentTitle": MessageLookupByLibrary.simpleMessage(
      "Tenang mandiri",
    ),
    "vibeInsufficientSummary": MessageLookupByLibrary.simpleMessage(
      "Lengkapi preferensi untuk melihat suasana rumahmu.",
    ),
    "vibeInsufficientTitle": MessageLookupByLibrary.simpleMessage(
      "Data belum cukup",
    ),
    "vibeMixedSummary": MessageLookupByLibrary.simpleMessage(
      "Rumahmu punya gaya hidup bersama yang beragam.",
    ),
    "vibeMixedTitle": MessageLookupByLibrary.simpleMessage("Rumah campuran"),
    "vibeQuietCareSummary": MessageLookupByLibrary.simpleMessage(
      "Rumahmu terasa tenang dan lembut.",
    ),
    "vibeQuietCareTitle": MessageLookupByLibrary.simpleMessage(
      "Perhatian tenang",
    ),
    "vibeSocialSummary": MessageLookupByLibrary.simpleMessage(
      "Rumahmu terasa aktif dan sosial.",
    ),
    "vibeSocialTitle": MessageLookupByLibrary.simpleMessage("Energi sosial"),
    "vibeSteadySummary": MessageLookupByLibrary.simpleMessage(
      "Rumahmu terasa stabil dan konsisten.",
    ),
    "vibeSteadyTitle": MessageLookupByLibrary.simpleMessage("Tenang stabil"),
    "vibeStructuredSummary": MessageLookupByLibrary.simpleMessage(
      "Rumahmu berjalan paling baik dengan rutinitas dan rencana.",
    ),
    "vibeStructuredTitle": MessageLookupByLibrary.simpleMessage(
      "Ritme terstruktur",
    ),
    "vibeWarmSocialSummary": MessageLookupByLibrary.simpleMessage(
      "Rumahmu terasa hangat dan ramah.",
    ),
    "vibeWarmSocialTitle": MessageLookupByLibrary.simpleMessage(
      "Sosial hangat",
    ),
    "weeklyRewriteCta": MessageLookupByLibrary.simpleMessage(
      "Kirim dengan tenang lewat Kinly",
    ),
    "welcome_create": MessageLookupByLibrary.simpleMessage("Buat Rumah"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("Gabung ke Rumah"),
    "welcome_title": MessageLookupByLibrary.simpleMessage(
      "Selamat datang di Kinly",
    ),
  };
}
