// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
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
  String get localeName => 'ar';

  static String m0(env) => "بدء تشغيل Kinly (${env})";

  static String m1(time) => "مجدول عند ${time}";

  static String m2(client, current) =>
      "إصدارك: ${client}\nأحدث إصدار: ${current}";

  static String m3(appName) =>
      "صُنع باستخدام ${appName} - معًا يصبح كل شيء أخف";

  static String m4(link) =>
      "مشاركة لمحة من جدار الامتنان لدينا على Kinly. حمّل التطبيق: ${link}";

  static String m5(time) => "${time} اليوم";

  static String m6(count) =>
      "جدار الامتنان ${Intl.plural(count, one: '(#)', other: '(#)')}";

  static String m7(weeks) =>
      "${Intl.plural(weeks, zero: 'هذا الأسبوع', one: 'قبل أسبوع واحد', other: 'قبل # أسابيع')}";

  static String m8(partOfDay, name) => "صباح/مساء ${partOfDay}، ${name}";

  static String m9(link) => "شارك Kinly ليصبح التشارك أخف: ${link}";

  static String m10(code, link) =>
      "مرحبًا بك في منزلنا على Kinly! أدخل رمز الدعوة التالي: ${code}\n\nحمّل تطبيق Kinly: ${link}";

  static String m11(code) => "تم الانضمام باستخدام الرمز: ${code}";

  static String m12(price) => "${price} شهريًا لمنزلك بالكامل.";

  static String m13(paidAmount, totalAmount) =>
      "${paidAmount} من ${totalAmount} تم تحصيلها";

  static String m14(paid, total) => "${paid} من ${total} مدفوعة";

  static String m15(count) =>
      "عرض الكل ${Intl.plural(count, one: '(#)', other: '(#)')}";

  static String m16(count) =>
      "${Intl.plural(count, one: '${count} دفعة معلّقة', other: '${count} دفعات معلّقة')}";

  static String m17(count) =>
      "${Intl.plural(count, one: '${count} new payment to you', other: '${count} new payments to you')}";

  static String m18(homeId, role) =>
      "المنزل الحالي: ${homeId} • الدور: ${role}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("كينلي"),
    "authMembershipLoadFailed": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من تحديث عضوية منزلك. حاول مرة أخرى.",
    ),
    "bootstrap_initializing": m0,
    "connectionNotificationsPermissionBlocked":
        MessageLookupByLibrary.simpleMessage(
          "فعّل الإشعارات من إعدادات الهاتف لاستخدام هذه الميزة.",
        ),
    "connectionNotificationsTimeLabel": MessageLookupByLibrary.simpleMessage(
      "وقت التذكير",
    ),
    "connectionNotificationsTimeSubtitle": m1,
    "connectionNotificationsToggleSubtitleOff":
        MessageLookupByLibrary.simpleMessage("فعّل تذكيرات حول منزلك."),
    "connectionNotificationsToggleSubtitleOn":
        MessageLookupByLibrary.simpleMessage("تلقي تذكير واحد كل يوم."),
    "connectionNotificationsToggleTitle": MessageLookupByLibrary.simpleMessage(
      "إشعارات يومية",
    ),
    "connectionSettingsGenericError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحديث الإعدادات. حاول مرة أخرى.",
    ),
    "connectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "تحكم في التذكيرات اليومية ووقت الإشعارات.",
    ),
    "connectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "إعدادات الاتصال",
    ),
    "create_failed_generic": MessageLookupByLibrary.simpleMessage(
      "تعذّر إنشاء المنزل. حاول مرة أخرى.",
    ),
    "create_submit": MessageLookupByLibrary.simpleMessage("إنشاء منزل"),
    "create_subtitle": MessageLookupByLibrary.simpleMessage(
      "سنُنشئ منزلك فورًا. يمكنك تغيير الاسم ودعوة الآخرين لاحقًا.",
    ),
    "create_success": MessageLookupByLibrary.simpleMessage("تم إنشاء المنزل!"),
    "create_title": MessageLookupByLibrary.simpleMessage("إنشاء منزل"),
    "exploreFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "راجع كل Flow وحافظ على استمرارها",
    ),
    "exploreIntroSubtitle": MessageLookupByLibrary.simpleMessage(
      "استكشف طرقًا أكثر لجعل منزلك أخف.",
    ),
    "exploreShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "شاهد كل Share أنشأتها وتابع التحصيل.",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage("إسناد إلى"),
    "flowChoreAssigneeUnassigned": MessageLookupByLibrary.simpleMessage(
      "غير مُسند",
    ),
    "flowChoreCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء الـFlow.",
    ),
    "flowChoreCreateTitle": MessageLookupByLibrary.simpleMessage("إضافة Flow"),
    "flowChoreDeleteButton": MessageLookupByLibrary.simpleMessage("حذف Flow"),
    "flowChoreDeleteCancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "flowChoreDeleteConfirm": MessageLookupByLibrary.simpleMessage("حذف"),
    "flowChoreDeleteDialogMessage": MessageLookupByLibrary.simpleMessage(
      "سيؤدي هذا إلى إزالة الـ Flow للجميع في منزلك.",
    ),
    "flowChoreDeleteDialogTitle": MessageLookupByLibrary.simpleMessage(
      "حذف هذا الـ Flow؟",
    ),
    "flowChoreDetailCompleteButton": MessageLookupByLibrary.simpleMessage(
      "إكمال Flow",
    ),
    "flowChoreDetailCompletionError": MessageLookupByLibrary.simpleMessage(
      "تعذّر إكمال الـ Flow. حاول مرة أخرى.",
    ),
    "flowChoreDetailCompletionSuccess": MessageLookupByLibrary.simpleMessage(
      "اكتمل الـFlow.",
    ),
    "flowChoreDetailMoreInfoTitle": MessageLookupByLibrary.simpleMessage(
      "مزيد من التفاصيل",
    ),
    "flowChoreDetailNoHowTo": MessageLookupByLibrary.simpleMessage(
      "لا يوجد رابط إرشادي.",
    ),
    "flowChoreDetailNoNotes": MessageLookupByLibrary.simpleMessage(
      "لا توجد ملاحظات بعد.",
    ),
    "flowChoreDetailTitle": MessageLookupByLibrary.simpleMessage("تفاصيل Flow"),
    "flowChoreDetailUnassigned": MessageLookupByLibrary.simpleMessage(
      "غير مُسند",
    ),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage("تعديل Flow"),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "هذا العضو غير قابل للإسناد الآن.",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "ليست لديك صلاحية تغيير هذا الـ Flow.",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذّر حفظ الـ Flow. حاول مرة أخرى.",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "مسار الصورة غير صالح لهذا المنزل.",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخ بدء صالحًا.",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "هذا الـ Flow غير قابل للتحديث الآن.",
    ),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "لقد وصلت إلى الحد المجاني للـ Flows النشطة. قم بالترقية لإضافة المزيد.",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "لقد وصلت إلى الحد المجاني لصور التوقع. احذف واحدة أو قم بالترقية.",
    ),
    "flowChoreExpectationPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "صورة للتوقع",
    ),
    "flowChoreHowToHint": MessageLookupByLibrary.simpleMessage(
      "ألصق رابط فيديو أو مستند (اختياري)",
    ),
    "flowChoreHowToLabel": MessageLookupByLibrary.simpleMessage("رابط إرشادي"),
    "flowChoreHowToLaunchError": MessageLookupByLibrary.simpleMessage(
      "تعذّر فتح الرابط. حاول مرة أخرى.",
    ),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل هذا الـ Flow. حاول مرة أخرى.",
    ),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage(
      "امنح Flow عنوانًا قصيرًا وواضحًا",
    ),
    "flowChoreNameLabel": MessageLookupByLibrary.simpleMessage("اسم Flow"),
    "flowChoreNotesHint": MessageLookupByLibrary.simpleMessage(
      "أضف سياقًا أو تذكيرات اختيارية",
    ),
    "flowChoreNotesLabel": MessageLookupByLibrary.simpleMessage("ملاحظات"),
    "flowChorePhotoHint": MessageLookupByLibrary.simpleMessage(
      "storage/households/... (اختياري)",
    ),
    "flowChorePhotoLabel": MessageLookupByLibrary.simpleMessage("صورة للتوقع"),
    "flowChorePhotoLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل الصورة",
    ),
    "flowChorePhotoPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "إذن الكاميرا مطلوب لالتقاط صورة.",
    ),
    "flowChorePhotoPermissionOpenSettings":
        MessageLookupByLibrary.simpleMessage("فتح الإعدادات"),
    "flowChorePhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "أضف صورة لتوضيح ما الذي يبدو رائعًا",
    ),
    "flowChorePhotoUploadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر رفع الصورة. حاول مرة أخرى.",
    ),
    "flowChoreRecurrenceAnnual": MessageLookupByLibrary.simpleMessage("سنويًا"),
    "flowChoreRecurrenceDaily": MessageLookupByLibrary.simpleMessage("يوميًا"),
    "flowChoreRecurrenceEvery2Months": MessageLookupByLibrary.simpleMessage(
      "كل شهرين",
    ),
    "flowChoreRecurrenceEvery2Weeks": MessageLookupByLibrary.simpleMessage(
      "كل أسبوعين",
    ),
    "flowChoreRecurrenceLabel": MessageLookupByLibrary.simpleMessage("تكرار"),
    "flowChoreRecurrenceMonthly": MessageLookupByLibrary.simpleMessage(
      "شهريًا",
    ),
    "flowChoreRecurrenceNone": MessageLookupByLibrary.simpleMessage(
      "مرة واحدة",
    ),
    "flowChoreRecurrenceWeekly": MessageLookupByLibrary.simpleMessage(
      "أسبوعيًا",
    ),
    "flowChoreRetry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "flowChoreStartLabel": MessageLookupByLibrary.simpleMessage(
      "تاريخ الـ Flow",
    ),
    "flowChoreSubmitCreate": MessageLookupByLibrary.simpleMessage("إضافة Flow"),
    "flowChoreSubmitUpdate": MessageLookupByLibrary.simpleMessage("حفظ Flow"),
    "flowChoreUpdateSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تحديث الـFlow.",
    ),
    "flowChoreValidationAssignee": MessageLookupByLibrary.simpleMessage(
      "اختر شخصًا لإسناد هذا الـ Flow إليه.",
    ),
    "flowChoreValidationDate": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخًا خلال سنة من اليوم.",
    ),
    "flowChoreValidationHowToUrl": MessageLookupByLibrary.simpleMessage(
      "أدخل رابطًا صالحًا يبدأ بـ http أو https.",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage(
      "أدخل اسمًا لـ Flow.",
    ),
    "flowListDraftLabel": MessageLookupByLibrary.simpleMessage("مسودة"),
    "flowListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "أضف أول روتين ليعرف الجميع ما الذي يجب فعله.",
    ),
    "flowListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا يوجد شيء في Flow بعد",
    ),
    "flowListError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل Flow. اسحب للتحديث.",
    ),
    "flowListOverdueLabel": MessageLookupByLibrary.simpleMessage("متأخر"),
    "force_update_body": MessageLookupByLibrary.simpleMessage(
      "لم تعد هذه النسخة من Kinly مدعومة. يرجى تثبيت أحدث إصدار للمتابعة.",
    ),
    "force_update_button": MessageLookupByLibrary.simpleMessage("تحديث Kinly"),
    "force_update_notes_label": MessageLookupByLibrary.simpleMessage(
      "ما الجديد",
    ),
    "force_update_title": MessageLookupByLibrary.simpleMessage("التحديث مطلوب"),
    "force_update_version_details": m2,
    "friendDefaultName": MessageLookupByLibrary.simpleMessage("صديق"),
    "gratitudeWallEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "شارك لحظة جميلة لبدء ملء الجدار.",
    ),
    "gratitudeWallEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد منشورات امتنان بعد",
    ),
    "gratitudeWallFooter": m3,
    "gratitudeWallKinlySubtitle": MessageLookupByLibrary.simpleMessage(
      "يساعد Kinly منزلك على مشاركة لحظات امتنان صغيرة.",
    ),
    "gratitudeWallPoweredBy": MessageLookupByLibrary.simpleMessage("بدعم من"),
    "gratitudeWallRetry": MessageLookupByLibrary.simpleMessage("حاول مرة أخرى"),
    "gratitudeWallShareCta": MessageLookupByLibrary.simpleMessage(
      "مشاركة هذا الجدار",
    ),
    "gratitudeWallShareError": MessageLookupByLibrary.simpleMessage(
      "تعذّرت المشاركة الآن. حاول مرة أخرى.",
    ),
    "gratitudeWallShareMessage": m4,
    "gratitudeWallShareTitle": MessageLookupByLibrary.simpleMessage(
      "جدار الامتنان",
    ),
    "gratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "لحظات مشتركة من منزلك.",
    ),
    "gratitudeWallTimestamp": m5,
    "gratitudeWallTitle": MessageLookupByLibrary.simpleMessage("جدار الامتنان"),
    "gratitudeWallTitleCount": m6,
    "gratitudeWallWeeksAgo": m7,
    "greetingPartAfternoon": MessageLookupByLibrary.simpleMessage("بعد الظهر"),
    "greetingPartEvening": MessageLookupByLibrary.simpleMessage("المساء"),
    "greetingPartMorning": MessageLookupByLibrary.simpleMessage("الصباح"),
    "greetingPartOfDay": m8,
    "harmonyCommentHint": MessageLookupByLibrary.simpleMessage(
      "ما الذي يجعل المنزل يشعر بهذا الشكل؟",
    ),
    "harmonyCommentLabel": MessageLookupByLibrary.simpleMessage(
      "أضف ملاحظة (اختياري)",
    ),
    "harmonyEntryCta": MessageLookupByLibrary.simpleMessage(
      "شارك حالة هذا الأسبوع",
    ),
    "harmonyEntryError": MessageLookupByLibrary.simpleMessage(
      "تعذّر فتح انسجام المنزل. حاول مرة أخرى.",
    ),
    "harmonyErrorAlreadySubmitted": MessageLookupByLibrary.simpleMessage(
      "لقد شاركت حالتك لهذا الأسبوع بالفعل.",
    ),
    "harmonyErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "لا يمكنك إرسال الملاحظات لهذا المنزل.",
    ),
    "harmonyErrorSelectMood": MessageLookupByLibrary.simpleMessage(
      "اختر حالة قبل الإرسال.",
    ),
    "harmonyErrorUnknown": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ ما. حاول مرة أخرى.",
    ),
    "harmonyMoodCloudy": MessageLookupByLibrary.simpleMessage("غائم"),
    "harmonyMoodPartiallySunny": MessageLookupByLibrary.simpleMessage(
      "مشمس جزئيًا",
    ),
    "harmonyMoodRainy": MessageLookupByLibrary.simpleMessage("ممطر"),
    "harmonyMoodSunny": MessageLookupByLibrary.simpleMessage("مشمس"),
    "harmonyMoodThunderstorm": MessageLookupByLibrary.simpleMessage(
      "عاصفة رعدية",
    ),
    "harmonyQuestion": MessageLookupByLibrary.simpleMessage(
      "كيف يشعر منزلك هذا الأسبوع؟",
    ),
    "harmonyShareLabel": MessageLookupByLibrary.simpleMessage(
      "شارك هذا على جدار الامتنان",
    ),
    "harmonySubmitCta": MessageLookupByLibrary.simpleMessage("إرسال الملاحظات"),
    "harmonySubmitSuccess": MessageLookupByLibrary.simpleMessage(
      "شكرًا! تم حفظ ملاحظاتك.",
    ),
    "harmonySubtext": MessageLookupByLibrary.simpleMessage(
      "اختر الطقس الذي يطابق الأجواء واترك ملاحظة اختيارية.",
    ),
    "harmonyTitle": MessageLookupByLibrary.simpleMessage(
      "انسجام المنزل الأسبوعي",
    ),
    "hubCardGratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "اقرأ شكرًا سريعًا ولحظات صغيرة من التقدير.",
    ),
    "hubCardGratitudeWallTitle": MessageLookupByLibrary.simpleMessage(
      "جدار الامتنان",
    ),
    "hubCodeCopied": MessageLookupByLibrary.simpleMessage("تم نسخ رمز الدعوة"),
    "hubCopyCode": MessageLookupByLibrary.simpleMessage("نسخ رمز الدعوة"),
    "hubError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل المركز. حاول مرة أخرى.",
    ),
    "hubInviteCta": MessageLookupByLibrary.simpleMessage("دعوة"),
    "hubInviteUnavailable": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل الدعوة. حاول مرة أخرى.",
    ),
    "hubMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "لا يوجد أعضاء نشطون بعد.",
    ),
    "hubMembersSubtitle": MessageLookupByLibrary.simpleMessage(
      "الأشخاص النشطون حاليًا في هذا المنزل.",
    ),
    "hubMembersTitle": MessageLookupByLibrary.simpleMessage("أعضاء المنزل"),
    "hubQrSubtitle": MessageLookupByLibrary.simpleMessage("امسح لتحميل Kinly"),
    "hubQrTitle": MessageLookupByLibrary.simpleMessage("مشاركة التطبيق"),
    "hubRetry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "hubRotateError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تدوير الدعوة. حاول مرة أخرى.",
    ),
    "hubRotateInvite": MessageLookupByLibrary.simpleMessage("تدوير الدعوة"),
    "hubRotateSuccess": MessageLookupByLibrary.simpleMessage("تم تدوير الدعوة"),
    "hubShareAppBody": m9,
    "hubShareAppCta": MessageLookupByLibrary.simpleMessage("مشاركة Kinly"),
    "hubShareAppTitle": MessageLookupByLibrary.simpleMessage(
      "احصل على تطبيق Kinly",
    ),
    "hubShareInviteBody": m10,
    "hubShareInviteTitle": MessageLookupByLibrary.simpleMessage(
      "دعوة إلى منزلي على Kinly",
    ),
    "join_error_already_in_other_home": MessageLookupByLibrary.simpleMessage(
      "أنت بالفعل في منزل آخر. غادره قبل الانضمام إلى منزل جديد.",
    ),
    "join_error_forbidden": MessageLookupByLibrary.simpleMessage(
      "ليست لديك صلاحية الانضمام إلى هذا المنزل.",
    ),
    "join_error_inactive_invite": MessageLookupByLibrary.simpleMessage(
      "هذه الدعوة لم تعد نشطة. اطلب من المالك رمزًا جديدًا.",
    ),
    "join_error_invalid_code": MessageLookupByLibrary.simpleMessage(
      "رمز الدعوة يبدو غير صحيح.",
    ),
    "join_error_paywall_limit": MessageLookupByLibrary.simpleMessage(
      "وصل هذا المنزل إلى الحد الأقصى للأعضاء. اطلب من المالك الترقية أو إزالة عضو.",
    ),
    "join_error_unauthorized": MessageLookupByLibrary.simpleMessage(
      "يرجى تسجيل الدخول للانضمام إلى هذا المنزل.",
    ),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من الانضمام إلى هذا المنزل. يرجى المحاولة مرة أخرى.",
    ),
    "join_hint": MessageLookupByLibrary.simpleMessage("أدخل رمز الدعوة"),
    "join_submit": MessageLookupByLibrary.simpleMessage("انضمام"),
    "join_success": m11,
    "join_title": MessageLookupByLibrary.simpleMessage("الانضمام إلى منزل"),
    "login_consent_connector": MessageLookupByLibrary.simpleMessage(" و"),
    "login_consent_prefix": MessageLookupByLibrary.simpleMessage(
      "لقد قرأت ووافقت على ",
    ),
    "login_privacy": MessageLookupByLibrary.simpleMessage("سياسة الخصوصية"),
    "login_tagline": MessageLookupByLibrary.simpleMessage(
      "معًا يصبح كل شيء أخف",
    ),
    "login_terms": MessageLookupByLibrary.simpleMessage("شروط الخدمة"),
    "login_with_apple": MessageLookupByLibrary.simpleMessage(
      "المتابعة باستخدام Apple",
    ),
    "login_with_google": MessageLookupByLibrary.simpleMessage(
      "المتابعة باستخدام Google",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
    "membership_status_active": MessageLookupByLibrary.simpleMessage(
      "أنت بالفعل ضمن منزل.",
    ),
    "membership_status_checking": MessageLookupByLibrary.simpleMessage(
      "جارٍ التحقق من حالة العضوية…",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "لم تنضم إلى أي منزل بعد.",
    ),
    "navExplore": MessageLookupByLibrary.simpleMessage("استكشاف"),
    "navHub": MessageLookupByLibrary.simpleMessage("المركز"),
    "navToday": MessageLookupByLibrary.simpleMessage("اليوم"),
    "npsCannotSkip": MessageLookupByLibrary.simpleMessage(
      "يجب اختيار تقييم للمتابعة.",
    ),
    "npsDescription": MessageLookupByLibrary.simpleMessage(
      "يساعدنا مؤشر صافي المروجين (NPS) على فهم أدائنا. اختر رقمًا من 0 (غير محتمل) إلى 10 (محتمل جدًا).",
    ),
    "npsEmailSubject": MessageLookupByLibrary.simpleMessage(
      "ما الذي يمكننا تحسينه؟",
    ),
    "npsLaunchError": MessageLookupByLibrary.simpleMessage(
      "تعذّر فتح الخطوة التالية.",
    ),
    "npsScaleHighLabel": MessageLookupByLibrary.simpleMessage("10 محتمل جدًا"),
    "npsScaleLowLabel": MessageLookupByLibrary.simpleMessage("0 غير محتمل"),
    "npsSubmitErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "غير مسموح لك بإرسال الملاحظات الآن.",
    ),
    "npsSubmitErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذّر إرسال ملاحظاتك. حاول مرة أخرى.",
    ),
    "npsSubmitErrorInvalidScore": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار رقم بين 0 و10.",
    ),
    "npsSubmitErrorNotRequired": MessageLookupByLibrary.simpleMessage(
      "هذه الملاحظات غير مطلوبة الآن.",
    ),
    "npsTitle": MessageLookupByLibrary.simpleMessage(
      "ما مدى احتمالية أن توصي بـ Kinly لصديق؟",
    ),
    "offline_body": MessageLookupByLibrary.simpleMessage(
      "يحتاج Kinly إلى اتصال بالإنترنت. تحقّق من الشبكة وحاول مرة أخرى.",
    ),
    "offline_retry": MessageLookupByLibrary.simpleMessage("حاول مرة أخرى"),
    "offline_title": MessageLookupByLibrary.simpleMessage("أنت غير متصل"),
    "paywallBulletFlows": MessageLookupByLibrary.simpleMessage(
      "Flows غير محدودة",
    ),
    "paywallBulletMembers": MessageLookupByLibrary.simpleMessage(
      "أعضاء غير محدودين للمنزل",
    ),
    "paywallBulletPhotos": MessageLookupByLibrary.simpleMessage(
      "صور Flow غير محدودة",
    ),
    "paywallBulletShares": MessageLookupByLibrary.simpleMessage(
      "مصاريف مشتركة غير محدودة",
    ),
    "paywallErrorTitle": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل صفحة الترقية.",
    ),
    "paywallPriceCaption": MessageLookupByLibrary.simpleMessage(
      "خطة واحدة للمنزل، بدون مستويات مخفية.",
    ),
    "paywallPricePerMonth": m12,
    "paywallPriceUnavailable": MessageLookupByLibrary.simpleMessage(
      "التسعير غير متاح الآن.",
    ),
    "paywallPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "الترقية إلى Kinly Premium",
    ),
    "paywallPurchaseFailed": MessageLookupByLibrary.simpleMessage(
      "لم تكتمل عملية الشراء — يمكنك المحاولة لاحقًا.",
    ),
    "paywallPurchaseSuccess": MessageLookupByLibrary.simpleMessage(
      "أنت الآن على Kinly Premium.",
    ),
    "paywallRestoreCta": MessageLookupByLibrary.simpleMessage(
      "استعادة المشتريات",
    ),
    "paywallRetryLabel": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "paywallSecondaryCta": MessageLookupByLibrary.simpleMessage(
      "المتابعة مع المنزل المجاني",
    ),
    "paywallSubtitle": MessageLookupByLibrary.simpleMessage(
      "ترقية على مستوى المنزل بأقل من 0.5% من الإيجار.",
    ),
    "paywallTitle": MessageLookupByLibrary.simpleMessage(
      "مزيد من الانسجام لمنزلك",
    ),
    "profileActionCancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "profileActionConfirm": MessageLookupByLibrary.simpleMessage(
      "مغادرة المنزل",
    ),
    "profileActionConfirmDelete": MessageLookupByLibrary.simpleMessage(
      "حذف الحساب",
    ),
    "profileConfirmDeleteMessage": MessageLookupByLibrary.simpleMessage(
      "سيؤدي هذا إلى حذف حسابك وتسجيل خروجك. لا يمكنك التراجع عن ذلك.",
    ),
    "profileConfirmDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "حذف حسابك؟",
    ),
    "profileConfirmLeaveMessage": MessageLookupByLibrary.simpleMessage(
      "ستفقد الوصول إلى Flow والسجل والدعوات.",
    ),
    "profileConfirmLeaveTitle": MessageLookupByLibrary.simpleMessage(
      "مغادرة هذا المنزل؟",
    ),
    "profileConnectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "إدارة الإشعارات والتذكيرات.",
    ),
    "profileConnectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "إعدادات الاتصال",
    ),
    "profileContactEmailSubject": MessageLookupByLibrary.simpleMessage(
      "تواصل معنا",
    ),
    "profileContactLaunchError": MessageLookupByLibrary.simpleMessage(
      "تعذّر فتح تطبيق البريد. حاول مرة أخرى.",
    ),
    "profileContactUsSubtitle": MessageLookupByLibrary.simpleMessage(
      "راسل support@makinglifeeasie.com",
    ),
    "profileContactUsTitle": MessageLookupByLibrary.simpleMessage("تواصل معنا"),
    "profileDeleteAccountSubtitle": MessageLookupByLibrary.simpleMessage(
      "إزالة حساب Kinly وبيانات الملف الشخصي.",
    ),
    "profileDeleteAccountTitle": MessageLookupByLibrary.simpleMessage(
      "حذف الحساب",
    ),
    "profileDeleteSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "سيُحذف حسابك قريبًا. سنقوم بتسجيل خروجك.",
    ),
    "profileGenericError": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ ما. حاول مرة أخرى.",
    ),
    "profileIdentityAvatarEmpty": MessageLookupByLibrary.simpleMessage(
      "لا توجد صور رمزية متاحة الآن. حاول لاحقًا.",
    ),
    "profileIdentityAvatarSectionDescription":
        MessageLookupByLibrary.simpleMessage("كل صورة رمزية فريدة داخل منزلك."),
    "profileIdentityAvatarSectionTitle": MessageLookupByLibrary.simpleMessage(
      "اختر صورة رمزية",
    ),
    "profileIdentityLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل ملفك الشخصي الآن.",
    ),
    "profileIdentityRetry": MessageLookupByLibrary.simpleMessage(
      "إعادة المحاولة",
    ),
    "profileIdentitySaveButton": MessageLookupByLibrary.simpleMessage(
      "حفظ التغييرات",
    ),
    "profileIdentitySubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر اسم مستخدم وصورة رمزية داخل منزلك.",
    ),
    "profileIdentitySuccessMessage": MessageLookupByLibrary.simpleMessage(
      "تم تحديث الملف الشخصي.",
    ),
    "profileIdentityTitle": MessageLookupByLibrary.simpleMessage(
      "تعديل الملف الشخصي",
    ),
    "profileIdentityUsernameEmptyError": MessageLookupByLibrary.simpleMessage(
      "أدخل اسم مستخدم للمتابعة.",
    ),
    "profileIdentityUsernameFormatError": MessageLookupByLibrary.simpleMessage(
      "استخدم 3-30 حرفًا/رقمًا صغيرًا. يمكنك استخدام النقاط أو الشرطات السفلية في الوسط.",
    ),
    "profileIdentityUsernameHint": MessageLookupByLibrary.simpleMessage(
      "حروف، أرقام، . أو _",
    ),
    "profileIdentityUsernameLabel": MessageLookupByLibrary.simpleMessage(
      "اسم المستخدم",
    ),
    "profileIdentityUsernamePreviewFallback":
        MessageLookupByLibrary.simpleMessage("اسم المستخدم الخاص بك"),
    "profileIdentityUsernameTakenError": MessageLookupByLibrary.simpleMessage(
      "هذا الاسم مستخدم. جرّب اسمًا آخر.",
    ),
    "profileInfoHubLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل مركز المعلومات. تحقّق من اتصالك.",
    ),
    "profileInfoHubSubtitle": MessageLookupByLibrary.simpleMessage(
      "افتح مركز Kinly على Notion داخل التطبيق.",
    ),
    "profileInfoHubTitle": MessageLookupByLibrary.simpleMessage(
      "مركز المعلومات",
    ),
    "profileKickActionConfirm": MessageLookupByLibrary.simpleMessage(
      "إزالة العضو",
    ),
    "profileKickMemberSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر من سيفقد الوصول إلى هذا المنزل.",
    ),
    "profileKickMemberTitle": MessageLookupByLibrary.simpleMessage("إزالة عضو"),
    "profileKickNoMembers": MessageLookupByLibrary.simpleMessage(
      "لا يوجد أعضاء آخرون لإزالتهم الآن.",
    ),
    "profileKickOwnerOnly": MessageLookupByLibrary.simpleMessage(
      "فقط مالك المنزل يمكنه إزالة الأعضاء.",
    ),
    "profileKickSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر عضوًا لإزالته. سيفقد الوصول فورًا.",
    ),
    "profileKickSheetTitle": MessageLookupByLibrary.simpleMessage("إزالة عضو"),
    "profileKickSuccessClose": MessageLookupByLibrary.simpleMessage(
      "العودة إلى الإعدادات",
    ),
    "profileKickSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "لم يعد لديه وصول إلى هذا المنزل.",
    ),
    "profileKickSuccessTitle": MessageLookupByLibrary.simpleMessage(
      "تمت إزالة العضو",
    ),
    "profileLeaveEligibilityError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل أعضاء المنزل. حاول مرة أخرى.",
    ),
    "profileLeaveEligibilityLoading": MessageLookupByLibrary.simpleMessage(
      "جارٍ التحقق من أعضاء المنزل…",
    ),
    "profileLeaveHomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "مغادرة هذا المنزل تعني الخروج من مساحة Kinly المشتركة.",
    ),
    "profileLeaveHomeTitle": MessageLookupByLibrary.simpleMessage(
      "مغادرة المنزل",
    ),
    "profileLeaveOwnerNoEligibleMembers": MessageLookupByLibrary.simpleMessage(
      "لا يمكن لأي شخص آخر تولّي الملكية الآن. حاول لاحقًا.",
    ),
    "profileLeaveOwnerSoloMessage": MessageLookupByLibrary.simpleMessage(
      "أنت العضو الأخير. المغادرة ستؤدي إلى تعطيل هذا المنزل للجميع.",
    ),
    "profileLeaveSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "لقد غادرت منزلك.",
    ),
    "profileLeaveTransferSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر من سيصبح المالك الجديد قبل مغادرتك.",
    ),
    "profileLeaveTransferSheetTitle": MessageLookupByLibrary.simpleMessage(
      "نقل الملكية",
    ),
    "profileLeaveTransferSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "تم نقل الملكية. جارٍ إكمال المغادرة…",
    ),
    "profileLogoutDialogMessage": MessageLookupByLibrary.simpleMessage(
      "ستحتاج لتسجيل الدخول مجددًا للوصول إلى منزلك.",
    ),
    "profileLogoutDialogTitle": MessageLookupByLibrary.simpleMessage(
      "تسجيل الخروج؟",
    ),
    "profileLogoutSubtitle": MessageLookupByLibrary.simpleMessage(
      "تسجيل الخروج من Kinly على هذا الجهاز.",
    ),
    "profileLogoutTitle": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
    "profileMissingHomeError": MessageLookupByLibrary.simpleMessage(
      "تعذّر العثور على منزلك الحالي. حاول مرة أخرى.",
    ),
    "profileSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "إدارة تفضيلات الحساب والوصول إلى المنزل.",
    ),
    "profileSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "الملف الشخصي والمنزل",
    ),
    "quick_add_fair_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "تسجيل إدخال للإنصاف",
    ),
    "quick_add_fair_share_title": MessageLookupByLibrary.simpleMessage(
      "تقسيم عادل",
    ),
    "quick_add_flow_subtitle": MessageLookupByLibrary.simpleMessage(
      "إضافة Flow",
    ),
    "quick_add_flow_title": MessageLookupByLibrary.simpleMessage("Flow"),
    "quick_add_poll_subtitle": MessageLookupByLibrary.simpleMessage(
      "إنشاء استطلاع منزلي سريع",
    ),
    "quick_add_poll_title": MessageLookupByLibrary.simpleMessage("استطلاع"),
    "quick_add_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "تسجيل Share",
    ),
    "quick_add_share_title": MessageLookupByLibrary.simpleMessage("Share"),
    "quick_add_title": MessageLookupByLibrary.simpleMessage("إضافة سريعة"),
    "shareCreateAmountHint": MessageLookupByLibrary.simpleMessage("0.00"),
    "shareCreateAmountLabel": MessageLookupByLibrary.simpleMessage("المبلغ"),
    "shareCreateCustomAmountLabel": MessageLookupByLibrary.simpleMessage(
      "المبلغ",
    ),
    "shareCreateCustomHelper": MessageLookupByLibrary.simpleMessage(
      "أدخل حصة كل شخص. تأكد أن المجموع يطابق المبلغ أعلاه.",
    ),
    "shareCreateDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "مثال: مشتريات بقالة",
    ),
    "shareCreateDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "الوصف",
    ),
    "shareCreateErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "ليست لديك صلاحية الإنشاء الآن.",
    ),
    "shareCreateErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذّر الإنشاء. حاول مرة أخرى.",
    ),
    "shareCreateErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "لقد وصلت إلى الحد المجاني وهو 10 مشاركات نشطة أو مسودات. أغلق واحدة أو ألغِها للمتابعة.",
    ),
    "shareCreateLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل أعضاء المنزل.",
    ),
    "shareCreateNotesHint": MessageLookupByLibrary.simpleMessage(
      "سياق اختياري يراه الجميع",
    ),
    "shareCreateNotesLabel": MessageLookupByLibrary.simpleMessage("ملاحظات"),
    "shareCreateParticipantsEmpty": MessageLookupByLibrary.simpleMessage(
      "تحتاج إلى عضوين على الأقل في المنزل للمشاركة.",
    ),
    "shareCreateParticipantsLabel": MessageLookupByLibrary.simpleMessage(
      "من يشارك؟",
    ),
    "shareCreateRetry": MessageLookupByLibrary.simpleMessage("حاول مرة أخرى"),
    "shareCreateSplitCustom": MessageLookupByLibrary.simpleMessage(
      "تقسيم مخصص",
    ),
    "shareCreateSplitEqual": MessageLookupByLibrary.simpleMessage(
      "تقسيم تلقائي",
    ),
    "shareCreateSplitLabel": MessageLookupByLibrary.simpleMessage(
      "نوع التقسيم",
    ),
    "shareCreateSubmit": MessageLookupByLibrary.simpleMessage("إنشاء"),
    "shareCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء Share.",
    ),
    "shareCreateTitle": MessageLookupByLibrary.simpleMessage("إنشاء"),
    "shareCreateValidationAmount": MessageLookupByLibrary.simpleMessage(
      "أدخل مبلغًا صالحًا أكبر من صفر.",
    ),
    "shareCreateValidationCustomAmounts": MessageLookupByLibrary.simpleMessage(
      "أدخل مبلغًا صالحًا لكل شخص محدد.",
    ),
    "shareCreateValidationCustomParticipants":
        MessageLookupByLibrary.simpleMessage(
          "التقسيم المخصص يحتاج إلى شخصين على الأقل.",
        ),
    "shareCreateValidationCustomSinglePayer":
        MessageLookupByLibrary.simpleMessage(
          "قسّم المبلغ بين شخصين على الأقل عند استخدام التقسيم المخصص.",
        ),
    "shareCreateValidationCustomSum": MessageLookupByLibrary.simpleMessage(
      "تأكد أن التقسيم المخصص يساوي المبلغ أعلاه.",
    ),
    "shareCreateValidationDescription": MessageLookupByLibrary.simpleMessage(
      "أدخل وصفًا.",
    ),
    "shareCreateValidationEqualParticipants":
        MessageLookupByLibrary.simpleMessage(
          "اختر شخصين على الأقل لتقسيم المبلغ.",
        ),
    "shareCreateValidationSplit": MessageLookupByLibrary.simpleMessage(
      "اختر طريقة المشاركة.",
    ),
    "shareCreatedListActiveAmount": m13,
    "shareCreatedListActiveSubtitle": m14,
    "shareCreatedListDraftBadge": MessageLookupByLibrary.simpleMessage(
      "غير مُسند",
    ),
    "shareCreatedListDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "قسّمها لإسناد حصة كل شخص قبل النشر.",
    ),
    "shareCreatedListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "أنشئ Share لتظهر هنا.",
    ),
    "shareCreatedListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد مشاركات بعد",
    ),
    "shareCreatedListError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل Shares الخاصة بك. اسحب للتحديث.",
    ),
    "shareCreatedListPaidBadge": MessageLookupByLibrary.simpleMessage(
      "مُسدَّد بالكامل",
    ),
    "shareCreatedListRetry": MessageLookupByLibrary.simpleMessage(
      "حاول مرة أخرى",
    ),
    "shareCreatedListTitle": MessageLookupByLibrary.simpleMessage(
      "Share الخاصة بك",
    ),
    "shareEditClose": MessageLookupByLibrary.simpleMessage("إغلاق"),
    "shareEditDeleteButton": MessageLookupByLibrary.simpleMessage("حذف"),
    "shareEditDeleteCancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "shareEditDeleteConfirm": MessageLookupByLibrary.simpleMessage("حذف"),
    "shareEditDeleteConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "سيؤدي هذا إلى إزالة المسودة للجميع.",
    ),
    "shareEditDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage("حذف؟"),
    "shareEditDeleteError": MessageLookupByLibrary.simpleMessage(
      "تعذّر الحذف. حاول مرة أخرى.",
    ),
    "shareEditDeleteSuccess": MessageLookupByLibrary.simpleMessage(
      "تم حذف Share.",
    ),
    "shareEditLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل هذه المسودة.",
    ),
    "shareEditNotAllowed": MessageLookupByLibrary.simpleMessage(
      "هذا مقفل حتى تُسند الـ Share إلى شخص.",
    ),
    "shareEditSplitsLocked": MessageLookupByLibrary.simpleMessage(
      "التقسيمات مقفلة لأن شخصًا ما دفع بالفعل. لا يزال بإمكانك تحديث الوصف والملاحظات.",
    ),
    "shareEditSubmit": MessageLookupByLibrary.simpleMessage("تحديث"),
    "shareEditSuccess": MessageLookupByLibrary.simpleMessage("تم تحديث Share."),
    "shareEditTitle": MessageLookupByLibrary.simpleMessage("تعديل Share"),
    "shareOwedDetailEmpty": MessageLookupByLibrary.simpleMessage(
      "أنت مُسدِّد بالكامل مع هذا الشخص.",
    ),
    "shareOwedDetailError": MessageLookupByLibrary.simpleMessage(
      "تعذّر وضع علامة مدفوع. حاول مرة أخرى.",
    ),
    "shareOwedDetailPaid": MessageLookupByLibrary.simpleMessage("تحديد كمدفوع"),
    "shareOwedDetailSelectionLabel": MessageLookupByLibrary.simpleMessage(
      "اختر من تريد المشاركة معه.",
    ),
    "shareOwedDetailSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر الـ Share الذي قمت بتسويته للتو.",
    ),
    "shareOwedDetailSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تسجيل الدفع.",
    ),
    "shareOwedDetailTitle": MessageLookupByLibrary.simpleMessage("دفعة معلّقة"),
    "todayAddSheetFlow": MessageLookupByLibrary.simpleMessage("إضافة Flow"),
    "todayAddSheetShare": MessageLookupByLibrary.simpleMessage("إضافة Share"),
    "todayAddSheetTitle": MessageLookupByLibrary.simpleMessage("أضف إلى منزلك"),
    "todayEmptyBody": MessageLookupByLibrary.simpleMessage(
      "استمتع بالهدوء — سيخبرك Kinly عندما يحتاج شيء إلى انتباهك.",
    ),
    "todayEmptyCardBadge": MessageLookupByLibrary.simpleMessage(
      "استراحة قصيرة",
    ),
    "todayEmptyCardTitle": MessageLookupByLibrary.simpleMessage(
      "كل شيء مُنجز اليوم",
    ),
    "todayFlatmateInviteSubtitle": MessageLookupByLibrary.simpleMessage(
      "شارك دعوتك لتقسيم المهام المنزلية معًا.",
    ),
    "todayFlatmateInviteTitle": MessageLookupByLibrary.simpleMessage(
      "ادعُ شريك السكن",
    ),
    "todayFlowBadgeNew": MessageLookupByLibrary.simpleMessage("جديد اليوم"),
    "todayFlowSectionTitle": MessageLookupByLibrary.simpleMessage("Flow"),
    "todayFlowSeeAll": m15,
    "todayFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "إليك ما يجري في منزلك اليوم.",
    ),
    "todayFlowTabActive": MessageLookupByLibrary.simpleMessage("نشط"),
    "todayFlowTabDrafts": MessageLookupByLibrary.simpleMessage("مسودات"),
    "todayGratitudeOpenCta": MessageLookupByLibrary.simpleMessage("عرض الجدار"),
    "todayGratitudeSectionTitle": MessageLookupByLibrary.simpleMessage(
      "جدار امتنان المنزل",
    ),
    "todayGratitudeUnreadBody": MessageLookupByLibrary.simpleMessage(
      "هناك منشورات امتنان جديدة بانتظارك.",
    ),
    "todayInviteFriendsSubtitle": MessageLookupByLibrary.simpleMessage(
      "شارك Kinly مع صديق ليضيف انسجامًا أكبر إلى منزله أيضًا.",
    ),
    "todayInviteFriendsTitle": MessageLookupByLibrary.simpleMessage(
      "ادعُ أصدقاء إلى Kinly",
    ),
    "todayInviteNotNow": MessageLookupByLibrary.simpleMessage("ليس الآن"),
    "todayInviteShareCta": MessageLookupByLibrary.simpleMessage(
      "مشاركة الدعوة",
    ),
    "todayShareActiveSubtitle": m16,
    "todayShareBadgeUpcoming": MessageLookupByLibrary.simpleMessage("قادمة"),
    "todayShareDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "قسّم بناءً على الـ Share.",
    ),
    "todayShareEmptyState": MessageLookupByLibrary.simpleMessage(
      "لا يوجد شيء هنا بعد.",
    ),
    "todayShareError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحديث Share الآن.",
    ),
    "todaySharePaidSubtitle": MessageLookupByLibrary.simpleMessage(
      "Paid to you",
    ),
    "todaySharePaidUnseen": m17,
    "todayShareSampleGroceries": MessageLookupByLibrary.simpleMessage(
      "مشتريات مشتركة من الأمس",
    ),
    "todayShareSampleInternet": MessageLookupByLibrary.simpleMessage(
      "فاتورة الإنترنت هذا الأسبوع",
    ),
    "todayShareSampleRent": MessageLookupByLibrary.simpleMessage(
      "تذكير الإيجار قريبًا",
    ),
    "todayShareSectionTitle": MessageLookupByLibrary.simpleMessage("Share"),
    "todayShareSeeAll": MessageLookupByLibrary.simpleMessage(
      "عرض كل المشاركات",
    ),
    "todayShareTabActive": MessageLookupByLibrary.simpleMessage("To pay"),
    "todayShareTabDrafts": MessageLookupByLibrary.simpleMessage("مسودات"),
    "todayShareTabPaidToMe": MessageLookupByLibrary.simpleMessage("Paid to me"),
    "today_home_details": m18,
    "today_no_membership": MessageLookupByLibrary.simpleMessage(
      "لا يوجد منزل نشط بعد. أنشئ منزلًا أو انضم إلى واحد لرؤية صفحة اليوم.",
    ),
    "today_title": MessageLookupByLibrary.simpleMessage("اليوم"),
    "unknownInitial": MessageLookupByLibrary.simpleMessage("؟"),
    "welcome_create": MessageLookupByLibrary.simpleMessage("إنشاء منزل"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("الانضمام إلى منزل"),
    "welcome_title": MessageLookupByLibrary.simpleMessage("مرحبًا بك في Kinly"),
  };
}
