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

  static String m0(env) => "جاري تشغيل كينلي (${env})";

  static String m1(client, current) =>
      "نسختك: ${client}\nأحدث إصدار: ${current}";

  static String m2(partOfDay, name) => "مرحبًا يا ${name}";

  static String m3(link) => "شارك كينلي ليصبح التعاون في المنزل أسهل: ${link}";

  static String m4(code, link) =>
      "مرحبًا بك في منزلنا على كينلي!\nاستخدم رمز الدعوة: ${code}\nحمّل تطبيق كينلي: ${link}";

  static String m5(code) => "تم الانضمام باستخدام الرمز: ${code}";

  static String m6(paidAmount, totalAmount) =>
      "${paidAmount} من ${totalAmount} تم تحصيلها";

  static String m7(paid, total) => "${paid} من ${total} مدفوع";

  static String m8(count) => "عرض الكل (${count})";

  static String m9(count) =>
      "${Intl.plural(count, one: '${count} دفعة معلّقة', other: '${count} دفعات معلّقة')}";

  static String m10(homeId, role) =>
      "المنزل الحالي: ${homeId} • الدور: ${role}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("كينلي"),
    "authMembershipLoadFailed": MessageLookupByLibrary.simpleMessage(
      "تعذر تحديث معلومات منزلك. يرجى المحاولة مرة أخرى.",
    ),
    "bootstrap_initializing": m0,
    "create_failed_generic": MessageLookupByLibrary.simpleMessage(
      "تعذر إنشاء المنزل. يرجى المحاولة مرة أخرى.",
    ),
    "create_submit": MessageLookupByLibrary.simpleMessage("إنشاء المنزل"),
    "create_subtitle": MessageLookupByLibrary.simpleMessage(
      "سنقوم بإعداد منزلك فورًا. يمكنك إعادة التسمية ودعوة الآخرين لاحقًا.",
    ),
    "create_success": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء المنزل بنجاح!",
    ),
    "create_title": MessageLookupByLibrary.simpleMessage("إنشاء منزل"),
    "exploreFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "راجع جميع مهام Flow وحافظ على سير الأعمال.",
    ),
    "exploreIntroSubtitle": MessageLookupByLibrary.simpleMessage(
      "استكشف المزيد من الطرق للحفاظ على انسجام منزلك.",
    ),
    "exploreIntroTitle": MessageLookupByLibrary.simpleMessage(
      "اكتشف ما هو قادم",
    ),
    "exploreShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "شاهد كل المصاريف التي أنشأتها وتتبع المدفوعات.",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage("تعيين إلى"),
    "flowChoreAssigneeUnassigned": MessageLookupByLibrary.simpleMessage(
      "غير معيّن",
    ),
    "flowChoreCreateTitle": MessageLookupByLibrary.simpleMessage(
      "إضافة مهمة Flow",
    ),
    "flowChoreDeleteButton": MessageLookupByLibrary.simpleMessage("حذف المهمة"),
    "flowChoreDeleteCancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "flowChoreDeleteConfirm": MessageLookupByLibrary.simpleMessage("حذف"),
    "flowChoreDeleteDialogMessage": MessageLookupByLibrary.simpleMessage(
      "سيتم إزالة هذه المهمة للجميع في المنزل.",
    ),
    "flowChoreDeleteDialogTitle": MessageLookupByLibrary.simpleMessage(
      "حذف هذه المهمة؟",
    ),
    "flowChoreDetailCompleteButton": MessageLookupByLibrary.simpleMessage(
      "إكمال المهمة",
    ),
    "dopamineFlowAffirmation": MessageLookupByLibrary.simpleMessage(
      "?????? ????? ???? ???.",
    ),
    "flowChoreDetailCompletionError": MessageLookupByLibrary.simpleMessage(
      "تعذر إكمال المهمة. حاول مرة أخرى.",
    ),
    "flowChoreDetailMoreInfoTitle": MessageLookupByLibrary.simpleMessage(
      "مزيد من التفاصيل",
    ),
    "flowChoreDetailNoHowTo": MessageLookupByLibrary.simpleMessage(
      "لا يوجد رابط تعليمات.",
    ),
    "flowChoreDetailNoNotes": MessageLookupByLibrary.simpleMessage(
      "لا توجد ملاحظات بعد.",
    ),
    "flowChoreDetailTitle": MessageLookupByLibrary.simpleMessage(
      "تفاصيل المهمة",
    ),
    "flowChoreDetailUnassigned": MessageLookupByLibrary.simpleMessage(
      "غير معيّن",
    ),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage(
      "تعديل مهمة Flow",
    ),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "لا يمكن تعيين هذه المهمة لهذا العضو حاليًا.",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "ليس لديك صلاحية تعديل هذه المهمة.",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذر حفظ المهمة. يرجى المحاولة مرة أخرى.",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "مسار الصورة غير صالح لهذا المنزل.",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار تاريخ بدء صالح.",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "لا يمكن تعديل هذه المهمة في الوقت الحالي.",
    ),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "لقد وصلت إلى الحد المجاني للمهام النشطة. قم بالترقية لإضافة المزيد.",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "لقد وصلت إلى الحد المجاني لصور التوقعات. احذف صورة أو قم بالترقية.",
    ),
    "flowChoreExpectationPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "صورة التوقعات",
    ),
    "flowChoreHowToHint": MessageLookupByLibrary.simpleMessage(
      "ألصق رابط فيديو أو مستند (اختياري)",
    ),
    "flowChoreHowToLabel": MessageLookupByLibrary.simpleMessage(
      "رابط التعليمات",
    ),
    "flowChoreHowToLaunchError": MessageLookupByLibrary.simpleMessage(
      "تعذر فتح هذا الرابط. حاول مرة أخرى.",
    ),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل هذه المهمة. يرجى المحاولة مرة أخرى.",
    ),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage(
      "اكتب عنوانًا قصيرًا وواضحًا للمهمة",
    ),
    "flowChoreNameLabel": MessageLookupByLibrary.simpleMessage("اسم المهمة"),
    "flowChoreNotesHint": MessageLookupByLibrary.simpleMessage(
      "أضف ملاحظات أو تذكيرات اختيارية",
    ),
    "flowChoreNotesLabel": MessageLookupByLibrary.simpleMessage("ملاحظات"),
    "flowChorePhotoHint": MessageLookupByLibrary.simpleMessage(
      "storage/households/... (اختياري)",
    ),
    "flowChorePhotoLabel": MessageLookupByLibrary.simpleMessage(
      "صورة التوقعات",
    ),
    "flowChorePhotoLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل الصورة.",
    ),
    "flowChorePhotoPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "يلزم منح إذن استخدام الكاميرا لالتقاط صورة.",
    ),
    "flowChorePhotoPermissionOpenSettings":
        MessageLookupByLibrary.simpleMessage("فتح الإعدادات"),
    "flowChorePhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "أضف صورة توضّح كيف يجب أن يبدو الأمر بشكل جيد",
    ),
    "flowChorePhotoUploadError": MessageLookupByLibrary.simpleMessage(
      "تعذر رفع الصورة. حاول مرة أخرى.",
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
    "flowChoreStartLabel": MessageLookupByLibrary.simpleMessage("تاريخ البدء"),
    "flowChoreSubmitCreate": MessageLookupByLibrary.simpleMessage(
      "إضافة المهمة",
    ),
    "flowChoreSubmitUpdate": MessageLookupByLibrary.simpleMessage(
      "حفظ التعديلات",
    ),
    "flowChoreValidationAssignee": MessageLookupByLibrary.simpleMessage(
      "اختر الشخص المسؤول عن هذه المهمة.",
    ),
    "flowChoreValidationDate": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخًا خلال سنة من اليوم.",
    ),
    "flowChoreValidationHowToUrl": MessageLookupByLibrary.simpleMessage(
      "أدخل رابطًا صالحًا يبدأ بـ http أو https.",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال اسم للمهمة.",
    ),
    "flowListDraftLabel": MessageLookupByLibrary.simpleMessage("مسودة"),
    "flowListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "أضف أول روتين ليعرف الجميع ما يجب فعله.",
    ),
    "flowListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد مهام Flow بعد",
    ),
    "flowListError": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل مهام Flow. اسحب للتحديث.",
    ),
    "flowListOverdueLabel": MessageLookupByLibrary.simpleMessage("متأخرة"),
    "force_update_body": MessageLookupByLibrary.simpleMessage(
      "هذا الإصدار من كينلي لم يعد مدعومًا. يرجى تثبيت أحدث إصدار للمتابعة.",
    ),
    "force_update_button": MessageLookupByLibrary.simpleMessage("تحديث كينلي"),
    "force_update_notes_label": MessageLookupByLibrary.simpleMessage(
      "ما الجديد",
    ),
    "force_update_title": MessageLookupByLibrary.simpleMessage("التحديث مطلوب"),
    "force_update_version_details": m1,
    "friendDefaultName": MessageLookupByLibrary.simpleMessage("صديق"),
    "greetingPartAfternoon": MessageLookupByLibrary.simpleMessage("مساء الخير"),
    "greetingPartEvening": MessageLookupByLibrary.simpleMessage("مساء الخير"),
    "greetingPartMorning": MessageLookupByLibrary.simpleMessage("صباح الخير"),
    "greetingPartOfDay": m2,
    "greetingPartOfDay_name": MessageLookupByLibrary.simpleMessage("الاسم"),
    "greetingPartOfDay_partOfDay": MessageLookupByLibrary.simpleMessage(
      "جزء اليوم (صباح/ظهر/مساء)",
    ),
    "harmonyErrorSelectMood": MessageLookupByLibrary.simpleMessage(
      "اختر مزاجا قبل الارسال.",
    ),
    "hubCodeCopied": MessageLookupByLibrary.simpleMessage("تم نسخ رمز الدعوة"),
    "hubCopyCode": MessageLookupByLibrary.simpleMessage("نسخ رمز الدعوة"),
    "hubError": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل المركز. يرجى المحاولة مرة أخرى.",
    ),
    "hubInviteCta": MessageLookupByLibrary.simpleMessage("دعوة"),
    "hubInviteUnavailable": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل الدعوة. يرجى المحاولة مرة أخرى.",
    ),
    "hubMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "لا يوجد أعضاء نشطون بعد.",
    ),
    "hubMembersSubtitle": MessageLookupByLibrary.simpleMessage(
      "الأشخاص النشطون حاليًا في هذا المنزل.",
    ),
    "hubMembersTitle": MessageLookupByLibrary.simpleMessage("أعضاء المنزل"),
    "hubQrSubtitle": MessageLookupByLibrary.simpleMessage(
      "امسح الكود لتحميل كينلي",
    ),
    "hubQrTitle": MessageLookupByLibrary.simpleMessage("مشاركة التطبيق"),
    "hubRetry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "hubRotateError": MessageLookupByLibrary.simpleMessage(
      "تعذر تجديد رمز الدعوة. حاول مرة أخرى.",
    ),
    "hubRotateInvite": MessageLookupByLibrary.simpleMessage("تجديد رمز الدعوة"),
    "hubRotateSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تجديد رمز الدعوة",
    ),
    "hubShareAppBody": m3,
    "hubShareAppCta": MessageLookupByLibrary.simpleMessage("مشاركة كينلي"),
    "hubShareAppTitle": MessageLookupByLibrary.simpleMessage(
      "الحصول على تطبيق كينلي",
    ),
    "hubShareInviteBody": m4,
    "hubShareInviteTitle": MessageLookupByLibrary.simpleMessage(
      "دعوة إلى منزلي في كينلي",
    ),
    "join_error_already_in_other_home": MessageLookupByLibrary.simpleMessage(
      "أنت بالفعل في منزل آخر. غادره قبل الانضمام إلى منزل جديد.",
    ),
    "join_error_forbidden": MessageLookupByLibrary.simpleMessage(
      "ليس لديك صلاحية الانضمام إلى هذا المنزل.",
    ),
    "join_error_inactive_invite": MessageLookupByLibrary.simpleMessage(
      "رمز الدعوة هذا لم يعد نشطًا. اطلب من المالك رمزًا جديدًا.",
    ),
    "join_error_invalid_code": MessageLookupByLibrary.simpleMessage(
      "رمز الدعوة غير صحيح.",
    ),
    "join_error_paywall_limit": MessageLookupByLibrary.simpleMessage(
      "وصل هذا المنزل إلى الحد الأقصى للأعضاء. اطلب من المالك الترقية أو إزالة عضو.",
    ),
    "join_error_unauthorized": MessageLookupByLibrary.simpleMessage(
      "يرجى تسجيل الدخول للانضمام إلى هذا المنزل.",
    ),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage(
      "تعذر إتمام الانضمام. حاول مرة أخرى.",
    ),
    "join_hint": MessageLookupByLibrary.simpleMessage("أدخل رمز الدعوة"),
    "join_submit": MessageLookupByLibrary.simpleMessage("انضمام"),
    "join_success": m5,
    "join_title": MessageLookupByLibrary.simpleMessage("الانضمام إلى المنزل"),
    "login_consent_connector": MessageLookupByLibrary.simpleMessage(" و "),
    "login_consent_prefix": MessageLookupByLibrary.simpleMessage(
      "لقد قرأت ووافقت على ",
    ),
    "login_privacy": MessageLookupByLibrary.simpleMessage("سياسة الخصوصية"),
    "login_tagline": MessageLookupByLibrary.simpleMessage(
      "معًا تصبح الحياة أخف وأسهل",
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
      "أنت بالفعل عضو في أحد المنازل.",
    ),
    "membership_status_checking": MessageLookupByLibrary.simpleMessage(
      "جارٍ التحقق من حالة عضويتك…",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "لم تنضم إلى أي منزل بعد.",
    ),
    "navExplore": MessageLookupByLibrary.simpleMessage("استكشاف"),
    "navHub": MessageLookupByLibrary.simpleMessage("المركز"),
    "navToday": MessageLookupByLibrary.simpleMessage("اليوم"),
    "offline_body": MessageLookupByLibrary.simpleMessage(
      "يتطلب كينلي اتصالًا بالإنترنت. تحقق من الشبكة وحاول مرة أخرى.",
    ),
    "offline_retry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "offline_title": MessageLookupByLibrary.simpleMessage("أنت غير متصل"),
    "profileActionCancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "profileActionConfirm": MessageLookupByLibrary.simpleMessage("متابعة"),
    "profileConfirmDeleteMessage": MessageLookupByLibrary.simpleMessage(
      "سيتم حذف حسابك وتسجيل خروجك. لا يمكن التراجع عن هذا الإجراء.",
    ),
    "profileConfirmDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "حذف حسابك؟",
    ),
    "profileConfirmLeaveMessage": MessageLookupByLibrary.simpleMessage(
      "ستفقد الوصول إلى Flow والسجل والمشاركات في هذا المنزل.",
    ),
    "profileConfirmLeaveTitle": MessageLookupByLibrary.simpleMessage(
      "مغادرة هذا المنزل؟",
    ),
    "profileContactEmailSubject": MessageLookupByLibrary.simpleMessage(
      "اتصل بنا",
    ),
    "profileContactLaunchError": MessageLookupByLibrary.simpleMessage(
      "تعذر فتح تطبيق البريد. حاول مرة أخرى.",
    ),
    "profileContactUsSubtitle": MessageLookupByLibrary.simpleMessage(
      "البريد الإلكتروني: support@makinglifeeasie.com",
    ),
    "profileContactUsTitle": MessageLookupByLibrary.simpleMessage("اتصل بنا"),
    "profileDeleteAccountSubtitle": MessageLookupByLibrary.simpleMessage(
      "إزالة حسابك في كينلي وبيانات ملفك الشخصي.",
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
      "لا توجد صور رمزية متاحة الآن. حاول مرة أخرى لاحقًا.",
    ),
    "profileIdentityAvatarSectionDescription":
        MessageLookupByLibrary.simpleMessage(
          "كل صورة رمزية فريدة داخل المنزل.",
        ),
    "profileIdentityAvatarSectionTitle": MessageLookupByLibrary.simpleMessage(
      "اختر صورة رمزية",
    ),
    "profileIdentityLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل ملفك الشخصي.",
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
      "يرجى إدخال اسم مستخدم للمتابعة.",
    ),
    "profileIdentityUsernameFormatError": MessageLookupByLibrary.simpleMessage(
      "استخدم 3–30 حرفًا صغيرة أو أرقامًا. يمكنك استخدام النقاط أو الشرطات السفلية في المنتصف.",
    ),
    "profileIdentityUsernameHint": MessageLookupByLibrary.simpleMessage(
      "أحرف، أرقام، . أو _",
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
      "تعذر تحميل مركز المعلومات. تحقق من اتصالك بالإنترنت.",
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
      "اختر من يجب أن يفقد الوصول إلى هذا المنزل.",
    ),
    "profileKickMemberTitle": MessageLookupByLibrary.simpleMessage("إزالة عضو"),
    "profileKickNoMembers": MessageLookupByLibrary.simpleMessage(
      "لا يوجد أعضاء آخرون لإزالتهم حالياً.",
    ),
    "profileKickOwnerOnly": MessageLookupByLibrary.simpleMessage(
      "يمكن لمالك المنزل فقط إزالة الأعضاء.",
    ),
    "profileKickSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر عضواً لإزالته. سيفقد الوصول فوراً.",
    ),
    "profileKickSheetTitle": MessageLookupByLibrary.simpleMessage("إزالة عضو"),
    "profileKickSuccessClose": MessageLookupByLibrary.simpleMessage(
      "العودة إلى الإعدادات",
    ),
    "profileKickSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "لم يعد لديه حق الوصول إلى هذا المنزل.",
    ),
    "profileKickSuccessTitle": MessageLookupByLibrary.simpleMessage(
      "تمت إزالة العضو",
    ),
    "profileLeaveEligibilityError": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل أعضاء المنزل. حاول مرة أخرى.",
    ),
    "profileLeaveEligibilityLoading": MessageLookupByLibrary.simpleMessage(
      "جارٍ التحقق من أعضاء المنزل…",
    ),
    "profileLeaveHomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "إيقاف المشاركة مع هذا المنزل. يجب على المالك نقل الملكية أولًا.",
    ),
    "profileLeaveHomeTitle": MessageLookupByLibrary.simpleMessage(
      "مغادرة المنزل",
    ),
    "profileLeaveOwnerNoEligibleMembers": MessageLookupByLibrary.simpleMessage(
      "لا يوجد من يمكنه تولي الملكية الآن. حاول مرة أخرى لاحقًا.",
    ),
    "profileLeaveOwnerSoloMessage": MessageLookupByLibrary.simpleMessage(
      "أنت آخر عضو في هذا المنزل. مغادرتك ستوقف هذا المنزل للجميع.",
    ),
    "profileLeaveSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "لقد غادرت المنزل.",
    ),
    "profileLeaveTransferSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر من سيصبح المالك الجديد قبل مغادرتك.",
    ),
    "profileLeaveTransferSheetTitle": MessageLookupByLibrary.simpleMessage(
      "نقل الملكية",
    ),
    "profileLeaveTransferSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "تم نقل الملكية. جارٍ إكمال عملية مغادرتك…",
    ),
    "profileLogoutDialogMessage": MessageLookupByLibrary.simpleMessage(
      "ستحتاج إلى تسجيل الدخول مرة أخرى للوصول إلى منزلك.",
    ),
    "profileLogoutDialogTitle": MessageLookupByLibrary.simpleMessage(
      "تسجيل الخروج؟",
    ),
    "profileLogoutSubtitle": MessageLookupByLibrary.simpleMessage(
      "تسجيل الخروج من كينلي على هذا الجهاز.",
    ),
    "profileLogoutTitle": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
    "profileMissingHomeError": MessageLookupByLibrary.simpleMessage(
      "تعذر العثور على منزلك الحالي. حاول مرة أخرى.",
    ),
    "profileSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "إدارة تفضيلات حسابك والوصول إلى المنزل.",
    ),
    "profileSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "الملف الشخصي والمنزل",
    ),
    "quick_add_fair_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "تسجيل ملاحظة عن الإنصاف",
    ),
    "quick_add_fair_share_title": MessageLookupByLibrary.simpleMessage(
      "الإنصاف",
    ),
    "quick_add_flow_subtitle": MessageLookupByLibrary.simpleMessage(
      "إضافة مهمة إلى Flow",
    ),
    "quick_add_flow_title": MessageLookupByLibrary.simpleMessage("Flow"),
    "quick_add_poll_subtitle": MessageLookupByLibrary.simpleMessage(
      "إنشاء استبيان سريع للمنزل",
    ),
    "quick_add_poll_title": MessageLookupByLibrary.simpleMessage("استبيان"),
    "quick_add_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "تسجيل مصروف مشترك",
    ),
    "quick_add_share_title": MessageLookupByLibrary.simpleMessage("Share"),
    "quick_add_title": MessageLookupByLibrary.simpleMessage("إضافة سريعة"),
    "shareCreateAmountHint": MessageLookupByLibrary.simpleMessage("0.00"),
    "shareCreateAmountLabel": MessageLookupByLibrary.simpleMessage("المبلغ"),
    "shareCreateCustomAmountLabel": MessageLookupByLibrary.simpleMessage(
      "المبلغ",
    ),
    "shareCreateCustomHelper": MessageLookupByLibrary.simpleMessage(
      "أدخل المبلغ الخاص بكل شخص. يجب أن يساوي المجموع المبلغ الكلي.",
    ),
    "shareCreateDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "مثال: مشتريات البقالة",
    ),
    "shareCreateDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "الوصف",
    ),
    "shareCreateErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "لا تملك صلاحية إنشاء هذا المصروف الآن.",
    ),
    "shareCreateErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "تعذر إنشاء المصروف. حاول مرة أخرى.",
    ),
    "shareCreateErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "وصلت إلى الحد المجاني (10 مصروفات نشطة أو مسودات). أغلق أو ألغ أحدها للمتابعة.",
    ),
    "shareCreateLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل أعضاء المنزل.",
    ),
    "shareCreateNotesHint": MessageLookupByLibrary.simpleMessage(
      "ملاحظات اختيارية يمكن للجميع رؤيتها",
    ),
    "shareCreateNotesLabel": MessageLookupByLibrary.simpleMessage("ملاحظات"),
    "shareCreateParticipantsEmpty": MessageLookupByLibrary.simpleMessage(
      "تحتاج إلى عضوين على الأقل في المنزل لتقسيم المصروف.",
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
      "طريقة التقسيم",
    ),
    "shareCreateSubmit": MessageLookupByLibrary.simpleMessage("إنشاء"),
    "shareCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء المصروف.",
    ),
    "shareCreateTitle": MessageLookupByLibrary.simpleMessage("إنشاء مصروف"),
    "shareCreateValidationAmount": MessageLookupByLibrary.simpleMessage(
      "أدخل مبلغًا صالحًا أكبر من صفر.",
    ),
    "shareCreateValidationCustomAmounts": MessageLookupByLibrary.simpleMessage(
      "أدخل مبلغًا صالحًا لكل شخص.",
    ),
    "shareCreateValidationCustomParticipants":
        MessageLookupByLibrary.simpleMessage(
          "التقسيم المخصص يحتاج إلى عضوين على الأقل.",
        ),
    "shareCreateValidationCustomSinglePayer":
        MessageLookupByLibrary.simpleMessage(
          "لا يمكن لشخص واحد دفع المبلغ كاملًا في التقسيم المخصص.",
        ),
    "shareCreateValidationCustomSum": MessageLookupByLibrary.simpleMessage(
      "يجب أن يتطابق مجموع المبالغ مع المبلغ الكلي.",
    ),
    "shareCreateValidationDescription": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال وصف.",
    ),
    "shareCreateValidationEqualParticipants":
        MessageLookupByLibrary.simpleMessage(
          "اختر عضوين على الأقل لتقسيم المبلغ.",
        ),
    "shareCreateValidationSplit": MessageLookupByLibrary.simpleMessage(
      "اختر طريقة التقسيم.",
    ),
    "shareCreatedListActiveAmount": m6,
    "shareCreatedListActiveSubtitle": m7,
    "shareCreatedListDraftBadge": MessageLookupByLibrary.simpleMessage(
      "غير معيَّن",
    ),
    "shareCreatedListDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "أكمل التقسيم لتعيين المبالغ قبل النشر.",
    ),
    "shareCreatedListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "أنشئ مصروفًا ليظهر في هذه القائمة.",
    ),
    "shareCreatedListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد مصاريف بعد",
    ),
    "shareCreatedListError": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل قائمة المصاريف. اسحب للتحديث.",
    ),
    "shareCreatedListPaidBadge": MessageLookupByLibrary.simpleMessage(
      "مدفوع بالكامل",
    ),
    "shareCreatedListRetry": MessageLookupByLibrary.simpleMessage(
      "إعادة المحاولة",
    ),
    "shareCreatedListTitle": MessageLookupByLibrary.simpleMessage("مصاريفك"),
    "shareEditClose": MessageLookupByLibrary.simpleMessage("إغلاق"),
    "shareEditDeleteButton": MessageLookupByLibrary.simpleMessage("حذف"),
    "shareEditDeleteCancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "shareEditDeleteConfirm": MessageLookupByLibrary.simpleMessage("حذف"),
    "shareEditDeleteConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "سيتم حذف المسودة للجميع.",
    ),
    "shareEditDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "حذف هذا المصروف؟",
    ),
    "shareEditDeleteError": MessageLookupByLibrary.simpleMessage(
      "تعذر حذف هذا المصروف. حاول مرة أخرى.",
    ),
    "shareEditDeleteSuccess": MessageLookupByLibrary.simpleMessage(
      "تم حذف المصروف.",
    ),
    "shareEditLoadError": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل هذه المسودة.",
    ),
    "shareEditNotAllowed": MessageLookupByLibrary.simpleMessage(
      "لا يمكن تعديل هذا المصروف لأنه أصبح مقفلًا.",
    ),
    "shareEditSplitsLocked": MessageLookupByLibrary.simpleMessage(
      "التقسيمات مقفلة لأن أحد الأعضاء دفع حصته بالفعل.",
    ),
    "shareEditSubmit": MessageLookupByLibrary.simpleMessage("تحديث"),
    "shareEditSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تحديث المصروف.",
    ),
    "shareEditTitle": MessageLookupByLibrary.simpleMessage("إكمال المسودة"),
    "shareOwedDetailEmpty": MessageLookupByLibrary.simpleMessage(
      "لا توجد دفعات معلّقة مع هذا الشخص.",
    ),
    "shareOwedDetailError": MessageLookupByLibrary.simpleMessage(
      "تعذر تسجيل هذه الدفعة. حاول مرة أخرى.",
    ),
    "shareOwedDetailPaid": MessageLookupByLibrary.simpleMessage("وضع كمدفوع"),
    "shareOwedDetailSelectionLabel": MessageLookupByLibrary.simpleMessage(
      "اختر مصروفًا للمتابعة.",
    ),
    "shareOwedDetailSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر المصروف الذي قمت بتسديده.",
    ),
    "shareOwedDetailSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تسجيل الدفعة.",
    ),
    "shareOwedDetailTitle": MessageLookupByLibrary.simpleMessage("دفعة معلّقة"),
    "todayAddSheetFlow": MessageLookupByLibrary.simpleMessage(
      "إضافة مهمة (Flow)",
    ),
    "todayAddSheetShare": MessageLookupByLibrary.simpleMessage(
      "إضافة مصروف (Share)",
    ),
    "todayAddSheetTitle": MessageLookupByLibrary.simpleMessage("أضف إلى منزلك"),
    "todayEmptyBody": MessageLookupByLibrary.simpleMessage(
      "استمتع بوقتك — سيُعلمك كينلي عندما يكون هناك ما يحتاج انتباهك.",
    ),
    "todayEmptyCardBadge": MessageLookupByLibrary.simpleMessage(
      "استمتع بالهدوء",
    ),
    "todayEmptyCardTitle": MessageLookupByLibrary.simpleMessage(
      "لقد أنهيت كل مهام اليوم ✨",
    ),
    "todayFlowBadgeNew": MessageLookupByLibrary.simpleMessage("جديد اليوم"),
    "todayFlowSectionTitle": MessageLookupByLibrary.simpleMessage("Flow"),
    "todayFlowSeeAll": m8,
    "todayFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "هذا ما يجري في منزلك اليوم.",
    ),
    "todayFlowTabActive": MessageLookupByLibrary.simpleMessage("نشطة"),
    "todayFlowTabDrafts": MessageLookupByLibrary.simpleMessage("مسودات"),
    "todayGratitudeOpenCta": MessageLookupByLibrary.simpleMessage("??? ??????"),
    "todayGratitudeSectionTitle": MessageLookupByLibrary.simpleMessage(
      "???? ????????",
    ),
    "todayGratitudeUnreadBody": MessageLookupByLibrary.simpleMessage(
      "???? ??????? ?????? ????? ????????.",
    ),
    "todayShareActiveSubtitle": m9,
    "todayShareBadgeUpcoming": MessageLookupByLibrary.simpleMessage("قريبًا"),
    "todayShareDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "أكمل تقسيم المبلغ لنشر هذا المصروف.",
    ),
    "todayShareEmptyState": MessageLookupByLibrary.simpleMessage(
      "لا يوجد شيء هنا بعد. عند تسجيل مصاريف أو إنشاء مسودات، ستظهر في Share.",
    ),
    "todayShareError": MessageLookupByLibrary.simpleMessage(
      "تعذر تحديث قسم Share الآن.",
    ),
    "todayShareSampleGroceries": MessageLookupByLibrary.simpleMessage(
      "مشتريات مشتركة من الأمس",
    ),
    "todayShareSampleInternet": MessageLookupByLibrary.simpleMessage(
      "فاتورة الإنترنت لهذا الأسبوع",
    ),
    "todayShareSampleRent": MessageLookupByLibrary.simpleMessage(
      "تذكير قريب بمبلغ الإيجار",
    ),
    "todayShareSectionTitle": MessageLookupByLibrary.simpleMessage("Share"),
    "todayShareSeeAll": MessageLookupByLibrary.simpleMessage("عرض كل المصاريف"),
    "todayShareTabActive": MessageLookupByLibrary.simpleMessage("نشطة"),
    "todayShareTabDrafts": MessageLookupByLibrary.simpleMessage("مسودات"),
    "today_home_details": m10,
    "today_no_membership": MessageLookupByLibrary.simpleMessage(
      "لا يوجد منزل نشط حاليًا. أنشئ أو انضم إلى منزل لرؤية عرض اليوم.",
    ),
    "today_title": MessageLookupByLibrary.simpleMessage("اليوم"),
    "unknownInitial": MessageLookupByLibrary.simpleMessage("؟"),
    "welcome_create": MessageLookupByLibrary.simpleMessage("إنشاء منزل"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("الانضمام إلى منزل"),
    "welcome_title": MessageLookupByLibrary.simpleMessage("مرحبًا بك في كينلي"),
  };
}
