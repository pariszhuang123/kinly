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

  static String m0(env) => "جارٍ بدء كينلي (${env})";

  static String m1(time) => "مجدول عند ${time}";

  static String m2(current) => "الوصول التجريبي: ${current} من 7 نقرات";

  static String m3(appName) =>
      "صُنع باستخدام ${appName} - معًا يصبح كل شيء أخف";

  static String m4(link) =>
      "بعض رسائل الشكر من منزلنا على كينلي. حمّل التطبيق: ${link}";

  static String m5(weeks) =>
      "${Intl.plural(weeks, zero: 'هذا الأسبوع', one: 'منذ أسبوع', other: 'منذ # أسابيع')}";

  static String m6(partOfDay, Good, Hi, name) =>
      "${Intl.select(partOfDay, {'morning': 'صباح الخير، ${name}', 'afternoon': 'مساء الخير، ${name}', 'evening': 'مساء الخير، ${name}', 'other': 'مرحباً، ${name}'})}";

  static String m7(answered, total) =>
      "استنادًا إلى ${answered} من أصل ${Intl.plural(total, one: '${total} عضو', two: '${total} عضوين', other: '${total} أعضاء')}";

  static String m8(current, total) => "${current}/${total}";

  static String m9(link) => "نشارك نبض منزلنا على كينلي. حمّل التطبيق: ${link}";

  static String m10(date) => "تم التحديث في ${date}";

  static String m11(link) =>
      "نشارك طابع منزلنا على كينلي. حمّل التطبيق: ${link}";

  static String m12(link) => "اجعل السكن المشترك أسهل مع كينلي: ${link}";

  static String m13(code, link) =>
      "انضم إلى منزلنا على كينلي باستخدام رمز الدعوة هذا: ${code}\n\nحمّل كينلي: ${link}";

  static String m14(code) => "لقد انضممت إلى منزلك.";

  static String m15(price) => "${price} شهريًا";

  static String m16(current, total) => "${current}/${total}";

  static String m17(period) => "ينطبق على ${period}";

  static String m18(total, included, difference) =>
      "التقسيم غير متطابق. الإجمالي: ${total}. المُدرج: ${included}. الفرق: ${difference}.";

  static String m19(paidAmount, totalAmount) =>
      "تم تحصيل ${paidAmount} من أصل ${totalAmount}";

  static String m20(paid, total) =>
      "${paid} من ${Intl.plural(total, one: '${total} دفعة', two: '${total} دفعتين', other: '${total} دفعات')} مدفوعة";

  static String m21(count) =>
      "${Intl.plural(count, one: '${count} عنصر للشراء', other: '${count} عناصر للشراء')}";

  static String m22(name) => "مرحبًا ${name}";

  static String m23(count) =>
      "عرض الكل ${Intl.plural(count, one: '(#)', other: '(#)')}";

  static String m24(name) => "تعذّر إكمال طلب ${name}.";

  static String m25(name) => "انضم ${name} إلى منزلك.";

  static String m26(name) => "انضم ${name} إلى منزل آخر.";

  static String m27(names) =>
      "${names} يريد الانضمام إلى منزلك. قم بالترقية لإضافة المزيد من الأعضاء.";

  static String m28(count) =>
      "${Intl.plural(count, one: '${count} دفعة معلقة', other: '${count} للتسوية')}";

  static String m29(count) =>
      "${Intl.plural(count, one: '${count} دفعة جديدة لك', other: '${count} دفعات جديدة لك')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("كينلي"),
    "authMembershipLoadFailed": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحديث عضويتك المنزلية.",
    ),
    "bootstrap_initializing": m0,
    "close": MessageLookupByLibrary.simpleMessage("إغلاق"),
    "connectionNotificationsPermissionBlocked":
        MessageLookupByLibrary.simpleMessage(
          "فعّل الإشعارات أولًا من إعدادات هاتفك.",
        ),
    "connectionNotificationsTimeLabel": MessageLookupByLibrary.simpleMessage(
      "وقت التذكير",
    ),
    "connectionNotificationsTimeSubtitle": m1,
    "connectionNotificationsToggleSubtitleOff":
        MessageLookupByLibrary.simpleMessage("فعّل التذكيرات لمنزلك."),
    "connectionNotificationsToggleSubtitleOn":
        MessageLookupByLibrary.simpleMessage("احصل على تذكير واحد كل يوم."),
    "connectionNotificationsToggleTitle": MessageLookupByLibrary.simpleMessage(
      "التذكيرات اليومية",
    ),
    "connectionSettingsGenericError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحديث إعدادات الإشعارات.",
    ),
    "connectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "التحكم في التذكيرات اليومية والتوقيت.",
    ),
    "connectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "الإشعارات",
    ),
    "create_failed_generic": MessageLookupByLibrary.simpleMessage(
      "تعذّر إنشاء المنزل.",
    ),
    "demoAccess": MessageLookupByLibrary.simpleMessage("وصول تجريبي"),
    "demoAccessEmail": MessageLookupByLibrary.simpleMessage(
      "البريد الإلكتروني",
    ),
    "demoAccessError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تسجيل الدخول. تحقق من بيانات الاعتماد.",
    ),
    "demoAccessPassword": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "demoAccessSubmit": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "demoAccessTapHint": m2,
    "exploreFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "اطّلع على ما يجب إنجازه ومن يقوم به.",
    ),
    "exploreIntroSubtitle": MessageLookupByLibrary.simpleMessage(
      "حافظ على وضوح الأشياء المشتركة.",
    ),
    "exploreShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "اطّلع على كل فاتورة أنشأتها وتابع التحصيلات.",
    ),
    "exploreShoppingSectionTitle": MessageLookupByLibrary.simpleMessage(
      "قائمة التسوق",
    ),
    "exploreShoppingSubtitle": MessageLookupByLibrary.simpleMessage(
      "عرض وإدارة عناصر التسوق المشتركة.",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage(
      "من سيقوم بهذا؟",
    ),
    "flowChoreCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء المهمة.",
    ),
    "flowChoreCreateTitle": MessageLookupByLibrary.simpleMessage("إضافة مهمة"),
    "flowChoreDeleteButton": MessageLookupByLibrary.simpleMessage("حذف المهمة"),
    "flowChoreDeleteConfirm": MessageLookupByLibrary.simpleMessage("حذف"),
    "flowChoreDeleteDialogMessage": MessageLookupByLibrary.simpleMessage(
      "سيؤدي هذا إلى إزالة المهمة للجميع في منزلك.",
    ),
    "flowChoreDeleteDialogTitle": MessageLookupByLibrary.simpleMessage(
      "هل تريد حذف هذه المهمة؟",
    ),
    "flowChoreDetailCompleteButton": MessageLookupByLibrary.simpleMessage(
      "تحديد كمكتملة",
    ),
    "flowChoreDetailCompletionError": MessageLookupByLibrary.simpleMessage(
      "تعذّر إكمال هذه المهمة.",
    ),
    "flowChoreDetailCompletionSuccess": MessageLookupByLibrary.simpleMessage(
      "اكتملت المهمة.",
    ),
    "flowChoreDetailMoreInfoTitle": MessageLookupByLibrary.simpleMessage(
      "تفاصيل مفيدة",
    ),
    "flowChoreDetailTitle": MessageLookupByLibrary.simpleMessage(
      "تفاصيل المهمة",
    ),
    "flowChoreDetailUnassigned": MessageLookupByLibrary.simpleMessage(
      "غير معيّنة",
    ),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage("تعديل المهمة"),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "هذا الشخص ليس جزءًا من هذا المنزل الآن.",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "ليس لديك إذن لتغيير هذه المهمة.",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذّر حفظ هذه المهمة.",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "هذه الصورة لا تنتمي إلى هذا المنزل.",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخ بدء صالحًا.",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "لا يمكن تحديث هذه المهمة الآن.",
    ),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "لقد وصلت إلى الحد المجاني للمهام النشطة. قم بالترقية للمزيد.",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "لقد وصلت إلى الحد المجاني لصور المهام. قم بالترقية للمزيد.",
    ),
    "flowChoreExpectationPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "صورة مرجعية",
    ),
    "flowChoreHowToHint": MessageLookupByLibrary.simpleMessage(
      "أضف رابطًا إذا كانت هناك طريقة محددة",
    ),
    "flowChoreHowToLabel": MessageLookupByLibrary.simpleMessage(
      "كيفية القيام بذلك (اختياري)",
    ),
    "flowChoreHowToLaunchError": MessageLookupByLibrary.simpleMessage(
      "تعذّر فتح هذا الرابط.",
    ),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل هذه المهمة.",
    ),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage(
      "مثال: ليلة إخراج القمامة، تنظيف الثلاجة، سقي النباتات",
    ),
    "flowChoreNameLabel": MessageLookupByLibrary.simpleMessage(
      "ما الذي يجب القيام به؟",
    ),
    "flowChoreNotesHint": MessageLookupByLibrary.simpleMessage(
      "أي شيء يساعد الآخرين على إنجاز هذا",
    ),
    "flowChoreNotesLabel": MessageLookupByLibrary.simpleMessage(
      "لماذا هذا مهم",
    ),
    "flowChorePhotoLabel": MessageLookupByLibrary.simpleMessage(
      "ما الشكل الصحيح",
    ),
    "flowChorePhotoLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل الصورة.",
    ),
    "flowChorePhotoPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "اسمح بالوصول إلى الكاميرا لالتقاط صورة.",
    ),
    "flowChorePhotoPermissionOpenSettings":
        MessageLookupByLibrary.simpleMessage("فتح الإعدادات"),
    "flowChorePhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "أضف صورة ليبقى الجميع على نفس الفهم",
    ),
    "flowChorePhotoUploadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر رفع الصورة.",
    ),
    "flowChoreRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "كم مرة يحدث هذا؟",
    ),
    "flowChoreRecurrenceNone": MessageLookupByLibrary.simpleMessage(
      "مرة واحدة",
    ),
    "flowChoreRetry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "flowChoreStartLabel": MessageLookupByLibrary.simpleMessage(
      "متى يحين موعدها؟",
    ),
    "flowChoreSubmitCreate": MessageLookupByLibrary.simpleMessage("إنشاء مهمة"),
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
      "اختر تاريخًا ضمن السنة القادمة.",
    ),
    "flowChoreValidationHowToUrl": MessageLookupByLibrary.simpleMessage(
      "أدخل رابطًا صالحًا يبدأ بـ http أو https.",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage(
      "أدخل اسم المهمة.",
    ),
    "flowChoreViewTitle": MessageLookupByLibrary.simpleMessage("عرض المهمة"),
    "flowListDraftLabel": MessageLookupByLibrary.simpleMessage("مسودة"),
    "flowListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "المهام تحافظ على انسجام الجميع.",
    ),
    "flowListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا يوجد شيء هنا بعد",
    ),
    "flowListError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل المهام. اسحب للتحديث.",
    ),
    "flowListOverdueLabel": MessageLookupByLibrary.simpleMessage(
      "يحتاج إلى انتباه",
    ),
    "flowListTabCurrent": MessageLookupByLibrary.simpleMessage("الحالي"),
    "flowListTabFuture": MessageLookupByLibrary.simpleMessage("القادم"),
    "force_update_body": MessageLookupByLibrary.simpleMessage(
      "هذا الإصدار من كينلي لم يعد مدعومًا. قم بالتحديث للمتابعة.",
    ),
    "force_update_button": MessageLookupByLibrary.simpleMessage("تحديث كينلي"),
    "force_update_title": MessageLookupByLibrary.simpleMessage("التحديث مطلوب"),
    "friendDefaultName": MessageLookupByLibrary.simpleMessage("صديق"),
    "gratitudeWallEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "أضف رسالة شكر من هذا الأسبوع.",
    ),
    "gratitudeWallEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد رسائل شكر بعد",
    ),
    "gratitudeWallErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل رسائل الشكر الآن.",
    ),
    "gratitudeWallFooter": m3,
    "gratitudeWallHouseTab": MessageLookupByLibrary.simpleMessage("المنزل"),
    "gratitudeWallPersonalSummary": MessageLookupByLibrary.simpleMessage(
      "مكان خاص للشكر السريع.",
    ),
    "gratitudeWallPersonalTab": MessageLookupByLibrary.simpleMessage("لي"),
    "gratitudeWallPersonalTitle": MessageLookupByLibrary.simpleMessage(
      "رسائل شكري",
    ),
    "gratitudeWallRetry": MessageLookupByLibrary.simpleMessage("حاول مرة أخرى"),
    "gratitudeWallShareCta": MessageLookupByLibrary.simpleMessage("مشاركة"),
    "gratitudeWallShareError": MessageLookupByLibrary.simpleMessage(
      "تعذّرت المشاركة الآن.",
    ),
    "gratitudeWallShareMessage": m4,
    "gratitudeWallShareTitle": MessageLookupByLibrary.simpleMessage(
      "رسائل شكر المنزل",
    ),
    "gratitudeWallStatsHomes": MessageLookupByLibrary.simpleMessage("منازل"),
    "gratitudeWallStatsMentions": MessageLookupByLibrary.simpleMessage(
      "رسائل شكر",
    ),
    "gratitudeWallStatsPeople": MessageLookupByLibrary.simpleMessage("أشخاص"),
    "gratitudeWallWeeksAgo": m5,
    "greetingPartOfDay": m6,
    "harmonyCommentHint": MessageLookupByLibrary.simpleMessage(
      "أضف سياقًا إذا كان ذلك مفيدًا",
    ),
    "harmonyCommentLabel": MessageLookupByLibrary.simpleMessage(
      "ملاحظة اختيارية",
    ),
    "harmonyErrorAlreadySubmitted": MessageLookupByLibrary.simpleMessage(
      "لقد أرسلت بالفعل هذا الأسبوع.",
    ),
    "harmonyErrorCommentRequiredForMention":
        MessageLookupByLibrary.simpleMessage(
          "أضف ملاحظة قصيرة قبل إرسال هذه الإشارة.",
        ),
    "harmonyErrorCommentRequiredForPublicWall":
        MessageLookupByLibrary.simpleMessage(
          "أضف ملاحظة قصيرة قبل نشر رسالة الشكر هذه.",
        ),
    "harmonyErrorComplaintNeedsSentence": MessageLookupByLibrary.simpleMessage(
      "أضف جملة واضحة.",
    ),
    "harmonyErrorComplaintTooBrief": MessageLookupByLibrary.simpleMessage(
      "اكتب جملة قصيرة حتى يكون الأمر واضحًا.",
    ),
    "harmonyErrorComplaintTooShort": MessageLookupByLibrary.simpleMessage(
      "أضف مزيدًا قليلًا من التفاصيل.",
    ),
    "harmonyErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "التغذية الراجعة الأسبوعية غير متاحة الآن.",
    ),
    "harmonyErrorSingleMentionRequired": MessageLookupByLibrary.simpleMessage(
      "اختر شخصًا واحدًا لهذه الملاحظة.",
    ),
    "harmonyErrorUnknown": MessageLookupByLibrary.simpleMessage("حدث خطأ ما."),
    "harmonyFeedbackSingleHousemateHint": MessageLookupByLibrary.simpleMessage(
      "اكتب @ للإشارة إلى زميل سكن واحد.",
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
      "ما الذي سار جيدًا أو يحتاج إلى تعديل هذا الأسبوع؟",
    ),
    "harmonyShareLabel": MessageLookupByLibrary.simpleMessage(
      "مرئي للجميع في المنزل",
    ),
    "harmonySubmitCta": MessageLookupByLibrary.simpleMessage("حفظ"),
    "harmonySubmitSuccess": MessageLookupByLibrary.simpleMessage("تم الحفظ"),
    "homeVibeCoverage": m7,
    "homeVibeTitle": MessageLookupByLibrary.simpleMessage("طابع المنزل"),
    "houseNormCopyUrlCta": MessageLookupByLibrary.simpleMessage("نسخ الرابط"),
    "houseNormDoneCta": MessageLookupByLibrary.simpleMessage("تم"),
    "houseNormEditTitle": MessageLookupByLibrary.simpleMessage(
      "تعديل أعراف المنزل",
    ),
    "houseNormGenerationFailed": MessageLookupByLibrary.simpleMessage(
      "تعذّر إنشاء أعراف المنزل الآن.",
    ),
    "houseNormOnboardingBack": MessageLookupByLibrary.simpleMessage("رجوع"),
    "houseNormOnboardingProgress": m8,
    "houseNormOnboardingSubmit": MessageLookupByLibrary.simpleMessage("إنشاء"),
    "houseNormOnboardingTitle": MessageLookupByLibrary.simpleMessage(
      "طابع المنزل",
    ),
    "houseNormPromptCta": MessageLookupByLibrary.simpleMessage("إنشاء"),
    "houseNormPromptSubtitle": MessageLookupByLibrary.simpleMessage(
      "حوّل إجاباتك إلى دليل مشترك.",
    ),
    "houseNormPromptTitle": MessageLookupByLibrary.simpleMessage(
      "أنشئ أعراف المنزل",
    ),
    "houseNormPublishCta": MessageLookupByLibrary.simpleMessage(
      "نشر على الويب",
    ),
    "houseNormReportEmptyBody": MessageLookupByLibrary.simpleMessage(
      "أنشئ أعراف المنزل لرؤيتها.",
    ),
    "houseNormReportEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "أعراف المنزل غير جاهزة",
    ),
    "houseNormReportErrorBody": MessageLookupByLibrary.simpleMessage(
      "يرجى المحاولة مرة أخرى.",
    ),
    "houseNormReportErrorTitle": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل أعراف المنزل",
    ),
    "houseNormReportTitle": MessageLookupByLibrary.simpleMessage(
      "أعراف المنزل",
    ),
    "houseNormRepublishCta": MessageLookupByLibrary.simpleMessage(
      "إعادة النشر",
    ),
    "houseNormScenarioGuestsOption1": MessageLookupByLibrary.simpleMessage(
      "اسأل أولًا",
    ),
    "houseNormScenarioGuestsOption2": MessageLookupByLibrary.simpleMessage(
      "أعطِ تنبيهًا مسبقًا",
    ),
    "houseNormScenarioGuestsOption3": MessageLookupByLibrary.simpleMessage(
      "هذا طبيعي تمامًا",
    ),
    "houseNormScenarioGuestsQuestion": MessageLookupByLibrary.simpleMessage(
      "إحضار الضيوف؟",
    ),
    "houseNormScenarioHomeIdentityOption1":
        MessageLookupByLibrary.simpleMessage("منزل هادئ"),
    "houseNormScenarioHomeIdentityOption2":
        MessageLookupByLibrary.simpleMessage("منزل متوازن"),
    "houseNormScenarioHomeIdentityOption3":
        MessageLookupByLibrary.simpleMessage("منزل اجتماعي"),
    "houseNormScenarioHomeIdentityQuestion":
        MessageLookupByLibrary.simpleMessage("أفضل وصف؟"),
    "houseNormScenarioPropertyContextOption1":
        MessageLookupByLibrary.simpleMessage("مملوك"),
    "houseNormScenarioPropertyContextOption2":
        MessageLookupByLibrary.simpleMessage("إيجار كامل"),
    "houseNormScenarioPropertyContextOption3":
        MessageLookupByLibrary.simpleMessage("إيجار غرفة"),
    "houseNormScenarioPropertyContextQuestion":
        MessageLookupByLibrary.simpleMessage("هذا المنزل هو:"),
    "houseNormScenarioRelationshipModelOption1":
        MessageLookupByLibrary.simpleMessage("زملاء سكن"),
    "houseNormScenarioRelationshipModelOption2":
        MessageLookupByLibrary.simpleMessage("عائلة"),
    "houseNormScenarioRelationshipModelOption3":
        MessageLookupByLibrary.simpleMessage("مختلط"),
    "houseNormScenarioRelationshipModelQuestion":
        MessageLookupByLibrary.simpleMessage("من يسكن هنا؟"),
    "houseNormScenarioRepairOption1": MessageLookupByLibrary.simpleMessage(
      "تحدث مبكرًا",
    ),
    "houseNormScenarioRepairOption2": MessageLookupByLibrary.simpleMessage(
      "اختر اللحظة المناسبة",
    ),
    "houseNormScenarioRepairOption3": MessageLookupByLibrary.simpleMessage(
      "اترك الأمور الصغيرة تمر",
    ),
    "houseNormScenarioRepairQuestion": MessageLookupByLibrary.simpleMessage(
      "التوتر؟",
    ),
    "houseNormScenarioResponsibilityOption1":
        MessageLookupByLibrary.simpleMessage("اتفاقات واضحة"),
    "houseNormScenarioResponsibilityOption2":
        MessageLookupByLibrary.simpleMessage("من يلاحظ يقوم بها"),
    "houseNormScenarioResponsibilityOption3":
        MessageLookupByLibrary.simpleMessage("كل شخص يهتم بأموره"),
    "houseNormScenarioResponsibilityQuestion":
        MessageLookupByLibrary.simpleMessage("الأعمال الصغيرة؟"),
    "houseNormScenarioRhythmOption1": MessageLookupByLibrary.simpleMessage(
      "الاسترخاء والهدوء",
    ),
    "houseNormScenarioRhythmOption2": MessageLookupByLibrary.simpleMessage(
      "يعتمد",
    ),
    "houseNormScenarioRhythmOption3": MessageLookupByLibrary.simpleMessage(
      "كل شخص يفعل ما يريد",
    ),
    "houseNormScenarioRhythmQuestion": MessageLookupByLibrary.simpleMessage(
      "في وقت متأخر من الليل؟",
    ),
    "houseNormScenarioSharedSpacesOption1":
        MessageLookupByLibrary.simpleMessage("نظيف"),
    "houseNormScenarioSharedSpacesOption2":
        MessageLookupByLibrary.simpleMessage("يُستخدم بشكل طبيعي"),
    "houseNormScenarioSharedSpacesOption3":
        MessageLookupByLibrary.simpleMessage("الفوضى لا بأس بها"),
    "houseNormScenarioSharedSpacesQuestion":
        MessageLookupByLibrary.simpleMessage("المطبخ ليلًا؟"),
    "houseNormSectionEditLabel": MessageLookupByLibrary.simpleMessage(
      "عدّل هذا القسم",
    ),
    "houseNormSectionEmptyError": MessageLookupByLibrary.simpleMessage(
      "أضف نصًا قبل الحفظ.",
    ),
    "houseNormSectionFallbackTitle": MessageLookupByLibrary.simpleMessage(
      "القسم",
    ),
    "houseNormSectionGuestsSocialTitle": MessageLookupByLibrary.simpleMessage(
      "الضيوف والتفاعل الاجتماعي",
    ),
    "houseNormSectionHomeIdentityTitle": MessageLookupByLibrary.simpleMessage(
      "هوية المنزل",
    ),
    "houseNormSectionRepairStyleTitle": MessageLookupByLibrary.simpleMessage(
      "أسلوب الإصلاح",
    ),
    "houseNormSectionResponsibilityFlowTitle":
        MessageLookupByLibrary.simpleMessage("تدفق المسؤوليات"),
    "houseNormSectionRhythmQuietTitle": MessageLookupByLibrary.simpleMessage(
      "الإيقاع والهدوء",
    ),
    "houseNormSectionSaveCta": MessageLookupByLibrary.simpleMessage("حفظ"),
    "houseNormSectionSaveFailed": MessageLookupByLibrary.simpleMessage(
      "تعذّر حفظ هذا التحديث.",
    ),
    "houseNormSectionSaveSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تحديث القسم.",
    ),
    "houseNormSectionSharedSpacesTitle": MessageLookupByLibrary.simpleMessage(
      "المساحات المشتركة",
    ),
    "houseNormShareSubject": MessageLookupByLibrary.simpleMessage(
      "أعراف منزلنا",
    ),
    "houseNormShareUrlCta": MessageLookupByLibrary.simpleMessage(
      "مشاركة الرابط",
    ),
    "houseNormSummaryFramingLabel": MessageLookupByLibrary.simpleMessage(
      "الملخص",
    ),
    "houseNormSummarySubtitle": MessageLookupByLibrary.simpleMessage(
      "دليل، وليس كتاب قواعد.",
    ),
    "houseNormSummaryTitle": MessageLookupByLibrary.simpleMessage(
      "أعراف المنزل",
    ),
    "houseNormUrlCopied": MessageLookupByLibrary.simpleMessage(
      "تم نسخ رابط أعراف المنزل.",
    ),
    "houseNormViewTitle": MessageLookupByLibrary.simpleMessage(
      "عرض أعراف المنزل",
    ),
    "housePulseCardHeader": MessageLookupByLibrary.simpleMessage(
      "نبض المنزل الأسبوعي",
    ),
    "housePulseShareCta": MessageLookupByLibrary.simpleMessage("مشاركة النبض"),
    "housePulseShareMessage": m9,
    "housePulseShareTitle": MessageLookupByLibrary.simpleMessage(
      "نشارك نبض منزلنا على كينلي",
    ),
    "housePulseUpdatedOn": m10,
    "houseVibeShareCta": MessageLookupByLibrary.simpleMessage("مشاركة الطابع"),
    "houseVibeShareError": MessageLookupByLibrary.simpleMessage(
      "تعذّرت المشاركة الآن.",
    ),
    "houseVibeShareMessage": m11,
    "houseVibeShareTitle": MessageLookupByLibrary.simpleMessage("طابع المنزل"),
    "hubCardGratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "شكر سريع من منزلك.",
    ),
    "hubCardGratitudeWallTitle": MessageLookupByLibrary.simpleMessage(
      "رسائل الشكر",
    ),
    "hubCodeCopied": MessageLookupByLibrary.simpleMessage("تم نسخ رمز الدعوة"),
    "hubError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل مركز المنزل.",
    ),
    "hubHouseNormsSubtitle": MessageLookupByLibrary.simpleMessage(
      "دليل لكيفية عمل هذا المنزل.",
    ),
    "hubHouseNormsTitle": MessageLookupByLibrary.simpleMessage("أعراف المنزل"),
    "hubInviteCta": MessageLookupByLibrary.simpleMessage("دعوة"),
    "hubInviteUnavailable": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل الدعوة.",
    ),
    "hubMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "لا يوجد أعضاء نشطون بعد.",
    ),
    "hubPreferencesSubtitle": MessageLookupByLibrary.simpleMessage(
      "كيف يفضل كل شخص أن يعمل السكن المشترك.",
    ),
    "hubPreferencesTitle": MessageLookupByLibrary.simpleMessage("التفضيلات"),
    "hubQrSubtitle": MessageLookupByLibrary.simpleMessage("امسح لتحميل كينلي"),
    "hubQrTitle": MessageLookupByLibrary.simpleMessage("مشاركة التطبيق"),
    "hubRetry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "hubRotateError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحديث الدعوة.",
    ),
    "hubRotateInvite": MessageLookupByLibrary.simpleMessage("تدوير الدعوة"),
    "hubRotateSuccess": MessageLookupByLibrary.simpleMessage("تم تحديث الدعوة"),
    "hubShareAppBody": m12,
    "hubShareAppCta": MessageLookupByLibrary.simpleMessage("مشاركة كينلي"),
    "hubShareAppTitle": MessageLookupByLibrary.simpleMessage("احصل على كينلي"),
    "hubShareInviteBody": m13,
    "hubShareInviteTitle": MessageLookupByLibrary.simpleMessage(
      "دعوة إلى منزلي على كينلي",
    ),
    "join_blocked_body": MessageLookupByLibrary.simpleMessage(
      "لقد أبلغنا مالك المنزل.",
    ),
    "join_blocked_cta": MessageLookupByLibrary.simpleMessage("تم"),
    "join_blocked_title": MessageLookupByLibrary.simpleMessage(
      "هذا المنزل لا يقبل أعضاء جدد الآن",
    ),
    "join_error_already_in_other_home": MessageLookupByLibrary.simpleMessage(
      "غادر منزلك الحالي أولًا.",
    ),
    "join_error_forbidden": MessageLookupByLibrary.simpleMessage(
      "ليس لديك إذن للانضمام إلى هذا المنزل.",
    ),
    "join_error_inactive_invite": MessageLookupByLibrary.simpleMessage(
      "انتهت صلاحية هذه الدعوة. اطلب من المالك دعوة جديدة.",
    ),
    "join_error_invalid_code": MessageLookupByLibrary.simpleMessage(
      "رمز الدعوة هذا يبدو غير صحيح.",
    ),
    "join_error_paywall_limit": MessageLookupByLibrary.simpleMessage(
      "وصل هذا المنزل إلى الحد الأقصى للأعضاء. اطلب من المالك الترقية أو إزالة أحد الأعضاء.",
    ),
    "join_error_unauthorized": MessageLookupByLibrary.simpleMessage(
      "سجّل الدخول للانضمام إلى هذا المنزل.",
    ),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage(
      "تعذّر الانضمام إلى هذا المنزل.",
    ),
    "join_hint": MessageLookupByLibrary.simpleMessage(
      "أدخل رمز الدعوة (مثال: ABC123)",
    ),
    "join_submit": MessageLookupByLibrary.simpleMessage("انضمام"),
    "join_success": m14,
    "join_title": MessageLookupByLibrary.simpleMessage("الانضمام إلى منزل"),
    "login_consent_connector": MessageLookupByLibrary.simpleMessage(" و "),
    "login_consent_prefix": MessageLookupByLibrary.simpleMessage("أوافق على "),
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
      "أنت متصل بمنزل.",
    ),
    "membership_status_checking": MessageLookupByLibrary.simpleMessage(
      "جارٍ الاتصال بمنزلك...",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "أنشئ منزلًا أو انضم إلى منزل.",
    ),
    "mentionFieldHint": MessageLookupByLibrary.simpleMessage(
      "اكتب @ للإشارة إلى شخص",
    ),
    "navExplore": MessageLookupByLibrary.simpleMessage("الإدارة"),
    "navHub": MessageLookupByLibrary.simpleMessage("مركز المنزل"),
    "navToday": MessageLookupByLibrary.simpleMessage("اليوم"),
    "npsCannotSkip": MessageLookupByLibrary.simpleMessage(
      "اختر درجة للمتابعة.",
    ),
    "npsDescription": MessageLookupByLibrary.simpleMessage(
      "0 يعني لم يساعد إطلاقًا. 10 يعني أنه أحدث فرقًا حقيقيًا.",
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
    "npsScaleLowLabel": MessageLookupByLibrary.simpleMessage(
      "0 لم يساعد إطلاقًا",
    ),
    "npsSubmitErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "التغذية الراجعة غير متاحة الآن.",
    ),
    "npsSubmitErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذّر إرسال ملاحظاتك.",
    ),
    "npsSubmitErrorInvalidScore": MessageLookupByLibrary.simpleMessage(
      "اختر رقمًا بين 0 و10.",
    ),
    "npsSubmitErrorNotRequired": MessageLookupByLibrary.simpleMessage(
      "لا تحتاج إلى مشاركة ملاحظات الآن.",
    ),
    "npsTitle": MessageLookupByLibrary.simpleMessage(
      "هل ساعد كينلي منزلك على العمل بسلاسة أكثر؟",
    ),
    "offline_body": MessageLookupByLibrary.simpleMessage(
      "لا يوجد اتصال بالإنترنت. حاول مرة أخرى.",
    ),
    "offline_retry": MessageLookupByLibrary.simpleMessage("حاول مرة أخرى"),
    "offline_title": MessageLookupByLibrary.simpleMessage("أنت غير متصل"),
    "paywallBulletFlows": MessageLookupByLibrary.simpleMessage(
      "مهام غير محدودة",
    ),
    "paywallBulletMembers": MessageLookupByLibrary.simpleMessage(
      "أعضاء غير محدودين",
    ),
    "paywallBulletPhotos": MessageLookupByLibrary.simpleMessage(
      "صور مهام غير محدودة",
    ),
    "paywallBulletShares": MessageLookupByLibrary.simpleMessage(
      "فواتير غير محدودة",
    ),
    "paywallBulletShoppingPhotos": MessageLookupByLibrary.simpleMessage(
      "صور تسوق غير محدودة",
    ),
    "paywallErrorTitle": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل صفحة الاشتراك.",
    ),
    "paywallFeatureUnlimitedSharedExpensePhotos":
        MessageLookupByLibrary.simpleMessage("صور فواتير غير محدودة"),
    "paywallPriceCaption": MessageLookupByLibrary.simpleMessage(
      "خطة واحدة للمنزل. بدون مستويات مخفية.",
    ),
    "paywallPricePerMonth": m15,
    "paywallPriceUnavailable": MessageLookupByLibrary.simpleMessage(
      "السعر غير متاح الآن.",
    ),
    "paywallPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "الترقية إلى بريميوم",
    ),
    "paywallPurchaseFailed": MessageLookupByLibrary.simpleMessage(
      "لم يكتمل الشراء.",
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
      "أقل من 0.5٪ من إيجارك.",
    ),
    "paywallTitle": MessageLookupByLibrary.simpleMessage(
      "حافظ على سير منزلك بسلاسة",
    ),
    "personalMentionsTitle": MessageLookupByLibrary.simpleMessage(
      "الإشارات الشخصية",
    ),
    "personalProfileLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل ملفك الشخصي.",
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
      "استمتع بوصول غير محدود إلى جميع الميزات.",
    ),
    "planPremiumActiveTitle": MessageLookupByLibrary.simpleMessage(
      "أنت على بريميوم",
    ),
    "planPremiumLabel": MessageLookupByLibrary.simpleMessage("بريميوم"),
    "preferenceOnboardingBack": MessageLookupByLibrary.simpleMessage("رجوع"),
    "preferenceOnboardingProgress": m16,
    "preferenceOnboardingSubmit": MessageLookupByLibrary.simpleMessage("حفظ"),
    "preferenceOnboardingTitle": MessageLookupByLibrary.simpleMessage("طابعك"),
    "preferencePromptCta": MessageLookupByLibrary.simpleMessage("ابدأ"),
    "preferencePromptSubtitle": MessageLookupByLibrary.simpleMessage(
      "ساعد منزلك على فهم ما يناسبك.",
    ),
    "preferencePromptTitle": MessageLookupByLibrary.simpleMessage("حدّد طابعك"),
    "preferenceReportDoneCta": MessageLookupByLibrary.simpleMessage("تم"),
    "preferenceReportEditCta": MessageLookupByLibrary.simpleMessage("تعديل"),
    "preferenceReportEditError": MessageLookupByLibrary.simpleMessage(
      "تعذّر حفظ هذا التحديث.",
    ),
    "preferenceReportEditSectionDone": MessageLookupByLibrary.simpleMessage(
      "تم",
    ),
    "preferenceReportEditSectionHint": MessageLookupByLibrary.simpleMessage(
      "اكتب ما يبدو مناسبًا",
    ),
    "preferenceReportEditSectionPrompt": MessageLookupByLibrary.simpleMessage(
      "عدّل هذا القسم.",
    ),
    "preferenceReportEditTitle": MessageLookupByLibrary.simpleMessage(
      "تعديل التفضيلات",
    ),
    "preferenceReportEmptyBody": MessageLookupByLibrary.simpleMessage(
      "أكمل تفضيلاتك لإنشاء تقريرك.",
    ),
    "preferenceReportEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "التفضيلات غير جاهزة",
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
      "هذا يوضح ما يشعرهم بالراحة.",
    ),
    "preferenceReportTitle": MessageLookupByLibrary.simpleMessage("تفضيلاتك"),
    "preferenceReportViewTitle": MessageLookupByLibrary.simpleMessage(
      "عرض التفضيلات",
    ),
    "preferenceScenarioCleanlinessSharedSpaceOption1":
        MessageLookupByLibrary.simpleMessage("ابقها مرتبة"),
    "preferenceScenarioCleanlinessSharedSpaceOption2":
        MessageLookupByLibrary.simpleMessage("فوضى بسيطة لا بأس بها"),
    "preferenceScenarioCleanlinessSharedSpaceOption3":
        MessageLookupByLibrary.simpleMessage("الفوضى لا بأس بها"),
    "preferenceScenarioCleanlinessSharedSpaceQuestion":
        MessageLookupByLibrary.simpleMessage("المساحة المشتركة؟"),
    "preferenceScenarioCommunicationChannelOption1":
        MessageLookupByLibrary.simpleMessage("رسالة نصية"),
    "preferenceScenarioCommunicationChannelOption2":
        MessageLookupByLibrary.simpleMessage("وجهًا لوجه"),
    "preferenceScenarioCommunicationChannelOption3":
        MessageLookupByLibrary.simpleMessage("مكالمة"),
    "preferenceScenarioCommunicationChannelQuestion":
        MessageLookupByLibrary.simpleMessage("أفضل طريقة للوصول إليك؟"),
    "preferenceScenarioCommunicationDirectnessOption1":
        MessageLookupByLibrary.simpleMessage("كن لطيفًا"),
    "preferenceScenarioCommunicationDirectnessOption2":
        MessageLookupByLibrary.simpleMessage("يعتمد"),
    "preferenceScenarioCommunicationDirectnessOption3":
        MessageLookupByLibrary.simpleMessage("كن مباشرًا"),
    "preferenceScenarioCommunicationDirectnessQuestion":
        MessageLookupByLibrary.simpleMessage("عندما يكون هناك شيء خاطئ؟"),
    "preferenceScenarioConflictResolutionOption1":
        MessageLookupByLibrary.simpleMessage("اهدأ أولًا"),
    "preferenceScenarioConflictResolutionOption2":
        MessageLookupByLibrary.simpleMessage("تحقق لاحقًا"),
    "preferenceScenarioConflictResolutionOption3":
        MessageLookupByLibrary.simpleMessage("تحدث مبكرًا"),
    "preferenceScenarioConflictResolutionQuestion":
        MessageLookupByLibrary.simpleMessage("إذا كان هناك شيء غير مريح؟"),
    "preferenceScenarioEnvironmentLightOption1":
        MessageLookupByLibrary.simpleMessage("ناعمة"),
    "preferenceScenarioEnvironmentLightOption2":
        MessageLookupByLibrary.simpleMessage("متوازنة"),
    "preferenceScenarioEnvironmentLightOption3":
        MessageLookupByLibrary.simpleMessage("ساطعة"),
    "preferenceScenarioEnvironmentLightQuestion":
        MessageLookupByLibrary.simpleMessage("الإضاءة؟"),
    "preferenceScenarioEnvironmentNoiseOption1":
        MessageLookupByLibrary.simpleMessage("هادئ من فضلك"),
    "preferenceScenarioEnvironmentNoiseOption2":
        MessageLookupByLibrary.simpleMessage("ضوضاء عادية"),
    "preferenceScenarioEnvironmentNoiseOption3":
        MessageLookupByLibrary.simpleMessage("الأجواء الحيوية لا بأس بها"),
    "preferenceScenarioEnvironmentNoiseQuestion":
        MessageLookupByLibrary.simpleMessage("مستوى الضوضاء؟"),
    "preferenceScenarioEnvironmentScentOption1":
        MessageLookupByLibrary.simpleMessage("حساس"),
    "preferenceScenarioEnvironmentScentOption2":
        MessageLookupByLibrary.simpleMessage("محايد"),
    "preferenceScenarioEnvironmentScentOption3":
        MessageLookupByLibrary.simpleMessage("لا تزعجني"),
    "preferenceScenarioEnvironmentScentQuestion":
        MessageLookupByLibrary.simpleMessage("الروائح القوية؟"),
    "preferenceScenarioPrivacyNotificationsOption1":
        MessageLookupByLibrary.simpleMessage("من فضلك لا"),
    "preferenceScenarioPrivacyNotificationsOption2":
        MessageLookupByLibrary.simpleMessage("للأمور المهمة فقط"),
    "preferenceScenarioPrivacyNotificationsOption3":
        MessageLookupByLibrary.simpleMessage("في أي وقت"),
    "preferenceScenarioPrivacyNotificationsQuestion":
        MessageLookupByLibrary.simpleMessage("الرسائل ليلًا؟"),
    "preferenceScenarioPrivacyRoomEntryOption1":
        MessageLookupByLibrary.simpleMessage("اطرق أولًا"),
    "preferenceScenarioPrivacyRoomEntryOption2":
        MessageLookupByLibrary.simpleMessage("عادةً اطرق"),
    "preferenceScenarioPrivacyRoomEntryOption3":
        MessageLookupByLibrary.simpleMessage("الباب مفتوح"),
    "preferenceScenarioPrivacyRoomEntryQuestion":
        MessageLookupByLibrary.simpleMessage("الدخول إلى غرفتك؟"),
    "preferenceScenarioRoutinePlanningOption1":
        MessageLookupByLibrary.simpleMessage("منظمة"),
    "preferenceScenarioRoutinePlanningOption2":
        MessageLookupByLibrary.simpleMessage("بعض التنظيم"),
    "preferenceScenarioRoutinePlanningOption3":
        MessageLookupByLibrary.simpleMessage("على حسب المزاج"),
    "preferenceScenarioRoutinePlanningQuestion":
        MessageLookupByLibrary.simpleMessage("الحياة اليومية؟"),
    "preferenceScenarioScheduleQuietHoursOption1":
        MessageLookupByLibrary.simpleMessage("ليالٍ هادئة"),
    "preferenceScenarioScheduleQuietHoursOption2":
        MessageLookupByLibrary.simpleMessage("يعتمد"),
    "preferenceScenarioScheduleQuietHoursOption3":
        MessageLookupByLibrary.simpleMessage("النشاط لا بأس به"),
    "preferenceScenarioScheduleQuietHoursQuestion":
        MessageLookupByLibrary.simpleMessage("المساءات؟"),
    "preferenceScenarioScheduleSleepTimingOption1":
        MessageLookupByLibrary.simpleMessage("يستيقظ مبكرًا"),
    "preferenceScenarioScheduleSleepTimingOption2":
        MessageLookupByLibrary.simpleMessage("بين هذا وذاك"),
    "preferenceScenarioScheduleSleepTimingOption3":
        MessageLookupByLibrary.simpleMessage("ساهر"),
    "preferenceScenarioScheduleSleepTimingQuestion":
        MessageLookupByLibrary.simpleMessage("أسلوب النوم؟"),
    "preferenceScenarioSocialHostingOption1":
        MessageLookupByLibrary.simpleMessage("نادرًا"),
    "preferenceScenarioSocialHostingOption2":
        MessageLookupByLibrary.simpleMessage("أحيانًا"),
    "preferenceScenarioSocialHostingOption3":
        MessageLookupByLibrary.simpleMessage("كثيرًا"),
    "preferenceScenarioSocialHostingQuestion":
        MessageLookupByLibrary.simpleMessage("الضيوف؟"),
    "preferenceScenarioSocialTogethernessOption1":
        MessageLookupByLibrary.simpleMessage("غالبًا بمفردي"),
    "preferenceScenarioSocialTogethernessOption2":
        MessageLookupByLibrary.simpleMessage("مزيج من الأمرين"),
    "preferenceScenarioSocialTogethernessOption3":
        MessageLookupByLibrary.simpleMessage("نتجمع كثيرًا"),
    "preferenceScenarioSocialTogethernessQuestion":
        MessageLookupByLibrary.simpleMessage("طاقة المنزل؟"),
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
      "هل تريد حذف حسابك؟",
    ),
    "profileConfirmLeaveMessage": MessageLookupByLibrary.simpleMessage(
      "ستفقد الوصول إلى المهام والسجل والدعوات.",
    ),
    "profileConfirmLeaveTitle": MessageLookupByLibrary.simpleMessage(
      "هل تريد مغادرة هذا المنزل؟",
    ),
    "profileConnectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "إدارة التذكيرات والتنبيهات.",
    ),
    "profileConnectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "الإشعارات",
    ),
    "profileContactEmailSubject": MessageLookupByLibrary.simpleMessage(
      "تواصل معنا",
    ),
    "profileContactLaunchError": MessageLookupByLibrary.simpleMessage(
      "تعذّر فتح تطبيق البريد الإلكتروني.",
    ),
    "profileContactUsSubtitle": MessageLookupByLibrary.simpleMessage(
      "راسل support@makinglifeeasie.com",
    ),
    "profileContactUsTitle": MessageLookupByLibrary.simpleMessage("تواصل معنا"),
    "profileDeleteAccountSubtitle": MessageLookupByLibrary.simpleMessage(
      "حذف حسابك وبياناتك على كينلي.",
    ),
    "profileDeleteAccountTitle": MessageLookupByLibrary.simpleMessage(
      "حذف الحساب",
    ),
    "profileDeleteSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "سيتم حذف حسابك قريبًا. سنقوم بتسجيل خروجك.",
    ),
    "profileGenericError": MessageLookupByLibrary.simpleMessage("حدث خطأ ما."),
    "profileIdentityAvatarEmpty": MessageLookupByLibrary.simpleMessage(
      "لا توجد صور رمزية متاحة الآن.",
    ),
    "profileIdentityAvatarSectionDescription":
        MessageLookupByLibrary.simpleMessage(
          "يجب أن تكون كل صورة رمزية فريدة داخل منزلك.",
        ),
    "profileIdentityAvatarSectionTitle": MessageLookupByLibrary.simpleMessage(
      "اختر صورة رمزية",
    ),
    "profileIdentityLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل ملفك الشخصي.",
    ),
    "profileIdentityRetry": MessageLookupByLibrary.simpleMessage(
      "إعادة المحاولة",
    ),
    "profileIdentitySaveButton": MessageLookupByLibrary.simpleMessage(
      "حفظ التغييرات",
    ),
    "profileIdentitySubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر اسم مستخدم وصورة رمزية.",
    ),
    "profileIdentitySuccessMessage": MessageLookupByLibrary.simpleMessage(
      "تم تحديث الملف الشخصي.",
    ),
    "profileIdentityTitle": MessageLookupByLibrary.simpleMessage(
      "تعديل الملف الشخصي",
    ),
    "profileIdentityUsernameEmptyError": MessageLookupByLibrary.simpleMessage(
      "أدخل اسم مستخدم.",
    ),
    "profileIdentityUsernameFormatError": MessageLookupByLibrary.simpleMessage(
      "استخدم من 3 إلى 30 حرفًا صغيرًا أو رقمًا. يمكن أن تأتي النقاط والشرطات السفلية في المنتصف.",
    ),
    "profileIdentityUsernameHint": MessageLookupByLibrary.simpleMessage(
      "حروف وأرقام و . أو _",
    ),
    "profileIdentityUsernameLabel": MessageLookupByLibrary.simpleMessage(
      "اسم المستخدم",
    ),
    "profileIdentityUsernamePreviewFallback":
        MessageLookupByLibrary.simpleMessage("اسم المستخدم الخاص بك"),
    "profileIdentityUsernameTakenError": MessageLookupByLibrary.simpleMessage(
      "اسم المستخدم هذا مستخدم بالفعل.",
    ),
    "profileInfoHubLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل مركز المعلومات. تحقق من اتصالك.",
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
      "فقط مالك المنزل يمكنه إزالة الأعضاء.",
    ),
    "profileKickSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر عضوًا لإزالته. سيفقد الوصول فورًا.",
    ),
    "profileKickSheetTitle": MessageLookupByLibrary.simpleMessage("إزالة عضو"),
    "profileKickSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "لم يعد لديه وصول إلى هذا المنزل.",
    ),
    "profileLeaveEligibilityError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل أعضاء منزلك.",
    ),
    "profileLeaveEligibilityLoading": MessageLookupByLibrary.simpleMessage(
      "جارٍ التحقق من أعضاء المنزل...",
    ),
    "profileLeaveHomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "ستغادر هذه المساحة المشتركة على كينلي.",
    ),
    "profileLeaveHomeTitle": MessageLookupByLibrary.simpleMessage(
      "مغادرة المنزل",
    ),
    "profileLeaveOwnerNoEligibleMembers": MessageLookupByLibrary.simpleMessage(
      "لا يوجد أي شخص آخر يمكنه تولّي الملكية الآن.",
    ),
    "profileLeaveOwnerSoloMessage": MessageLookupByLibrary.simpleMessage(
      "أنت العضو الأخير. مغادرتك ستؤدي إلى إلغاء تفعيل هذا المنزل.",
    ),
    "profileLeaveSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "لقد غادرت منزلك.",
    ),
    "profileLeaveTransferSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر من سيصبح المالك الجديد قبل أن تغادر.",
    ),
    "profileLeaveTransferSheetTitle": MessageLookupByLibrary.simpleMessage(
      "نقل الملكية",
    ),
    "profileLeaveTransferSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "تم نقل الملكية. جارٍ إنهاء المغادرة...",
    ),
    "profileLogoutSubtitle": MessageLookupByLibrary.simpleMessage(
      "تسجيل الخروج من كينلي على هذا الجهاز.",
    ),
    "profileLogoutTitle": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
    "profileMissingHomeError": MessageLookupByLibrary.simpleMessage(
      "تعذّر العثور على منزلك الحالي.",
    ),
    "profileSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "إدارة حسابك ووصولك إلى المنزل.",
    ),
    "profileSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "الملف الشخصي",
    ),
    "profile_deactivated_message": MessageLookupByLibrary.simpleMessage(
      "تم إلغاء تفعيل ملفك الشخصي. سجّل الدخول باستخدام عنوان بريد إلكتروني آخر.",
    ),
    "pulseCloudySteadySummary": MessageLookupByLibrary.simpleMessage(
      "بعض الأمور نجحت. وبعضها لم ينجح.",
    ),
    "pulseCloudySteadyTitle": MessageLookupByLibrary.simpleMessage("مختلط"),
    "pulseCloudyTenseSummary": MessageLookupByLibrary.simpleMessage(
      "ظهر بعض التوتر هذا الأسبوع.",
    ),
    "pulseCloudyTenseTitle": MessageLookupByLibrary.simpleMessage(
      "يحتاج إلى انتباه",
    ),
    "pulseFormingSummary": MessageLookupByLibrary.simpleMessage(
      "بعض المتابعات الإضافية ستعطي صورة أوضح.",
    ),
    "pulseFormingTitle": MessageLookupByLibrary.simpleMessage("ما يزال يتشكل"),
    "pulsePartlySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "الأمور مستقرة في الغالب، مع بعض المجال للتحسن.",
    ),
    "pulsePartlySupportedTitle": MessageLookupByLibrary.simpleMessage(
      "جيد إجمالًا",
    ),
    "pulseRainySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "قد يكون الوقت مناسبًا لإعادة ضبط بسيطة.",
    ),
    "pulseRainySupportedTitle": MessageLookupByLibrary.simpleMessage(
      "يُنصح بإعادة ضبط",
    ),
    "pulseRainyUnsupportedSummary": MessageLookupByLibrary.simpleMessage(
      "هناك احتكاك ملحوظ الآن.",
    ),
    "pulseRainyUnsupportedTitle": MessageLookupByLibrary.simpleMessage(
      "إعادة الضبط مطلوبة",
    ),
    "pulseSunnyBumpySummary": MessageLookupByLibrary.simpleMessage(
      "كان سلسًا في الغالب، مع بعض التعثرات.",
    ),
    "pulseSunnyBumpyTitle": MessageLookupByLibrary.simpleMessage(
      "سلس في الغالب",
    ),
    "pulseSunnyCalmSummary": MessageLookupByLibrary.simpleMessage(
      "سارت الأمور بسلاسة هذا الأسبوع.",
    ),
    "pulseSunnyCalmTitle": MessageLookupByLibrary.simpleMessage("يسير بسلاسة"),
    "pulseThunderstormSummary": MessageLookupByLibrary.simpleMessage(
      "التوتر مرتفع. أعد الضبط قريبًا.",
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
      "نقوم بتجميع هذا بعناية.",
    ),
    "reflectiveGenericSecondary": MessageLookupByLibrary.simpleMessage(
      "وقفة قصيرة قبل أن نعرضه.",
    ),
    "reflectiveHouseNormsPrimary": MessageLookupByLibrary.simpleMessage(
      "نعكس ما شاركه هذا المنزل.",
    ),
    "reflectiveHouseNormsSecondary": MessageLookupByLibrary.simpleMessage(
      "دليل مشترك، وليس كتاب قواعد.",
    ),
    "reflectiveHousePrimary": MessageLookupByLibrary.simpleMessage(
      "نحوّل توقعات منزلك إلى كلمات.",
    ),
    "reflectiveHouseSecondary": MessageLookupByLibrary.simpleMessage(
      "حتى تكون التوقعات واضحة.",
    ),
    "reflectivePersonalPrimary": MessageLookupByLibrary.simpleMessage(
      "نعكس ما شاركته.",
    ),
    "reflectivePersonalSecondary": MessageLookupByLibrary.simpleMessage(
      "حتى يفهم الآخرون ما يجعلك مرتاحًا.",
    ),
    "shareCreateAmountHint": MessageLookupByLibrary.simpleMessage("0.00"),
    "shareCreateAmountLabel": MessageLookupByLibrary.simpleMessage("المبلغ"),
    "shareCreateCustomAmountLabel": MessageLookupByLibrary.simpleMessage(
      "المبلغ",
    ),
    "shareCreateCustomHelper": MessageLookupByLibrary.simpleMessage(
      "أدخل حصة كل شخص. يجب أن يطابق المجموع المبلغ أعلاه.",
    ),
    "shareCreateCyclePeriod": m17,
    "shareCreateDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "مثال: مشتريات البقالة",
    ),
    "shareCreateDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "الوصف",
    ),
    "shareCreateErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "ليس لديك إذن لإنشاء هذا الآن.",
    ),
    "shareCreateErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذّر إنشاء الفاتورة.",
    ),
    "shareCreateErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "لقد وصلت إلى الحد المجاني للفواتير النشطة. قم بالترقية للمزيد.",
    ),
    "shareCreateErrorRecurrenceDraft": MessageLookupByLibrary.simpleMessage(
      "لا يمكن للمسودات أن تتكرر حتى تضيف تقسيمًا.",
    ),
    "shareCreateLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل أعضاء منزلك.",
    ),
    "shareCreateNotesHint": MessageLookupByLibrary.simpleMessage(
      "ملاحظة اختيارية يمكن للجميع رؤيتها",
    ),
    "shareCreateNotesLabel": MessageLookupByLibrary.simpleMessage("ملاحظات"),
    "shareCreateParticipantsEmpty": MessageLookupByLibrary.simpleMessage(
      "تحتاج إلى عضوين على الأقل في المنزل لمشاركة فاتورة.",
    ),
    "shareCreateRecurrenceEveryLabel": MessageLookupByLibrary.simpleMessage(
      "كل",
    ),
    "shareCreateRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "التكرار",
    ),
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
      "كيف يجب تقسيمها؟",
    ),
    "shareCreateStartLabel": MessageLookupByLibrary.simpleMessage(
      "متى ينطبق هذا؟",
    ),
    "shareCreateSubmit": MessageLookupByLibrary.simpleMessage("إنشاء"),
    "shareCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء الفاتورة.",
    ),
    "shareCreateTitle": MessageLookupByLibrary.simpleMessage("إضافة فاتورة"),
    "shareCreateValidationAmount": MessageLookupByLibrary.simpleMessage(
      "أدخل مبلغًا أكبر من صفر.",
    ),
    "shareCreateValidationCustomAmounts": MessageLookupByLibrary.simpleMessage(
      "أدخل مبلغًا صالحًا لكل شخص تم اختياره.",
    ),
    "shareCreateValidationCustomParticipants":
        MessageLookupByLibrary.simpleMessage(
          "اختر شخصًا واحدًا على الأقل لهذه الفاتورة.",
        ),
    "shareCreateValidationCustomSinglePayer":
        MessageLookupByLibrary.simpleMessage("أضف شخصًا آخر واحدًا على الأقل."),
    "shareCreateValidationCustomSum": MessageLookupByLibrary.simpleMessage(
      "تأكد من أن التقسيم يساوي المبلغ الإجمالي.",
    ),
    "shareCreateValidationCustomSumBreakdown": m18,
    "shareCreateValidationDescription": MessageLookupByLibrary.simpleMessage(
      "أدخل وصفًا.",
    ),
    "shareCreateValidationEqualParticipants":
        MessageLookupByLibrary.simpleMessage(
          "اختر شخصًا واحدًا على الأقل لتقسيم هذه الفاتورة.",
        ),
    "shareCreateValidationRecurrence": MessageLookupByLibrary.simpleMessage(
      "اختر عدد مرات التكرار.",
    ),
    "shareCreateValidationRecurrenceSplit":
        MessageLookupByLibrary.simpleMessage(
          "اختر طريقة تقسيم قبل جعل هذه الفاتورة متكررة.",
        ),
    "shareCreateValidationStartDate": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخ البدء.",
    ),
    "shareCreateValidationStartDateRange": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخًا ضمن النطاق المسموح.",
    ),
    "shareCreatedListActiveAmount": m19,
    "shareCreatedListActiveSubtitle": m20,
    "shareCreatedListDraftBadge": MessageLookupByLibrary.simpleMessage(
      "غير مخصّصة",
    ),
    "shareCreatedListDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "قسّمها قبل النشر حتى يعرف الجميع حصتهم.",
    ),
    "shareCreatedListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "الفواتير تجعل الأمور المالية واضحة.",
    ),
    "shareCreatedListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد فواتير بعد",
    ),
    "shareCreatedListError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل فواتيرك. اسحب للتحديث.",
    ),
    "shareCreatedListPaidBadge": MessageLookupByLibrary.simpleMessage(
      "مدفوعة بالكامل",
    ),
    "shareCreatedListRetry": MessageLookupByLibrary.simpleMessage(
      "حاول مرة أخرى",
    ),
    "shareCreatedListTitle": MessageLookupByLibrary.simpleMessage("فواتيرك"),
    "shareEditClose": MessageLookupByLibrary.simpleMessage("إغلاق"),
    "shareEditDeleteButton": MessageLookupByLibrary.simpleMessage("حذف"),
    "shareEditDeleteConfirm": MessageLookupByLibrary.simpleMessage("حذف"),
    "shareEditDeleteConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "سيؤدي هذا إلى إزالة المسودة للجميع.",
    ),
    "shareEditDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "هل تريد حذف الفاتورة؟",
    ),
    "shareEditDeleteError": MessageLookupByLibrary.simpleMessage(
      "تعذّر حذف الفاتورة.",
    ),
    "shareEditDeleteSuccess": MessageLookupByLibrary.simpleMessage(
      "تم حذف الفاتورة.",
    ),
    "shareEditDisabledActive": MessageLookupByLibrary.simpleMessage(
      "لا يمكن تعديل الفواتير النشطة.",
    ),
    "shareEditDisabledConverted": MessageLookupByLibrary.simpleMessage(
      "هذه الفاتورة أصبحت الآن خطة ولا يمكن تعديلها هنا.",
    ),
    "shareEditDisabledGeneric": MessageLookupByLibrary.simpleMessage(
      "لا يمكن تعديل هذه الفاتورة الآن.",
    ),
    "shareEditDisabledRecurringCycle": MessageLookupByLibrary.simpleMessage(
      "لا يمكن تعديل الدورات المتكررة هنا.",
    ),
    "shareEditLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحميل هذه المسودة.",
    ),
    "shareEditNotAllowed": MessageLookupByLibrary.simpleMessage(
      "تبقى هذه الفاتورة مقفلة حتى يتولاها أحد.",
    ),
    "shareEditSplitsLocked": MessageLookupByLibrary.simpleMessage(
      "التقسيمات مقفلة لأن شخصًا ما قد دفع بالفعل. لا يزال بإمكانك تحديث الوصف والملاحظات.",
    ),
    "shareEditSubmit": MessageLookupByLibrary.simpleMessage("تحديث"),
    "shareEditSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تحديث الفاتورة.",
    ),
    "shareEditTerminateError": MessageLookupByLibrary.simpleMessage(
      "تعذّر إنهاء الخطة.",
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
      "سيؤدي هذا إلى إيقاف دورات الفواتير المستقبلية.",
    ),
    "shareEditTerminatePlanTitle": MessageLookupByLibrary.simpleMessage(
      "هل تريد إنهاء الخطة المتكررة؟",
    ),
    "shareEditTerminateSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إنهاء الخطة.",
    ),
    "shareEditTitle": MessageLookupByLibrary.simpleMessage("تعديل الفاتورة"),
    "shareOwedDetailEmpty": MessageLookupByLibrary.simpleMessage(
      "أنت منتهٍ تمامًا مع هذا الشخص.",
    ),
    "shareOwedDetailError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحديد هذه الدفعة كمسوّاة.",
    ),
    "shareOwedDetailPaid": MessageLookupByLibrary.simpleMessage("تحديد كمسوّى"),
    "shareOwedDetailSuccess": MessageLookupByLibrary.simpleMessage(
      "تم التحديد كمسوّى.",
    ),
    "shareOwedDetailTitle": MessageLookupByLibrary.simpleMessage("للتسوية"),
    "sharePaidDetailAcknowledge": MessageLookupByLibrary.simpleMessage(
      "تأكيد الاستلام",
    ),
    "sharePaidDetailAcknowledgeError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تأكيد هذه الدفعة.",
    ),
    "sharePaidDetailAcknowledging": MessageLookupByLibrary.simpleMessage(
      "جارٍ التأكيد...",
    ),
    "shoppingAllItemsBought": MessageLookupByLibrary.simpleMessage(
      "تم شراء كل شيء",
    ),
    "shoppingAmountHint": MessageLookupByLibrary.simpleMessage("مثال: عبوتان"),
    "shoppingAmountLabel": MessageLookupByLibrary.simpleMessage("الكمية"),
    "shoppingArchiveCta": MessageLookupByLibrary.simpleMessage(
      "العناصر المشتراة",
    ),
    "shoppingArchiveDraftBillCreated": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء مسودة فاتورة",
    ),
    "shoppingArchiveItemsBought": MessageLookupByLibrary.simpleMessage(
      "تم تحديد العناصر كمشتراة وإزالتها",
    ),
    "shoppingArchiveShareNo": MessageLookupByLibrary.simpleMessage("لا"),
    "shoppingArchiveSharePromptBody": MessageLookupByLibrary.simpleMessage(
      "هل تريد إنشاء مسودة فاتورة من هذه العناصر؟",
    ),
    "shoppingArchiveSharePromptTitle": MessageLookupByLibrary.simpleMessage(
      "إنشاء فاتورة؟",
    ),
    "shoppingArchiveShareYes": MessageLookupByLibrary.simpleMessage("نعم"),
    "shoppingCardSubtitle": m21,
    "shoppingCardTitle": MessageLookupByLibrary.simpleMessage("قائمة التسوق"),
    "shoppingContextHint": MessageLookupByLibrary.simpleMessage(
      "الماركة أو الحجم أو ملاحظات",
    ),
    "shoppingContextLabel": MessageLookupByLibrary.simpleMessage("ملاحظات"),
    "shoppingCreateTitle": MessageLookupByLibrary.simpleMessage(
      "إضافة عنصر تسوق",
    ),
    "shoppingDelete": MessageLookupByLibrary.simpleMessage("حذف العنصر"),
    "shoppingDeleteConfirmBody": MessageLookupByLibrary.simpleMessage(
      "سيؤدي هذا إلى إزالته من قائمة التسوق المشتركة.",
    ),
    "shoppingDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "هل تريد حذف هذا العنصر؟",
    ),
    "shoppingDetailTitle": MessageLookupByLibrary.simpleMessage("عنصر التسوق"),
    "shoppingEditTitle": MessageLookupByLibrary.simpleMessage(
      "تعديل عنصر التسوق",
    ),
    "shoppingEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد عناصر تسوق.",
    ),
    "shoppingErrorItemAlreadyCompletedByOther":
        MessageLookupByLibrary.simpleMessage(
          "قام شخص آخر بالفعل بتحديد هذا العنصر كمشترى.",
        ),
    "shoppingListTitle": MessageLookupByLibrary.simpleMessage("قائمة التسوق"),
    "shoppingMarkCompleteCta": MessageLookupByLibrary.simpleMessage(
      "تحديد كمشترى",
    ),
    "shoppingNameHint": MessageLookupByLibrary.simpleMessage("مثال: حليب"),
    "shoppingNameLabel": MessageLookupByLibrary.simpleMessage("الاسم"),
    "shoppingPhotoLabel": MessageLookupByLibrary.simpleMessage("إضافة صورة"),
    "shoppingPhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "أضف صورة",
    ),
    "shoppingPhotoReplaceLabel": MessageLookupByLibrary.simpleMessage(
      "ساعد الآخرين على شراء العنصر الصحيح",
    ),
    "shoppingSubmitAdd": MessageLookupByLibrary.simpleMessage("إضافة عنصر"),
    "shoppingSubmitEdit": MessageLookupByLibrary.simpleMessage("حفظ التغييرات"),
    "shoppingTabPending": MessageLookupByLibrary.simpleMessage("للشراء"),
    "shoppingValidationName": MessageLookupByLibrary.simpleMessage(
      "أدخل اسم العنصر.",
    ),
    "startReturningSubtitle": MessageLookupByLibrary.simpleMessage(
      "ماذا تريد أن تفعل؟",
    ),
    "startReturningTitle": m22,
    "todayAddSheetFlow": MessageLookupByLibrary.simpleMessage("إضافة مهمة"),
    "todayAddSheetShare": MessageLookupByLibrary.simpleMessage("إضافة فاتورة"),
    "todayAddSheetShopping": MessageLookupByLibrary.simpleMessage(
      "إضافة عنصر تسوق",
    ),
    "todayAddSheetTitle": MessageLookupByLibrary.simpleMessage("أضف إلى منزلك"),
    "todayEmptyBody": MessageLookupByLibrary.simpleMessage(
      "لا يوجد ما يحتاج إلى انتباهك الآن.",
    ),
    "todayEmptyCardBadge": MessageLookupByLibrary.simpleMessage("خذ استراحة"),
    "todayEmptyCardTitle": MessageLookupByLibrary.simpleMessage(
      "كل شيء تحت السيطرة",
    ),
    "todayFlatmateInviteSubtitle": MessageLookupByLibrary.simpleMessage(
      "ابقوا منسجمين وتقاسموا المسؤوليات.",
    ),
    "todayFlatmateInviteTitle": MessageLookupByLibrary.simpleMessage(
      "ادعُ زملاء السكن",
    ),
    "todayFlowBadgeNew": MessageLookupByLibrary.simpleMessage("جديد اليوم"),
    "todayFlowSectionTitle": MessageLookupByLibrary.simpleMessage("المهام"),
    "todayFlowSeeAll": m23,
    "todayFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "إليك ما يحتاج إلى انتباه اليوم.",
    ),
    "todayFlowTabActive": MessageLookupByLibrary.simpleMessage("نشطة"),
    "todayFlowTabDrafts": MessageLookupByLibrary.simpleMessage("مسودات"),
    "todayGratitudeHouseCta": MessageLookupByLibrary.simpleMessage(
      "رسائل شكر المنزل",
    ),
    "todayGratitudePersonalCta": MessageLookupByLibrary.simpleMessage(
      "رسائل شكري",
    ),
    "todayGratitudeSectionTitle": MessageLookupByLibrary.simpleMessage(
      "رسائل الشكر",
    ),
    "todayGratitudeUnreadBody": MessageLookupByLibrary.simpleMessage(
      "هناك رسائل شكر جديدة بانتظارك.",
    ),
    "todayInviteFriendsSubtitle": MessageLookupByLibrary.simpleMessage(
      "شارك كينلي مع الأصدقاء.",
    ),
    "todayInviteFriendsTitle": MessageLookupByLibrary.simpleMessage(
      "ادعُ أصدقاءك إلى كينلي",
    ),
    "todayInviteNotNow": MessageLookupByLibrary.simpleMessage("ليس الآن"),
    "todayInviteShareCta": MessageLookupByLibrary.simpleMessage(
      "مشاركة الدعوة",
    ),
    "todayMemberCapPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "ترقية المنزل",
    ),
    "todayMemberCapResolutionFailed": m24,
    "todayMemberCapResolutionJoined": m25,
    "todayMemberCapResolutionSuperseded": m26,
    "todayMemberCapResolutionUnknownName": MessageLookupByLibrary.simpleMessage(
      "شخص ما",
    ),
    "todayMemberCapSecondaryCta": MessageLookupByLibrary.simpleMessage("تجاهل"),
    "todayMemberCapSubtitle": m27,
    "todayMemberCapSubtitleGeneric": MessageLookupByLibrary.simpleMessage(
      "قم بالترقية لإضافة المزيد من الأشخاص.",
    ),
    "todayMemberCapTitle": MessageLookupByLibrary.simpleMessage(
      "هناك من يريد الانضمام إلى منزلك",
    ),
    "todayShareActiveSubtitle": m28,
    "todayShareError": MessageLookupByLibrary.simpleMessage(
      "تعذّر تحديث الفواتير الآن.",
    ),
    "todaySharePaidSubtitle": MessageLookupByLibrary.simpleMessage(
      "المبلغ المُسوّى",
    ),
    "todaySharePaidUnseen": m29,
    "todayShareSectionTitle": MessageLookupByLibrary.simpleMessage("الفواتير"),
    "todayShareTabActive": MessageLookupByLibrary.simpleMessage("للتسوية"),
    "todayShareTabDrafts": MessageLookupByLibrary.simpleMessage("مسودات"),
    "todayShareTabPaidToMe": MessageLookupByLibrary.simpleMessage(
      "تمت التسوية",
    ),
    "vibeCozySocialSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك يبدو مريحًا وهادئًا معًا.",
    ),
    "vibeCozySocialTitle": MessageLookupByLibrary.simpleMessage("اجتماعي مريح"),
    "vibeDefaultSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك يبدو متوازنًا.",
    ),
    "vibeDefaultTitle": MessageLookupByLibrary.simpleMessage("منزل متوازن"),
    "vibeEasygoingSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك يبدو مريحًا ومرنًا.",
    ),
    "vibeEasygoingTitle": MessageLookupByLibrary.simpleMessage("تدفق سهل"),
    "vibeIndependentSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك يقدّر المساحة والهدوء.",
    ),
    "vibeIndependentTitle": MessageLookupByLibrary.simpleMessage("هدوء مستقل"),
    "vibeInsufficientSummary": MessageLookupByLibrary.simpleMessage(
      "أكمل التفضيلات لرؤية طابع منزلك.",
    ),
    "vibeInsufficientTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد بيانات كافية بعد",
    ),
    "vibeMixedSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك يحتوي على أنماط معيشة مختلفة.",
    ),
    "vibeMixedTitle": MessageLookupByLibrary.simpleMessage("منزل بطابع مختلط"),
    "vibeQuietCareSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك يبدو هادئًا ولطيفًا.",
    ),
    "vibeQuietCareTitle": MessageLookupByLibrary.simpleMessage("اهتمام هادئ"),
    "vibeSocialSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك يبدو نشيطًا واجتماعيًا.",
    ),
    "vibeSocialTitle": MessageLookupByLibrary.simpleMessage("طاقة اجتماعية"),
    "vibeSteadySummary": MessageLookupByLibrary.simpleMessage(
      "منزلك يبدو ثابتًا ومتسقًا.",
    ),
    "vibeSteadyTitle": MessageLookupByLibrary.simpleMessage("هدوء ثابت"),
    "vibeStructuredSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك يعمل بشكل أفضل مع الروتين والخطط.",
    ),
    "vibeStructuredTitle": MessageLookupByLibrary.simpleMessage("إيقاع منظم"),
    "vibeWarmSocialSummary": MessageLookupByLibrary.simpleMessage(
      "منزلك يبدو دافئًا ومرحبًا.",
    ),
    "vibeWarmSocialTitle": MessageLookupByLibrary.simpleMessage("اجتماعي دافئ"),
    "weeklyRewriteCta": MessageLookupByLibrary.simpleMessage(
      "أرسل بهدوء مع كينلي",
    ),
    "welcome_create": MessageLookupByLibrary.simpleMessage("إنشاء منزل"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("الانضمام إلى منزل"),
    "welcome_title": MessageLookupByLibrary.simpleMessage("مرحبًا بك في كينلي"),
  };
}
