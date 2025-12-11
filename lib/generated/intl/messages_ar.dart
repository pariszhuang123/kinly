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

  static String m0(env) => "جارٍ تشغيل Kinly ‏(${env})";

  static String m1(time) => "محدّد عند الساعة ${time}";

  static String m2(client, current) =>
      "إصدارك: ${client}\nأحدث إصدار: ${current}";

  static String m3(appName) => "صُنع بواسطة ${appName} - معًا يصبح العبء أخف";

  static String m4(link) =>
      "أشارككم لمحة من جدار الامتنان في منزلنا على Kinly. حمّل التطبيق: ${link}";

  static String m5(time) => "${time} اليوم";

  static String m6(count) => "جدار الامتنان (${count})";

  static String m7(weeks) =>
      "${Intl.plural(weeks, zero: 'هذا الأسبوع', one: 'قبل أسبوع واحد', other: 'قبل ${weeks} أسابيع')}";

  static String m8(partOfDay, name) => "صباح/مساء الخير يا ${name}";

  static String m9(link) => "شارك Kinly حتى يصبح تقاسم الأعباء أخف: ${link}";

  static String m10(code, link) =>
      "مرحبًا بك في منزلنا على Kinly! أدخل رمز الدعوة هذا: ${code}\n\nحمّل تطبيق Kinly: ${link}";

  static String m11(code) => "تم الانضمام باستخدام الرمز: ${code}";

  static String m12(price) => "${price} ?????? ????? ???????.";

  static String m13(paidAmount, totalAmount) =>
      "${paidAmount} من ${totalAmount} تم تحصيلها";

  static String m14(paid, total) => "${paid} من ${total} مدفوعة";

  static String m15(count) => "عرض الكل (${count})";

  static String m16(count) =>
      "${Intl.plural(count, one: '${count} دفعة معلّقة', other: '${count} دفعات معلّقة')}";

  static String m17(homeId, role) =>
      "المنزل الحالي: ${homeId} • الدور: ${role}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("Kinly"),
    "authMembershipLoadFailed": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحديث عضويتك المنزلية. حاول مرة أخرى.",
    ),
    "bootstrap_initializing": m0,
    "connectionNotificationsPermissionBlocked":
        MessageLookupByLibrary.simpleMessage(
          "اسمح للإشعارات من إعدادات هاتفك لتفعيل هذا الخيار.",
        ),
    "connectionNotificationsTimeLabel": MessageLookupByLibrary.simpleMessage(
      "وقت التذكير",
    ),
    "connectionNotificationsTimeSubtitle": m1,
    "connectionNotificationsToggleSubtitleOff":
        MessageLookupByLibrary.simpleMessage(
          "قم بتفعيل التذكيرات المتعلقة بمنزلك.",
        ),
    "connectionNotificationsToggleSubtitleOn":
        MessageLookupByLibrary.simpleMessage("استلم تذكيرًا واحدًا كل يوم."),
    "connectionNotificationsToggleTitle": MessageLookupByLibrary.simpleMessage(
      "الإشعارات اليومية",
    ),
    "connectionSettingsGenericError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحديث إعدادات الاتصال. حاول مرة أخرى.",
    ),
    "connectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "تحكّم بالتذكيرات اليومية وتوقيت الإشعارات.",
    ),
    "connectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "إعدادات الاتصال",
    ),
    "create_failed_generic": MessageLookupByLibrary.simpleMessage(
      "تعذّر إنشاء المنزل. حاول مرة أخرى.",
    ),
    "create_submit": MessageLookupByLibrary.simpleMessage("إنشاء المنزل"),
    "create_subtitle": MessageLookupByLibrary.simpleMessage(
      "سنُجهّز منزلك فورًا. يمكنك إعادة تسميته ودعوة الآخرين لاحقًا.",
    ),
    "create_success": MessageLookupByLibrary.simpleMessage("تم إنشاء المنزل!"),
    "create_title": MessageLookupByLibrary.simpleMessage("إنشاء منزل"),
    "dopamineFlowAffirmation": MessageLookupByLibrary.simpleMessage(
      "شكرًا لك، منزلك أصبح أخف شعورًا.",
    ),
    "exploreFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "راجع كل Flow وأبقِ الأمور في حركة",
    ),
    "exploreIntroSubtitle": MessageLookupByLibrary.simpleMessage(
      "استكشف المزيد من الطرق لجعل منزلك أخف شعورًا.",
    ),
    "exploreIntroTitle": MessageLookupByLibrary.simpleMessage(
      "اكتشف ما هو التالي",
    ),
    "exploreShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "شاهد كل Share أنشأته وتابع عمليات التحصيل.",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage("تعيين إلى"),
    "flowChoreAssigneeUnassigned": MessageLookupByLibrary.simpleMessage(
      "غير معيَّن",
    ),
    "flowChoreCreateTitle": MessageLookupByLibrary.simpleMessage("إضافة Flow"),
    "flowChoreDeleteButton": MessageLookupByLibrary.simpleMessage(
      "حذف الـFlow",
    ),
    "flowChoreDeleteCancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "flowChoreDeleteConfirm": MessageLookupByLibrary.simpleMessage("حذف"),
    "flowChoreDeleteDialogMessage": MessageLookupByLibrary.simpleMessage(
      "سيتم حذف الـFlow للجميع في منزلك.",
    ),
    "flowChoreDeleteDialogTitle": MessageLookupByLibrary.simpleMessage(
      "حذف هذا الـFlow؟",
    ),
    "flowChoreDetailCompleteButton": MessageLookupByLibrary.simpleMessage(
      "إكمال الـFlow",
    ),
    "flowChoreDetailCompletionError": MessageLookupByLibrary.simpleMessage(
      "تعذّر إكمال الـFlow. حاول مرة أخرى.",
    ),
    "flowChoreDetailMoreInfoTitle": MessageLookupByLibrary.simpleMessage(
      "مزيد من التفاصيل",
    ),
    "flowChoreDetailNoHowTo": MessageLookupByLibrary.simpleMessage(
      "لم يتم توفير رابط إرشادي.",
    ),
    "flowChoreDetailNoNotes": MessageLookupByLibrary.simpleMessage(
      "لا توجد ملاحظات بعد.",
    ),
    "flowChoreDetailTitle": MessageLookupByLibrary.simpleMessage(
      "تفاصيل الـFlow",
    ),
    "flowChoreDetailUnassigned": MessageLookupByLibrary.simpleMessage(
      "غير معيَّن",
    ),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage("تعديل Flow"),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "لا يمكن تعيين هذا العضو حاليًا.",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "ليس لديك صلاحية تعديل هذا الـFlow.",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذّر حفظ الـFlow. حاول مرة أخرى.",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "مسار الصورة غير صالح لهذا المنزل.",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخ بدء صالحًا.",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "لا يمكن تحديث هذا الـFlow في الوقت الحالي.",
    ),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "وصلت إلى الحد المجاني للـFlows النشِطة. قم بالترقية لإضافة المزيد.",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "وصلت إلى الحد المجاني لصور التوقع. أزل صورة أو قم بالترقية.",
    ),
    "flowChoreExpectationPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "صورة متوقَّعة",
    ),
    "flowChoreHowToHint": MessageLookupByLibrary.simpleMessage(
      "ألصِق رابط فيديو أو مستند (اختياري)",
    ),
    "flowChoreHowToLabel": MessageLookupByLibrary.simpleMessage("رابط إرشادي"),
    "flowChoreHowToLaunchError": MessageLookupByLibrary.simpleMessage(
      "تعذّر فتح الرابط. حاول مرة أخرى.",
    ),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل هذا الـFlow. حاول مرة أخرى.",
    ),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage(
      "امنح الـFlow عنوانًا قصيرًا وواضحًا",
    ),
    "flowChoreNameLabel": MessageLookupByLibrary.simpleMessage("اسم الـFlow"),
    "flowChoreNotesHint": MessageLookupByLibrary.simpleMessage(
      "أضف سياقًا اختياريًا أو تذكيرات",
    ),
    "flowChoreNotesLabel": MessageLookupByLibrary.simpleMessage("ملاحظات"),
    "flowChorePhotoHint": MessageLookupByLibrary.simpleMessage(
      "storage/households/... ‏(اختياري)",
    ),
    "flowChorePhotoLabel": MessageLookupByLibrary.simpleMessage(
      "صورة متوقَّعة",
    ),
    "flowChorePhotoLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل الصورة",
    ),
    "flowChorePhotoPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "إذن الكاميرا مطلوب لالتقاط صورة.",
    ),
    "flowChorePhotoPermissionOpenSettings":
        MessageLookupByLibrary.simpleMessage("فتح الإعدادات"),
    "flowChorePhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "أضف صورة توضّح الشكل المطلوب",
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
    "flowChoreRecurrenceLabel": MessageLookupByLibrary.simpleMessage("التكرار"),
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
      "تاريخ الـFlow",
    ),
    "flowChoreSubmitCreate": MessageLookupByLibrary.simpleMessage("إضافة Flow"),
    "flowChoreSubmitUpdate": MessageLookupByLibrary.simpleMessage(
      "حفظ الـFlow",
    ),
    "flowChoreValidationAssignee": MessageLookupByLibrary.simpleMessage(
      "اختر شخصًا للتعيين.",
    ),
    "flowChoreValidationDate": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخًا خلال سنة من اليوم.",
    ),
    "flowChoreValidationHowToUrl": MessageLookupByLibrary.simpleMessage(
      "أدخل رابطًا صالحًا يبدأ بـ http أو https.",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage(
      "أدخل اسمًا للـFlow.",
    ),
    "flowListDraftLabel": MessageLookupByLibrary.simpleMessage("مسوّدة"),
    "flowListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "أضف أول روتين ليعرف الجميع ما الذي عليهم فعله.",
    ),
    "flowListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا يوجد أي Flow بعد",
    ),
    "flowListError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل Flows. اسحب للتحديث.",
    ),
    "flowListOverdueLabel": MessageLookupByLibrary.simpleMessage("متأخر"),
    "force_update_body": MessageLookupByLibrary.simpleMessage(
      "لم يَعُد هذا الإصدار من Kinly مدعومًا. يُرجى تثبيت الإصدار الأحدث للمتابعة.",
    ),
    "force_update_button": MessageLookupByLibrary.simpleMessage("تحديث Kinly"),
    "force_update_notes_label": MessageLookupByLibrary.simpleMessage(
      "ما الجديد",
    ),
    "force_update_title": MessageLookupByLibrary.simpleMessage("التحديث مطلوب"),
    "force_update_version_details": m2,
    "friendDefaultName": MessageLookupByLibrary.simpleMessage("صديق"),
    "gratitudeWallEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "شارك لحظة مشرقة لبدء ملء الجدار.",
    ),
    "gratitudeWallEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد منشورات امتنان بعد",
    ),
    "gratitudeWallFooter": m3,
    "gratitudeWallKinlySubtitle": MessageLookupByLibrary.simpleMessage(
      "يساعدك Kinly على مشاركة لحظات الامتنان الصغيرة مع أهل منزلك.",
    ),
    "gratitudeWallPoweredBy": MessageLookupByLibrary.simpleMessage("مدعوم من"),
    "gratitudeWallRetry": MessageLookupByLibrary.simpleMessage(
      "إعادة المحاولة",
    ),
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
    "greetingPartAfternoon": MessageLookupByLibrary.simpleMessage("مساء الخير"),
    "greetingPartEvening": MessageLookupByLibrary.simpleMessage("مساء الخير"),
    "greetingPartMorning": MessageLookupByLibrary.simpleMessage("صباح الخير"),
    "greetingPartOfDay": m8,
    "greetingPartOfDay_name": MessageLookupByLibrary.simpleMessage("الاسم"),
    "greetingPartOfDay_partOfDay": MessageLookupByLibrary.simpleMessage(
      "جزء اليوم (صباح/ظهر/مساء) — مدمج في النص",
    ),
    "harmonyCommentHint": MessageLookupByLibrary.simpleMessage(
      "ما الذي يجعل المنزل يشعر بهذه الطريقة؟",
    ),
    "harmonyCommentLabel": MessageLookupByLibrary.simpleMessage(
      "إضافة ملاحظة (اختياري)",
    ),
    "harmonyEntryCta": MessageLookupByLibrary.simpleMessage(
      "شارك انسجام هذا الأسبوع",
    ),
    "harmonyEntryError": MessageLookupByLibrary.simpleMessage(
      "تعذّر فتح صفحة الانسجام. حاول مرة أخرى.",
    ),
    "harmonyErrorAlreadySubmitted": MessageLookupByLibrary.simpleMessage(
      "لقد شاركت مزاجك بالفعل لهذا الأسبوع.",
    ),
    "harmonyErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "لا يمكنك إرسال ملاحظات لهذا المنزل.",
    ),
    "harmonyErrorSelectMood": MessageLookupByLibrary.simpleMessage(
      "اختر حالة المزاج قبل الإرسال.",
    ),
    "harmonyErrorUnknown": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ ما. حاول مرة أخرى.",
    ),
    "harmonyMoodCloudy": MessageLookupByLibrary.simpleMessage("غائم"),
    "harmonyMoodPartiallySunny": MessageLookupByLibrary.simpleMessage(
      "غائم جزئيًا",
    ),
    "harmonyMoodRainy": MessageLookupByLibrary.simpleMessage("ممطر"),
    "harmonyMoodSunny": MessageLookupByLibrary.simpleMessage("مشمس"),
    "harmonyMoodThunderstorm": MessageLookupByLibrary.simpleMessage(
      "عاصفة رعدية",
    ),
    "harmonyQuestion": MessageLookupByLibrary.simpleMessage(
      "كيف هو شعور المنزل هذا الأسبوع؟",
    ),
    "harmonyShareLabel": MessageLookupByLibrary.simpleMessage(
      "مشاركة في جدار الامتنان",
    ),
    "harmonyShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "يظهر لأهل المنزل عندما يكون المزاج مشمسًا أو غائمًا جزئيًا.",
    ),
    "harmonySubmitCta": MessageLookupByLibrary.simpleMessage("إرسال الملاحظات"),
    "harmonySubmitSuccess": MessageLookupByLibrary.simpleMessage(
      "شكرًا! تم حفظ ملاحظاتك.",
    ),
    "harmonySubtext": MessageLookupByLibrary.simpleMessage(
      "اختر حالة الطقس التي تعكس مزاجك وأضف ملاحظة اختيارية.",
    ),
    "harmonyTitle": MessageLookupByLibrary.simpleMessage(
      "انسجام المنزل الأسبوعي",
    ),
    "hubCardGratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "اقرأ عبارات الشكر واللحظات الجميلة.",
    ),
    "hubCardGratitudeWallTitle": MessageLookupByLibrary.simpleMessage(
      "جدار الامتنان",
    ),
    "hubCodeCopied": MessageLookupByLibrary.simpleMessage("تم نسخ رمز الدعوة"),
    "hubCopyCode": MessageLookupByLibrary.simpleMessage("نسخ رمز الدعوة"),
    "hubError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل الـHub. حاول مرة أخرى.",
    ),
    "hubInviteCta": MessageLookupByLibrary.simpleMessage("دعوة"),
    "hubInviteUnavailable": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل الدعوة. حاول مرة أخرى.",
    ),
    "hubMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "لا يوجد أعضاء نشِطون بعد.",
    ),
    "hubMembersSubtitle": MessageLookupByLibrary.simpleMessage(
      "الأشخاص النشِطون حاليًا في هذا المنزل.",
    ),
    "hubMembersTitle": MessageLookupByLibrary.simpleMessage("أعضاء المنزل"),
    "hubQrSubtitle": MessageLookupByLibrary.simpleMessage(
      "امسح الرمز لتنزيل Kinly",
    ),
    "hubQrTitle": MessageLookupByLibrary.simpleMessage("مشاركة التطبيق"),
    "hubRetry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "hubRotateError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تغيير رمز الدعوة. حاول مرة أخرى.",
    ),
    "hubRotateInvite": MessageLookupByLibrary.simpleMessage("تغيير رمز الدعوة"),
    "hubRotateSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تغيير رمز الدعوة",
    ),
    "hubShareAppBody": m9,
    "hubShareAppCta": MessageLookupByLibrary.simpleMessage("مشاركة Kinly"),
    "hubShareAppTitle": MessageLookupByLibrary.simpleMessage(
      "حمّل تطبيق Kinly",
    ),
    "hubShareInviteBody": m10,
    "hubShareInviteTitle": MessageLookupByLibrary.simpleMessage(
      "دعوة إلى منزلي على Kinly",
    ),
    "join_error_already_in_other_home": MessageLookupByLibrary.simpleMessage(
      "أنت بالفعل ضمن منزل آخر. غادره قبل الانضمام إلى منزل جديد.",
    ),
    "join_error_forbidden": MessageLookupByLibrary.simpleMessage(
      "ليس لديك صلاحية الانضمام إلى هذا المنزل.",
    ),
    "join_error_inactive_invite": MessageLookupByLibrary.simpleMessage(
      "هذه الدعوة لم تعد نشِطة. اطلب من المالك رمزًا جديدًا.",
    ),
    "join_error_invalid_code": MessageLookupByLibrary.simpleMessage(
      "يبدو أن رمز الدعوة غير صحيح.",
    ),
    "join_error_paywall_limit": MessageLookupByLibrary.simpleMessage(
      "وصل هذا المنزل إلى الحد الأقصى من الأعضاء. اطلب من المالك الترقية أو إزالة أحد الأعضاء.",
    ),
    "join_error_unauthorized": MessageLookupByLibrary.simpleMessage(
      "يُرجى تسجيل الدخول للانضمام إلى هذا المنزل.",
    ),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage(
      "فشل الانضمام. يُرجى المحاولة مرة أخرى.",
    ),
    "join_hint": MessageLookupByLibrary.simpleMessage("أدخل رمز الدعوة"),
    "join_submit": MessageLookupByLibrary.simpleMessage("انضمام"),
    "join_success": m11,
    "join_title": MessageLookupByLibrary.simpleMessage("الانضمام إلى المنزل"),
    "login_consent_connector": MessageLookupByLibrary.simpleMessage(" و"),
    "login_consent_prefix": MessageLookupByLibrary.simpleMessage(
      "لقد قرأت ووافقت على ",
    ),
    "login_privacy": MessageLookupByLibrary.simpleMessage("سياسة الخصوصية"),
    "login_tagline": MessageLookupByLibrary.simpleMessage(
      "معًا يصبح العبء أخف",
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
      "جارٍ التحقق من حالة عضويتك…",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "لم تنضم إلى أي منزل بعد.",
    ),
    "navExplore": MessageLookupByLibrary.simpleMessage("استكشاف"),
    "navHub": MessageLookupByLibrary.simpleMessage("Hub"),
    "navToday": MessageLookupByLibrary.simpleMessage("اليوم"),
    "npsCannotSkip": MessageLookupByLibrary.simpleMessage(
      "يجب اختيار درجة للمتابعة.",
    ),
    "npsDescription": MessageLookupByLibrary.simpleMessage(
      "يساعدنا مؤشر ولاء العملاء (NPS) على معرفة مستوى رضاك. اختر رقمًا من 0 (غير محتمل) إلى 10 (محتمل جدًا).",
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
      "لا يمكنك إرسال ملاحظات الآن.",
    ),
    "npsSubmitErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذّر إرسال ملاحظاتك. حاول مرة أخرى.",
    ),
    "npsSubmitErrorInvalidScore": MessageLookupByLibrary.simpleMessage(
      "يُرجى اختيار درجة بين 0 و10.",
    ),
    "npsSubmitErrorNotRequired": MessageLookupByLibrary.simpleMessage(
      "لا نحتاج هذا التعليق في الوقت الحالي.",
    ),
    "npsTitle": MessageLookupByLibrary.simpleMessage(
      "ما مدى احتمال أن توصي بـ Kinly لصديق أو أحد أفراد العائلة؟",
    ),
    "offline_body": MessageLookupByLibrary.simpleMessage(
      "يحتاج Kinly إلى اتصال بالإنترنت. تحقّق من الشبكة ثم حاول مرة أخرى.",
    ),
    "offline_retry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "offline_title": MessageLookupByLibrary.simpleMessage("أنت دون اتصال"),
    "paywallBulletFlows": MessageLookupByLibrary.simpleMessage(
      "?????? ??? ??????",
    ),
    "paywallBulletMembers": MessageLookupByLibrary.simpleMessage(
      "????? ??? ??? ???????",
    ),
    "paywallBulletPhotos": MessageLookupByLibrary.simpleMessage(
      "??? ?????? ??? ??????",
    ),
    "paywallBulletShares": MessageLookupByLibrary.simpleMessage(
      "????? ?????? ??? ??????",
    ),
    "paywallEmotional": MessageLookupByLibrary.simpleMessage(
      "Premium ????? ???? ????? ??? ?? ??? ? ??? ?????? ??? ????? ??????? ??????.",
    ),
    "paywallErrorTitle": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل شاشة الترقية.",
    ),
    "paywallPriceCaption": MessageLookupByLibrary.simpleMessage(
      "????? ??? ????? ?????. ??? ????? ?????? ??? ??????? ?????.",
    ),
    "paywallPricePerMonth": m12,
    "paywallPriceUnavailable": MessageLookupByLibrary.simpleMessage(
      "????? ??? ???? ??????.",
    ),
    "paywallPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "الترقية إلى Kinly Premium",
    ),
    "paywallPurchaseFailed": MessageLookupByLibrary.simpleMessage(
      "لم تكتمل عملية الشراء — يمكنك المحاولة مرة أخرى في أي وقت.",
    ),
    "paywallPurchaseSuccess": MessageLookupByLibrary.simpleMessage(
      "أصبحت الآن على Kinly Premium.",
    ),
    "paywallRestoreCta": MessageLookupByLibrary.simpleMessage(
      "استعادة عمليات الشراء",
    ),
    "paywallRetryLabel": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "paywallSecondaryCta": MessageLookupByLibrary.simpleMessage(
      "المتابعة بمنزل مجاني",
    ),
    "paywallSubtitle": MessageLookupByLibrary.simpleMessage(
      "??? ????? ????? ????? ???????. ?????? ???? ??? ?????.",
    ),
    "paywallTitle": MessageLookupByLibrary.simpleMessage(
      "???? ????? ???? ??????? ????.",
    ),
    "profileActionCancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "profileActionConfirm": MessageLookupByLibrary.simpleMessage(
      "مغادرة المنزل",
    ),
    "profileActionConfirmDelete": MessageLookupByLibrary.simpleMessage(
      "حذف الحساب",
    ),
    "profileConfirmDeleteMessage": MessageLookupByLibrary.simpleMessage(
      "سيتم حذف حسابك وتسجيل خروجك. لا يمكن التراجع عن هذا الإجراء.",
    ),
    "profileConfirmDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "حذف حسابك؟",
    ),
    "profileConfirmLeaveMessage": MessageLookupByLibrary.simpleMessage(
      "ستفقد الوصول إلى Flow، والتاريخ المشترك، والدعوات.",
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
      "تعذّر فتح تطبيق البريد لديك. حاول مرة أخرى.",
    ),
    "profileContactUsSubtitle": MessageLookupByLibrary.simpleMessage(
      "راسلنا عبر البريد: support@makinglifeeasie.com",
    ),
    "profileContactUsTitle": MessageLookupByLibrary.simpleMessage("تواصل معنا"),
    "profileDeleteAccountSubtitle": MessageLookupByLibrary.simpleMessage(
      "إزالة حسابك على Kinly وبيانات ملفك.",
    ),
    "profileDeleteAccountTitle": MessageLookupByLibrary.simpleMessage(
      "حذف الحساب",
    ),
    "profileDeleteSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "سيتم حذف حسابك قريبًا. سنقوم بتسجيل خروجك.",
    ),
    "profileGenericError": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ ما. يُرجى المحاولة مرة أخرى.",
    ),
    "profileIdentityAvatarEmpty": MessageLookupByLibrary.simpleMessage(
      "لا توجد صور رمزية متاحة حاليًا. حاول مرة أخرى قريبًا.",
    ),
    "profileIdentityAvatarSectionDescription":
        MessageLookupByLibrary.simpleMessage("كل صورة رمزية فريدة داخل منزلك."),
    "profileIdentityAvatarSectionTitle": MessageLookupByLibrary.simpleMessage(
      "اختر صورة رمزية",
    ),
    "profileIdentityLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل ملفك الشخصي حاليًا.",
    ),
    "profileIdentityRetry": MessageLookupByLibrary.simpleMessage(
      "إعادة المحاولة",
    ),
    "profileIdentitySaveButton": MessageLookupByLibrary.simpleMessage(
      "حفظ التغييرات",
    ),
    "profileIdentitySubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر اسم مستخدم وصورة رمزية لمنزلك.",
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
      "استخدم من 3 إلى 30 حرفًا صغيرة أو أرقامًا. يمكنك إدراج النقاط أو الشرطة السفلية في الوسط.",
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
      "اسم المستخدم هذا مستخدم بالفعل. جرّب اسمًا آخر.",
    ),
    "profileInfoHubLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل الـInfo Hub. تحقّق من اتصالك.",
    ),
    "profileInfoHubSubtitle": MessageLookupByLibrary.simpleMessage(
      "افتح مركز Kinly على Notion داخل التطبيق.",
    ),
    "profileInfoHubTitle": MessageLookupByLibrary.simpleMessage("Info Hub"),
    "profileKickActionConfirm": MessageLookupByLibrary.simpleMessage(
      "إزالة العضو",
    ),
    "profileKickMemberSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر من يجب أن يفقد الوصول إلى المنزل.",
    ),
    "profileKickMemberTitle": MessageLookupByLibrary.simpleMessage("إزالة عضو"),
    "profileKickNoMembers": MessageLookupByLibrary.simpleMessage(
      "لا يوجد أعضاء آخرون لإزالتهم حاليًا.",
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
      "لم يَعُد لديه وصول إلى هذا المنزل.",
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
      "لا يوجد شخص يمكنه استلام الملكية حاليًا. حاول لاحقًا.",
    ),
    "profileLeaveOwnerSoloMessage": MessageLookupByLibrary.simpleMessage(
      "أنت آخر عضو متبقٍ. عند المغادرة سيتم تعطيل هذا المنزل للجميع.",
    ),
    "profileLeaveSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "لقد غادرت منزلك.",
    ),
    "profileLeaveTransferSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر من يجب أن يصبح المالك الجديد قبل أن تغادر.",
    ),
    "profileLeaveTransferSheetTitle": MessageLookupByLibrary.simpleMessage(
      "نقل الملكية",
    ),
    "profileLeaveTransferSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "تم نقل الملكية. نكمل الآن عملية خروجك…",
    ),
    "profileLogoutDialogMessage": MessageLookupByLibrary.simpleMessage(
      "ستحتاج لتسجيل الدخول مرة أخرى للوصول إلى منزلك.",
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
      "إدارة تفضيلات حسابك والوصول إلى المنزل.",
    ),
    "profileSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "الملف الشخصي والمنزل",
    ),
    "quick_add_fair_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "تسجيل إدخال للإنصاف",
    ),
    "quick_add_fair_share_title": MessageLookupByLibrary.simpleMessage(
      "Fair Share",
    ),
    "quick_add_flow_subtitle": MessageLookupByLibrary.simpleMessage(
      "إضافة Flow",
    ),
    "quick_add_flow_title": MessageLookupByLibrary.simpleMessage("Flow"),
    "quick_add_poll_subtitle": MessageLookupByLibrary.simpleMessage(
      "إنشاء استطلاع سريع لأهل المنزل",
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
      "أدخل ما يدفعه كل شخص. يجب أن يساوي الإجمالي المبلغ أعلاه.",
    ),
    "shareCreateDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "مثال: مشتريات البقالة",
    ),
    "shareCreateDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "الوصف",
    ),
    "shareCreateErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "ليس لديك صلاحية إنشاء هذا الآن.",
    ),
    "shareCreateErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذّر الإنشاء. حاول مرة أخرى.",
    ),
    "shareCreateErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "وصلت إلى الحد المجاني وهو 10 نفقات نشِطة أو مسوّدات. أغلق أو ألغِ أحدها للمتابعة.",
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
    "shareCreateRetry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
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
      "تم إنشاء الـShare.",
    ),
    "shareCreateTitle": MessageLookupByLibrary.simpleMessage("إنشاء"),
    "shareCreateValidationAmount": MessageLookupByLibrary.simpleMessage(
      "أدخل مبلغًا صحيحًا أكبر من صفر.",
    ),
    "shareCreateValidationCustomAmounts": MessageLookupByLibrary.simpleMessage(
      "أدخل مبلغًا صحيحًا لكل شخص مختار.",
    ),
    "shareCreateValidationCustomParticipants":
        MessageLookupByLibrary.simpleMessage(
          "التقسيم المخصص يحتاج إلى شخصين على الأقل.",
        ),
    "shareCreateValidationCustomSinglePayer":
        MessageLookupByLibrary.simpleMessage(
          "لا يمكن لشخص واحد دفع المبلغ كاملًا عند استخدام تقسيم مخصص.",
        ),
    "shareCreateValidationCustomSum": MessageLookupByLibrary.simpleMessage(
      "يجب أن يساوي مجموع المبالغ المبلغ أعلاه.",
    ),
    "shareCreateValidationDescription": MessageLookupByLibrary.simpleMessage(
      "أدخل وصفًا.",
    ),
    "shareCreateValidationEqualParticipants":
        MessageLookupByLibrary.simpleMessage(
          "اختر شخصين على الأقل لتقسيم المبلغ.",
        ),
    "shareCreateValidationSplit": MessageLookupByLibrary.simpleMessage(
      "اختر طريقة التقسيم.",
    ),
    "shareCreatedListActiveAmount": m13,
    "shareCreatedListActiveSubtitle": m14,
    "shareCreatedListDraftBadge": MessageLookupByLibrary.simpleMessage(
      "غير معيَّن",
    ),
    "shareCreatedListDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "قسّم المبلغ على كل شخص قبل النشر.",
    ),
    "shareCreatedListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "أنشئ Share لتراه هنا.",
    ),
    "shareCreatedListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد Shares بعد",
    ),
    "shareCreatedListError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل الـShares الخاصة بك. اسحب للتحديث.",
    ),
    "shareCreatedListPaidBadge": MessageLookupByLibrary.simpleMessage(
      "مدفوع بالكامل",
    ),
    "shareCreatedListRetry": MessageLookupByLibrary.simpleMessage(
      "إعادة المحاولة",
    ),
    "shareCreatedListTitle": MessageLookupByLibrary.simpleMessage(
      "الـShares الخاصة بك",
    ),
    "shareEditClose": MessageLookupByLibrary.simpleMessage("إغلاق"),
    "shareEditDeleteButton": MessageLookupByLibrary.simpleMessage("حذف"),
    "shareEditDeleteCancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "shareEditDeleteConfirm": MessageLookupByLibrary.simpleMessage("حذف"),
    "shareEditDeleteConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "سيتم حذف هذه المسوّدة للجميع.",
    ),
    "shareEditDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage("حذف؟"),
    "shareEditDeleteError": MessageLookupByLibrary.simpleMessage(
      "تعذّر الحذف. حاول مرة أخرى.",
    ),
    "shareEditDeleteSuccess": MessageLookupByLibrary.simpleMessage(
      "تم حذف الـShare.",
    ),
    "shareEditLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل هذه المسوّدة.",
    ),
    "shareEditNotAllowed": MessageLookupByLibrary.simpleMessage(
      "لا يمكن تعديل هذا بعد الآن لأن عليك تعيين الـShare.",
    ),
    "shareEditSplitsLocked": MessageLookupByLibrary.simpleMessage(
      "التقسيمات مقفلة لأن أحدهم دفع بالفعل. لا يزال بإمكانك تعديل الوصف والملاحظات.",
    ),
    "shareEditSubmit": MessageLookupByLibrary.simpleMessage("تحديث"),
    "shareEditSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تحديث الـShare.",
    ),
    "shareEditTitle": MessageLookupByLibrary.simpleMessage("تعديل Share"),
    "shareOwedDetailEmpty": MessageLookupByLibrary.simpleMessage(
      "أنت على وفاق تام مع هذا الشخص.",
    ),
    "shareOwedDetailError": MessageLookupByLibrary.simpleMessage(
      "تعذّر وضع علامة مدفوع. حاول مرة أخرى.",
    ),
    "shareOwedDetailPaid": MessageLookupByLibrary.simpleMessage(
      "وضع علامة مدفوع",
    ),
    "shareOwedDetailSelectionLabel": MessageLookupByLibrary.simpleMessage(
      "اختر مع من تشارك.",
    ),
    "shareOwedDetailSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر الـShare الذي سددته للتو.",
    ),
    "shareOwedDetailSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تسجيل الدفعة.",
    ),
    "shareOwedDetailTitle": MessageLookupByLibrary.simpleMessage("دفعة معلّقة"),
    "todayAddSheetFlow": MessageLookupByLibrary.simpleMessage("إضافة Flow"),
    "todayAddSheetShare": MessageLookupByLibrary.simpleMessage("إضافة Share"),
    "todayAddSheetTitle": MessageLookupByLibrary.simpleMessage(
      "إضافة إلى منزلك",
    ),
    "todayEmptyBody": MessageLookupByLibrary.simpleMessage(
      "استمتع بالهدوء — Kinly سيُعلِمك عندما يحتاج المنزل إلى انتباهك.",
    ),
    "todayEmptyCardBadge": MessageLookupByLibrary.simpleMessage("استرح قليلًا"),
    "todayEmptyCardTitle": MessageLookupByLibrary.simpleMessage(
      "أنت منجز كل شيء لليوم ✨",
    ),
    "todayFlatmateInviteSubtitle": MessageLookupByLibrary.simpleMessage(
      "شارك رمز الدعوة لتقسيم المهام المنزلية معًا.",
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
    "todayFlowTabActive": MessageLookupByLibrary.simpleMessage("نشِطة"),
    "todayFlowTabDrafts": MessageLookupByLibrary.simpleMessage("مسوّدات"),
    "todayGratitudeOpenCta": MessageLookupByLibrary.simpleMessage("عرض الجدار"),
    "todayGratitudeSectionTitle": MessageLookupByLibrary.simpleMessage(
      "جدار الامتنان في المنزل",
    ),
    "todayGratitudeUnreadBody": MessageLookupByLibrary.simpleMessage(
      "هناك منشورات امتنان جديدة في انتظارك.",
    ),
    "todayInviteFriendsSubtitle": MessageLookupByLibrary.simpleMessage(
      "شارك Kinly مع صديق ليساعده على جلب مزيد من الانسجام إلى منزله.",
    ),
    "todayInviteFriendsTitle": MessageLookupByLibrary.simpleMessage(
      "ادعُ أصدقاءك إلى Kinly",
    ),
    "todayInviteNotNow": MessageLookupByLibrary.simpleMessage("ليس الآن"),
    "todayInviteShareCta": MessageLookupByLibrary.simpleMessage(
      "مشاركة الدعوة",
    ),
    "todayShareActiveSubtitle": m16,
    "todayShareBadgeUpcoming": MessageLookupByLibrary.simpleMessage("قادم"),
    "todayShareDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "قسّم المبلغ بناءً على الـShare.",
    ),
    "todayShareEmptyState": MessageLookupByLibrary.simpleMessage(
      "لا شيء هنا بعد.",
    ),
    "todayShareError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحديث قسم Share الآن.",
    ),
    "todayShareSampleGroceries": MessageLookupByLibrary.simpleMessage(
      "مشتريات مشتركة من الأمس",
    ),
    "todayShareSampleInternet": MessageLookupByLibrary.simpleMessage(
      "فاتورة الإنترنت هذا الأسبوع",
    ),
    "todayShareSampleRent": MessageLookupByLibrary.simpleMessage(
      "تذكير بالإيجار قريبًا",
    ),
    "todayShareSectionTitle": MessageLookupByLibrary.simpleMessage("Share"),
    "todayShareSeeAll": MessageLookupByLibrary.simpleMessage(
      "عرض كل الـShares",
    ),
    "todayShareTabActive": MessageLookupByLibrary.simpleMessage("نشِطة"),
    "todayShareTabDrafts": MessageLookupByLibrary.simpleMessage("مسوّدات"),
    "today_home_details": m17,
    "today_no_membership": MessageLookupByLibrary.simpleMessage(
      "لا يوجد منزل نشِط حتى الآن. أنشئ أو انضم إلى منزل لعرض صفحة اليوم.",
    ),
    "today_title": MessageLookupByLibrary.simpleMessage("اليوم"),
    "unknownInitial": MessageLookupByLibrary.simpleMessage("?"),
    "welcome_create": MessageLookupByLibrary.simpleMessage("إنشاء منزل"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("الانضمام إلى منزل"),
    "welcome_title": MessageLookupByLibrary.simpleMessage("مرحبًا في Kinly"),
  };
}
