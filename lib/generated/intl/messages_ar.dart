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

  static String m0(env) => "بدء تشغيل كينلي (${env})";

  static String m1(time) => "مجدول في ${time}";

  static String m2(current) => "وصول تجريبي: ${current} من 7 نقرات";

  static String m3(appName) => "صُنع باستخدام ${appName} - معًا يصبح الأمر أخف";

  static String m4(link) =>
      "بعض الإشادات من منزلنا على كينلي. حمّل التطبيق: ${link}";

  static String m5(weeks) =>
      "${Intl.plural(weeks, zero: 'هذا الأسبوع', one: 'قبل أسبوع واحد', other: 'قبل # أسابيع')}";

  static String m6(partOfDay, name) => "${partOfDay} سعيد، ${name}";

  static String m7(answered, total) =>
      "بناءً على ${answered} من ${total} أعضاء";

  static String m8(link) =>
      "مشاركة نبض منزلنا على كينلي. حمّل التطبيق: ${link}";

  static String m9(date) => "تم التحديث ${date}";

  static String m10(link) =>
      "نشارك طابع منزلنا على كينلي. حمّل التطبيق: ${link}";

  static String m11(link) => "شارك كينلي ليصبح العيش معًا أخف: ${link}";

  static String m12(code, link) =>
      "مرحبًا بك في منزلنا على كينلي! أدخل رمز الدعوة: ${code}\n\nحمّل تطبيق كينلي: ${link}";

  static String m13(code) => "تم الأمر. أهلًا بك في المنزل.";

  static String m14(price) => "${price} شهريًا.";

  static String m15(current, total) => "سؤال ${current} من ${total}";

  static String m16(period) => "ينطبق على ${period}";

  static String m17(total, included, difference) =>
      "التقسيم المخصص غير متطابق. الإجمالي: ${total}. المُضمَّن: ${included}. الفرق: ${difference}.";

  static String m18(paidAmount, totalAmount) =>
      "تم تحصيل ${paidAmount} من ${totalAmount}";

  static String m19(paid, total) => "تم دفع ${paid} من ${total}";

  static String m20(count) =>
      "${Intl.plural(count, one: '${count} عنصر للتأشير', other: '${count} عناصر للتأشير')}";

  static String m21(name) => "مرحبًا ${name}";

  static String m22(count) =>
      "عرض الكل ${Intl.plural(count, one: '(#)', other: '(#)')}";

  static String m23(name) => "لم نتمكن من إكمال طلب ${name}.";

  static String m24(name) => "انضم ${name} إلى منزلك.";

  static String m25(name) => "انضم ${name} إلى منزل آخر.";

  static String m26(names) =>
      "${names} يريد الانضمام إلى منزلك. قم بالترقية لدعم عدد غير محدود من الأعضاء.";

  static String m27(count) =>
      "${Intl.plural(count, one: '${count} دفعة معلّقة', other: '${count} للتسوية')}";

  static String m28(count) =>
      "${Intl.plural(count, one: '${count} دفعة جديدة لك', other: '${count} دفعات جديدة لك')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("كينلي"),
    "authMembershipLoadFailed": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحديث عضوية منزلك. يرجى المحاولة مرة أخرى.",
    ),
    "bootstrap_initializing": m0,
    "close": MessageLookupByLibrary.simpleMessage("إغلاق"),
    "connectionNotificationsPermissionBlocked":
        MessageLookupByLibrary.simpleMessage(
          "فعّل الإشعارات في إعدادات هاتفك لاستخدام هذا.",
        ),
    "connectionNotificationsTimeLabel": MessageLookupByLibrary.simpleMessage(
      "وقت التذكير",
    ),
    "connectionNotificationsTimeSubtitle": m1,
    "connectionNotificationsToggleSubtitleOff":
        MessageLookupByLibrary.simpleMessage("فعّل التذكيرات حول منزلك."),
    "connectionNotificationsToggleSubtitleOn":
        MessageLookupByLibrary.simpleMessage("احصل على تذكير واحد كل يوم."),
    "connectionNotificationsToggleTitle": MessageLookupByLibrary.simpleMessage(
      "إشعارات يومية",
    ),
    "connectionSettingsGenericError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحديث إعدادات الاتصال. حاول مرة أخرى.",
    ),
    "connectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "تحكّم بتذكير اليوم الواحد وتوقيت الإشعارات.",
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
      "تعذّر تسجيل الدخول. يرجى التحقق من بياناتك.",
    ),
    "demoAccessPassword": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "demoAccessSubmit": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "demoAccessTapHint": m2,
    "exploreFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "اطّلع على ما يجب فعله ومن سيتولى ذلك.",
    ),
    "exploreIntroSubtitle": MessageLookupByLibrary.simpleMessage(
      "حدّث الحالة والتفاصيل لإبقاء الأمور المشتركة واضحة.",
    ),
    "exploreShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "اطّلع على كل فاتورة أنشأتها وتتبع التحصيل.",
    ),
    "exploreShoppingSectionTitle": MessageLookupByLibrary.simpleMessage(
      "قائمة التسوّق",
    ),
    "exploreShoppingSubtitle": MessageLookupByLibrary.simpleMessage(
      "عرض وإدارة عناصر التسوّق المشتركة.",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage(
      "من سيتولى هذا؟",
    ),
    "flowChoreCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء المهمة.",
    ),
    "flowChoreCreateTitle": MessageLookupByLibrary.simpleMessage("إضافة مهمة"),
    "flowChoreDeleteButton": MessageLookupByLibrary.simpleMessage("حذف التدفق"),
    "flowChoreDeleteConfirm": MessageLookupByLibrary.simpleMessage("حذف"),
    "flowChoreDeleteDialogMessage": MessageLookupByLibrary.simpleMessage(
      "سيؤدي ذلك إلى إزالة التدفق للجميع في منزلك.",
    ),
    "flowChoreDeleteDialogTitle": MessageLookupByLibrary.simpleMessage(
      "حذف هذا التدفق؟",
    ),
    "flowChoreDetailCompleteButton": MessageLookupByLibrary.simpleMessage(
      "وضع علامة كمكتمل",
    ),
    "flowChoreDetailCompletionError": MessageLookupByLibrary.simpleMessage(
      "تعذّر إكمال هذه المهمة. يرجى المحاولة مرة أخرى.",
    ),
    "flowChoreDetailCompletionSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إكمال المهمة.",
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
      "تفاصيل المهمة",
    ),
    "flowChoreDetailUnassigned": MessageLookupByLibrary.simpleMessage(
      "غير مُسندة",
    ),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage("تعديل المهمة"),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "هذا العضو ليس ضمن هذا المنزل الآن.",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "ليس لديك إذن لتغيير هذا التدفق.",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذّر حفظ هذا التدفق. يرجى المحاولة مرة أخرى.",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "مسار الصورة غير صالح لهذا المنزل.",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخ بدء صالحًا.",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "هذا التدفق غير متاح للتحديث الآن.",
    ),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "وصلت إلى الحد المجاني للتدفقات النشطة. قم بالترقية للمزيد.",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "وصلت إلى الحد المجاني لصور التدفق. قم بالترقية للمزيد.",
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
      "تعذّر فتح هذا الرابط. حاول مرة أخرى.",
    ),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل هذه المهمة. يرجى المحاولة مرة أخرى.",
    ),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage(
      "مثل: ليلة إخراج القمامة، تنظيف الثلاجة، سقي النباتات",
    ),
    "flowChoreNameLabel": MessageLookupByLibrary.simpleMessage(
      "ما الذي يجب إنجازه؟",
    ),
    "flowChoreNotesHint": MessageLookupByLibrary.simpleMessage(
      "أي شيء يساعد الآخرين على تنفيذ المهمة بسهولة",
    ),
    "flowChoreNotesLabel": MessageLookupByLibrary.simpleMessage(
      "لماذا هذا مهم",
    ),
    "flowChorePhotoLabel": MessageLookupByLibrary.simpleMessage(
      "ما الذي يبدو جيدًا",
    ),
    "flowChorePhotoLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل الصورة",
    ),
    "flowChorePhotoPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "اسمح بالوصول للكاميرا لالتقاط صورة.",
    ),
    "flowChorePhotoPermissionOpenSettings":
        MessageLookupByLibrary.simpleMessage("فتح الإعدادات"),
    "flowChorePhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "قد تساعد الصورة الجميع على البقاء متوافقين",
    ),
    "flowChorePhotoUploadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر رفع الصورة. حاول مرة أخرى.",
    ),
    "flowChoreRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "كم مرة يتكرر هذا؟",
    ),
    "flowChoreRecurrenceNone": MessageLookupByLibrary.simpleMessage(
      "مرة واحدة",
    ),
    "flowChoreRetry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "flowChoreStartLabel": MessageLookupByLibrary.simpleMessage(
      "متى يحدث هذا؟ ",
    ),
    "flowChoreSubmitCreate": MessageLookupByLibrary.simpleMessage(
      "إنشاء التدفق",
    ),
    "flowChoreSubmitUpdate": MessageLookupByLibrary.simpleMessage(
      "حفظ التغييرات",
    ),
    "flowChoreUpdateSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تحديث المهمة.",
    ),
    "flowChoreValidationAssignee": MessageLookupByLibrary.simpleMessage(
      "اختر شخصًا.",
    ),
    "flowChoreValidationDate": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخًا حتى سنة من اليوم.",
    ),
    "flowChoreValidationHowToUrl": MessageLookupByLibrary.simpleMessage(
      "أدخل رابطًا صالحًا يبدأ بـ http أو https.",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage(
      "سمِّ هذه المهمة.",
    ),
    "flowListDraftLabel": MessageLookupByLibrary.simpleMessage("مسودة"),
    "flowListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "مهام لإبقاء الجميع متوافقين.",
    ),
    "flowListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا شيء هنا بعد",
    ),
    "flowListError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل المهام. اسحب للتحديث.",
    ),
    "flowListOverdueLabel": MessageLookupByLibrary.simpleMessage(
      "يحتاج انتباهًا",
    ),
    "flowListTabCurrent": MessageLookupByLibrary.simpleMessage("الحالية"),
    "flowListTabFuture": MessageLookupByLibrary.simpleMessage("القادمة"),
    "force_update_body": MessageLookupByLibrary.simpleMessage(
      "لم تعد هذه النسخة من كينلي مدعومة. يرجى تثبيت أحدث إصدار للمتابعة.",
    ),
    "force_update_button": MessageLookupByLibrary.simpleMessage("تحديث كينلي"),
    "force_update_title": MessageLookupByLibrary.simpleMessage("يلزم تحديث"),
    "friendDefaultName": MessageLookupByLibrary.simpleMessage("صديق"),
    "gratitudeWallEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "مكان الإشادات السريعة هنا.\n\nأضف واحدة من هذا الأسبوع.",
    ),
    "gratitudeWallEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد إشادات بعد",
    ),
    "gratitudeWallErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل الإشادات الآن.",
    ),
    "gratitudeWallFooter": m3,
    "gratitudeWallHouseTab": MessageLookupByLibrary.simpleMessage("المنزل"),
    "gratitudeWallPersonalSummary": MessageLookupByLibrary.simpleMessage(
      "مكان خاص لحفظ شكر سريع.",
    ),
    "gratitudeWallPersonalTab": MessageLookupByLibrary.simpleMessage("خاصتي"),
    "gratitudeWallPersonalTitle": MessageLookupByLibrary.simpleMessage(
      "إشاداتي",
    ),
    "gratitudeWallRetry": MessageLookupByLibrary.simpleMessage("حاول مرة أخرى"),
    "gratitudeWallShareCta": MessageLookupByLibrary.simpleMessage("مشاركة"),
    "gratitudeWallShareError": MessageLookupByLibrary.simpleMessage(
      "تعذّرت المشاركة الآن. يرجى المحاولة مرة أخرى.",
    ),
    "gratitudeWallShareMessage": m4,
    "gratitudeWallShareTitle": MessageLookupByLibrary.simpleMessage(
      "إشادات المنزل",
    ),
    "gratitudeWallStatsHomes": MessageLookupByLibrary.simpleMessage("منازل"),
    "gratitudeWallStatsMentions": MessageLookupByLibrary.simpleMessage(
      "إشادات",
    ),
    "gratitudeWallStatsPeople": MessageLookupByLibrary.simpleMessage("أشخاص"),
    "gratitudeWallWeeksAgo": m5,
    "greetingPartOfDay": m6,
    "harmonyCommentHint": MessageLookupByLibrary.simpleMessage(
      "أضف سياقًا إن كان مفيدًا",
    ),
    "harmonyCommentLabel": MessageLookupByLibrary.simpleMessage(
      "ملاحظة اختيارية",
    ),
    "harmonyErrorAlreadySubmitted": MessageLookupByLibrary.simpleMessage(
      "لقد أرسلت لهذا الأسبوع بالفعل.",
    ),
    "harmonyErrorCommentRequiredForMention":
        MessageLookupByLibrary.simpleMessage(
          "أضف ملاحظة قصيرة لإرسال هذه الإشارة.",
        ),
    "harmonyErrorCommentRequiredForPublicWall":
        MessageLookupByLibrary.simpleMessage(
          "أضف ملاحظة قصيرة لنشر هذا الشكر.",
        ),
    "harmonyErrorComplaintNeedsSentence": MessageLookupByLibrary.simpleMessage(
      "أضف جملة واضحة لتكون أسهل للفهم.",
    ),
    "harmonyErrorComplaintTooBrief": MessageLookupByLibrary.simpleMessage(
      "اكتب جملة قصيرة لتكون أسهل للفهم.",
    ),
    "harmonyErrorComplaintTooShort": MessageLookupByLibrary.simpleMessage(
      "أضف مزيدًا من التفاصيل ليكون الأمر واضحًا.",
    ),
    "harmonyErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "الإرسال لهذا المنزل غير متاح.",
    ),
    "harmonyErrorSingleMentionRequired": MessageLookupByLibrary.simpleMessage(
      "اختر شخصًا واحدًا لهذه الملاحظة.",
    ),
    "harmonyErrorUnknown": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ ما. يرجى المحاولة مرة أخرى.",
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
      "هل هناك شيء لتقديره أو تعديله هذا الأسبوع؟",
    ),
    "harmonyShareLabel": MessageLookupByLibrary.simpleMessage(
      "مرئي للجميع في المنزل",
    ),
    "harmonySubmitCta": MessageLookupByLibrary.simpleMessage("حفظ"),
    "harmonySubmitSuccess": MessageLookupByLibrary.simpleMessage("تم الحفظ"),
    "homeVibeCoverage": m7,
    "homeVibeTitle": MessageLookupByLibrary.simpleMessage("طابع المنزل"),
    "housePulseCardHeader": MessageLookupByLibrary.simpleMessage(
      "نبض المنزل الأسبوعي",
    ),
    "housePulseShareCta": MessageLookupByLibrary.simpleMessage("مشاركة النبض"),
    "housePulseShareMessage": m8,
    "housePulseShareTitle": MessageLookupByLibrary.simpleMessage(
      "مشاركة نبض منزلنا على كينلي",
    ),
    "housePulseUpdatedOn": m9,
    "houseVibeShareCta": MessageLookupByLibrary.simpleMessage("مشاركة الطابع"),
    "houseVibeShareError": MessageLookupByLibrary.simpleMessage(
      "تعذّرت المشاركة الآن. يرجى المحاولة مرة أخرى.",
    ),
    "houseVibeShareMessage": m10,
    "houseVibeShareTitle": MessageLookupByLibrary.simpleMessage("طابع المنزل"),
    "hubCardGratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "شكر سريع من منزلك.",
    ),
    "hubCardGratitudeWallTitle": MessageLookupByLibrary.simpleMessage("إشادات"),
    "hubCodeCopied": MessageLookupByLibrary.simpleMessage("تم نسخ رمز الدعوة"),
    "hubError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل مركز المنزل. يرجى المحاولة مرة أخرى.",
    ),
    "hubInviteCta": MessageLookupByLibrary.simpleMessage("دعوة"),
    "hubInviteUnavailable": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل الدعوة. يرجى المحاولة مرة أخرى.",
    ),
    "hubMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "لا يوجد أعضاء نشطون بعد.",
    ),
    "hubPreferencesSubtitle": MessageLookupByLibrary.simpleMessage(
      "كيف يفضّل كل شخص أن تعمل الحياة المشتركة.",
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
      "لقد أخطرنا مالك المنزل.",
    ),
    "join_blocked_cta": MessageLookupByLibrary.simpleMessage("تم"),
    "join_blocked_title": MessageLookupByLibrary.simpleMessage(
      "هذا المنزل لا يقبل أعضاء جددًا الآن",
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
      "وصل هذا المنزل إلى الحد الأقصى للأعضاء. اطلب من المالك الترقية أو إزالة عضو.",
    ),
    "join_error_unauthorized": MessageLookupByLibrary.simpleMessage(
      "يرجى تسجيل الدخول للانضمام إلى هذا المنزل.",
    ),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من الانضمام إلى هذا المنزل. يرجى المحاولة مرة أخرى.",
    ),
    "join_hint": MessageLookupByLibrary.simpleMessage(
      "أدخل رمز الدعوة مثل ABC123",
    ),
    "join_submit": MessageLookupByLibrary.simpleMessage("انضمام"),
    "join_success": m13,
    "join_title": MessageLookupByLibrary.simpleMessage("الانضمام إلى منزل"),
    "login_consent_connector": MessageLookupByLibrary.simpleMessage(" و "),
    "login_consent_prefix": MessageLookupByLibrary.simpleMessage(
      "لقد قرأت ووافقت على ",
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
      "نوصلك بمنزلك…",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "منزلك المشترك يبدأ من هنا.",
    ),
    "mentionFieldHint": MessageLookupByLibrary.simpleMessage("اكتب @ لذكر شخص"),
    "navExplore": MessageLookupByLibrary.simpleMessage("إدارة"),
    "navHub": MessageLookupByLibrary.simpleMessage("مركز المنزل"),
    "navToday": MessageLookupByLibrary.simpleMessage("اليوم"),
    "npsCannotSkip": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار درجة للمتابعة.",
    ),
    "npsDescription": MessageLookupByLibrary.simpleMessage(
      "0 يعني إطلاقًا. 10 يعني أنه أحدث فرقًا حقيقيًا.",
    ),
    "npsEmailSubject": MessageLookupByLibrary.simpleMessage(
      "كيف يمكن لكينلي أن يدعم منزلك بشكل أفضل؟",
    ),
    "npsLaunchError": MessageLookupByLibrary.simpleMessage(
      "تعذّر فتح الخطوة التالية.",
    ),
    "npsScaleHighLabel": MessageLookupByLibrary.simpleMessage(
      "10 أحدث فرقًا حقيقيًا",
    ),
    "npsScaleLowLabel": MessageLookupByLibrary.simpleMessage("0 إطلاقًا"),
    "npsSubmitErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "الملاحظات غير متاحة الآن.",
    ),
    "npsSubmitErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذّر إرسال ملاحظاتك. يرجى المحاولة مرة أخرى.",
    ),
    "npsSubmitErrorInvalidScore": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار رقم بين 0 و10.",
    ),
    "npsSubmitErrorNotRequired": MessageLookupByLibrary.simpleMessage(
      "لست بحاجة لمشاركة ملاحظات الآن.",
    ),
    "npsTitle": MessageLookupByLibrary.simpleMessage(
      "هل ساعد كينلي منزلك على العمل بسلاسة أكثر؟",
    ),
    "offline_body": MessageLookupByLibrary.simpleMessage(
      "يحتاج كينلي إلى اتصال بالإنترنت. تحقّق من الشبكة وحاول مرة أخرى.",
    ),
    "offline_retry": MessageLookupByLibrary.simpleMessage("حاول مرة أخرى"),
    "offline_title": MessageLookupByLibrary.simpleMessage("أنت غير متصل"),
    "paywallBulletFlows": MessageLookupByLibrary.simpleMessage(
      "مهام غير محدودة",
    ),
    "paywallBulletMembers": MessageLookupByLibrary.simpleMessage(
      "أعضاء منزل غير محدودين",
    ),
    "paywallBulletPhotos": MessageLookupByLibrary.simpleMessage(
      "صور مهام غير محدودة",
    ),
    "paywallBulletShares": MessageLookupByLibrary.simpleMessage(
      "فواتير مشتركة غير محدودة",
    ),
    "paywallBulletShoppingPhotos": MessageLookupByLibrary.simpleMessage(
      "صور قائمة تسوّق غير محدودة",
    ),
    "paywallErrorTitle": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل صفحة الترقية.",
    ),
    "paywallPriceCaption": MessageLookupByLibrary.simpleMessage(
      "خطة واحدة للمنزل، بدون مستويات مخفية.",
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
      "يكلف أقل من 0.5% من إيجارك.",
    ),
    "paywallTitle": MessageLookupByLibrary.simpleMessage(
      "حافظ على سير منزلك بسلاسة",
    ),
    "personalMentionsTitle": MessageLookupByLibrary.simpleMessage(
      "الإشارات الشخصية",
    ),
    "personalProfileLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل ملفك الشخصي الآن. يرجى المحاولة مرة أخرى.",
    ),
    "personalProfileMentions": MessageLookupByLibrary.simpleMessage(
      "الإشارات الشخصية",
    ),
    "personalProfilePreferences": MessageLookupByLibrary.simpleMessage(
      "التفضيلات الشخصية",
    ),
    "personalProfileTitle": MessageLookupByLibrary.simpleMessage("ملفك الشخصي"),
    "planFreeLabel": MessageLookupByLibrary.simpleMessage(
      "الترقية إلى بريميوم",
    ),
    "planPremiumActiveBody": MessageLookupByLibrary.simpleMessage(
      "استمتع بوصول غير محدود لكل الميزات.",
    ),
    "planPremiumActiveTitle": MessageLookupByLibrary.simpleMessage(
      "أنت على بريميوم",
    ),
    "planPremiumLabel": MessageLookupByLibrary.simpleMessage("بريميوم"),
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
      "قم بإعداد تفضيلاتك الشخصية حتى يتعلم منزلك كيف تفضل الأمور.",
    ),
    "preferencePromptTitle": MessageLookupByLibrary.simpleMessage(
      "شارك تفضيلاتك",
    ),
    "preferenceReportDoneCta": MessageLookupByLibrary.simpleMessage("تم"),
    "preferenceReportEditCta": MessageLookupByLibrary.simpleMessage("تعديل"),
    "preferenceReportEditError": MessageLookupByLibrary.simpleMessage(
      "تعذّر حفظ هذا التحديث.",
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
      "أكمل تفضيلاتك لإنشاء تقريرك.",
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
      "تعذّر إكمال انعكاس تفضيلاتك. ارجع وحاول مرة أخرى.",
    ),
    "preferenceReportGenerationMissing": MessageLookupByLibrary.simpleMessage(
      "تعذّر إكمال انعكاس تفضيلاتك. حاول مرة أخرى قريبًا.",
    ),
    "preferenceReportReadOnlyNote": MessageLookupByLibrary.simpleMessage(
      "هذا يوضح ما يشعرون بالراحة معه.",
    ),
    "preferenceReportTitle": MessageLookupByLibrary.simpleMessage(
      "تقرير تفضيلاتك",
    ),
    "preferenceReportViewTitle": MessageLookupByLibrary.simpleMessage(
      "عرض التفضيلات",
    ),
    "preferenceScenarioCleanlinessSharedSpaceOption1":
        MessageLookupByLibrary.simpleMessage(
          "أشعر بأفضل حال عندما تكون الأمور مرتبة إلى حدّ كبير",
        ),
    "preferenceScenarioCleanlinessSharedSpaceOption2":
        MessageLookupByLibrary.simpleMessage("بعض الفوضى اليومية مقبول"),
    "preferenceScenarioCleanlinessSharedSpaceOption3":
        MessageLookupByLibrary.simpleMessage(
          "أنا مرتاح مع الفوضى في المناطق المشتركة",
        ),
    "preferenceScenarioCleanlinessSharedSpaceQuestion":
        MessageLookupByLibrary.simpleMessage(
          "في المساحات المشتركة، ما مستوى الترتيب الذي يناسبك؟",
        ),
    "preferenceScenarioCommunicationChannelOption1":
        MessageLookupByLibrary.simpleMessage("الرسائل أو الكتابة"),
    "preferenceScenarioCommunicationChannelOption2":
        MessageLookupByLibrary.simpleMessage(
          "التحدث وجهًا لوجه عندما يحين الوقت",
        ),
    "preferenceScenarioCommunicationChannelOption3":
        MessageLookupByLibrary.simpleMessage("مكالمة سريعة هي الأسهل"),
    "preferenceScenarioCommunicationChannelQuestion":
        MessageLookupByLibrary.simpleMessage(
          "عندما تحتاجون للتنسيق في المنزل، ما الأسهل لك؟",
        ),
    "preferenceScenarioCommunicationDirectnessOption1":
        MessageLookupByLibrary.simpleMessage("بلطف، مع سياق أو تمهيد"),
    "preferenceScenarioCommunicationDirectnessOption2":
        MessageLookupByLibrary.simpleMessage("مزيج — يعتمد على الموقف"),
    "preferenceScenarioCommunicationDirectnessOption3":
        MessageLookupByLibrary.simpleMessage("بشكل مباشر وواضح"),
    "preferenceScenarioCommunicationDirectnessQuestion":
        MessageLookupByLibrary.simpleMessage(
          "عندما يطرح عليك شخص موضوعًا، كيف تفضل أن يصلك؟",
        ),
    "preferenceScenarioConflictResolutionOption1":
        MessageLookupByLibrary.simpleMessage("أخذ وقت للهدوء أولًا"),
    "preferenceScenarioConflictResolutionOption2":
        MessageLookupByLibrary.simpleMessage("الاطمئنان بلطف في الوقت المناسب"),
    "preferenceScenarioConflictResolutionOption3":
        MessageLookupByLibrary.simpleMessage(
          "التحدث عنه sooner rather than later",
        ),
    "preferenceScenarioConflictResolutionQuestion":
        MessageLookupByLibrary.simpleMessage(
          "إذا كان هناك أمر يحتاج معالجة في المنزل، ما الذي يساعد أكثر؟",
        ),
    "preferenceScenarioEnvironmentLightOption1":
        MessageLookupByLibrary.simpleMessage("إضاءة أهدأ أو أخف"),
    "preferenceScenarioEnvironmentLightOption2":
        MessageLookupByLibrary.simpleMessage("إضاءة متوازنة وطبيعية"),
    "preferenceScenarioEnvironmentLightOption3":
        MessageLookupByLibrary.simpleMessage("إضاءة ساطعة وجيدة"),
    "preferenceScenarioEnvironmentLightQuestion":
        MessageLookupByLibrary.simpleMessage(
          "في المناطق المشتركة، ما الإضاءة التي تفضلها؟",
        ),
    "preferenceScenarioEnvironmentNoiseOption1":
        MessageLookupByLibrary.simpleMessage(
          "أشعر براحة أكبر عندما تكون الأجواء هادئة بشكل عام",
        ),
    "preferenceScenarioEnvironmentNoiseOption2":
        MessageLookupByLibrary.simpleMessage(
          "مستوى معتدل من ضجيج الحياة اليومية مناسب",
        ),
    "preferenceScenarioEnvironmentNoiseOption3":
        MessageLookupByLibrary.simpleMessage(
          "الضوضاء لا تزعجني كثيرًا — الأجواء الحيوية مناسبة",
        ),
    "preferenceScenarioEnvironmentNoiseQuestion":
        MessageLookupByLibrary.simpleMessage(
          "ما مدى راحتك مع الضوضاء الخلفية في المساحات المشتركة؟",
        ),
    "preferenceScenarioEnvironmentScentOption1":
        MessageLookupByLibrary.simpleMessage("أنا حساس جدًا للروائح القوية"),
    "preferenceScenarioEnvironmentScentOption2":
        MessageLookupByLibrary.simpleMessage("أنا محايد غالبًا"),
    "preferenceScenarioEnvironmentScentOption3":
        MessageLookupByLibrary.simpleMessage("الروائح القوية لا تزعجني كثيرًا"),
    "preferenceScenarioEnvironmentScentQuestion":
        MessageLookupByLibrary.simpleMessage(
          "ما مدى راحتك مع الروائح القوية (شموع، طبخ، منظفات)؟",
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
        MessageLookupByLibrary.simpleMessage("لا مشكلة لدي في التواصل بأي وقت"),
    "preferenceScenarioPrivacyNotificationsQuestion":
        MessageLookupByLibrary.simpleMessage("ما شعورك تجاه الرسائل ليلًا؟"),
    "preferenceScenarioPrivacyRoomEntryOption1":
        MessageLookupByLibrary.simpleMessage(
          "أفضل أن يطرقوا أو يطلبوا الإذن أولًا",
        ),
    "preferenceScenarioPrivacyRoomEntryOption2":
        MessageLookupByLibrary.simpleMessage(
          "طلب الإذن لطيف، لكن المرونة مقبولة",
        ),
    "preferenceScenarioPrivacyRoomEntryOption3":
        MessageLookupByLibrary.simpleMessage(
          "أنا مرتاح عمومًا مع الدخول دون تعقيد",
        ),
    "preferenceScenarioPrivacyRoomEntryQuestion":
        MessageLookupByLibrary.simpleMessage(
          "قبل دخول غرفة شخص ما، ما الذي يبدو مناسبًا لك؟",
        ),
    "preferenceScenarioRoutinePlanningOption1":
        MessageLookupByLibrary.simpleMessage("يساعدني وجود خطط وتنظيم"),
    "preferenceScenarioRoutinePlanningOption2":
        MessageLookupByLibrary.simpleMessage("مزيج من التخطيط والعفوية"),
    "preferenceScenarioRoutinePlanningOption3":
        MessageLookupByLibrary.simpleMessage("المرونة وترك الأمور تسير أسهل"),
    "preferenceScenarioRoutinePlanningQuestion":
        MessageLookupByLibrary.simpleMessage(
          "فيما يخص الحياة اليومية في المنزل، ما الأكثر طبيعية لك؟",
        ),
    "preferenceScenarioScheduleQuietHoursOption1":
        MessageLookupByLibrary.simpleMessage("أمسياتي عادةً أكثر هدوءًا"),
    "preferenceScenarioScheduleQuietHoursOption2":
        MessageLookupByLibrary.simpleMessage(
          "يعتمد — بعض الليالي أهدأ من غيرها",
        ),
    "preferenceScenarioScheduleQuietHoursOption3":
        MessageLookupByLibrary.simpleMessage("النشاط ليلًا لا يزعجني عادةً"),
    "preferenceScenarioScheduleQuietHoursQuestion":
        MessageLookupByLibrary.simpleMessage(
          "في المساء، ما الذي يناسبك عادةً؟",
        ),
    "preferenceScenarioScheduleSleepTimingOption1":
        MessageLookupByLibrary.simpleMessage("أنام وأستيقظ مبكرًا"),
    "preferenceScenarioScheduleSleepTimingOption2":
        MessageLookupByLibrary.simpleMessage("في الوسط"),
    "preferenceScenarioScheduleSleepTimingOption3":
        MessageLookupByLibrary.simpleMessage("أنام وأستيقظ متأخرًا"),
    "preferenceScenarioScheduleSleepTimingQuestion":
        MessageLookupByLibrary.simpleMessage("هل أنت شخص صباحي أم ليلي؟"),
    "preferenceScenarioSocialHostingOption1":
        MessageLookupByLibrary.simpleMessage(
          "أرتاح أكثر عندما يكون الضيوف نادرين",
        ),
    "preferenceScenarioSocialHostingOption2":
        MessageLookupByLibrary.simpleMessage("الضيوف أحيانًا مناسبون"),
    "preferenceScenarioSocialHostingOption3":
        MessageLookupByLibrary.simpleMessage("الضيوف المتكررون لا بأس بهم"),
    "preferenceScenarioSocialHostingQuestion":
        MessageLookupByLibrary.simpleMessage(
          "ما شعورك تجاه قدوم ضيوف إلى المنزل؟",
        ),
    "preferenceScenarioSocialTogethernessOption1":
        MessageLookupByLibrary.simpleMessage(
          "في الغالب أكون على راحتي وأنا بمفردي",
        ),
    "preferenceScenarioSocialTogethernessOption2":
        MessageLookupByLibrary.simpleMessage(
          "مزيج من الوقت المشترك والوقت الخاص",
        ),
    "preferenceScenarioSocialTogethernessOption3":
        MessageLookupByLibrary.simpleMessage("قضاء وقت معًا غالبًا"),
    "preferenceScenarioSocialTogethernessQuestion":
        MessageLookupByLibrary.simpleMessage(
          "في المنزل، ما التوازن الأنسب لك؟",
        ),
    "profileActionConfirm": MessageLookupByLibrary.simpleMessage(
      "مغادرة المنزل",
    ),
    "profileActionConfirmDelete": MessageLookupByLibrary.simpleMessage(
      "حذف الحساب",
    ),
    "profileConfirmDeleteMessage": MessageLookupByLibrary.simpleMessage(
      "سيؤدي ذلك إلى إزالة حسابك وتسجيل خروجك. لا يمكنك التراجع عن هذا.",
    ),
    "profileConfirmDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "حذف حسابك؟",
    ),
    "profileConfirmLeaveMessage": MessageLookupByLibrary.simpleMessage(
      "ستفقد الوصول إلى المهام والسجل والدعوات.",
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
      "سيتم حذف حسابك قريبًا. سنقوم بتسجيل خروجك.",
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
      "تعذّر تحميل ملفك الشخصي الآن.",
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
      "استخدم 3-30 حرفًا/رقمًا صغيرًا. يمكنك إضافة نقاط أو شرطات سفلية في الوسط.",
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
      "اسم المستخدم هذا مستخدم. جرّب اسمًا آخر.",
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
      "يمكن لمالك المنزل فقط إزالة الأعضاء.",
    ),
    "profileKickSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر عضوًا لإزالته. سيفقد الوصول فورًا.",
    ),
    "profileKickSheetTitle": MessageLookupByLibrary.simpleMessage("إزالة عضو"),
    "profileKickSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "لم يعد لديه وصول إلى هذا المنزل.",
    ),
    "profileLeaveEligibilityError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل أعضاء منزلك. حاول مرة أخرى.",
    ),
    "profileLeaveEligibilityLoading": MessageLookupByLibrary.simpleMessage(
      "جارٍ التحقق من أعضاء منزلك...",
    ),
    "profileLeaveHomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "مغادرة هذا المنزل تعني الخروج من مساحتك المشتركة على كينلي.",
    ),
    "profileLeaveHomeTitle": MessageLookupByLibrary.simpleMessage(
      "مغادرة المنزل",
    ),
    "profileLeaveOwnerNoEligibleMembers": MessageLookupByLibrary.simpleMessage(
      "لا يمكن لأي شخص آخر استلام الملكية الآن. حاول لاحقًا.",
    ),
    "profileLeaveOwnerSoloMessage": MessageLookupByLibrary.simpleMessage(
      "أنت آخر عضو. المغادرة ستؤدي إلى تعطيل هذا المنزل.",
    ),
    "profileLeaveSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "لقد غادرت منزلك.",
    ),
    "profileLeaveTransferSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر من سيصبح المالك الجديد قبل المغادرة.",
    ),
    "profileLeaveTransferSheetTitle": MessageLookupByLibrary.simpleMessage(
      "نقل الملكية",
    ),
    "profileLeaveTransferSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "تم نقل الملكية. جارٍ إكمال المغادرة...",
    ),
    "profileLogoutSubtitle": MessageLookupByLibrary.simpleMessage(
      "تسجيل الخروج من كينلي على هذا الجهاز.",
    ),
    "profileLogoutTitle": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
    "profileMissingHomeError": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من العثور على منزلك الحالي. حاول مرة أخرى.",
    ),
    "profileSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "إدارة تفضيلات الحساب والوصول إلى المنزل.",
    ),
    "profileSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "الملف الشخصي",
    ),
    "profile_deactivated_message": MessageLookupByLibrary.simpleMessage(
      "تم تعطيل ملفك الشخصي. يرجى تسجيل الدخول باستخدام بريد إلكتروني آخر.",
    ),
    "pulseCloudySteadySummary": MessageLookupByLibrary.simpleMessage(
      "مزيج من لحظات سلسة واحتكاكات صغيرة.",
    ),
    "pulseCloudySteadyTitle": MessageLookupByLibrary.simpleMessage("مختلط"),
    "pulseCloudyTenseSummary": MessageLookupByLibrary.simpleMessage(
      "ظهر بعض التوتر هذا الأسبوع.",
    ),
    "pulseCloudyTenseTitle": MessageLookupByLibrary.simpleMessage(
      "يحتاج انتباهًا",
    ),
    "pulseFormingSummary": MessageLookupByLibrary.simpleMessage(
      "بعض التحققّات الإضافية ستعطي صورة أوضح.",
    ),
    "pulseFormingTitle": MessageLookupByLibrary.simpleMessage("لا يزال يتشكل"),
    "pulsePartlySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "مستقر عمومًا، مع بعض الجوانب للتحسين.",
    ),
    "pulsePartlySupportedTitle": MessageLookupByLibrary.simpleMessage(
      "جيد عمومًا",
    ),
    "pulseRainySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "قد يكون الوقت مناسبًا لإعادة ضبط بسيطة.",
    ),
    "pulseRainySupportedTitle": MessageLookupByLibrary.simpleMessage(
      "يوصى بإعادة ضبط",
    ),
    "pulseRainyUnsupportedSummary": MessageLookupByLibrary.simpleMessage(
      "هناك احتكاك ملحوظ الآن.",
    ),
    "pulseRainyUnsupportedTitle": MessageLookupByLibrary.simpleMessage(
      "إعادة ضبط مطلوبة",
    ),
    "pulseSunnyBumpySummary": MessageLookupByLibrary.simpleMessage(
      "سلس غالبًا، مع بعض العثرات الصغيرة.",
    ),
    "pulseSunnyBumpyTitle": MessageLookupByLibrary.simpleMessage("سلس غالبًا"),
    "pulseSunnyCalmSummary": MessageLookupByLibrary.simpleMessage(
      "سارت الأمور بسلاسة هذا الأسبوع.",
    ),
    "pulseSunnyCalmTitle": MessageLookupByLibrary.simpleMessage("يسير بسلاسة"),
    "pulseThunderstormSummary": MessageLookupByLibrary.simpleMessage(
      "التوتر مرتفع. إعادة ضبط سريعة قد تساعد.",
    ),
    "pulseThunderstormTitle": MessageLookupByLibrary.simpleMessage(
      "توتر مرتفع",
    ),
    "quick_add_flow_subtitle": MessageLookupByLibrary.simpleMessage(
      "إنشاء مهمة",
    ),
    "quick_add_flow_title": MessageLookupByLibrary.simpleMessage("مهمة"),
    "quick_add_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "إضافة فاتورة",
    ),
    "quick_add_share_title": MessageLookupByLibrary.simpleMessage("فاتورة"),
    "quick_add_title": MessageLookupByLibrary.simpleMessage("إضافة سريعة"),
    "reflectiveAcknowledgementTitle": MessageLookupByLibrary.simpleMessage(
      "حسنًا.",
    ),
    "reflectiveGenericPrimary": MessageLookupByLibrary.simpleMessage(
      "نرتّب هذا بعناية.",
    ),
    "reflectiveGenericSecondary": MessageLookupByLibrary.simpleMessage(
      "لحظة هادئة قبل أن نعرضه.",
    ),
    "reflectiveHousePrimary": MessageLookupByLibrary.simpleMessage(
      "نضع توقعات المنزل في كلمات.",
    ),
    "reflectiveHouseSecondary": MessageLookupByLibrary.simpleMessage(
      "حتى يعرف الجميع ما الذي يتوقعونه.",
    ),
    "reflectivePersonalPrimary": MessageLookupByLibrary.simpleMessage(
      "نعكس ما شاركته.",
    ),
    "reflectivePersonalSecondary": MessageLookupByLibrary.simpleMessage(
      "حتى يفهم الآخرون ما الذي يشعرك بالراحة.",
    ),
    "shareCreateAmountHint": MessageLookupByLibrary.simpleMessage("0.00"),
    "shareCreateAmountLabel": MessageLookupByLibrary.simpleMessage("المبلغ"),
    "shareCreateCustomAmountLabel": MessageLookupByLibrary.simpleMessage(
      "المبلغ",
    ),
    "shareCreateCustomHelper": MessageLookupByLibrary.simpleMessage(
      "أدخل حصة كل شخص. تأكد أن المجموع يساوي المبلغ أعلاه.",
    ),
    "shareCreateCyclePeriod": m16,
    "shareCreateDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "مثال: مشتريات البقالة",
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
      "وصلت إلى الحد المجاني للفواتير النشطة. قم بالترقية للمزيد.",
    ),
    "shareCreateErrorRecurrenceDraft": MessageLookupByLibrary.simpleMessage(
      "لا يمكن للمسودات أن تتكرر قبل إضافة تقسيم.",
    ),
    "shareCreateLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل أعضاء منزلك.",
    ),
    "shareCreateNotesHint": MessageLookupByLibrary.simpleMessage(
      "سياق اختياري يمكن للجميع رؤيته",
    ),
    "shareCreateNotesLabel": MessageLookupByLibrary.simpleMessage("السياق"),
    "shareCreateParticipantsEmpty": MessageLookupByLibrary.simpleMessage(
      "تحتاج إلى عضوين على الأقل للمشاركة.",
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
      "اختيار المبالغ",
    ),
    "shareCreateSplitEqual": MessageLookupByLibrary.simpleMessage(
      "تقسيم بالتساوي",
    ),
    "shareCreateSplitLabel": MessageLookupByLibrary.simpleMessage(
      "كيف نريد تقسيم هذا؟",
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
          "اختر شخصًا واحدًا على الأقل لهذه الفاتورة.",
        ),
    "shareCreateValidationCustomSinglePayer":
        MessageLookupByLibrary.simpleMessage(
          "لا يمكنك تضمين نفسك فقط في هذه الفاتورة. أضف شخصًا آخر على الأقل.",
        ),
    "shareCreateValidationCustomSum": MessageLookupByLibrary.simpleMessage(
      "تأكد أن التقسيم المخصص يساوي المبلغ أعلاه.",
    ),
    "shareCreateValidationCustomSumBreakdown": m17,
    "shareCreateValidationDescription": MessageLookupByLibrary.simpleMessage(
      "أدخل وصفًا.",
    ),
    "shareCreateValidationEqualParticipants":
        MessageLookupByLibrary.simpleMessage(
          "اختر شخصًا واحدًا على الأقل لتقسيم المبلغ.",
        ),
    "shareCreateValidationRecurrence": MessageLookupByLibrary.simpleMessage(
      "اختر وتيرة التكرار.",
    ),
    "shareCreateValidationRecurrenceSplit":
        MessageLookupByLibrary.simpleMessage(
          "اختر طريقة التقسيم قبل تحديد التكرار.",
        ),
    "shareCreateValidationStartDate": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخ بدء.",
    ),
    "shareCreateValidationStartDateRange": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخًا ضمن النطاق المسموح.",
    ),
    "shareCreatedListActiveAmount": m18,
    "shareCreatedListActiveSubtitle": m19,
    "shareCreatedListDraftBadge": MessageLookupByLibrary.simpleMessage(
      "غير مُسندة",
    ),
    "shareCreatedListDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "قسّمها ليعرف الجميع حصتهم قبل النشر.",
    ),
    "shareCreatedListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "الفواتير تُبقي المال واضحًا بدون تذكيرات محرجة.",
    ),
    "shareCreatedListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد فواتير بعد",
    ),
    "shareCreatedListError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل فواتيرك. اسحب للتحديث.",
    ),
    "shareCreatedListPaidBadge": MessageLookupByLibrary.simpleMessage("مُسددة"),
    "shareCreatedListRetry": MessageLookupByLibrary.simpleMessage(
      "حاول مرة أخرى",
    ),
    "shareCreatedListTitle": MessageLookupByLibrary.simpleMessage("فواتيرك"),
    "shareEditClose": MessageLookupByLibrary.simpleMessage("إغلاق"),
    "shareEditDeleteButton": MessageLookupByLibrary.simpleMessage("حذف"),
    "shareEditDeleteConfirm": MessageLookupByLibrary.simpleMessage("حذف"),
    "shareEditDeleteConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "سيؤدي ذلك إلى إزالة المسودة للجميع.",
    ),
    "shareEditDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage("حذف؟"),
    "shareEditDeleteError": MessageLookupByLibrary.simpleMessage(
      "تعذّر الحذف. حاول مرة أخرى.",
    ),
    "shareEditDeleteSuccess": MessageLookupByLibrary.simpleMessage(
      "تم حذف الفاتورة.",
    ),
    "shareEditDisabledActive": MessageLookupByLibrary.simpleMessage(
      "الفواتير النشطة مقفلة عن التعديل.",
    ),
    "shareEditDisabledConverted": MessageLookupByLibrary.simpleMessage(
      "أصبحت هذه الفاتورة الآن خطة، وتم إيقاف التعديل.",
    ),
    "shareEditDisabledGeneric": MessageLookupByLibrary.simpleMessage(
      "تعديل هذه الفاتورة غير متاح الآن.",
    ),
    "shareEditDisabledRecurringCycle": MessageLookupByLibrary.simpleMessage(
      "دورات التكرار مقفلة عن التعديل هنا.",
    ),
    "shareEditLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل هذه المسودة.",
    ),
    "shareEditNotAllowed": MessageLookupByLibrary.simpleMessage(
      "ستظل مقفلة حتى يأخذ أحدهم هذه الفاتورة.",
    ),
    "shareEditSplitsLocked": MessageLookupByLibrary.simpleMessage(
      "تم قفل التقسيم لأن شخصًا ما دفع بالفعل. يمكنك تحديث الوصف والملاحظات فقط.",
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
      "جارٍ الإنهاء…",
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
      "أنت على ما يرام مع هذا الشخص.",
    ),
    "shareOwedDetailError": MessageLookupByLibrary.simpleMessage(
      "تعذّر وضع علامة التسوية. حاول مرة أخرى.",
    ),
    "shareOwedDetailPaid": MessageLookupByLibrary.simpleMessage(
      "وضع علامة كمُسَوّى",
    ),
    "shareOwedDetailSuccess": MessageLookupByLibrary.simpleMessage(
      "تمت التسوية.",
    ),
    "shareOwedDetailTitle": MessageLookupByLibrary.simpleMessage("للتسوية"),
    "sharePaidDetailAcknowledge": MessageLookupByLibrary.simpleMessage(
      "تأكيد الاستلام",
    ),
    "sharePaidDetailAcknowledgeError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تأكيد استلام الفواتير.",
    ),
    "sharePaidDetailAcknowledging": MessageLookupByLibrary.simpleMessage(
      "جارٍ التأكيد…",
    ),
    "shoppingAmountHint": MessageLookupByLibrary.simpleMessage("مثال: 2 عبوات"),
    "shoppingAmountLabel": MessageLookupByLibrary.simpleMessage("الكمية"),
    "shoppingArchiveCta": MessageLookupByLibrary.simpleMessage(
      "العناصر التي تم شراؤها",
    ),
    "shoppingArchiveSharePromptBody": MessageLookupByLibrary.simpleMessage(
      "هل تريد إنشاء مسودة فاتورة من هذه العناصر؟",
    ),
    "shoppingArchiveSharePromptTitle": MessageLookupByLibrary.simpleMessage(
      "إنشاء فاتورة؟",
    ),
    "shoppingArchiveShareYes": MessageLookupByLibrary.simpleMessage("نعم"),
    "shoppingCardSubtitle": m20,
    "shoppingCardTitle": MessageLookupByLibrary.simpleMessage("قائمة التسوّق"),
    "shoppingContextHint": MessageLookupByLibrary.simpleMessage(
      "أي شيء مفيد (العلامة، الحجم، إلخ)",
    ),
    "shoppingContextLabel": MessageLookupByLibrary.simpleMessage("ملاحظات"),
    "shoppingCreateTitle": MessageLookupByLibrary.simpleMessage(
      "إضافة عنصر تسوّق",
    ),
    "shoppingDelete": MessageLookupByLibrary.simpleMessage("حذف العنصر"),
    "shoppingDeleteConfirmBody": MessageLookupByLibrary.simpleMessage(
      "سيؤدي ذلك إلى إزالة العنصر من قائمة التسوّق المشتركة.",
    ),
    "shoppingDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "حذف هذا العنصر؟",
    ),
    "shoppingDetailTitle": MessageLookupByLibrary.simpleMessage("عنصر تسوّق"),
    "shoppingEditTitle": MessageLookupByLibrary.simpleMessage(
      "تفاصيل عنصر التسوّق",
    ),
    "shoppingEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد عناصر تسوّق للشراء.",
    ),
    "shoppingErrorItemAlreadyCompletedByOther":
        MessageLookupByLibrary.simpleMessage(
          "قام شخص آخر بالفعل بتأشير هذا العنصر كمكتمل.",
        ),
    "shoppingListTitle": MessageLookupByLibrary.simpleMessage("قائمة التسوّق"),
    "shoppingMarkCompleteCta": MessageLookupByLibrary.simpleMessage(
      "وضع علامة كمكتمل",
    ),
    "shoppingNameHint": MessageLookupByLibrary.simpleMessage("مثال: حليب"),
    "shoppingNameLabel": MessageLookupByLibrary.simpleMessage("الاسم"),
    "shoppingPhotoLabel": MessageLookupByLibrary.simpleMessage("إضافة صورة"),
    "shoppingPhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "أضف صورة للمساعدة في التسوّق",
    ),
    "shoppingPhotoReplaceLabel": MessageLookupByLibrary.simpleMessage(
      "ساعد الآخرين على معرفة ما الذي يجب شراؤه",
    ),
    "shoppingSubmitAdd": MessageLookupByLibrary.simpleMessage("إضافة عنصر"),
    "shoppingSubmitEdit": MessageLookupByLibrary.simpleMessage("حفظ التغييرات"),
    "shoppingTabPending": MessageLookupByLibrary.simpleMessage("للشراء"),
    "shoppingValidationName": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال اسم العنصر.",
    ),
    "startReturningSubtitle": MessageLookupByLibrary.simpleMessage(
      "ماذا تريد أن تفعل بعد ذلك؟",
    ),
    "startReturningTitle": m21,
    "todayAddSheetFlow": MessageLookupByLibrary.simpleMessage("إضافة مهمة"),
    "todayAddSheetShare": MessageLookupByLibrary.simpleMessage("إضافة فاتورة"),
    "todayAddSheetShopping": MessageLookupByLibrary.simpleMessage(
      "إضافة عنصر تسوّق",
    ),
    "todayAddSheetTitle": MessageLookupByLibrary.simpleMessage(
      "إضافة إلى منزلك",
    ),
    "todayEmptyBody": MessageLookupByLibrary.simpleMessage(
      "استمتع بالهدوء — سيخبرك كينلي عندما يحتاج شيء إلى انتباهك.",
    ),
    "todayEmptyCardBadge": MessageLookupByLibrary.simpleMessage("خذ نفسًا"),
    "todayEmptyCardTitle": MessageLookupByLibrary.simpleMessage(
      "تم إنجاز كل شيء اليوم",
    ),
    "todayFlatmateInviteSubtitle": MessageLookupByLibrary.simpleMessage(
      "ابقوا متوافقين وتشاركوا المسؤوليات.",
    ),
    "todayFlatmateInviteTitle": MessageLookupByLibrary.simpleMessage(
      "ادعُ زملاء السكن",
    ),
    "todayFlowBadgeNew": MessageLookupByLibrary.simpleMessage("جديد اليوم"),
    "todayFlowSectionTitle": MessageLookupByLibrary.simpleMessage("المهام"),
    "todayFlowSeeAll": m22,
    "todayFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "إليك ما يحتاج إلى انتباه اليوم.",
    ),
    "todayFlowTabActive": MessageLookupByLibrary.simpleMessage("نشطة"),
    "todayFlowTabDrafts": MessageLookupByLibrary.simpleMessage("مسودات"),
    "todayGratitudeHouseCta": MessageLookupByLibrary.simpleMessage(
      "إشادات المنزل",
    ),
    "todayGratitudePersonalCta": MessageLookupByLibrary.simpleMessage(
      "إشاداتي",
    ),
    "todayGratitudeSectionTitle": MessageLookupByLibrary.simpleMessage(
      "لوحة الامتنان",
    ),
    "todayGratitudeUnreadBody": MessageLookupByLibrary.simpleMessage(
      "هناك منشورات امتنان جديدة بانتظارك.",
    ),
    "todayInviteFriendsSubtitle": MessageLookupByLibrary.simpleMessage(
      "شارك كينلي كي يسهل عليهم العيش المشترك.",
    ),
    "todayInviteFriendsTitle": MessageLookupByLibrary.simpleMessage(
      "ادعُ أصدقاء إلى كينلي",
    ),
    "todayInviteNotNow": MessageLookupByLibrary.simpleMessage("ليس الآن"),
    "todayInviteShareCta": MessageLookupByLibrary.simpleMessage(
      "مشاركة الدعوة",
    ),
    "todayMemberCapPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "ترقية المنزل",
    ),
    "todayMemberCapResolutionFailed": m23,
    "todayMemberCapResolutionJoined": m24,
    "todayMemberCapResolutionSuperseded": m25,
    "todayMemberCapResolutionUnknownName": MessageLookupByLibrary.simpleMessage(
      "شخص ما",
    ),
    "todayMemberCapSecondaryCta": MessageLookupByLibrary.simpleMessage("تجاهل"),
    "todayMemberCapSubtitle": m26,
    "todayMemberCapSubtitleGeneric": MessageLookupByLibrary.simpleMessage(
      "منزلك يكبر. قم بالترقية للترحيب بالمزيد من الأشخاص.",
    ),
    "todayMemberCapTitle": MessageLookupByLibrary.simpleMessage(
      "يريد شخص ما الانضمام إلى منزلك",
    ),
    "todayShareActiveSubtitle": m27,
    "todayShareError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحديث قسم الفواتير الآن.",
    ),
    "todaySharePaidSubtitle": MessageLookupByLibrary.simpleMessage(
      "المبلغ المُسَوّى",
    ),
    "todaySharePaidUnseen": m28,
    "todayShareSectionTitle": MessageLookupByLibrary.simpleMessage("فاتورة"),
    "todayShareTabActive": MessageLookupByLibrary.simpleMessage("للتسوية"),
    "todayShareTabDrafts": MessageLookupByLibrary.simpleMessage("مسودات"),
    "todayShareTabPaidToMe": MessageLookupByLibrary.simpleMessage("مُسَوّاة"),
    "vibeCozySocialSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك مريح وهادئ عندما يقضي الناس وقتًا معًا.",
    ),
    "vibeCozySocialTitle": MessageLookupByLibrary.simpleMessage(
      "اجتماعي ومريح",
    ),
    "vibeDefaultSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك سهل العيش للجميع.",
    ),
    "vibeDefaultTitle": MessageLookupByLibrary.simpleMessage("منزل متوازن"),
    "vibeEasygoingSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك مريح ومفتوح للتغيّر يومًا بيوم.",
    ),
    "vibeEasygoingTitle": MessageLookupByLibrary.simpleMessage("سلاسة مرنة"),
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
      "يعرض منزلك مزيجًا من أساليب الراحة، متأثرًا باختلاف طرق عيش الأشخاص.",
    ),
    "vibeMixedTitle": MessageLookupByLibrary.simpleMessage("منزل متنوع"),
    "vibeQuietCareSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك هادئ، بطاقة لطيفة وإيقاع ألين.",
    ),
    "vibeQuietCareTitle": MessageLookupByLibrary.simpleMessage("هدوء واهتمام"),
    "vibeSocialSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك نشِط، والناس معًا.",
    ),
    "vibeSocialTitle": MessageLookupByLibrary.simpleMessage("طاقة اجتماعية"),
    "vibeSteadySummary": MessageLookupByLibrary.simpleMessage(
      "منزلك ثابت، ويظهر الاهتمام عبر العادات اليومية.",
    ),
    "vibeSteadyTitle": MessageLookupByLibrary.simpleMessage("هدوء ثابت"),
    "vibeStructuredSummary": MessageLookupByLibrary.simpleMessage(
      "يعمل منزلك بأفضل شكل مع روتين واضح وخطط مشتركة.",
    ),
    "vibeStructuredTitle": MessageLookupByLibrary.simpleMessage("إيقاع منظّم"),
    "vibeWarmSocialSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك دافئ ومرحب، وغالبًا ما يقضي الناس وقتًا معًا.",
    ),
    "vibeWarmSocialTitle": MessageLookupByLibrary.simpleMessage(
      "اجتماعي ودافئ",
    ),
    "weeklyRewriteCta": MessageLookupByLibrary.simpleMessage(
      "أرسل بهدوء مع كينلي",
    ),
    "welcome_create": MessageLookupByLibrary.simpleMessage("إنشاء منزل"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("الانضمام إلى منزلك"),
    "welcome_title": MessageLookupByLibrary.simpleMessage("مرحبًا بك في كينلي"),
  };
}
