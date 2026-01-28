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

  static String m0(env) => "جارٍ تشغيل كينلي (${env})";

  static String m1(time) => "مجدول عند ${time}";

  static String m2(current) => "وصول تجريبي: ${current} من 7 نقرات";

  static String m3(appName) => "صُنع باستخدام ${appName} - معًا يصبح الأمر أخف";

  static String m4(link) =>
      "مشاركة لمحة من جدار امتنان كينلي لدينا. حمّل التطبيق: ${link}";

  static String m5(weeks) =>
      "${Intl.plural(weeks, zero: 'هذا الأسبوع', one: 'قبل أسبوع (#)', other: 'قبل (#) أسابيع')}";

  static String m6(partOfDay, name) => "${partOfDay} سعيد، ${name}";

  static String m7(answered, total) =>
      "استنادًا إلى ${answered} من أصل ${total} أعضاء";

  static String m8(link) => "مشاركة نبض منزلنا في كينلي. حمّل التطبيق: ${link}";

  static String m9(date) => "تم التحديث في ${date}";

  static String m10(link) =>
      "مشاركة طابع منزلنا في كينلي. حمّل التطبيق: ${link}";

  static String m11(link) => "شارك كينلي ليصبح الشعور معًا أخف: ${link}";

  static String m12(code, link) =>
      "مرحبًا بك في منزلنا على كينلي! أدخل رمز الدعوة هذا: ${code}\n\nحمّل تطبيق كينلي: ${link}";

  static String m13(code) => "تم الأمر. أهلاً بك في المنزل.";

  static String m14(price) => "${price} شهريًا.";

  static String m15(current, total) => "السؤال ${current} من ${total}";

  static String m16(period) => "ينطبق على ${period}";

  static String m17(paidAmount, totalAmount) =>
      "${paidAmount} من ${totalAmount} تم تحصيلها";

  static String m18(paid, total) => "${paid} من ${total} مدفوعة";

  static String m19(name) => "مرحبًا ${name}";

  static String m20(count) =>
      "عرض الكل ${Intl.plural(count, one: '(#)', other: '(#)')}";

  static String m21(name) => "لم نتمكن من إكمال طلب ${name}.";

  static String m22(name) => "انضم ${name} إلى منزلك.";

  static String m23(name) => "انضم ${name} إلى منزل آخر.";

  static String m24(names) =>
      "${names} يريد الانضمام إلى منزلك. قم بالترقية لدعم أعضاء غير محدودين.";

  static String m25(count) =>
      "${Intl.plural(count, one: '${count} دفعة معلّقة', other: '${count} للتسوية')}";

  static String m26(count) =>
      "${Intl.plural(count, one: '${count} دفعة جديدة لك', other: '${count} دفعات جديدة لك')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("كينلي"),
    "authMembershipLoadFailed": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من تحديث عضويتك في المنزل. يرجى المحاولة مرة أخرى.",
    ),
    "bootstrap_initializing": m0,
    "connectionNotificationsPermissionBlocked":
        MessageLookupByLibrary.simpleMessage(
          "فعّل الإشعارات من إعدادات هاتفك لاستخدام هذا.",
        ),
    "connectionNotificationsTimeLabel": MessageLookupByLibrary.simpleMessage(
      "وقت التذكير",
    ),
    "connectionNotificationsTimeSubtitle": m1,
    "connectionNotificationsToggleSubtitleOff":
        MessageLookupByLibrary.simpleMessage("فعّل التذكيرات بشأن منزلك."),
    "connectionNotificationsToggleSubtitleOn":
        MessageLookupByLibrary.simpleMessage("احصل على تذكير واحد كل يوم."),
    "connectionNotificationsToggleTitle": MessageLookupByLibrary.simpleMessage(
      "إشعارات يومية",
    ),
    "connectionSettingsGenericError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحديث إعدادات الاتصال. حاول مرة أخرى.",
    ),
    "connectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "تحكّم بتذكير الإشعارات اليومية وتوقيتها.",
    ),
    "connectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "إعدادات الاتصال",
    ),
    "create_failed_generic": MessageLookupByLibrary.simpleMessage(
      "تعذّر إنشاء المنزل. حاول مرة أخرى.",
    ),
    "demoAccess": MessageLookupByLibrary.simpleMessage("وصول تجريبي"),
    "demoAccessEmail": MessageLookupByLibrary.simpleMessage(
      "البريد الإلكتروني",
    ),
    "demoAccessError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تسجيل الدخول. يرجى التحقق من بيانات الاعتماد.",
    ),
    "demoAccessPassword": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "demoAccessSubmit": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "demoAccessTapHint": m2,
    "exploreFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "اعرف ما الذي يحتاج إلى إنجاز — ومن يتولى ذلك.",
    ),
    "exploreIntroSubtitle": MessageLookupByLibrary.simpleMessage(
      "استكشف طرقًا أكثر لتبقى أجواء منزلك أخف.",
    ),
    "exploreShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "اعرض كل فاتورة أنشأتها وتتبع التحصيل.",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage(
      "من سيتولى هذا؟",
    ),
    "flowChoreCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء التدفّق.",
    ),
    "flowChoreCreateTitle": MessageLookupByLibrary.simpleMessage("إضافة تدفّق"),
    "flowChoreDeleteButton": MessageLookupByLibrary.simpleMessage(
      "حذف التدفّق",
    ),
    "flowChoreDeleteConfirm": MessageLookupByLibrary.simpleMessage("حذف"),
    "flowChoreDeleteDialogMessage": MessageLookupByLibrary.simpleMessage(
      "سيزيل هذا التدفّق للجميع في منزلك.",
    ),
    "flowChoreDeleteDialogTitle": MessageLookupByLibrary.simpleMessage(
      "حذف هذا التدفّق؟",
    ),
    "flowChoreDetailCompleteButton": MessageLookupByLibrary.simpleMessage(
      "وضع علامة مكتمل",
    ),
    "flowChoreDetailCompletionError": MessageLookupByLibrary.simpleMessage(
      "تعذّر إكمال التدفّق. يرجى المحاولة مرة أخرى.",
    ),
    "flowChoreDetailCompletionSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إكمال التدفّق.",
    ),
    "flowChoreDetailMoreInfoTitle": MessageLookupByLibrary.simpleMessage(
      "سياق مفيد",
    ),
    "flowChoreDetailNoHowTo": MessageLookupByLibrary.simpleMessage(
      "لا توجد روابط إرشادية.",
    ),
    "flowChoreDetailNoNotes": MessageLookupByLibrary.simpleMessage(
      "لا يوجد سياق.",
    ),
    "flowChoreDetailTitle": MessageLookupByLibrary.simpleMessage(
      "تفاصيل التدفّق",
    ),
    "flowChoreDetailUnassigned": MessageLookupByLibrary.simpleMessage(
      "غير مكلّف",
    ),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage("تعديل التدفّق"),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "هذا العضو ليس ضمن هذا المنزل الآن.",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "ليس لديك إذن لتغيير هذا التدفّق.",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذّر حفظ التدفّق. يرجى المحاولة مرة أخرى.",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "مسار الصورة غير صالح لهذا المنزل.",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخ بدء صالحًا.",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "لا يمكن تحديث هذا التدفّق الآن.",
    ),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "لقد وصلت إلى الحد المجاني للتدفّقات النشطة. قم بالترقية لمساحة أكبر.",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "لقد وصلت إلى الحد المجاني لصور التدفّق. قم بالترقية لمساحة أكبر.",
    ),
    "flowChoreExpectationPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "صورة مرجعية",
    ),
    "flowChoreHowToHint": MessageLookupByLibrary.simpleMessage(
      "أضف رابطًا إذا كانت هناك طريقة محددة",
    ),
    "flowChoreHowToLabel": MessageLookupByLibrary.simpleMessage(
      "طريقة التنفيذ (اختياري)",
    ),
    "flowChoreHowToLaunchError": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من فتح الرابط. حاول مرة أخرى.",
    ),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من تحميل هذا التدفّق. يرجى المحاولة مرة أخرى.",
    ),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage(
      "مثل: إخراج القمامة، تنظيف الثلاجة، سقي النباتات",
    ),
    "flowChoreNameLabel": MessageLookupByLibrary.simpleMessage(
      "ما الذي يجب إنجازه؟",
    ),
    "flowChoreNotesHint": MessageLookupByLibrary.simpleMessage(
      "أي شيء يساعد الآخرين على إنجازه بسهولة",
    ),
    "flowChoreNotesLabel": MessageLookupByLibrary.simpleMessage(
      "لماذا هذا مهم",
    ),
    "flowChorePhotoLabel": MessageLookupByLibrary.simpleMessage(
      "كيف يبدو “الجيد”",
    ),
    "flowChorePhotoLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل الصورة",
    ),
    "flowChorePhotoPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "اسمح بالوصول إلى الكاميرا لالتقاط صورة.",
    ),
    "flowChorePhotoPermissionOpenSettings":
        MessageLookupByLibrary.simpleMessage("فتح الإعدادات"),
    "flowChorePhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "قد تساعد الصورة الجميع على البقاء على نفس الصفحة",
    ),
    "flowChorePhotoUploadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر رفع الصورة. حاول مرة أخرى.",
    ),
    "flowChoreRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "كم مرة يحدث هذا؟",
    ),
    "flowChoreRecurrenceNone": MessageLookupByLibrary.simpleMessage(
      "مرة واحدة",
    ),
    "flowChoreRetry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "flowChoreStartLabel": MessageLookupByLibrary.simpleMessage(
      "متى يحدث هذا؟",
    ),
    "flowChoreSubmitCreate": MessageLookupByLibrary.simpleMessage(
      "إنشاء تدفّق",
    ),
    "flowChoreSubmitUpdate": MessageLookupByLibrary.simpleMessage(
      "حفظ التغييرات",
    ),
    "flowChoreUpdateSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تحديث التدفّق.",
    ),
    "flowChoreValidationAssignee": MessageLookupByLibrary.simpleMessage(
      "اختر شخصًا، أو اتركه متاحًا لأي شخص.",
    ),
    "flowChoreValidationDate": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخًا حتى سنة من اليوم.",
    ),
    "flowChoreValidationHowToUrl": MessageLookupByLibrary.simpleMessage(
      "أدخل رابطًا صالحًا يبدأ بـ http أو https.",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage(
      "امنح التدفّق اسمًا.",
    ),
    "flowListDraftLabel": MessageLookupByLibrary.simpleMessage("مسودة"),
    "flowListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "التدفّقات تُبقي الجميع على نفس الصفحة.",
    ),
    "flowListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا يوجد شيء هنا بعد",
    ),
    "flowListError": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من تحميل التدفّقات. اسحب للتحديث.",
    ),
    "flowListOverdueLabel": MessageLookupByLibrary.simpleMessage(
      "بحاجة إلى انتباه",
    ),
    "force_update_body": MessageLookupByLibrary.simpleMessage(
      "لم يعد هذا الإصدار من كينلي مدعومًا. يرجى تثبيت أحدث إصدار للمتابعة.",
    ),
    "force_update_button": MessageLookupByLibrary.simpleMessage("تحديث كينلي"),
    "force_update_title": MessageLookupByLibrary.simpleMessage("يلزم تحديث"),
    "friendDefaultName": MessageLookupByLibrary.simpleMessage("صديق"),
    "gratitudeWallEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "هنا تعيش الشكرات الصغيرة.\n\nابدأ بلحظة واحدة من هذا الأسبوع.",
    ),
    "gratitudeWallEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد منشورات امتنان بعد",
    ),
    "gratitudeWallErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل الامتنان الآن.",
    ),
    "gratitudeWallFooter": m3,
    "gratitudeWallHouseTab": MessageLookupByLibrary.simpleMessage("المنزل"),
    "gratitudeWallPersonalSummary": MessageLookupByLibrary.simpleMessage(
      "مساحتك الخاصة للرسائل اللطيفة.",
    ),
    "gratitudeWallPersonalTab": MessageLookupByLibrary.simpleMessage("شخصي"),
    "gratitudeWallPersonalTitle": MessageLookupByLibrary.simpleMessage(
      "جدار الامتنان الشخصي",
    ),
    "gratitudeWallRetry": MessageLookupByLibrary.simpleMessage("حاول مرة أخرى"),
    "gratitudeWallShareCta": MessageLookupByLibrary.simpleMessage(
      "مشاركة هذا الجدار",
    ),
    "gratitudeWallShareError": MessageLookupByLibrary.simpleMessage(
      "تعذّرت المشاركة الآن. يرجى المحاولة مرة أخرى.",
    ),
    "gratitudeWallShareMessage": m4,
    "gratitudeWallShareTitle": MessageLookupByLibrary.simpleMessage(
      "جدار الامتنان",
    ),
    "gratitudeWallStatsHomes": MessageLookupByLibrary.simpleMessage("منازل"),
    "gratitudeWallStatsMentions": MessageLookupByLibrary.simpleMessage("شكرًا"),
    "gratitudeWallStatsPeople": MessageLookupByLibrary.simpleMessage("أشخاص"),
    "gratitudeWallWeeksAgo": m5,
    "greetingPartOfDay": m6,
    "harmonyCommentHint": MessageLookupByLibrary.simpleMessage(
      "ما الذي ساهم في هذا الشعور في المنزل؟",
    ),
    "harmonyCommentLabel": MessageLookupByLibrary.simpleMessage(
      "هل تود مشاركة شيء؟",
    ),
    "harmonyErrorAlreadySubmitted": MessageLookupByLibrary.simpleMessage(
      "لقد شاركت حالتك لهذا الأسبوع بالفعل.",
    ),
    "harmonyErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "لا يمكنك إرسال الملاحظات لهذا المنزل.",
    ),
    "harmonyErrorUnknown": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ ما. يرجى المحاولة مرة أخرى.",
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
      "كيف يشعر منزلك هذا الأسبوع؟",
    ),
    "harmonyShareLabel": MessageLookupByLibrary.simpleMessage(
      "شارك هذا مع منزلك",
    ),
    "harmonySubmitCta": MessageLookupByLibrary.simpleMessage("إرسال الملاحظات"),
    "harmonySubmitSuccess": MessageLookupByLibrary.simpleMessage(
      "شكرًا! تم حفظ ملاحظاتك.",
    ),
    "homeVibeCoverage": m7,
    "homeVibeTitle": MessageLookupByLibrary.simpleMessage("طابع المنزل"),
    "housePulseCardHeader": MessageLookupByLibrary.simpleMessage(
      "نبض المنزل الأسبوعي",
    ),
    "housePulseShareCta": MessageLookupByLibrary.simpleMessage("مشاركة النبض"),
    "housePulseShareMessage": m8,
    "housePulseShareTitle": MessageLookupByLibrary.simpleMessage(
      "مشاركة نبض منزلنا في كينلي",
    ),
    "housePulseUpdatedOn": m9,
    "houseVibeShareCta": MessageLookupByLibrary.simpleMessage("مشاركة الطابع"),
    "houseVibeShareError": MessageLookupByLibrary.simpleMessage(
      "تعذّر المشاركة الآن. يرجى المحاولة مرة أخرى.",
    ),
    "houseVibeShareMessage": m10,
    "houseVibeShareTitle": MessageLookupByLibrary.simpleMessage("طابع المنزل"),
    "hubCardGratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "اقرأ شكرًا سريعًا ولحظات تقدير صغيرة.",
    ),
    "hubCardGratitudeWallTitle": MessageLookupByLibrary.simpleMessage(
      "جدار الامتنان",
    ),
    "hubCodeCopied": MessageLookupByLibrary.simpleMessage("تم نسخ رمز الدعوة"),
    "hubError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل المركز. يرجى المحاولة مرة أخرى.",
    ),
    "hubInviteCta": MessageLookupByLibrary.simpleMessage("دعوة"),
    "hubInviteUnavailable": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل الدعوة. يرجى المحاولة مرة أخرى.",
    ),
    "hubMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "لا يوجد أعضاء نشطون بعد.",
    ),
    "hubPreferencesSubtitle": MessageLookupByLibrary.simpleMessage(
      "كيف يختبر كل شخص السكن المشترك.",
    ),
    "hubPreferencesTitle": MessageLookupByLibrary.simpleMessage(
      "التفضيلات الشخصية",
    ),
    "hubQrSubtitle": MessageLookupByLibrary.simpleMessage("امسح لتنزيل كينلي"),
    "hubQrTitle": MessageLookupByLibrary.simpleMessage("مشاركة التطبيق"),
    "hubRetry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "hubRotateError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تغيير رمز الدعوة. حاول مرة أخرى.",
    ),
    "hubRotateInvite": MessageLookupByLibrary.simpleMessage("تغيير رمز الدعوة"),
    "hubRotateSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تغيير رمز الدعوة",
    ),
    "hubShareAppBody": m11,
    "hubShareAppCta": MessageLookupByLibrary.simpleMessage("مشاركة كينلي"),
    "hubShareAppTitle": MessageLookupByLibrary.simpleMessage(
      "احصل على تطبيق كينلي",
    ),
    "hubShareInviteBody": m12,
    "hubShareInviteTitle": MessageLookupByLibrary.simpleMessage(
      "دعوة إلى منزلي على كينلي",
    ),
    "join_blocked_body": MessageLookupByLibrary.simpleMessage(
      "لقد أبلغنا مالك المنزل.",
    ),
    "join_blocked_cta": MessageLookupByLibrary.simpleMessage("تم"),
    "join_blocked_title": MessageLookupByLibrary.simpleMessage(
      "هذا المنزل لا يقبل أعضاءً جددًا الآن",
    ),
    "join_error_already_in_other_home": MessageLookupByLibrary.simpleMessage(
      "غادر منزلك الحالي للانضمام إلى منزل جديد",
    ),
    "join_error_forbidden": MessageLookupByLibrary.simpleMessage(
      "ليس لديك إذن للانضمام إلى هذا المنزل.",
    ),
    "join_error_inactive_invite": MessageLookupByLibrary.simpleMessage(
      "هذه الدعوة لم تعد نشطة. اطلب من المالك رمزًا جديدًا.",
    ),
    "join_error_invalid_code": MessageLookupByLibrary.simpleMessage(
      "رمز الدعوة هذا لا يبدو صحيحًا.",
    ),
    "join_error_paywall_limit": MessageLookupByLibrary.simpleMessage(
      "وصل هذا المنزل إلى حد الأعضاء. اطلب من المالك الترقية أو إزالة عضو.",
    ),
    "join_error_unauthorized": MessageLookupByLibrary.simpleMessage(
      "يرجى تسجيل الدخول للانضمام إلى هذا المنزل.",
    ),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من ضمّك إلى هذا المنزل. يرجى المحاولة مرة أخرى.",
    ),
    "join_hint": MessageLookupByLibrary.simpleMessage(
      "أدخل رمز الدعوة مثل ABC123",
    ),
    "join_submit": MessageLookupByLibrary.simpleMessage("انضم"),
    "join_success": m13,
    "join_title": MessageLookupByLibrary.simpleMessage("الانضمام إلى المنزل"),
    "login_consent_connector": MessageLookupByLibrary.simpleMessage(" و "),
    "login_consent_prefix": MessageLookupByLibrary.simpleMessage(
      "لقد قرأت وأوافق على ",
    ),
    "login_privacy": MessageLookupByLibrary.simpleMessage("سياسة الخصوصية"),
    "login_tagline": MessageLookupByLibrary.simpleMessage(
      "معًا يصبح الأمر أخف",
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
      "أنت متصل بمنزل.",
    ),
    "membership_status_checking": MessageLookupByLibrary.simpleMessage(
      "جارٍ ربطك بمنزلك…",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "منزلك المشترك يبدأ هنا.",
    ),
    "mentionFieldHint": MessageLookupByLibrary.simpleMessage("اكتب @ للإشارة"),
    "navExplore": MessageLookupByLibrary.simpleMessage("استكشاف"),
    "navHub": MessageLookupByLibrary.simpleMessage("المركز"),
    "navToday": MessageLookupByLibrary.simpleMessage("اليوم"),
    "npsCannotSkip": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار تقييم للمتابعة.",
    ),
    "npsDescription": MessageLookupByLibrary.simpleMessage(
      "اختر رقمًا من 0 (غير مفيد) إلى 10 (مفيد جدًا).",
    ),
    "npsEmailSubject": MessageLookupByLibrary.simpleMessage(
      "ما الذي يمكن أن يفعله كينلي بشكل أفضل لمنزلك؟",
    ),
    "npsLaunchError": MessageLookupByLibrary.simpleMessage(
      "تعذّر فتح الخطوة التالية.",
    ),
    "npsScaleHighLabel": MessageLookupByLibrary.simpleMessage("10 مفيد جدًا"),
    "npsScaleLowLabel": MessageLookupByLibrary.simpleMessage("0 غير مفيد"),
    "npsSubmitErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "لا يُسمح لك بإرسال الملاحظات الآن.",
    ),
    "npsSubmitErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذّر إرسال ملاحظاتك. يرجى المحاولة مرة أخرى.",
    ),
    "npsSubmitErrorInvalidScore": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار رقم بين 0 و10.",
    ),
    "npsSubmitErrorNotRequired": MessageLookupByLibrary.simpleMessage(
      "لا تحتاج إلى مشاركة ملاحظات الآن.",
    ),
    "npsTitle": MessageLookupByLibrary.simpleMessage(
      "هل كان كينلي مفيدًا لمنزلك حتى الآن؟",
    ),
    "offline_body": MessageLookupByLibrary.simpleMessage(
      "يحتاج كينلي إلى اتصال بالإنترنت. تحقّق من الإشارة وحاول مرة أخرى.",
    ),
    "offline_retry": MessageLookupByLibrary.simpleMessage("حاول مرة أخرى"),
    "offline_title": MessageLookupByLibrary.simpleMessage("أنت غير متصل"),
    "paywallBulletFlows": MessageLookupByLibrary.simpleMessage(
      "تدفّقات غير محدودة",
    ),
    "paywallBulletMembers": MessageLookupByLibrary.simpleMessage(
      "أعضاء منزل غير محدودين",
    ),
    "paywallBulletPhotos": MessageLookupByLibrary.simpleMessage(
      "صور تدفّق غير محدودة",
    ),
    "paywallBulletShares": MessageLookupByLibrary.simpleMessage(
      "مصاريف مشتركة غير محدودة",
    ),
    "paywallErrorTitle": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل صفحة الترقية.",
    ),
    "paywallPriceCaption": MessageLookupByLibrary.simpleMessage(
      "خطة واحدة للمنزل، دون مستويات مخفية.",
    ),
    "paywallPricePerMonth": m14,
    "paywallPriceUnavailable": MessageLookupByLibrary.simpleMessage(
      "التسعير غير متاح الآن.",
    ),
    "paywallPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "الترقية إلى كينلي بريميوم",
    ),
    "paywallPurchaseFailed": MessageLookupByLibrary.simpleMessage(
      "لم تكتمل عملية الشراء — يمكنك المحاولة مرة أخرى في أي وقت.",
    ),
    "paywallPurchaseSuccess": MessageLookupByLibrary.simpleMessage(
      "أنت الآن على كينلي بريميوم.",
    ),
    "paywallRestoreCta": MessageLookupByLibrary.simpleMessage(
      "استعادة المشتريات",
    ),
    "paywallRetryLabel": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "paywallSecondaryCta": MessageLookupByLibrary.simpleMessage(
      "البقاء على الخطة المجانية",
    ),
    "paywallSubtitle": MessageLookupByLibrary.simpleMessage(
      "ترقية على مستوى المنزل بأقل من 0.5% من إيجارك.",
    ),
    "paywallTitle": MessageLookupByLibrary.simpleMessage(
      "اجعل منزلك أكثر انسجامًا",
    ),
    "personalMentionsTitle": MessageLookupByLibrary.simpleMessage(
      "الإشارات الشخصية",
    ),
    "personalProfileLoadError": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من تحميل ملفك الشخصي الآن. يرجى المحاولة مرة أخرى.",
    ),
    "personalProfileMentions": MessageLookupByLibrary.simpleMessage(
      "الإشارات الشخصية",
    ),
    "personalProfilePreferences": MessageLookupByLibrary.simpleMessage(
      "التفضيلات الشخصية",
    ),
    "personalProfileTitle": MessageLookupByLibrary.simpleMessage("ملفك الشخصي"),
    "preferenceOnboardingBack": MessageLookupByLibrary.simpleMessage("رجوع"),
    "preferenceOnboardingProgress": m15,
    "preferenceOnboardingSubmit": MessageLookupByLibrary.simpleMessage(
      "حفظ التفضيلات",
    ),
    "preferenceOnboardingTitle": MessageLookupByLibrary.simpleMessage(
      "التفضيلات الشخصية",
    ),
    "preferencePromptCta": MessageLookupByLibrary.simpleMessage(
      "بدء التفضيلات",
    ),
    "preferencePromptSubtitle": MessageLookupByLibrary.simpleMessage(
      "أعد إعداد تفضيلاتك الشخصية حتى يتعلم منزلك كيف تحب الأمور.",
    ),
    "preferencePromptTitle": MessageLookupByLibrary.simpleMessage(
      "شارك تفضيلاتك",
    ),
    "preferenceReportDoneCta": MessageLookupByLibrary.simpleMessage("تم"),
    "preferenceReportEditCta": MessageLookupByLibrary.simpleMessage("تعديل"),
    "preferenceReportEditError": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من حفظ هذا التحديث.",
    ),
    "preferenceReportEditSectionDone": MessageLookupByLibrary.simpleMessage(
      "تم",
    ),
    "preferenceReportEditSectionHint": MessageLookupByLibrary.simpleMessage(
      "اكتب ما يبدو مناسبًا لك",
    ),
    "preferenceReportEditSectionPrompt": MessageLookupByLibrary.simpleMessage(
      "عدّل صياغة هذا القسم.",
    ),
    "preferenceReportEditTitle": MessageLookupByLibrary.simpleMessage(
      "تعديل التفضيلات",
    ),
    "preferenceReportEmptyBody": MessageLookupByLibrary.simpleMessage(
      "أكمل تفضيلاتك لتوليد التقرير.",
    ),
    "preferenceReportEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "تقرير التفضيلات غير جاهز",
    ),
    "preferenceReportErrorBody": MessageLookupByLibrary.simpleMessage(
      "يرجى المحاولة مرة أخرى.",
    ),
    "preferenceReportErrorTitle": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل التقرير",
    ),
    "preferenceReportGenerationFailed": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من إكمال انعكاس تفضيلاتك. ارجع وحاول مرة أخرى.",
    ),
    "preferenceReportGenerationMissing": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من إكمال انعكاس تفضيلاتك. يرجى المحاولة مرة أخرى قريبًا.",
    ),
    "preferenceReportReadOnlyNote": MessageLookupByLibrary.simpleMessage(
      "هذا يوضح ما يشعرون أنه مريح لهم.",
    ),
    "preferenceReportTitle": MessageLookupByLibrary.simpleMessage(
      "تقرير تفضيلاتك",
    ),
    "preferenceReportViewTitle": MessageLookupByLibrary.simpleMessage(
      "عرض التفضيلات",
    ),
    "preferenceScenarioCleanlinessSharedSpaceOption1":
        MessageLookupByLibrary.simpleMessage(
          "أشعر بأفضل حال عندما يكون المكان مرتبًا إلى حد كبير",
        ),
    "preferenceScenarioCleanlinessSharedSpaceOption2":
        MessageLookupByLibrary.simpleMessage("بعض الفوضى مقبول يوميًا"),
    "preferenceScenarioCleanlinessSharedSpaceOption3":
        MessageLookupByLibrary.simpleMessage(
          "أنا مرتاح مع الفوضى في المساحات المشتركة",
        ),
    "preferenceScenarioCleanlinessSharedSpaceQuestion":
        MessageLookupByLibrary.simpleMessage(
          "في المساحات المشتركة، ما مدى الترتيب الذي يجعلك مرتاحًا؟",
        ),
    "preferenceScenarioCommunicationChannelOption1":
        MessageLookupByLibrary.simpleMessage("الرسائل أو النص"),
    "preferenceScenarioCommunicationChannelOption2":
        MessageLookupByLibrary.simpleMessage(
          "الحديث وجهًا لوجه عندما يحين الوقت",
        ),
    "preferenceScenarioCommunicationChannelOption3":
        MessageLookupByLibrary.simpleMessage("مكالمة سريعة هي الأسهل"),
    "preferenceScenarioCommunicationChannelQuestion":
        MessageLookupByLibrary.simpleMessage(
          "عندما تحتاج إلى تنسيق في المنزل، ما الأنسب لك؟",
        ),
    "preferenceScenarioCommunicationDirectnessOption1":
        MessageLookupByLibrary.simpleMessage("بلطف، مع سياق أو تمهيد"),
    "preferenceScenarioCommunicationDirectnessOption2":
        MessageLookupByLibrary.simpleMessage("مزيج — يعتمد على الموقف"),
    "preferenceScenarioCommunicationDirectnessOption3":
        MessageLookupByLibrary.simpleMessage("مباشرة وبوضوح"),
    "preferenceScenarioCommunicationDirectnessQuestion":
        MessageLookupByLibrary.simpleMessage(
          "عندما يطرح عليك شخص ما أمرًا، كيف تفضّل أن يصلك؟",
        ),
    "preferenceScenarioConflictResolutionOption1":
        MessageLookupByLibrary.simpleMessage("أخذ وقت للهدوء أولًا"),
    "preferenceScenarioConflictResolutionOption2":
        MessageLookupByLibrary.simpleMessage("التواصل بلطف في الوقت المناسب"),
    "preferenceScenarioConflictResolutionOption3":
        MessageLookupByLibrary.simpleMessage(
          "التحدث عنه أقرب ما يمكن بدلًا من التأجيل",
        ),
    "preferenceScenarioConflictResolutionQuestion":
        MessageLookupByLibrary.simpleMessage(
          "إذا بدا أن شيئًا ما غير مريح بين الناس في المنزل، ما الذي يساعدك عادةً أكثر؟",
        ),
    "preferenceScenarioEnvironmentLightOption1":
        MessageLookupByLibrary.simpleMessage("إضاءة أهدأ أو أخفت"),
    "preferenceScenarioEnvironmentLightOption2":
        MessageLookupByLibrary.simpleMessage("إضاءة متوازنة وطبيعية"),
    "preferenceScenarioEnvironmentLightOption3":
        MessageLookupByLibrary.simpleMessage("إضاءة ساطعة وجيدة"),
    "preferenceScenarioEnvironmentLightQuestion":
        MessageLookupByLibrary.simpleMessage(
          "في المناطق المشتركة، أي نوع من الإضاءة يجعلك تشعر براحة أكبر؟",
        ),
    "preferenceScenarioEnvironmentNoiseOption1":
        MessageLookupByLibrary.simpleMessage(
          "أشعر براحة أكبر عندما تكون الأمور هادئة عمومًا",
        ),
    "preferenceScenarioEnvironmentNoiseOption2":
        MessageLookupByLibrary.simpleMessage(
          "مستوى معتدل من ضجيج الحياة اليومية مناسب",
        ),
    "preferenceScenarioEnvironmentNoiseOption3":
        MessageLookupByLibrary.simpleMessage(
          "الضجيج لا يزعجني كثيرًا — المساحات الحيوية مناسبة",
        ),
    "preferenceScenarioEnvironmentNoiseQuestion":
        MessageLookupByLibrary.simpleMessage(
          "ما مدى تقبّلك للضجيج الخلفي في المساحات المشتركة؟",
        ),
    "preferenceScenarioEnvironmentScentOption1":
        MessageLookupByLibrary.simpleMessage("أنا حساس جدًا للروائح القوية"),
    "preferenceScenarioEnvironmentScentOption2":
        MessageLookupByLibrary.simpleMessage("أنا محايد غالبًا"),
    "preferenceScenarioEnvironmentScentOption3":
        MessageLookupByLibrary.simpleMessage("الروائح القوية لا تزعجني كثيرًا"),
    "preferenceScenarioEnvironmentScentQuestion":
        MessageLookupByLibrary.simpleMessage(
          "كيف تشعر تجاه الروائح القوية (الشموع، الطبخ، المنظفات)؟",
        ),
    "preferenceScenarioPrivacyNotificationsOption1":
        MessageLookupByLibrary.simpleMessage(
          "أفضل عدم التواصل بعد ساعات الهدوء",
        ),
    "preferenceScenarioPrivacyNotificationsOption2":
        MessageLookupByLibrary.simpleMessage(
          "الرسائل المحدودة أو المهمة مقبولة",
        ),
    "preferenceScenarioPrivacyNotificationsOption3":
        MessageLookupByLibrary.simpleMessage("لا مانع لدي بالتواصل في أي وقت"),
    "preferenceScenarioPrivacyNotificationsQuestion":
        MessageLookupByLibrary.simpleMessage("كيف تشعر تجاه الرسائل ليلًا؟"),
    "preferenceScenarioPrivacyRoomEntryOption1":
        MessageLookupByLibrary.simpleMessage(
          "أفضل أن يطلبوا الإذن أو يطرقوا أولًا",
        ),
    "preferenceScenarioPrivacyRoomEntryOption2":
        MessageLookupByLibrary.simpleMessage("الطلب لطيف، لكن المرونة مقبولة"),
    "preferenceScenarioPrivacyRoomEntryOption3":
        MessageLookupByLibrary.simpleMessage(
          "أنا عمومًا مرتاح مع الوصول المفتوح",
        ),
    "preferenceScenarioPrivacyRoomEntryQuestion":
        MessageLookupByLibrary.simpleMessage(
          "بخصوص دخول غرف بعضكم، ما الذي يبدو مناسبًا لك؟",
        ),
    "preferenceScenarioRoutinePlanningOption1":
        MessageLookupByLibrary.simpleMessage("وجود خطط وهيكل يساعدني"),
    "preferenceScenarioRoutinePlanningOption2":
        MessageLookupByLibrary.simpleMessage("مزيج من التخطيط والعفوية"),
    "preferenceScenarioRoutinePlanningOption3":
        MessageLookupByLibrary.simpleMessage("السير مع التدفق هو الأفضل"),
    "preferenceScenarioRoutinePlanningQuestion":
        MessageLookupByLibrary.simpleMessage(
          "عندما يتعلق الأمر بالحياة اليومية في المنزل، ما الذي يبدو طبيعيًا لك؟",
        ),
    "preferenceScenarioScheduleQuietHoursOption1":
        MessageLookupByLibrary.simpleMessage(
          "أمسياتي تميل لأن تكون أكثر هدوءًا",
        ),
    "preferenceScenarioScheduleQuietHoursOption2":
        MessageLookupByLibrary.simpleMessage(
          "الأمر يعتمد — بعض الليالي أهدأ من غيرها",
        ),
    "preferenceScenarioScheduleQuietHoursOption3":
        MessageLookupByLibrary.simpleMessage("النشاط ليلًا لا يزعجني عادةً"),
    "preferenceScenarioScheduleQuietHoursQuestion":
        MessageLookupByLibrary.simpleMessage(
          "عندما يهدأ اليوم، ما الذي يكون مناسبًا لك عادةً في المنزل؟",
        ),
    "preferenceScenarioScheduleSleepTimingOption1":
        MessageLookupByLibrary.simpleMessage("أنام وأستيقظ مبكرًا"),
    "preferenceScenarioScheduleSleepTimingOption2":
        MessageLookupByLibrary.simpleMessage("في المنتصف تقريبًا"),
    "preferenceScenarioScheduleSleepTimingOption3":
        MessageLookupByLibrary.simpleMessage("أنام وأستيقظ متأخرًا"),
    "preferenceScenarioScheduleSleepTimingQuestion":
        MessageLookupByLibrary.simpleMessage("كيف هو جدول نومك واستيقاظك؟"),
    "preferenceScenarioSocialHostingOption1":
        MessageLookupByLibrary.simpleMessage(
          "أشعر براحة أكبر عندما يكون الضيوف نادرين",
        ),
    "preferenceScenarioSocialHostingOption2":
        MessageLookupByLibrary.simpleMessage("الضيوف أحيانًا مناسبون"),
    "preferenceScenarioSocialHostingOption3":
        MessageLookupByLibrary.simpleMessage("الضيوف بشكل متكرر مناسبون لي"),
    "preferenceScenarioSocialHostingQuestion":
        MessageLookupByLibrary.simpleMessage(
          "كيف تشعر عمومًا تجاه استضافة الضيوف في المنزل؟",
        ),
    "preferenceScenarioSocialTogethernessOption1":
        MessageLookupByLibrary.simpleMessage("في الغالب أفعل أموري وحدي"),
    "preferenceScenarioSocialTogethernessOption2":
        MessageLookupByLibrary.simpleMessage(
          "مزيج من الوقت المشترك والوقت الخاص",
        ),
    "preferenceScenarioSocialTogethernessOption3":
        MessageLookupByLibrary.simpleMessage("قضاء وقت معًا غالبًا"),
    "preferenceScenarioSocialTogethernessQuestion":
        MessageLookupByLibrary.simpleMessage(
          "في المنزل، ما التوازن الأنسب لك عادةً؟",
        ),
    "profileActionConfirm": MessageLookupByLibrary.simpleMessage(
      "مغادرة المنزل",
    ),
    "profileActionConfirmDelete": MessageLookupByLibrary.simpleMessage(
      "حذف الحساب",
    ),
    "profileConfirmDeleteMessage": MessageLookupByLibrary.simpleMessage(
      "سيزيل هذا حسابك ويسجّلك خروجًا. لا يمكنك التراجع.",
    ),
    "profileConfirmDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "حذف حسابك؟",
    ),
    "profileConfirmLeaveMessage": MessageLookupByLibrary.simpleMessage(
      "ستفقد الوصول إلى التدفّق والسجل والدعوات.",
    ),
    "profileConfirmLeaveTitle": MessageLookupByLibrary.simpleMessage(
      "مغادرة هذا المنزل؟",
    ),
    "profileConnectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "إدارة الإشعارات وتذكيراتك.",
    ),
    "profileConnectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "إعدادات الاتصال",
    ),
    "profileContactEmailSubject": MessageLookupByLibrary.simpleMessage(
      "تواصل معنا",
    ),
    "profileContactLaunchError": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من فتح تطبيق البريد. حاول مرة أخرى.",
    ),
    "profileContactUsSubtitle": MessageLookupByLibrary.simpleMessage(
      "أرسل بريدًا إلى support@makinglifeeasie.com",
    ),
    "profileContactUsTitle": MessageLookupByLibrary.simpleMessage("تواصل معنا"),
    "profileDeleteAccountSubtitle": MessageLookupByLibrary.simpleMessage(
      "إزالة حساب كينلي وبيانات ملفك الشخصي.",
    ),
    "profileDeleteAccountTitle": MessageLookupByLibrary.simpleMessage(
      "حذف الحساب",
    ),
    "profileDeleteSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "سيتم حذف حسابك قريبًا. سنسجّلك خروجًا.",
    ),
    "profileGenericError": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ ما. يرجى المحاولة مرة أخرى.",
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
      "لم نتمكن من تحميل ملفك الشخصي الآن.",
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
      "استخدم 3-30 حرفًا أو رقمًا صغيرًا. يمكنك إضافة نقاط أو شرطات سفلية في الوسط.",
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
      "اسم المستخدم هذا محجوز. جرّب اسمًا آخر.",
    ),
    "profileInfoHubLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل مركز المعلومات. تحقّق من الاتصال.",
    ),
    "profileInfoHubSubtitle": MessageLookupByLibrary.simpleMessage(
      "افتح مركز كينلي على Notion داخل التطبيق.",
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
      "مالك المنزل فقط يمكنه إزالة الأعضاء.",
    ),
    "profileKickSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر عضوًا لإزالته. سيفقد الوصول فورًا.",
    ),
    "profileKickSheetTitle": MessageLookupByLibrary.simpleMessage("إزالة عضو"),
    "profileKickSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "لم يعد لديه وصول إلى هذا المنزل.",
    ),
    "profileLeaveEligibilityError": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من تحميل أعضاء منزلك. حاول مرة أخرى.",
    ),
    "profileLeaveEligibilityLoading": MessageLookupByLibrary.simpleMessage(
      "جارٍ التحقق من أعضاء المنزل...",
    ),
    "profileLeaveHomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "مغادرة هذا المنزل تعني الخروج من مساحة كينلي المشتركة.",
    ),
    "profileLeaveHomeTitle": MessageLookupByLibrary.simpleMessage(
      "مغادرة المنزل",
    ),
    "profileLeaveOwnerNoEligibleMembers": MessageLookupByLibrary.simpleMessage(
      "لا يمكن لأي شخص آخر تولي الملكية الآن. حاول لاحقًا.",
    ),
    "profileLeaveOwnerSoloMessage": MessageLookupByLibrary.simpleMessage(
      "أنت آخر عضو. المغادرة ستعطّل هذا المنزل.",
    ),
    "profileLeaveSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "غادرت منزلك.",
    ),
    "profileLeaveTransferSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر من سيصبح المالك الجديد قبل أن تغادر.",
    ),
    "profileLeaveTransferSheetTitle": MessageLookupByLibrary.simpleMessage(
      "نقل الملكية",
    ),
    "profileLeaveTransferSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "تم نقل الملكية. جارٍ إنهاء مغادرتك...",
    ),
    "profileLogoutSubtitle": MessageLookupByLibrary.simpleMessage(
      "تسجيل الخروج من كينلي على هذا الجهاز.",
    ),
    "profileLogoutTitle": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
    "profileMissingHomeError": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من العثور على منزلك الحالي. حاول مرة أخرى.",
    ),
    "profileSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "إدارة تفضيلات حسابك ووصول المنزل.",
    ),
    "profileSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "الملف الشخصي والمنزل",
    ),
    "profile_deactivated_message": MessageLookupByLibrary.simpleMessage(
      "تم إلغاء تنشيط ملفك الشخصي. يرجى تسجيل الدخول باستخدام بريد إلكتروني آخر.",
    ),
    "pulseCloudySteadySummary": MessageLookupByLibrary.simpleMessage(
      "هذا الأسبوع كان مختلطًا وثابتًا.",
    ),
    "pulseCloudySteadyTitle": MessageLookupByLibrary.simpleMessage(
      "مختلط وثابت",
    ),
    "pulseCloudyTenseSummary": MessageLookupByLibrary.simpleMessage(
      "هذا الأسبوع كان مختلطًا، مع بعض التوتر.",
    ),
    "pulseCloudyTenseTitle": MessageLookupByLibrary.simpleMessage(
      "مختلط مع توتر",
    ),
    "pulseFormingSummary": MessageLookupByLibrary.simpleMessage(
      "بضع عمليات تسجيل إضافية تساعد.",
    ),
    "pulseFormingTitle": MessageLookupByLibrary.simpleMessage("لا يزال يتكوّن"),
    "pulsePartlySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك كان لا بأس به، مع ظهور العناية.",
    ),
    "pulsePartlySupportedTitle": MessageLookupByLibrary.simpleMessage(
      "لا بأس مع عناية",
    ),
    "pulseRainySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "هذا الأسبوع كان أثقل، لكن العناية كانت حاضرة.",
    ),
    "pulseRainySupportedTitle": MessageLookupByLibrary.simpleMessage(
      "ثقيل لكن مع دعم",
    ),
    "pulseRainyUnsupportedSummary": MessageLookupByLibrary.simpleMessage(
      "هذا الأسبوع كان ثقيلًا. قد يساعد الدعم.",
    ),
    "pulseRainyUnsupportedTitle": MessageLookupByLibrary.simpleMessage(
      "ثقيل، يحتاج دعمًا",
    ),
    "pulseSunnyBumpySummary": MessageLookupByLibrary.simpleMessage(
      "هذا الأسبوع كان جيدًا في الغالب، مع بعض التعثرات.",
    ),
    "pulseSunnyBumpyTitle": MessageLookupByLibrary.simpleMessage("جيد غالبًا"),
    "pulseSunnyCalmSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك كان دافئًا وسهلًا هذا الأسبوع.",
    ),
    "pulseSunnyCalmTitle": MessageLookupByLibrary.simpleMessage("دافئ وسهل"),
    "pulseThunderstormSummary": MessageLookupByLibrary.simpleMessage(
      "هذا الأسبوع كان متوترًا. اللطف مهم الآن.",
    ),
    "pulseThunderstormTitle": MessageLookupByLibrary.simpleMessage(
      "متوتر الآن",
    ),
    "quick_add_flow_subtitle": MessageLookupByLibrary.simpleMessage(
      "إنشاء تدفّق",
    ),
    "quick_add_flow_title": MessageLookupByLibrary.simpleMessage("تدفّق"),
    "quick_add_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "إضافة فاتورة",
    ),
    "quick_add_share_title": MessageLookupByLibrary.simpleMessage("فاتورة"),
    "quick_add_title": MessageLookupByLibrary.simpleMessage("إضافة سريعة"),
    "reflectiveAcknowledgementTitle": MessageLookupByLibrary.simpleMessage(
      "حسنًا.",
    ),
    "reflectiveGenericPrimary": MessageLookupByLibrary.simpleMessage(
      "نجمع هذا بعناية.",
    ),
    "reflectiveGenericSecondary": MessageLookupByLibrary.simpleMessage(
      "لحظة هادئة قبل أن نعرضه.",
    ),
    "reflectiveHousePrimary": MessageLookupByLibrary.simpleMessage(
      "نضع توقعات المنزل في كلمات.",
    ),
    "reflectiveHouseSecondary": MessageLookupByLibrary.simpleMessage(
      "كي يعرف الجميع ما الذي يتوقعونه.",
    ),
    "reflectivePersonalPrimary": MessageLookupByLibrary.simpleMessage(
      "نعكس ما شاركته.",
    ),
    "reflectivePersonalSecondary": MessageLookupByLibrary.simpleMessage(
      "كي يفهم الآخرون ما الذي يجعلك مرتاحًا.",
    ),
    "shareCreateAmountHint": MessageLookupByLibrary.simpleMessage("0.00"),
    "shareCreateAmountLabel": MessageLookupByLibrary.simpleMessage("المبلغ"),
    "shareCreateCustomAmountLabel": MessageLookupByLibrary.simpleMessage(
      "المبلغ",
    ),
    "shareCreateCustomHelper": MessageLookupByLibrary.simpleMessage(
      "أدخل نصيب كل شخص. تأكد أن الإجمالي يطابق المبلغ أعلاه.",
    ),
    "shareCreateCyclePeriod": m16,
    "shareCreateDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "مثلاً: مشتريات البقالة",
    ),
    "shareCreateDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "الوصف",
    ),
    "shareCreateErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "ليس لديك إذن للإنشاء الآن.",
    ),
    "shareCreateErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذّر الإنشاء. حاول مرة أخرى.",
    ),
    "shareCreateErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "لقد وصلت إلى الحد المجاني للفواتير النشطة. قم بالترقية لمساحة أكبر.",
    ),
    "shareCreateErrorRecurrenceDraft": MessageLookupByLibrary.simpleMessage(
      "لا يمكن للمسودات أن تتكرر حتى تضيف تقسيمًا.",
    ),
    "shareCreateLoadError": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من تحميل أفراد منزلك.",
    ),
    "shareCreateNotesHint": MessageLookupByLibrary.simpleMessage(
      "سياق اختياري يراه الجميع",
    ),
    "shareCreateNotesLabel": MessageLookupByLibrary.simpleMessage("سياق"),
    "shareCreateParticipantsEmpty": MessageLookupByLibrary.simpleMessage(
      "تحتاج إلى عضوين على الأقل في المنزل للمشاركة.",
    ),
    "shareCreateRecurrenceEveryLabel": MessageLookupByLibrary.simpleMessage(
      "كل",
    ),
    "shareCreateRecurrenceLabel": MessageLookupByLibrary.simpleMessage("تكرار"),
    "shareCreateRecurrenceToggleLabel": MessageLookupByLibrary.simpleMessage(
      "متكرر",
    ),
    "shareCreateRecurrenceUnitDay": MessageLookupByLibrary.simpleMessage("يوم"),
    "shareCreateRecurrenceUnitMonth": MessageLookupByLibrary.simpleMessage(
      "شهر",
    ),
    "shareCreateRecurrenceUnitWeek": MessageLookupByLibrary.simpleMessage(
      "أسبوع",
    ),
    "shareCreateRecurrenceUnitYear": MessageLookupByLibrary.simpleMessage(
      "سنة",
    ),
    "shareCreateRetry": MessageLookupByLibrary.simpleMessage("حاول مرة أخرى"),
    "shareCreateSplitCustom": MessageLookupByLibrary.simpleMessage(
      "تحديد المبالغ",
    ),
    "shareCreateSplitEqual": MessageLookupByLibrary.simpleMessage(
      "تقسيم بالتساوي",
    ),
    "shareCreateSplitLabel": MessageLookupByLibrary.simpleMessage(
      "كيف نريد تقسيم هذه الفاتورة؟",
    ),
    "shareCreateStartLabel": MessageLookupByLibrary.simpleMessage(
      "متى ينطبق هذا؟",
    ),
    "shareCreateSubmit": MessageLookupByLibrary.simpleMessage("إنشاء"),
    "shareCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء الفاتورة.",
    ),
    "shareCreateTitle": MessageLookupByLibrary.simpleMessage("إنشاء فاتورة"),
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
          "قسّم المبلغ بين شخصين على الأقل عند استخدام تقسيم مخصص.",
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
    "shareCreateValidationRecurrence": MessageLookupByLibrary.simpleMessage(
      "اختر وتيرة التكرار.",
    ),
    "shareCreateValidationRecurrenceSplit":
        MessageLookupByLibrary.simpleMessage(
          "اختر طريقة التقسيم قبل ضبط التكرار.",
        ),
    "shareCreateValidationStartDate": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخ بدء.",
    ),
    "shareCreateValidationStartDateRange": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخًا ضمن النطاق المسموح.",
    ),
    "shareCreatedListActiveAmount": m17,
    "shareCreatedListActiveSubtitle": m18,
    "shareCreatedListDraftBadge": MessageLookupByLibrary.simpleMessage(
      "غير مكلّف",
    ),
    "shareCreatedListDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "قسّمها حتى يعرف الجميع نصيبه قبل النشر.",
    ),
    "shareCreatedListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "الفواتير تُوضّح المال بين الناس — دون تذكيرات محرجة.",
    ),
    "shareCreatedListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد فواتير بعد",
    ),
    "shareCreatedListError": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من تحميل فواتيرك. اسحب للتحديث.",
    ),
    "shareCreatedListPaidBadge": MessageLookupByLibrary.simpleMessage(
      "تم السداد",
    ),
    "shareCreatedListRetry": MessageLookupByLibrary.simpleMessage(
      "حاول مرة أخرى",
    ),
    "shareCreatedListTitle": MessageLookupByLibrary.simpleMessage("فواتيرك"),
    "shareEditClose": MessageLookupByLibrary.simpleMessage("إغلاق"),
    "shareEditDeleteButton": MessageLookupByLibrary.simpleMessage("حذف"),
    "shareEditDeleteConfirm": MessageLookupByLibrary.simpleMessage("حذف"),
    "shareEditDeleteConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "سيزيل هذا المسودة للجميع.",
    ),
    "shareEditDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage("حذف؟"),
    "shareEditDeleteError": MessageLookupByLibrary.simpleMessage(
      "تعذّر الحذف. حاول مرة أخرى.",
    ),
    "shareEditDeleteSuccess": MessageLookupByLibrary.simpleMessage(
      "تم حذف الفاتورة.",
    ),
    "shareEditDisabledActive": MessageLookupByLibrary.simpleMessage(
      "الفواتير النشطة مقفلة عن التحرير.",
    ),
    "shareEditDisabledConverted": MessageLookupByLibrary.simpleMessage(
      "هذه الفاتورة أصبحت خطة، والتحرير متوقف.",
    ),
    "shareEditDisabledGeneric": MessageLookupByLibrary.simpleMessage(
      "تحرير هذه الفاتورة غير متاح الآن.",
    ),
    "shareEditDisabledRecurringCycle": MessageLookupByLibrary.simpleMessage(
      "الدورات المتكررة مقفلة عن التحرير هنا.",
    ),
    "shareEditLoadError": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من تحميل هذه المسودة.",
    ),
    "shareEditNotAllowed": MessageLookupByLibrary.simpleMessage(
      "ستبقى مقفلة حتى يأخذها أحد.",
    ),
    "shareEditSplitsLocked": MessageLookupByLibrary.simpleMessage(
      "التقسيمات مقفلة لأن أحدهم دفع بالفعل. ما زلت تستطيع تحديث الوصف والملاحظات.",
    ),
    "shareEditSubmit": MessageLookupByLibrary.simpleMessage("تحديث"),
    "shareEditSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تحديث الفاتورة.",
    ),
    "shareEditTerminateError": MessageLookupByLibrary.simpleMessage(
      "تعذّر إنهاء الخطة. حاول مرة أخرى.",
    ),
    "shareEditTerminatePlan": MessageLookupByLibrary.simpleMessage(
      "إنهاء الخطة",
    ),
    "shareEditTerminatePlanBusy": MessageLookupByLibrary.simpleMessage(
      "جارٍ الإنهاء...",
    ),
    "shareEditTerminatePlanConfirm": MessageLookupByLibrary.simpleMessage(
      "إنهاء الخطة",
    ),
    "shareEditTerminatePlanMessage": MessageLookupByLibrary.simpleMessage(
      "سيوقف هذا دورات الفواتير المستقبلية.",
    ),
    "shareEditTerminatePlanTitle": MessageLookupByLibrary.simpleMessage(
      "إنهاء الخطة المتكررة؟",
    ),
    "shareEditTerminateSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إنهاء الخطة.",
    ),
    "shareEditTitle": MessageLookupByLibrary.simpleMessage("تعديل الفاتورة"),
    "shareOwedDetailEmpty": MessageLookupByLibrary.simpleMessage(
      "لقد أنهيت كل شيء مع هذا الشخص.",
    ),
    "shareOwedDetailError": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من وضع علامة على هذه الفاتورة كمُسددة. حاول مرة أخرى.",
    ),
    "shareOwedDetailPaid": MessageLookupByLibrary.simpleMessage(
      "وضع علامة تمت التسوية",
    ),
    "shareOwedDetailSuccess": MessageLookupByLibrary.simpleMessage(
      "تمت التسوية.",
    ),
    "shareOwedDetailTitle": MessageLookupByLibrary.simpleMessage("للتسوية"),
    "sharePaidDetailAcknowledge": MessageLookupByLibrary.simpleMessage(
      "تأكيد الاستلام",
    ),
    "sharePaidDetailAcknowledgeError": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من تأكيد استلام الفواتير.",
    ),
    "sharePaidDetailAcknowledging": MessageLookupByLibrary.simpleMessage(
      "جارٍ التأكيد...",
    ),
    "startReturningSubtitle": MessageLookupByLibrary.simpleMessage(
      "ماذا تريد أن تفعل بعد ذلك؟",
    ),
    "startReturningTitle": m19,
    "todayAddSheetFlow": MessageLookupByLibrary.simpleMessage("إضافة تدفّق"),
    "todayAddSheetShare": MessageLookupByLibrary.simpleMessage("إضافة فاتورة"),
    "todayAddSheetTitle": MessageLookupByLibrary.simpleMessage("أضف إلى منزلك"),
    "todayEmptyBody": MessageLookupByLibrary.simpleMessage(
      "استمتع بالهدوء — سيُخبرك كينلي عندما يحتاج شيء إلى انتباهك.",
    ),
    "todayEmptyCardBadge": MessageLookupByLibrary.simpleMessage("خذ نفسًا"),
    "todayEmptyCardTitle": MessageLookupByLibrary.simpleMessage(
      "لقد أنهيت كل شيء اليوم",
    ),
    "todayFlatmateInviteSubtitle": MessageLookupByLibrary.simpleMessage(
      "ادعُهم كي تبقوا متوافقين وتتقاسموا الحمل.",
    ),
    "todayFlatmateInviteTitle": MessageLookupByLibrary.simpleMessage(
      "أدخل منزلك إلى كينلي",
    ),
    "todayFlowBadgeNew": MessageLookupByLibrary.simpleMessage("جديد اليوم"),
    "todayFlowSectionTitle": MessageLookupByLibrary.simpleMessage("التدفّق"),
    "todayFlowSeeAll": m20,
    "todayFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "إليك ما يجري في منزلك اليوم.",
    ),
    "todayFlowTabActive": MessageLookupByLibrary.simpleMessage("نشط"),
    "todayFlowTabDrafts": MessageLookupByLibrary.simpleMessage("مسودات"),
    "todayGratitudeHouseCta": MessageLookupByLibrary.simpleMessage(
      "جدار المنزل",
    ),
    "todayGratitudePersonalCta": MessageLookupByLibrary.simpleMessage(
      "الجدار الشخصي",
    ),
    "todayGratitudeSectionTitle": MessageLookupByLibrary.simpleMessage(
      "جدار الامتنان",
    ),
    "todayGratitudeUnreadBody": MessageLookupByLibrary.simpleMessage(
      "هناك منشورات امتنان جديدة بانتظارك.",
    ),
    "todayInviteFriendsSubtitle": MessageLookupByLibrary.simpleMessage(
      "شارك كينلي مع صديق ليجلب مزيدًا من الانسجام إلى منزله أيضًا.",
    ),
    "todayInviteFriendsTitle": MessageLookupByLibrary.simpleMessage(
      "ادعُ الأصدقاء إلى كينلي",
    ),
    "todayInviteNotNow": MessageLookupByLibrary.simpleMessage("ليس الآن"),
    "todayInviteShareCta": MessageLookupByLibrary.simpleMessage(
      "مشاركة الدعوة",
    ),
    "todayMemberCapPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "ترقية المنزل",
    ),
    "todayMemberCapResolutionFailed": m21,
    "todayMemberCapResolutionJoined": m22,
    "todayMemberCapResolutionSuperseded": m23,
    "todayMemberCapResolutionUnknownName": MessageLookupByLibrary.simpleMessage(
      "شخص ما",
    ),
    "todayMemberCapSecondaryCta": MessageLookupByLibrary.simpleMessage("تجاهل"),
    "todayMemberCapSubtitle": m24,
    "todayMemberCapSubtitleGeneric": MessageLookupByLibrary.simpleMessage(
      "منزلك يكبر. قم بالترقية للترحيب بالمزيد من الأشخاص.",
    ),
    "todayMemberCapTitle": MessageLookupByLibrary.simpleMessage(
      "هناك شخص يريد الانضمام إلى منزلك",
    ),
    "todayShareActiveSubtitle": m25,
    "todayShareError": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من تحديث قسم المشاركة الآن.",
    ),
    "todaySharePaidSubtitle": MessageLookupByLibrary.simpleMessage(
      "المبلغ المُسوّى",
    ),
    "todaySharePaidUnseen": m26,
    "todayShareSectionTitle": MessageLookupByLibrary.simpleMessage("فاتورة"),
    "todayShareTabActive": MessageLookupByLibrary.simpleMessage("للتسوية"),
    "todayShareTabDrafts": MessageLookupByLibrary.simpleMessage("مسودات"),
    "todayShareTabPaidToMe": MessageLookupByLibrary.simpleMessage(
      "تمت التسوية",
    ),
    "vibeCozySocialSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك مريح وهادئ عندما يقضي الناس وقتًا معًا.",
    ),
    "vibeCozySocialTitle": MessageLookupByLibrary.simpleMessage(
      "اجتماعي دافئ ومريح",
    ),
    "vibeDefaultSummary": MessageLookupByLibrary.simpleMessage(
      "يبدو منزلك سهل العيش للجميع.",
    ),
    "vibeDefaultTitle": MessageLookupByLibrary.simpleMessage("منزل متوازن"),
    "vibeEasygoingSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك مرتاح ومنفتح على التغيير يومًا بيوم.",
    ),
    "vibeEasygoingTitle": MessageLookupByLibrary.simpleMessage("تدفّق مرن"),
    "vibeIndependentSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك يدعم المساحة والهدوء.",
    ),
    "vibeIndependentTitle": MessageLookupByLibrary.simpleMessage("هدوء مستقل"),
    "vibeInsufficientSummary": MessageLookupByLibrary.simpleMessage(
      "أكمل التفضيلات لرؤية طابع منزلك.",
    ),
    "vibeInsufficientTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد بيانات كافية بعد",
    ),
    "vibeMixedSummary": MessageLookupByLibrary.simpleMessage(
      "يُظهر منزلك مزيجًا من أساليب الراحة، متأثرًا بكيف يحب الناس المختلفون العيش.",
    ),
    "vibeMixedTitle": MessageLookupByLibrary.simpleMessage("منزل بطابع مختلط"),
    "vibeQuietCareSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك هادئ، بطاقة لطيفة وإيقاع أهدأ.",
    ),
    "vibeQuietCareTitle": MessageLookupByLibrary.simpleMessage("عناية هادئة"),
    "vibeSocialSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك نشِط، والناس معًا.",
    ),
    "vibeSocialTitle": MessageLookupByLibrary.simpleMessage("طاقة اجتماعية"),
    "vibeSteadySummary": MessageLookupByLibrary.simpleMessage(
      "منزلك ثابت، ويظهر الاهتمام عبر العادات اليومية.",
    ),
    "vibeSteadyTitle": MessageLookupByLibrary.simpleMessage("هدوء ثابت"),
    "vibeStructuredSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك يعمل أفضل مع روتين واضح وخطط مشتركة.",
    ),
    "vibeStructuredTitle": MessageLookupByLibrary.simpleMessage("إيقاع منظّم"),
    "vibeWarmSocialSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك دافئ ومرحِّب، والناس غالبًا معًا.",
    ),
    "vibeWarmSocialTitle": MessageLookupByLibrary.simpleMessage("اجتماعي دافئ"),
    "welcome_create": MessageLookupByLibrary.simpleMessage("إنشاء منزل"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("الانضمام إلى منزل"),
    "welcome_title": MessageLookupByLibrary.simpleMessage("مرحبًا بك في كينلي"),
  };
}
