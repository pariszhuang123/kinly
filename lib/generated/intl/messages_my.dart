// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a my locale. All the
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
  String get localeName => 'my';

  static String m0(env) => "Kinly ကို စတင်နေသည် (${env})";

  static String m1(time) => "${time} အတွက် စီစဉ်ထားသည်";

  static String m2(current) => "Demo access: 7 ချက်ထဲမှ ${current} ချက်";

  static String m3(appName) =>
      "${appName} ဖြင့် ပြုလုပ်ထားသည် - အတူဆို ပိုပေါ့ပါးတယ်";

  static String m4(link) =>
      "ကျွန်ုပ်တို့၏ Kinly အိမ်မှ ကျေးဇူးတင်စကားအချို့ကို မျှဝေနေပါသည်။ အက်ပ်ကို ဒေါင်းလုဒ်လုပ်ပါ: ${link}";

  static String m5(weeks) =>
      "${Intl.plural(weeks, zero: 'ဒီအပတ်', one: '# ပတ်အကြာ', other: '# ပတ်အကြာများ')}";

  static String m6(partOfDay, name) =>
      "${Intl.select(partOfDay, {'morning': 'မင်္ဂလာနံနက်ခင်းပါ၊ ${name}', 'afternoon': 'မင်္ဂလာနေ့လည်ခင်းပါ၊ ${name}', 'evening': 'မင်္ဂလာညနေခင်းပါ၊ ${name}', 'other': 'မင်္ဂလာပါ၊ ${name}'})}";

  static String m7(answered, total) =>
      "အဖွဲ့ဝင် ${Intl.plural(total, other: '${total} ယောက်')}ထဲမှ ${answered} ယောက်၏ ဖြေဆိုချက်အပေါ် အခြေခံထားသည်";

  static String m8(current, total) => "${current}/${total}";

  static String m9(link) =>
      "ကျွန်ုပ်တို့၏ Kinly အိမ် pulse ကို မျှဝေနေပါသည်။ အက်ပ်ကို ဒေါင်းလုဒ်လုပ်ပါ: ${link}";

  static String m10(date) => "${date} တွင် အပ်ဒိတ်လုပ်ခဲ့သည်";

  static String m11(link) =>
      "ကျွန်ုပ်တို့၏ Kinly အိမ် vibe ကို မျှဝေနေပါသည်။ အက်ပ်ကို ဒေါင်းလုဒ်လုပ်ပါ: ${link}";

  static String m12(link) =>
      "Kinly ဖြင့် မျှဝေနေထိုင်မှုကို ပိုလွယ်ကူစေပါ: ${link}";

  static String m13(code, link) =>
      "ဒီဖိတ်ခေါ်ကုဒ်နဲ့ ကျွန်ုပ်တို့၏ Kinly အိမ်သို့ ဝင်ပါ: ${code}\n\nKinly ဒေါင်းလုဒ်လုပ်ရန်: ${link}";

  static String m14(code) => "သင့်အိမ်သို့ ဝင်ရောက်ပြီးပါပြီ။";

  static String m15(price) => "တစ်လလျှင် ${price}";

  static String m16(current, total) => "${current}/${total}";

  static String m17(period) => "${period} အတွက် သက်ရောက်သည်";

  static String m18(total, included, difference) =>
      "ခွဲဝေမှု မကိုက်ညီပါ။ စုစုပေါင်း: ${total}. ထည့်သွင်းထားသည်: ${included}. ကွာခြားချက်: ${difference}.";

  static String m19(paidAmount, totalAmount) =>
      "${paidAmount} / ${totalAmount} စုဆောင်းပြီး";

  static String m20(paid, total) =>
      "${paid} / ${Intl.plural(total, other: '${total} ခု')} ပေးချေပြီး";

  static String m21(count) =>
      "${Intl.plural(count, one: '${count} ခု ဝယ်ရန်ရှိသည်', other: '${count} ခု ဝယ်ရန်ရှိသည်')}";

  static String m22(name) => "မင်္ဂလာပါ ${name}";

  static String m23(count) =>
      "အားလုံးကြည့်မည် ${Intl.plural(count, one: '(#)', other: '(#)')}";

  static String m24(name) => "${name} ၏ တောင်းဆိုမှုကို မပြီးမြောက်နိုင်ခဲ့ပါ။";

  static String m25(name) => "${name} သည် သင့်အိမ်သို့ ဝင်ရောက်ပြီးပါပြီ။";

  static String m26(name) => "${name} သည် အခြားအိမ်တစ်ခုသို့ ဝင်သွားပါပြီ။";

  static String m27(names) =>
      "${names} သင့်အိမ်သို့ ပူးပေါင်းလိုပါသည်။ အဖွဲ့ဝင်များ ထပ်ထည့်ရန် အဆင့်မြှင့်ပါ။";

  static String m28(count) =>
      "${Intl.plural(count, one: '${count} ခု ပေးချေရန် ကျန်သည်', other: '${count} ခု ဖြေရှင်းရန် ကျန်သည်')}";

  static String m29(count) =>
      "${Intl.plural(count, one: '${count} ခု ပေးချေမှုအသစ်', other: '${count} ခု ပေးချေမှုအသစ်များ')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("Kinly"),
    "authMembershipLoadFailed": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်အဖွဲ့ဝင်အခြေအနေကို မပြန်လည်စစ်ဆေးနိုင်ခဲ့ပါ။",
    ),
    "bootstrap_initializing": m0,
    "close": MessageLookupByLibrary.simpleMessage("ပိတ်မည်"),
    "connectionNotificationsPermissionBlocked":
        MessageLookupByLibrary.simpleMessage(
          "မူလဦးစွာ သင့်ဖုန်းဆက်တင်များတွင် အသိပေးချက်များကို ဖွင့်ပါ။",
        ),
    "connectionNotificationsTimeLabel": MessageLookupByLibrary.simpleMessage(
      "သတိပေးချိန်",
    ),
    "connectionNotificationsTimeSubtitle": m1,
    "connectionNotificationsToggleSubtitleOff":
        MessageLookupByLibrary.simpleMessage(
          "သင့်အိမ်အတွက် သတိပေးချက်များကို ဖွင့်ပါ။",
        ),
    "connectionNotificationsToggleSubtitleOn":
        MessageLookupByLibrary.simpleMessage("နေ့စဉ် သတိပေးချက်တစ်ခု ရယူပါ။"),
    "connectionNotificationsToggleTitle": MessageLookupByLibrary.simpleMessage(
      "နေ့စဉ် သတိပေးချက်များ",
    ),
    "connectionSettingsGenericError": MessageLookupByLibrary.simpleMessage(
      "အသိပေးချက်ဆက်တင်များကို အပ်ဒိတ်မလုပ်နိုင်ခဲ့ပါ။",
    ),
    "connectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "နေ့စဉ်သတိပေးချက်များနှင့် အချိန်ကို ထိန်းချုပ်ပါ။",
    ),
    "connectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "အသိပေးချက်များ",
    ),
    "create_failed_generic": MessageLookupByLibrary.simpleMessage(
      "အိမ်ကို မဖန်တီးနိုင်ခဲ့ပါ။",
    ),
    "demoAccess": MessageLookupByLibrary.simpleMessage("Demo Access"),
    "demoAccessEmail": MessageLookupByLibrary.simpleMessage("အီးမေးလ်"),
    "demoAccessError": MessageLookupByLibrary.simpleMessage(
      "အကောင့်မဝင်နိုင်ခဲ့ပါ။ သင့်အချက်အလက်များကို စစ်ဆေးပါ။",
    ),
    "demoAccessPassword": MessageLookupByLibrary.simpleMessage("စကားဝှက်"),
    "demoAccessSubmit": MessageLookupByLibrary.simpleMessage("အကောင့်ဝင်မည်"),
    "demoAccessTapHint": m2,
    "exploreFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "ဘာလုပ်ရမည်၊ ဘယ်သူလုပ်နေသည်ကို ကြည့်ပါ။",
    ),
    "exploreIntroSubtitle": MessageLookupByLibrary.simpleMessage(
      "မျှဝေထားသောအရာများကို ရှင်းလင်းစွာထားပါ။",
    ),
    "exploreShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "သင်ဖန်တီးထားသော ဘေလ်များအားလုံးကို ကြည့်ပြီး စုဆောင်းမှုများကို ခြေရာခံပါ။",
    ),
    "exploreShoppingSectionTitle": MessageLookupByLibrary.simpleMessage(
      "စျေးဝယ်စာရင်း",
    ),
    "exploreShoppingSubtitle": MessageLookupByLibrary.simpleMessage(
      "မျှဝေစျေးဝယ်ပစ္စည်းများကို ကြည့်ရှုပြီး စီမံပါ။",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage(
      "ဘယ်သူ လုပ်မလဲ?",
    ),
    "flowChoreCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "တာဝန် ဖန်တီးပြီးပါပြီ။",
    ),
    "flowChoreCreateTitle": MessageLookupByLibrary.simpleMessage(
      "တာဝန် ထည့်မည်",
    ),
    "flowChoreDeleteButton": MessageLookupByLibrary.simpleMessage(
      "တာဝန် ဖျက်မည်",
    ),
    "flowChoreDeleteConfirm": MessageLookupByLibrary.simpleMessage("ဖျက်မည်"),
    "flowChoreDeleteDialogMessage": MessageLookupByLibrary.simpleMessage(
      "၎င်းသည် သင့်အိမ်ရှိ လူတိုင်းအတွက် ဤတာဝန်ကို ဖယ်ရှားမည်။",
    ),
    "flowChoreDeleteDialogTitle": MessageLookupByLibrary.simpleMessage(
      "ဤတာဝန်ကို ဖျက်မလား?",
    ),
    "flowChoreDetailCompleteButton": MessageLookupByLibrary.simpleMessage(
      "ပြီးစီးဟု မှတ်မည်",
    ),
    "flowChoreDetailCompletionError": MessageLookupByLibrary.simpleMessage(
      "ဤတာဝန်ကို မပြီးစီးနိုင်ခဲ့ပါ။",
    ),
    "flowChoreDetailCompletionSuccess": MessageLookupByLibrary.simpleMessage(
      "တာဝန် ပြီးစီးပြီးပါပြီ။",
    ),
    "flowChoreDetailMoreInfoTitle": MessageLookupByLibrary.simpleMessage(
      "အသုံးဝင်သော အသေးစိတ်အချက်များ",
    ),
    "flowChoreDetailTitle": MessageLookupByLibrary.simpleMessage(
      "တာဝန်အသေးစိတ်",
    ),
    "flowChoreDetailUnassigned": MessageLookupByLibrary.simpleMessage(
      "တာဝန်မပေးထားသေးပါ",
    ),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage("တာဝန် ပြင်မည်"),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "ဤလူသည် လက်ရှိတွင် ဒီအိမ်၏ အဖွဲ့ဝင် မဟုတ်ပါ။",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "ဤတာဝန်ကို ပြောင်းလဲရန် သင့်တွင် ခွင့်ပြုချက် မရှိပါ။",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "ဤတာဝန်ကို မသိမ်းနိုင်ခဲ့ပါ။",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "ဤဓာတ်ပုံသည် ဤအိမ်နှင့် မသက်ဆိုင်ပါ။",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "မှန်ကန်သော စတင်ရက်စွဲ ရွေးပါ။",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "ဤတာဝန်ကို လတ်တလော အပ်ဒိတ်မလုပ်နိုင်ပါ။",
    ),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "လက်ရှိ တာဝန်များအတွက် အခမဲ့ကန့်သတ်ချက် ပြည့်သွားပါပြီ။ ပိုမိုအသုံးပြုရန် အဆင့်မြှင့်ပါ။",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "တာဝန်ဓာတ်ပုံများအတွက် အခမဲ့ကန့်သတ်ချက် ပြည့်သွားပါပြီ။ ပိုမိုအသုံးပြုရန် အဆင့်မြှင့်ပါ။",
    ),
    "flowChoreExpectationPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "ကိုးကားဓာတ်ပုံ",
    ),
    "flowChoreHowToHint": MessageLookupByLibrary.simpleMessage(
      "သီးသန့်နည်းလမ်းရှိလျှင် လင့်ခ်ထည့်ပါ",
    ),
    "flowChoreHowToLabel": MessageLookupByLibrary.simpleMessage(
      "ဘယ်လိုလုပ်ရမလဲ (မဖြစ်မနေမဟုတ်)",
    ),
    "flowChoreHowToLaunchError": MessageLookupByLibrary.simpleMessage(
      "ထိုလင့်ခ်ကို မဖွင့်နိုင်ခဲ့ပါ။",
    ),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage(
      "ဤတာဝန်ကို မတင်နိုင်ခဲ့ပါ။",
    ),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage(
      "ဥပမာ အမှိုက်ပစ်ည၊ ရေခဲသေတ္တာ သန့်ရှင်းရေး၊ အပင်ရေလောင်း",
    ),
    "flowChoreNameLabel": MessageLookupByLibrary.simpleMessage("ဘာလုပ်ရမလဲ?"),
    "flowChoreNotesHint": MessageLookupByLibrary.simpleMessage(
      "အခြားသူများ ဒီတာဝန်ကို လုပ်ရာတွင် ကူညီမည့် အရာများ",
    ),
    "flowChoreNotesLabel": MessageLookupByLibrary.simpleMessage(
      "ဘာကြောင့် အရေးကြီးသလဲ",
    ),
    "flowChorePhotoLabel": MessageLookupByLibrary.simpleMessage(
      "ကောင်းမွန်သော အခြေအနေ ပုံစံ",
    ),
    "flowChorePhotoLoadError": MessageLookupByLibrary.simpleMessage(
      "ဓာတ်ပုံကို မတင်နိုင်ခဲ့ပါ။",
    ),
    "flowChorePhotoPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "ဓာတ်ပုံရိုက်ရန် ကင်မရာခွင့်ပြုချက် ပေးပါ။",
    ),
    "flowChorePhotoPermissionOpenSettings":
        MessageLookupByLibrary.simpleMessage("ဆက်တင်များ ဖွင့်မည်"),
    "flowChorePhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "လူတိုင်း တစ်မျိုးတည်း နားလည်ရန် ဓာတ်ပုံ ထည့်ပါ",
    ),
    "flowChorePhotoUploadError": MessageLookupByLibrary.simpleMessage(
      "ဓာတ်ပုံကို မတင်နိုင်ခဲ့ပါ။",
    ),
    "flowChoreRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "ဒါ ဘယ်နှကြိမ် ဖြစ်တတ်သလဲ?",
    ),
    "flowChoreRecurrenceNone": MessageLookupByLibrary.simpleMessage(
      "တစ်ကြိမ်တည်း",
    ),
    "flowChoreRetry": MessageLookupByLibrary.simpleMessage("ပြန်ကြိုးစားမည်"),
    "flowChoreStartLabel": MessageLookupByLibrary.simpleMessage(
      "ဘယ်နေ့ နောက်ဆုံးထားရမလဲ?",
    ),
    "flowChoreSubmitCreate": MessageLookupByLibrary.simpleMessage(
      "တာဝန် ဖန်တီးမည်",
    ),
    "flowChoreSubmitUpdate": MessageLookupByLibrary.simpleMessage(
      "ပြောင်းလဲမှုများ သိမ်းမည်",
    ),
    "flowChoreUpdateSuccess": MessageLookupByLibrary.simpleMessage(
      "တာဝန်ကို အပ်ဒိတ်လုပ်ပြီးပါပြီ။",
    ),
    "flowChoreValidationAssignee": MessageLookupByLibrary.simpleMessage(
      "တစ်ယောက်ရွေးပါ။",
    ),
    "flowChoreValidationDate": MessageLookupByLibrary.simpleMessage(
      "နောက်တစ်နှစ်အတွင်း ရက်စွဲတစ်ခု ရွေးပါ။",
    ),
    "flowChoreValidationHowToUrl": MessageLookupByLibrary.simpleMessage(
      "http သို့မဟုတ် https ဖြင့် စတင်သော မှန်ကန်သော လင့်ခ် ထည့်ပါ။",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage(
      "တာဝန်အမည် ထည့်ပါ။",
    ),
    "flowChoreViewTitle": MessageLookupByLibrary.simpleMessage(
      "တာဝန် ကြည့်မည်",
    ),
    "flowListDraftLabel": MessageLookupByLibrary.simpleMessage("မူကြမ်း"),
    "flowListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "တာဝန်များသည် လူတိုင်းကို တစ်မျိုးတည်း နားလည်စေသည်။",
    ),
    "flowListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "ဒီမှာ ဘာမှ မရှိသေးပါ",
    ),
    "flowListError": MessageLookupByLibrary.simpleMessage(
      "တာဝန်များကို မတင်နိုင်ခဲ့ပါ။ ဆွဲချပြီး ပြန်လည်ရယူပါ။",
    ),
    "flowListOverdueLabel": MessageLookupByLibrary.simpleMessage(
      "အာရုံစိုက်ရန်လိုသည်",
    ),
    "flowListTabCurrent": MessageLookupByLibrary.simpleMessage("လက်ရှိ"),
    "flowListTabFuture": MessageLookupByLibrary.simpleMessage("လာမည့်"),
    "force_update_body": MessageLookupByLibrary.simpleMessage(
      "ဤ Kinly ဗားရှင်းကို မထောက်ပံ့တော့ပါ။ ဆက်လက်အသုံးပြုရန် အပ်ဒိတ်လုပ်ပါ။",
    ),
    "force_update_button": MessageLookupByLibrary.simpleMessage(
      "Kinly ကို အပ်ဒိတ်လုပ်မည်",
    ),
    "force_update_title": MessageLookupByLibrary.simpleMessage(
      "အပ်ဒိတ် လိုအပ်ပါသည်",
    ),
    "friendDefaultName": MessageLookupByLibrary.simpleMessage("သူငယ်ချင်း"),
    "gratitudeWallEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "ဒီအပတ်မှ ကျေးဇူးတင်စကားတစ်ခု ထည့်ပါ။",
    ),
    "gratitudeWallEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "ကျေးဇူးတင်စကား မရှိသေးပါ",
    ),
    "gratitudeWallErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "လတ်တလော ကျေးဇူးတင်စကားများကို မတင်နိုင်ခဲ့ပါ။",
    ),
    "gratitudeWallFooter": m3,
    "gratitudeWallHouseTab": MessageLookupByLibrary.simpleMessage("အိမ်"),
    "gratitudeWallPersonalSummary": MessageLookupByLibrary.simpleMessage(
      "အမြန်ကျေးဇူးတင်စကားများအတွက် ကိုယ်ပိုင်နေရာတစ်ခု။",
    ),
    "gratitudeWallPersonalTab": MessageLookupByLibrary.simpleMessage(
      "ကျွန်ုပ်",
    ),
    "gratitudeWallPersonalTitle": MessageLookupByLibrary.simpleMessage(
      "ကျွန်ုပ်၏ ကျေးဇူးတင်စကားများ",
    ),
    "gratitudeWallRetry": MessageLookupByLibrary.simpleMessage(
      "ထပ်မံကြိုးစားမည်",
    ),
    "gratitudeWallShareCta": MessageLookupByLibrary.simpleMessage("မျှဝေမည်"),
    "gratitudeWallShareError": MessageLookupByLibrary.simpleMessage(
      "လတ်တလော မမျှဝေနိုင်ပါ။",
    ),
    "gratitudeWallShareMessage": m4,
    "gratitudeWallShareTitle": MessageLookupByLibrary.simpleMessage(
      "အိမ်ကျေးဇူးတင်စကားများ",
    ),
    "gratitudeWallStatsHomes": MessageLookupByLibrary.simpleMessage("အိမ်များ"),
    "gratitudeWallStatsMentions": MessageLookupByLibrary.simpleMessage(
      "ကျေးဇူးတင်စကားများ",
    ),
    "gratitudeWallStatsPeople": MessageLookupByLibrary.simpleMessage("လူများ"),
    "gratitudeWallWeeksAgo": m5,
    "greetingPartOfDay": m6,
    "harmonyCommentHint": MessageLookupByLibrary.simpleMessage(
      "လိုအပ်လျှင် အကြောင်းအရာထည့်ပါ",
    ),
    "harmonyCommentLabel": MessageLookupByLibrary.simpleMessage(
      "ရွေးချယ်နိုင်သော မှတ်စု",
    ),
    "harmonyErrorAlreadySubmitted": MessageLookupByLibrary.simpleMessage(
      "ဒီအပတ် သင် တင်ပြီးသားဖြစ်ပါသည်။",
    ),
    "harmonyErrorCommentRequiredForMention":
        MessageLookupByLibrary.simpleMessage(
          "ဤဖော်ပြချက်ကို မပို့မီ တိုတိုမှတ်စု ထည့်ပါ။",
        ),
    "harmonyErrorCommentRequiredForPublicWall":
        MessageLookupByLibrary.simpleMessage(
          "ဤကျေးဇူးတင်စကားကို မတင်မီ တိုတိုမှတ်စု ထည့်ပါ။",
        ),
    "harmonyErrorComplaintNeedsSentence": MessageLookupByLibrary.simpleMessage(
      "ရှင်းလင်းသော စာကြောင်းတစ်ကြောင်း ထည့်ပါ။",
    ),
    "harmonyErrorComplaintTooBrief": MessageLookupByLibrary.simpleMessage(
      "ရှင်းလင်းစေရန် စာကြောင်းတိုတစ်ကြောင်း ရေးပါ။",
    ),
    "harmonyErrorComplaintTooShort": MessageLookupByLibrary.simpleMessage(
      "နည်းနည်း ပိုပြီး အသေးစိတ် ထည့်ပါ။",
    ),
    "harmonyErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "အပတ်စဉ် အကြံပြုချက်ကို လတ်တလော မရနိုင်ပါ။",
    ),
    "harmonyErrorSingleMentionRequired": MessageLookupByLibrary.simpleMessage(
      "ဤမှတ်စုအတွက် လူတစ်ယောက် ရွေးပါ။",
    ),
    "harmonyErrorUnknown": MessageLookupByLibrary.simpleMessage(
      "တစ်ခုခု မှားယွင်းသွားပါသည်။",
    ),
    "harmonyFeedbackSingleHousemateHint": MessageLookupByLibrary.simpleMessage(
      "@ ရိုက်ပြီး အိမ်ဖော် 1 ယောက်ကို ဖော်ပြပါ။",
    ),
    "harmonyMoodCloudy": MessageLookupByLibrary.simpleMessage("မိုးအုံ့"),
    "harmonyMoodPartiallySunny": MessageLookupByLibrary.simpleMessage(
      "နေရောင်အနည်းငယ်",
    ),
    "harmonyMoodRainy": MessageLookupByLibrary.simpleMessage("မိုးရွာ"),
    "harmonyMoodSunny": MessageLookupByLibrary.simpleMessage("နေရောင်ကောင်း"),
    "harmonyMoodThunderstorm": MessageLookupByLibrary.simpleMessage(
      "မိုးကြိုးမုန်တိုင်း",
    ),
    "harmonyQuestion": MessageLookupByLibrary.simpleMessage(
      "ဒီအပတ် ဘာက ကောင်းခဲ့သလဲ သို့မဟုတ် ဘာကို ညှိရမလဲ?",
    ),
    "harmonyShareLabel": MessageLookupByLibrary.simpleMessage(
      "အိမ်ရှိ လူတိုင်း မြင်နိုင်သည်",
    ),
    "harmonySubmitCta": MessageLookupByLibrary.simpleMessage("သိမ်းမည်"),
    "harmonySubmitSuccess": MessageLookupByLibrary.simpleMessage(
      "သိမ်းပြီးပါပြီ",
    ),
    "homeVibeCoverage": m7,
    "homeVibeTitle": MessageLookupByLibrary.simpleMessage("အိမ်၏ vibe"),
    "houseNormCopyUrlCta": MessageLookupByLibrary.simpleMessage("URL ကူးမည်"),
    "houseNormDoneCta": MessageLookupByLibrary.simpleMessage("ပြီးပြီ"),
    "houseNormEditTitle": MessageLookupByLibrary.simpleMessage(
      "အိမ်စံနှုန်းများ ပြင်မည်",
    ),
    "houseNormGenerationFailed": MessageLookupByLibrary.simpleMessage(
      "လတ်တလော အိမ်စံနှုန်းများကို မဖန်တီးနိုင်ခဲ့ပါ။",
    ),
    "houseNormOnboardingBack": MessageLookupByLibrary.simpleMessage(
      "နောက်သို့",
    ),
    "houseNormOnboardingProgress": m8,
    "houseNormOnboardingSubmit": MessageLookupByLibrary.simpleMessage(
      "ဖန်တီးမည်",
    ),
    "houseNormOnboardingTitle": MessageLookupByLibrary.simpleMessage(
      "အိမ် vibe",
    ),
    "houseNormPromptCta": MessageLookupByLibrary.simpleMessage("ဖန်တီးမည်"),
    "houseNormPromptSubtitle": MessageLookupByLibrary.simpleMessage(
      "သင့်အဖြေများကို မျှဝေထားသော လမ်းညွှန်တစ်ခုအဖြစ် ပြောင်းလဲပါ။",
    ),
    "houseNormPromptTitle": MessageLookupByLibrary.simpleMessage(
      "အိမ်စံနှုန်းများ ဖန်တီးမည်",
    ),
    "houseNormPublishCta": MessageLookupByLibrary.simpleMessage(
      "ဝဘ်သို့ ထုတ်ပြန်မည်",
    ),
    "houseNormReportEmptyBody": MessageLookupByLibrary.simpleMessage(
      "ကြည့်ရန် အိမ်စံနှုန်းများကို ဖန်တီးပါ။",
    ),
    "houseNormReportEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "အိမ်စံနှုန်းများ မအဆင်သင့်သေးပါ",
    ),
    "houseNormReportErrorBody": MessageLookupByLibrary.simpleMessage(
      "ထပ်မံကြိုးစားပါ။",
    ),
    "houseNormReportErrorTitle": MessageLookupByLibrary.simpleMessage(
      "အိမ်စံနှုန်းများကို မတင်နိုင်ခဲ့ပါ",
    ),
    "houseNormReportTitle": MessageLookupByLibrary.simpleMessage(
      "အိမ်စံနှုန်းများ",
    ),
    "houseNormRepublishCta": MessageLookupByLibrary.simpleMessage(
      "ပြန်လည်ထုတ်ပြန်မည်",
    ),
    "houseNormScenarioGuestsOption1": MessageLookupByLibrary.simpleMessage(
      "အရင် မေးပါ",
    ),
    "houseNormScenarioGuestsOption2": MessageLookupByLibrary.simpleMessage(
      "ကြိုတင် အသိပေးပါ",
    ),
    "houseNormScenarioGuestsOption3": MessageLookupByLibrary.simpleMessage(
      "ပုံမှန်ပါပဲ",
    ),
    "houseNormScenarioGuestsQuestion": MessageLookupByLibrary.simpleMessage(
      "ဧည့်သည် ခေါ်လာခြင်း?",
    ),
    "houseNormScenarioHomeIdentityOption1":
        MessageLookupByLibrary.simpleMessage("အေးချမ်းသောအိမ်"),
    "houseNormScenarioHomeIdentityOption2":
        MessageLookupByLibrary.simpleMessage("မျှတသောအိမ်"),
    "houseNormScenarioHomeIdentityOption3":
        MessageLookupByLibrary.simpleMessage("လူမှုရေးဆန်သောအိမ်"),
    "houseNormScenarioHomeIdentityQuestion":
        MessageLookupByLibrary.simpleMessage("အကောင်းဆုံး ဖော်ပြချက်?"),
    "houseNormScenarioPropertyContextOption1":
        MessageLookupByLibrary.simpleMessage("ပိုင်ဆိုင်ထားသောအိမ်"),
    "houseNormScenarioPropertyContextOption2":
        MessageLookupByLibrary.simpleMessage("တစ်အိမ်လုံး ငှားထားသည်"),
    "houseNormScenarioPropertyContextOption3":
        MessageLookupByLibrary.simpleMessage("အခန်းငှားနေထိုင်မှု"),
    "houseNormScenarioPropertyContextQuestion":
        MessageLookupByLibrary.simpleMessage("ဤအိမ်သည်:"),
    "houseNormScenarioRelationshipModelOption1":
        MessageLookupByLibrary.simpleMessage("အိမ်ဖော်များ"),
    "houseNormScenarioRelationshipModelOption2":
        MessageLookupByLibrary.simpleMessage("မိသားစု"),
    "houseNormScenarioRelationshipModelOption3":
        MessageLookupByLibrary.simpleMessage("ရောနှော"),
    "houseNormScenarioRelationshipModelQuestion":
        MessageLookupByLibrary.simpleMessage("ဘယ်သူတွေ နေကြသလဲ?"),
    "houseNormScenarioRepairOption1": MessageLookupByLibrary.simpleMessage(
      "စောစော ပြောပါ",
    ),
    "houseNormScenarioRepairOption2": MessageLookupByLibrary.simpleMessage(
      "သင့်တော်သော အချိန်ကို ရွေးပါ",
    ),
    "houseNormScenarioRepairOption3": MessageLookupByLibrary.simpleMessage(
      "သေးငယ်တာတွေကို ကျော်လိုက်မည်",
    ),
    "houseNormScenarioRepairQuestion": MessageLookupByLibrary.simpleMessage(
      "တင်းမာမှု?",
    ),
    "houseNormScenarioResponsibilityOption1":
        MessageLookupByLibrary.simpleMessage("ရှင်းလင်းသော သဘောတူညီချက်များ"),
    "houseNormScenarioResponsibilityOption2":
        MessageLookupByLibrary.simpleMessage("ဘယ်သူ သတိထားမိလဲ သူလုပ်"),
    "houseNormScenarioResponsibilityOption3":
        MessageLookupByLibrary.simpleMessage("လူတိုင်း ကိုယ့်တာဝန်ကိုယ် လုပ်"),
    "houseNormScenarioResponsibilityQuestion":
        MessageLookupByLibrary.simpleMessage("သေးငယ်တဲ့ အိမ်မှုကိစ္စများ?"),
    "houseNormScenarioRhythmOption1": MessageLookupByLibrary.simpleMessage(
      "အေးဆေးနားမည်",
    ),
    "houseNormScenarioRhythmOption2": MessageLookupByLibrary.simpleMessage(
      "အခြေအနေပေါ်မူတည်",
    ),
    "houseNormScenarioRhythmOption3": MessageLookupByLibrary.simpleMessage(
      "လူတိုင်း ကိုယ့်အလုပ်ကိုယ် လုပ်ကြမည်",
    ),
    "houseNormScenarioRhythmQuestion": MessageLookupByLibrary.simpleMessage(
      "ညနက်ပိုင်း?",
    ),
    "houseNormScenarioSharedSpacesOption1":
        MessageLookupByLibrary.simpleMessage("သန့်ရှင်း"),
    "houseNormScenarioSharedSpacesOption2":
        MessageLookupByLibrary.simpleMessage("အသုံးပြုထားသလို"),
    "houseNormScenarioSharedSpacesOption3":
        MessageLookupByLibrary.simpleMessage("ရှုပ်နေလည်း ရတယ်"),
    "houseNormScenarioSharedSpacesQuestion":
        MessageLookupByLibrary.simpleMessage("ညဘက် မီးဖိုချောင်?"),
    "houseNormSectionEditLabel": MessageLookupByLibrary.simpleMessage(
      "ဤအပိုင်းကို ပြင်မည်",
    ),
    "houseNormSectionEmptyError": MessageLookupByLibrary.simpleMessage(
      "မသိမ်းမီ စာသားထည့်ပါ။",
    ),
    "houseNormSectionFallbackTitle": MessageLookupByLibrary.simpleMessage(
      "အပိုင်း",
    ),
    "houseNormSectionGuestsSocialTitle": MessageLookupByLibrary.simpleMessage(
      "ဧည့်သည်များနှင့် လူမှုရေးစီးဆင်းမှု",
    ),
    "houseNormSectionHomeIdentityTitle": MessageLookupByLibrary.simpleMessage(
      "အိမ်၏ အထင်အမြင်",
    ),
    "houseNormSectionRepairStyleTitle": MessageLookupByLibrary.simpleMessage(
      "ပြန်လည်ညှိနှိုင်းပုံစံ",
    ),
    "houseNormSectionResponsibilityFlowTitle":
        MessageLookupByLibrary.simpleMessage("တာဝန်စီးဆင်းမှု"),
    "houseNormSectionRhythmQuietTitle": MessageLookupByLibrary.simpleMessage(
      "နေ့စဉ်လှုပ်ရှားမှုနှင့် တိတ်ဆိတ်မှု",
    ),
    "houseNormSectionSaveCta": MessageLookupByLibrary.simpleMessage("သိမ်းမည်"),
    "houseNormSectionSaveFailed": MessageLookupByLibrary.simpleMessage(
      "ဤအပ်ဒိတ်ကို မသိမ်းနိုင်ခဲ့ပါ။",
    ),
    "houseNormSectionSaveSuccess": MessageLookupByLibrary.simpleMessage(
      "အပိုင်းကို အပ်ဒိတ်လုပ်ပြီးပါပြီ။",
    ),
    "houseNormSectionSharedSpacesTitle": MessageLookupByLibrary.simpleMessage(
      "မျှဝေနေရာများ",
    ),
    "houseNormShareSubject": MessageLookupByLibrary.simpleMessage(
      "ကျွန်ုပ်တို့၏ အိမ်စံနှုန်းများ",
    ),
    "houseNormShareUrlCta": MessageLookupByLibrary.simpleMessage(
      "URL မျှဝေမည်",
    ),
    "houseNormSummaryFramingLabel": MessageLookupByLibrary.simpleMessage(
      "အကျဉ်းချုပ်",
    ),
    "houseNormSummarySubtitle": MessageLookupByLibrary.simpleMessage(
      "စည်းကမ်းစာအုပ် မဟုတ်သော လမ်းညွှန်တစ်ခု။",
    ),
    "houseNormSummaryTitle": MessageLookupByLibrary.simpleMessage(
      "အိမ်စံနှုန်းများ",
    ),
    "houseNormUrlCopied": MessageLookupByLibrary.simpleMessage(
      "အိမ်စံနှုန်း URL ကို ကူးယူပြီးပါပြီ။",
    ),
    "houseNormViewTitle": MessageLookupByLibrary.simpleMessage(
      "အိမ်စံနှုန်းများ ကြည့်မည်",
    ),
    "housePulseCardHeader": MessageLookupByLibrary.simpleMessage(
      "အပတ်စဉ် အိမ် pulse",
    ),
    "housePulseShareCta": MessageLookupByLibrary.simpleMessage(
      "pulse ကို မျှဝေမည်",
    ),
    "housePulseShareMessage": m9,
    "housePulseShareTitle": MessageLookupByLibrary.simpleMessage(
      "ကျွန်ုပ်တို့၏ Kinly အိမ် pulse ကို မျှဝေနေပါသည်",
    ),
    "housePulseUpdatedOn": m10,
    "houseVibeShareCta": MessageLookupByLibrary.simpleMessage(
      "vibe ကို မျှဝေမည်",
    ),
    "houseVibeShareError": MessageLookupByLibrary.simpleMessage(
      "လတ်တလော မမျှဝေနိုင်ပါ။",
    ),
    "houseVibeShareMessage": m11,
    "houseVibeShareTitle": MessageLookupByLibrary.simpleMessage("အိမ်၏ vibe"),
    "hubCardGratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်မှ အမြန်ကျေးဇူးတင်စကားများ။",
    ),
    "hubCardGratitudeWallTitle": MessageLookupByLibrary.simpleMessage(
      "ကျေးဇူးတင်စကားများ",
    ),
    "hubCodeCopied": MessageLookupByLibrary.simpleMessage(
      "ဖိတ်ခေါ်ကုဒ် ကူးယူပြီးပါပြီ",
    ),
    "hubError": MessageLookupByLibrary.simpleMessage(
      "အိမ် Hub ကို မတင်နိုင်ခဲ့ပါ။",
    ),
    "hubHouseNormsSubtitle": MessageLookupByLibrary.simpleMessage(
      "ဤအိမ် ဘယ်လို အလုပ်လုပ်သလဲဆိုသော လမ်းညွှန်။",
    ),
    "hubHouseNormsTitle": MessageLookupByLibrary.simpleMessage(
      "အိမ်စံနှုန်းများ",
    ),
    "hubInviteCta": MessageLookupByLibrary.simpleMessage("ဖိတ်မည်"),
    "hubInviteUnavailable": MessageLookupByLibrary.simpleMessage(
      "ဖိတ်ခေါ်မှုကို မတင်နိုင်ခဲ့ပါ။",
    ),
    "hubMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "လက်ရှိ အဖွဲ့ဝင် မရှိသေးပါ။",
    ),
    "hubPreferencesSubtitle": MessageLookupByLibrary.simpleMessage(
      "လူတိုင်း မျှဝေနေထိုင်မှုကို ဘယ်လို အလုပ်လုပ်စေချင်သလဲ။",
    ),
    "hubPreferencesTitle": MessageLookupByLibrary.simpleMessage("အကြိုက်များ"),
    "hubQrSubtitle": MessageLookupByLibrary.simpleMessage(
      "Kinly ဒေါင်းလုဒ်လုပ်ရန် စကင်ဖတ်ပါ",
    ),
    "hubQrTitle": MessageLookupByLibrary.simpleMessage("အက်ပ် မျှဝေမည်"),
    "hubRetry": MessageLookupByLibrary.simpleMessage("ပြန်ကြိုးစားမည်"),
    "hubRotateError": MessageLookupByLibrary.simpleMessage(
      "ဖိတ်ခေါ်မှုကို အသစ်မပြောင်းနိုင်ခဲ့ပါ။",
    ),
    "hubRotateInvite": MessageLookupByLibrary.simpleMessage(
      "ဖိတ်ခေါ်မှု အသစ်ပြောင်းမည်",
    ),
    "hubRotateSuccess": MessageLookupByLibrary.simpleMessage(
      "ဖိတ်ခေါ်မှု အသစ်ပြောင်းပြီးပါပြီ",
    ),
    "hubShareAppBody": m12,
    "hubShareAppCta": MessageLookupByLibrary.simpleMessage("Kinly မျှဝေမည်"),
    "hubShareAppTitle": MessageLookupByLibrary.simpleMessage("Kinly ရယူမည်"),
    "hubShareInviteBody": m13,
    "hubShareInviteTitle": MessageLookupByLibrary.simpleMessage(
      "ကျွန်ုပ်၏ Kinly အိမ်သို့ ဖိတ်ခေါ်မည်",
    ),
    "join_blocked_body": MessageLookupByLibrary.simpleMessage(
      "အိမ်ပိုင်ရှင်ကို ကျွန်ုပ်တို့ အသိပေးထားပါသည်။",
    ),
    "join_blocked_cta": MessageLookupByLibrary.simpleMessage("ပြီးပြီ"),
    "join_blocked_title": MessageLookupByLibrary.simpleMessage(
      "ဤအိမ်သည် လတ်တလော အဖွဲ့ဝင်အသစ်များကို လက်မခံသေးပါ",
    ),
    "join_error_already_in_other_home": MessageLookupByLibrary.simpleMessage(
      "လက်ရှိအိမ်မှ အရင်ထွက်ပါ။",
    ),
    "join_error_forbidden": MessageLookupByLibrary.simpleMessage(
      "ဤအိမ်သို့ ဝင်ရန် သင့်တွင် ခွင့်ပြုချက် မရှိပါ။",
    ),
    "join_error_inactive_invite": MessageLookupByLibrary.simpleMessage(
      "ဤဖိတ်ခေါ်မှု သက်တမ်းကုန်သွားပါပြီ။ ပိုင်ရှင်ထံမှ အသစ်တစ်ခု တောင်းပါ။",
    ),
    "join_error_invalid_code": MessageLookupByLibrary.simpleMessage(
      "ဖိတ်ခေါ်ကုဒ် မမှန်သလို ဖြစ်နေပါသည်။",
    ),
    "join_error_paywall_limit": MessageLookupByLibrary.simpleMessage(
      "ဤအိမ်သည် အဖွဲ့ဝင်အရေအတွက် ကန့်သတ်ချက်ပြည့်သွားပါပြီ။ ပိုင်ရှင်အား အဆင့်မြှင့်ရန် သို့မဟုတ် တစ်ယောက်ယောက်ကို ဖယ်ရှားရန် ပြောပါ။",
    ),
    "join_error_unauthorized": MessageLookupByLibrary.simpleMessage(
      "ဤအိမ်သို့ ဝင်ရန် အကောင့်ဝင်ပါ။",
    ),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage(
      "ဤအိမ်သို့ မဝင်နိုင်ခဲ့ပါ။",
    ),
    "join_hint": MessageLookupByLibrary.simpleMessage(
      "ဖိတ်ခေါ်ကုဒ် ထည့်ပါ (ဥပမာ ABC123)",
    ),
    "join_submit": MessageLookupByLibrary.simpleMessage("ဝင်မည်"),
    "join_success": m14,
    "join_title": MessageLookupByLibrary.simpleMessage("အိမ်သို့ ဝင်မည်"),
    "login_consent_connector": MessageLookupByLibrary.simpleMessage(" နှင့် "),
    "login_consent_prefix": MessageLookupByLibrary.simpleMessage(
      "ကျွန်ုပ်သည် ",
    ),
    "login_privacy": MessageLookupByLibrary.simpleMessage(
      "ကိုယ်ရေးအချက်အလက် မူဝါဒ",
    ),
    "login_tagline": MessageLookupByLibrary.simpleMessage(
      "အတူတကွဆို ပိုပေါ့ပါးတယ်",
    ),
    "login_terms": MessageLookupByLibrary.simpleMessage(
      "ဝန်ဆောင်မှုစည်းမျဉ်းများ",
    ),
    "login_with_apple": MessageLookupByLibrary.simpleMessage(
      "Apple ဖြင့် ဆက်လုပ်မည်",
    ),
    "login_with_google": MessageLookupByLibrary.simpleMessage(
      "Google ဖြင့် ဆက်လုပ်မည်",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("အကောင့်ထွက်မည်"),
    "membership_status_active": MessageLookupByLibrary.simpleMessage(
      "သင်သည် အိမ်တစ်ခုနှင့် ချိတ်ဆက်ထားပါသည်။",
    ),
    "membership_status_checking": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်နှင့် ချိတ်ဆက်နေသည်...",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "အိမ်တစ်ခု ဖန်တီးပါ သို့မဟုတ် ဝင်ပါ။",
    ),
    "mentionFieldHint": MessageLookupByLibrary.simpleMessage(
      "@ ရိုက်ပြီး တစ်ယောက်ယောက်ကို ဖော်ပြပါ",
    ),
    "navExplore": MessageLookupByLibrary.simpleMessage("စီမံမည်"),
    "navHub": MessageLookupByLibrary.simpleMessage("အိမ် Hub"),
    "navToday": MessageLookupByLibrary.simpleMessage("ယနေ့"),
    "npsCannotSkip": MessageLookupByLibrary.simpleMessage(
      "ဆက်လုပ်ရန် အမှတ်တစ်ခု ရွေးပါ။",
    ),
    "npsDescription": MessageLookupByLibrary.simpleMessage(
      "0 ဆိုသည်မှာ လုံးဝမဟုတ်ပါ။ 10 ဆိုသည်မှာ တကယ် ကွာခြားမှုရှိစေခဲ့သည်။",
    ),
    "npsEmailSubject": MessageLookupByLibrary.simpleMessage(
      "Kinly က သင့်အိမ်ကို ဘယ်လို ပိုကောင်းအောင် ကူညီနိုင်မလဲ?",
    ),
    "npsLaunchError": MessageLookupByLibrary.simpleMessage(
      "နောက်အဆင့်ကို မဖွင့်နိုင်ခဲ့ပါ။",
    ),
    "npsScaleHighLabel": MessageLookupByLibrary.simpleMessage(
      "10 တကယ် ကွာခြားမှုရှိစေခဲ့သည်",
    ),
    "npsScaleLowLabel": MessageLookupByLibrary.simpleMessage("0 လုံးဝမဟုတ်ပါ"),
    "npsSubmitErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "လတ်တလော အကြံပြုချက် မရနိုင်ပါ။",
    ),
    "npsSubmitErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "သင့်အကြံပြုချက်ကို မပို့နိုင်ခဲ့ပါ။",
    ),
    "npsSubmitErrorInvalidScore": MessageLookupByLibrary.simpleMessage(
      "0 နှင့် 10 ကြား နံပါတ်တစ်ခု ရွေးပါ။",
    ),
    "npsSubmitErrorNotRequired": MessageLookupByLibrary.simpleMessage(
      "လတ်တလော သင် အကြံပြုချက် မပေးလည်း ရပါသည်။",
    ),
    "npsTitle": MessageLookupByLibrary.simpleMessage(
      "Kinly က သင့်အိမ်ကို ပိုချောမွေ့စွာ လည်ပတ်စေဖို့ ကူညီခဲ့ပါသလား?",
    ),
    "offline_body": MessageLookupByLibrary.simpleMessage(
      "အင်တာနက်ချိတ်ဆက်မှု မရှိပါ။ ထပ်မံကြိုးစားပါ။",
    ),
    "offline_retry": MessageLookupByLibrary.simpleMessage("ထပ်မံကြိုးစားမည်"),
    "offline_title": MessageLookupByLibrary.simpleMessage(
      "သင် အော့ဖ်လိုင်း ဖြစ်နေပါသည်",
    ),
    "paywallBulletFlows": MessageLookupByLibrary.simpleMessage(
      "တာဝန်များ အကန့်အသတ်မရှိ",
    ),
    "paywallBulletMembers": MessageLookupByLibrary.simpleMessage(
      "အဖွဲ့ဝင် အကန့်အသတ်မရှိ",
    ),
    "paywallBulletPhotos": MessageLookupByLibrary.simpleMessage(
      "တာဝန်ဓာတ်ပုံများ အကန့်အသတ်မရှိ",
    ),
    "paywallBulletShares": MessageLookupByLibrary.simpleMessage(
      "ဘေလ်များ အကန့်အသတ်မရှိ",
    ),
    "paywallBulletShoppingPhotos": MessageLookupByLibrary.simpleMessage(
      "စျေးဝယ်ဓာတ်ပုံများ အကန့်အသတ်မရှိ",
    ),
    "paywallErrorTitle": MessageLookupByLibrary.simpleMessage(
      "Paywall ကို မတင်နိုင်ခဲ့ပါ။",
    ),
    "paywallFeatureUnlimitedSharedExpensePhotos":
        MessageLookupByLibrary.simpleMessage("ဘေလ်ဓာတ်ပုံများ အကန့်အသတ်မရှိ"),
    "paywallPriceCaption": MessageLookupByLibrary.simpleMessage(
      "အိမ်တစ်အိမ် အစီအစဉ်တစ်ခု။ လျှို့ဝှက်အဆင့်များ မရှိပါ။",
    ),
    "paywallPricePerMonth": m15,
    "paywallPriceUnavailable": MessageLookupByLibrary.simpleMessage(
      "လတ်တလော ဈေးနှုန်း မရရှိနိုင်ပါ။",
    ),
    "paywallPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "Premium သို့ အဆင့်မြှင့်မည်",
    ),
    "paywallPurchaseFailed": MessageLookupByLibrary.simpleMessage(
      "ဝယ်ယူမှု မပြီးဆုံးခဲ့ပါ။",
    ),
    "paywallPurchaseSuccess": MessageLookupByLibrary.simpleMessage(
      "ယခု သင်သည် Kinly Premium တွင် ရှိပါသည်။",
    ),
    "paywallRestoreCta": MessageLookupByLibrary.simpleMessage(
      "ဝယ်ယူမှုများ ပြန်လည်ရယူမည်",
    ),
    "paywallRetryLabel": MessageLookupByLibrary.simpleMessage(
      "ပြန်ကြိုးစားမည်",
    ),
    "paywallSecondaryCta": MessageLookupByLibrary.simpleMessage(
      "အခမဲ့အစီအစဉ်တွင် ဆက်နေရမည်",
    ),
    "paywallSubtitle": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်လခ၏ 0.5% ထက်နည်းပါသည်။",
    ),
    "paywallTitle": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်ကို ချောမွေ့စွာ လည်ပတ်နေစေပါ",
    ),
    "personalMentionsTitle": MessageLookupByLibrary.simpleMessage(
      "ကိုယ်ပိုင် ဖော်ပြချက်များ",
    ),
    "personalProfileLoadError": MessageLookupByLibrary.simpleMessage(
      "သင့်ကိုယ်ပိုင် ပရိုဖိုင်ကို မတင်နိုင်ခဲ့ပါ။",
    ),
    "personalProfileMentions": MessageLookupByLibrary.simpleMessage(
      "ကိုယ်ပိုင် ဖော်ပြချက်များ",
    ),
    "personalProfilePreferences": MessageLookupByLibrary.simpleMessage(
      "ကိုယ်ပိုင်အကြိုက်များ",
    ),
    "personalProfileTitle": MessageLookupByLibrary.simpleMessage(
      "သင့်ပရိုဖိုင်",
    ),
    "planFreeLabel": MessageLookupByLibrary.simpleMessage(
      "Premium သို့ အဆင့်မြှင့်မည်",
    ),
    "planPremiumActiveBody": MessageLookupByLibrary.simpleMessage(
      "အင်္ဂါရပ်အားလုံးကို အကန့်အသတ်မရှိ အသုံးပြုနိုင်ပါသည်။",
    ),
    "planPremiumActiveTitle": MessageLookupByLibrary.simpleMessage(
      "သင်သည် Premium တွင် ရှိပါသည်",
    ),
    "planPremiumLabel": MessageLookupByLibrary.simpleMessage("Premium"),
    "preferenceOnboardingBack": MessageLookupByLibrary.simpleMessage(
      "နောက်သို့",
    ),
    "preferenceOnboardingProgress": m16,
    "preferenceOnboardingSubmit": MessageLookupByLibrary.simpleMessage(
      "သိမ်းမည်",
    ),
    "preferenceOnboardingTitle": MessageLookupByLibrary.simpleMessage(
      "သင့် vibe",
    ),
    "preferencePromptCta": MessageLookupByLibrary.simpleMessage("စတင်မည်"),
    "preferencePromptSubtitle": MessageLookupByLibrary.simpleMessage(
      "သင့်အတွက် ဘာက အဆင်ပြေလဲဆိုတာ အိမ်က နားလည်စေရန် ကူညီပါ။",
    ),
    "preferencePromptTitle": MessageLookupByLibrary.simpleMessage(
      "သင့် vibe ကို သတ်မှတ်ပါ",
    ),
    "preferenceReportDoneCta": MessageLookupByLibrary.simpleMessage("ပြီးပြီ"),
    "preferenceReportEditCta": MessageLookupByLibrary.simpleMessage("ပြင်မည်"),
    "preferenceReportEditError": MessageLookupByLibrary.simpleMessage(
      "ဤအပ်ဒိတ်ကို မသိမ်းနိုင်ခဲ့ပါ။",
    ),
    "preferenceReportEditSectionDone": MessageLookupByLibrary.simpleMessage(
      "ပြီးပြီ",
    ),
    "preferenceReportEditSectionHint": MessageLookupByLibrary.simpleMessage(
      "သင့်အတွက် မှန်ကန်သလို ခံစားရတာကို ရေးပါ",
    ),
    "preferenceReportEditSectionPrompt": MessageLookupByLibrary.simpleMessage(
      "ဤအပိုင်းကို ပြင်ပါ။",
    ),
    "preferenceReportEditTitle": MessageLookupByLibrary.simpleMessage(
      "အကြိုက်များကို ပြင်မည်",
    ),
    "preferenceReportEmptyBody": MessageLookupByLibrary.simpleMessage(
      "သင့်အစီရင်ခံစာ ဖန်တီးရန် အကြိုက်များကို ဖြည့်စွက်ပါ။",
    ),
    "preferenceReportEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "အကြိုက်များ မပြည့်စုံသေးပါ",
    ),
    "preferenceReportErrorBody": MessageLookupByLibrary.simpleMessage(
      "ထပ်မံကြိုးစားပါ။",
    ),
    "preferenceReportErrorTitle": MessageLookupByLibrary.simpleMessage(
      "အစီရင်ခံစာကို မတင်နိုင်ခဲ့ပါ",
    ),
    "preferenceReportGenerationFailed": MessageLookupByLibrary.simpleMessage(
      "သင့်အကြိုက် ထင်ဟပ်ချက်ကို မပြီးမြောက်နိုင်ခဲ့ပါ။ နောက်သို့ ပြန်ပြီး ထပ်ကြိုးစားပါ။",
    ),
    "preferenceReportGenerationMissing": MessageLookupByLibrary.simpleMessage(
      "သင့်အကြိုက် ထင်ဟပ်ချက်ကို မပြီးမြောက်နိုင်ခဲ့ပါ။ မကြာမီ ထပ်ကြိုးစားပါ။",
    ),
    "preferenceReportReadOnlyNote": MessageLookupByLibrary.simpleMessage(
      "ဤအရာသည် သူတို့အတွက် ဘာက သက်သောင့်သက်သာရှိသလဲကို ပြသသည်။",
    ),
    "preferenceReportTitle": MessageLookupByLibrary.simpleMessage(
      "သင့်အကြိုက်များ",
    ),
    "preferenceReportViewTitle": MessageLookupByLibrary.simpleMessage(
      "အကြိုက်များကို ကြည့်မည်",
    ),
    "preferenceScenarioCleanlinessSharedSpaceOption1":
        MessageLookupByLibrary.simpleMessage("သပ်ရပ်စွာထား"),
    "preferenceScenarioCleanlinessSharedSpaceOption2":
        MessageLookupByLibrary.simpleMessage("နည်းနည်း ရှုပ်လည်း ရတယ်"),
    "preferenceScenarioCleanlinessSharedSpaceOption3":
        MessageLookupByLibrary.simpleMessage("ရှုပ်နေလည်း ရတယ်"),
    "preferenceScenarioCleanlinessSharedSpaceQuestion":
        MessageLookupByLibrary.simpleMessage("မျှဝေနေရာ?"),
    "preferenceScenarioCommunicationChannelOption1":
        MessageLookupByLibrary.simpleMessage("စာတို"),
    "preferenceScenarioCommunicationChannelOption2":
        MessageLookupByLibrary.simpleMessage("ကိုယ်တိုင်တွေ့"),
    "preferenceScenarioCommunicationChannelOption3":
        MessageLookupByLibrary.simpleMessage("ဖုန်းခေါ်"),
    "preferenceScenarioCommunicationChannelQuestion":
        MessageLookupByLibrary.simpleMessage(
          "သင့်ကို ဆက်သွယ်ရန် အကောင်းဆုံးနည်း?",
        ),
    "preferenceScenarioCommunicationDirectnessOption1":
        MessageLookupByLibrary.simpleMessage("နူးညံ့စွာ ပြောပါ"),
    "preferenceScenarioCommunicationDirectnessOption2":
        MessageLookupByLibrary.simpleMessage("အခြေအနေပေါ်မူတည်"),
    "preferenceScenarioCommunicationDirectnessOption3":
        MessageLookupByLibrary.simpleMessage("တိုက်ရိုက် ပြောပါ"),
    "preferenceScenarioCommunicationDirectnessQuestion":
        MessageLookupByLibrary.simpleMessage("တစ်ခုခု မမှန်ရင်?"),
    "preferenceScenarioConflictResolutionOption1":
        MessageLookupByLibrary.simpleMessage("အရင် စိတ်အေးအောင်လုပ်"),
    "preferenceScenarioConflictResolutionOption2":
        MessageLookupByLibrary.simpleMessage("နောက်မှ စစ်ဆေးပြောဆိုမည်"),
    "preferenceScenarioConflictResolutionOption3":
        MessageLookupByLibrary.simpleMessage("စောစော ပြောဆိုမည်"),
    "preferenceScenarioConflictResolutionQuestion":
        MessageLookupByLibrary.simpleMessage("တစ်ခုခု မမှန်ဘူးဆိုရင်?"),
    "preferenceScenarioEnvironmentLightOption1":
        MessageLookupByLibrary.simpleMessage("ပျော့ပျောင်း"),
    "preferenceScenarioEnvironmentLightOption2":
        MessageLookupByLibrary.simpleMessage("မျှတ"),
    "preferenceScenarioEnvironmentLightOption3":
        MessageLookupByLibrary.simpleMessage("တောက်ပ"),
    "preferenceScenarioEnvironmentLightQuestion":
        MessageLookupByLibrary.simpleMessage("အလင်းအနေအထား?"),
    "preferenceScenarioEnvironmentNoiseOption1":
        MessageLookupByLibrary.simpleMessage("တိတ်တိတ်ဆိတ်ဆိတ်ပါ"),
    "preferenceScenarioEnvironmentNoiseOption2":
        MessageLookupByLibrary.simpleMessage("ပုံမှန်အသံ"),
    "preferenceScenarioEnvironmentNoiseOption3":
        MessageLookupByLibrary.simpleMessage("အသက်ဝင်နေတာ အဆင်ပြေတယ်"),
    "preferenceScenarioEnvironmentNoiseQuestion":
        MessageLookupByLibrary.simpleMessage("အသံအဆင့်?"),
    "preferenceScenarioEnvironmentScentOption1":
        MessageLookupByLibrary.simpleMessage("လွယ်ကူစွာ ထိခိုက်တတ်"),
    "preferenceScenarioEnvironmentScentOption2":
        MessageLookupByLibrary.simpleMessage("ပုံမှန်"),
    "preferenceScenarioEnvironmentScentOption3":
        MessageLookupByLibrary.simpleMessage("မကန့်ကွက်ဘူး"),
    "preferenceScenarioEnvironmentScentQuestion":
        MessageLookupByLibrary.simpleMessage("အနံ့ပြင်းတာ?"),
    "preferenceScenarioPrivacyNotificationsOption1":
        MessageLookupByLibrary.simpleMessage("မပို့ပါနဲ့"),
    "preferenceScenarioPrivacyNotificationsOption2":
        MessageLookupByLibrary.simpleMessage("အရေးကြီးတာသာ"),
    "preferenceScenarioPrivacyNotificationsOption3":
        MessageLookupByLibrary.simpleMessage("ဘယ်အချိန်မဆို"),
    "preferenceScenarioPrivacyNotificationsQuestion":
        MessageLookupByLibrary.simpleMessage("ညဘက် မက်ဆေ့ချ်များ?"),
    "preferenceScenarioPrivacyRoomEntryOption1":
        MessageLookupByLibrary.simpleMessage("အရင် တံခါးခေါက်ပါ"),
    "preferenceScenarioPrivacyRoomEntryOption2":
        MessageLookupByLibrary.simpleMessage("များသောအားဖြင့် တံခါးခေါက်ပါ"),
    "preferenceScenarioPrivacyRoomEntryOption3":
        MessageLookupByLibrary.simpleMessage("တံခါးဖွင့်ထားလျှင် ရတယ်"),
    "preferenceScenarioPrivacyRoomEntryQuestion":
        MessageLookupByLibrary.simpleMessage("သင့်အခန်းထဲ ဝင်ခြင်း?"),
    "preferenceScenarioRoutinePlanningOption1":
        MessageLookupByLibrary.simpleMessage("ဖွဲ့စည်းထားသည်"),
    "preferenceScenarioRoutinePlanningOption2":
        MessageLookupByLibrary.simpleMessage("အနည်းငယ် ဖွဲ့စည်းထားသည်"),
    "preferenceScenarioRoutinePlanningOption3":
        MessageLookupByLibrary.simpleMessage("ဖြစ်သလို စီးဆင်းမည်"),
    "preferenceScenarioRoutinePlanningQuestion":
        MessageLookupByLibrary.simpleMessage("နေ့စဉ်ဘဝ?"),
    "preferenceScenarioScheduleQuietHoursOption1":
        MessageLookupByLibrary.simpleMessage("တိတ်ဆိတ်သောညများ"),
    "preferenceScenarioScheduleQuietHoursOption2":
        MessageLookupByLibrary.simpleMessage("အခြေအနေပေါ်မူတည်"),
    "preferenceScenarioScheduleQuietHoursOption3":
        MessageLookupByLibrary.simpleMessage("တက်ကြွနေလည်း အဆင်ပြေတယ်"),
    "preferenceScenarioScheduleQuietHoursQuestion":
        MessageLookupByLibrary.simpleMessage("ညနေပိုင်း?"),
    "preferenceScenarioScheduleSleepTimingOption1":
        MessageLookupByLibrary.simpleMessage("စောစောထ"),
    "preferenceScenarioScheduleSleepTimingOption2":
        MessageLookupByLibrary.simpleMessage("အလယ်အလတ်"),
    "preferenceScenarioScheduleSleepTimingOption3":
        MessageLookupByLibrary.simpleMessage("ညဉ့်နက်နေရသူ"),
    "preferenceScenarioScheduleSleepTimingQuestion":
        MessageLookupByLibrary.simpleMessage("အိပ်စက်မှုပုံစံ?"),
    "preferenceScenarioSocialHostingOption1":
        MessageLookupByLibrary.simpleMessage("ရှားရှားပါးပါး"),
    "preferenceScenarioSocialHostingOption2":
        MessageLookupByLibrary.simpleMessage("တစ်ခါတစ်လေ"),
    "preferenceScenarioSocialHostingOption3":
        MessageLookupByLibrary.simpleMessage("မကြာခဏ"),
    "preferenceScenarioSocialHostingQuestion":
        MessageLookupByLibrary.simpleMessage("ဧည့်သည်များ?"),
    "preferenceScenarioSocialTogethernessOption1":
        MessageLookupByLibrary.simpleMessage("အများစု ကိုယ်တိုင်နေ"),
    "preferenceScenarioSocialTogethernessOption2":
        MessageLookupByLibrary.simpleMessage("နှစ်မျိုးလုံး ရောနှော"),
    "preferenceScenarioSocialTogethernessOption3":
        MessageLookupByLibrary.simpleMessage("အတူ မကြာခဏ အပန်းဖြေ"),
    "preferenceScenarioSocialTogethernessQuestion":
        MessageLookupByLibrary.simpleMessage("အိမ်၏ စွမ်းအင်?"),
    "profileActionConfirm": MessageLookupByLibrary.simpleMessage(
      "အိမ်မှ ထွက်မည်",
    ),
    "profileActionConfirmDelete": MessageLookupByLibrary.simpleMessage(
      "အကောင့် ဖျက်မည်",
    ),
    "profileConfirmDeleteMessage": MessageLookupByLibrary.simpleMessage(
      "၎င်းသည် သင့်အကောင့်ကို ဖျက်ပြီး အကောင့်ထွက်စေမည်။ ပြန်မလည်နိုင်ပါ။",
    ),
    "profileConfirmDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "သင့်အကောင့်ကို ဖျက်မလား?",
    ),
    "profileConfirmLeaveMessage": MessageLookupByLibrary.simpleMessage(
      "သင်သည် တာဝန်များ၊ မှတ်တမ်းနှင့် ဖိတ်ခေါ်မှုများသို့ ဝင်ရောက်ခွင့် ဆုံးရှုံးမည်။",
    ),
    "profileConfirmLeaveTitle": MessageLookupByLibrary.simpleMessage(
      "ဤအိမ်မှ ထွက်မလား?",
    ),
    "profileConnectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "သတိပေးချက်များနှင့် အကြောင်းကြားချက်များကို စီမံပါ။",
    ),
    "profileConnectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "အသိပေးချက်များ",
    ),
    "profileContactEmailSubject": MessageLookupByLibrary.simpleMessage(
      "ဆက်သွယ်ရန်",
    ),
    "profileContactLaunchError": MessageLookupByLibrary.simpleMessage(
      "သင့်အီးမေးလ်အက်ပ်ကို မဖွင့်နိုင်ခဲ့ပါ။",
    ),
    "profileContactUsSubtitle": MessageLookupByLibrary.simpleMessage(
      "support@makinglifeeasie.com သို့ အီးမေးလ်ပို့ပါ",
    ),
    "profileContactUsTitle": MessageLookupByLibrary.simpleMessage("ဆက်သွယ်ရန်"),
    "profileDeleteAccountSubtitle": MessageLookupByLibrary.simpleMessage(
      "သင့် Kinly အကောင့်နှင့် ဒေတာများကို ဖျက်မည်။",
    ),
    "profileDeleteAccountTitle": MessageLookupByLibrary.simpleMessage(
      "အကောင့် ဖျက်မည်",
    ),
    "profileDeleteSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "သင့်အကောင့်ကို မကြာမီ ဖျက်ပါမည်။ ကျွန်ုပ်တို့က သင့်ကို အကောင့်ထွက်ပေးပါမည်။",
    ),
    "profileGenericError": MessageLookupByLibrary.simpleMessage(
      "တစ်ခုခု မှားယွင်းသွားပါသည်။",
    ),
    "profileIdentityAvatarEmpty": MessageLookupByLibrary.simpleMessage(
      "လတ်တလော avatar မရရှိနိုင်ပါ။",
    ),
    "profileIdentityAvatarSectionDescription":
        MessageLookupByLibrary.simpleMessage(
          "အိမ်အတွင်း avatar တစ်ခုစီသည် သီးသန့် ဖြစ်ရမည်။",
        ),
    "profileIdentityAvatarSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Avatar ရွေးပါ",
    ),
    "profileIdentityLoadError": MessageLookupByLibrary.simpleMessage(
      "သင့်ပရိုဖိုင်ကို မတင်နိုင်ခဲ့ပါ။",
    ),
    "profileIdentityRetry": MessageLookupByLibrary.simpleMessage(
      "ပြန်ကြိုးစားမည်",
    ),
    "profileIdentitySaveButton": MessageLookupByLibrary.simpleMessage(
      "ပြောင်းလဲမှုများ သိမ်းမည်",
    ),
    "profileIdentitySubtitle": MessageLookupByLibrary.simpleMessage(
      "အသုံးပြုသူအမည်နှင့် avatar ရွေးပါ။",
    ),
    "profileIdentitySuccessMessage": MessageLookupByLibrary.simpleMessage(
      "ပရိုဖိုင်ကို အပ်ဒိတ်လုပ်ပြီးပါပြီ။",
    ),
    "profileIdentityTitle": MessageLookupByLibrary.simpleMessage(
      "ပရိုဖိုင် ပြင်မည်",
    ),
    "profileIdentityUsernameEmptyError": MessageLookupByLibrary.simpleMessage(
      "အသုံးပြုသူအမည် ထည့်ပါ။",
    ),
    "profileIdentityUsernameFormatError": MessageLookupByLibrary.simpleMessage(
      "စာလုံးသေး သို့မဟုတ် နံပါတ် 3-30 လုံး သုံးပါ။ Dot နှင့် underscore ကို အလယ်တွင်သာ သုံးနိုင်သည်။",
    ),
    "profileIdentityUsernameHint": MessageLookupByLibrary.simpleMessage(
      "အက္ခရာ၊ နံပါတ်၊ . သို့မဟုတ် _",
    ),
    "profileIdentityUsernameLabel": MessageLookupByLibrary.simpleMessage(
      "အသုံးပြုသူအမည်",
    ),
    "profileIdentityUsernamePreviewFallback":
        MessageLookupByLibrary.simpleMessage("သင့်အသုံးပြုသူအမည်"),
    "profileIdentityUsernameTakenError": MessageLookupByLibrary.simpleMessage(
      "ဤအသုံးပြုသူအမည်ကို အခြားသူ အသုံးပြုပြီးပါပြီ။",
    ),
    "profileInfoHubLoadError": MessageLookupByLibrary.simpleMessage(
      "Info Hub ကို မတင်နိုင်ခဲ့ပါ။ သင့်ချိတ်ဆက်မှုကို စစ်ဆေးပါ။",
    ),
    "profileInfoHubSubtitle": MessageLookupByLibrary.simpleMessage(
      "Kinly Notion hub ကို အက်ပ်အတွင်းဖွင့်ပါ။",
    ),
    "profileInfoHubTitle": MessageLookupByLibrary.simpleMessage("Info Hub"),
    "profileKickActionConfirm": MessageLookupByLibrary.simpleMessage(
      "အဖွဲ့ဝင် ဖယ်ရှားမည်",
    ),
    "profileKickMemberSubtitle": MessageLookupByLibrary.simpleMessage(
      "ဤအိမ်မှ ဝင်ရောက်ခွင့် ဆုံးရှုံးမည့်သူကို ရွေးပါ။",
    ),
    "profileKickMemberTitle": MessageLookupByLibrary.simpleMessage(
      "အဖွဲ့ဝင် ဖယ်ရှားမည်",
    ),
    "profileKickNoMembers": MessageLookupByLibrary.simpleMessage(
      "လတ်တလော ဖယ်ရှားရန် အခြားအဖွဲ့ဝင် မရှိပါ။",
    ),
    "profileKickOwnerOnly": MessageLookupByLibrary.simpleMessage(
      "အိမ်ပိုင်ရှင်သာ အဖွဲ့ဝင်များကို ဖယ်ရှားနိုင်သည်။",
    ),
    "profileKickSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "ဖယ်ရှားမည့် အဖွဲ့ဝင်ကို ရွေးပါ။ သူတို့သည် ချက်ချင်း ဝင်ရောက်ခွင့် ဆုံးရှုံးမည်။",
    ),
    "profileKickSheetTitle": MessageLookupByLibrary.simpleMessage(
      "အဖွဲ့ဝင် ဖယ်ရှားမည်",
    ),
    "profileKickSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "သူတို့သည် ဤအိမ်သို့ မဝင်ရောက်နိုင်တော့ပါ။",
    ),
    "profileLeaveEligibilityError": MessageLookupByLibrary.simpleMessage(
      "အိမ်အဖွဲ့ဝင်များကို မတင်နိုင်ခဲ့ပါ။",
    ),
    "profileLeaveEligibilityLoading": MessageLookupByLibrary.simpleMessage(
      "အိမ်အဖွဲ့ဝင်များကို စစ်ဆေးနေသည်...",
    ),
    "profileLeaveHomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "သင်သည် ဤ မျှဝေထားသော Kinly နေရာမှ ထွက်သွားမည်ဖြစ်သည်။",
    ),
    "profileLeaveHomeTitle": MessageLookupByLibrary.simpleMessage(
      "အိမ်မှ ထွက်မည်",
    ),
    "profileLeaveOwnerNoEligibleMembers": MessageLookupByLibrary.simpleMessage(
      "ယခုပိုင်ဆိုင်မှု လွှဲပြောင်းယူနိုင်မည့် အခြားသူ မရှိသေးပါ။",
    ),
    "profileLeaveOwnerSoloMessage": MessageLookupByLibrary.simpleMessage(
      "သင်က နောက်ဆုံးအဖွဲ့ဝင်ဖြစ်ပါသည်။ ထွက်သွားပါက ဤအိမ်ကို ပိတ်သိမ်းမည်ဖြစ်သည်။",
    ),
    "profileLeaveSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "သင်သည် သင့်အိမ်မှ ထွက်သွားပြီးပါပြီ။",
    ),
    "profileLeaveTransferSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "သင်မထွက်မီ ပိုင်ရှင်အသစ် ဖြစ်မည့်သူကို ရွေးပါ။",
    ),
    "profileLeaveTransferSheetTitle": MessageLookupByLibrary.simpleMessage(
      "ပိုင်ဆိုင်မှု လွှဲပြောင်းမည်",
    ),
    "profileLeaveTransferSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "ပိုင်ဆိုင်မှု လွှဲပြောင်းပြီးပါပြီ။ ထွက်ခွာမှုကို ဆက်လက်ပြီးဆုံးနေသည်...",
    ),
    "profileLogoutSubtitle": MessageLookupByLibrary.simpleMessage(
      "ဤစက်ပေါ်ရှိ Kinly မှ အကောင့်ထွက်မည်။",
    ),
    "profileLogoutTitle": MessageLookupByLibrary.simpleMessage(
      "အကောင့်ထွက်မည်",
    ),
    "profileMissingHomeError": MessageLookupByLibrary.simpleMessage(
      "သင့်လက်ရှိအိမ်ကို မတွေ့နိုင်ခဲ့ပါ။",
    ),
    "profileSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "သင့်အကောင့်နှင့် အိမ်ဝင်ရောက်မှုကို စီမံပါ။",
    ),
    "profileSettingsTitle": MessageLookupByLibrary.simpleMessage("ပရိုဖိုင်"),
    "profile_deactivated_message": MessageLookupByLibrary.simpleMessage(
      "သင့်ပရိုဖိုင်ကို ပိတ်ထားပါသည်။ အခြားအီးမေးလ်လိပ်စာဖြင့် အကောင့်ဝင်ပါ။",
    ),
    "pulseCloudySteadySummary": MessageLookupByLibrary.simpleMessage(
      "အချို့က အလုပ်ဖြစ်ခဲ့တယ်။ အချို့က မဖြစ်ခဲ့ဘူး။",
    ),
    "pulseCloudySteadyTitle": MessageLookupByLibrary.simpleMessage(
      "ရောနှောနေသည်",
    ),
    "pulseCloudyTenseSummary": MessageLookupByLibrary.simpleMessage(
      "ဒီအပတ် တင်းမာမှုအချို့ ပေါ်လာခဲ့တယ်။",
    ),
    "pulseCloudyTenseTitle": MessageLookupByLibrary.simpleMessage(
      "အာရုံစိုက်ရန်လိုသည်",
    ),
    "pulseFormingSummary": MessageLookupByLibrary.simpleMessage(
      "နောက်ထပ် စစ်ဆေးမှုအချို့ ရှိလာပါက ပိုရှင်းလင်းသော ပုံရိပ် ရလာမည်။",
    ),
    "pulseFormingTitle": MessageLookupByLibrary.simpleMessage("ဖွဲ့စည်းဆဲ"),
    "pulsePartlySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "အများစု တည်ငြိမ်ပေမယ့် တိုးတက်စရာ အနည်းငယ် ရှိတယ်။",
    ),
    "pulsePartlySupportedTitle": MessageLookupByLibrary.simpleMessage(
      "စုစုပေါင်း အဆင်ပြေသည်",
    ),
    "pulseRainySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "သေးငယ်သော reset တစ်ခု လုပ်ရန် အချိန်ရောက်ပြီ ဖြစ်နိုင်သည်။",
    ),
    "pulseRainySupportedTitle": MessageLookupByLibrary.simpleMessage(
      "ပြန်လည်ညှိနှိုင်းရန် အကြံပြုသည်",
    ),
    "pulseRainyUnsupportedSummary": MessageLookupByLibrary.simpleMessage(
      "လတ်တလော သိသာသော friction ရှိနေပါသည်။",
    ),
    "pulseRainyUnsupportedTitle": MessageLookupByLibrary.simpleMessage(
      "ပြန်လည်ညှိနှိုင်းရန် လိုအပ်သည်",
    ),
    "pulseSunnyBumpySummary": MessageLookupByLibrary.simpleMessage(
      "အများစု ချောမွေ့ပေမယ့် နည်းနည်း အခက်အခဲတွေ ရှိတယ်။",
    ),
    "pulseSunnyBumpyTitle": MessageLookupByLibrary.simpleMessage(
      "အများစု ချောမွေ့သည်",
    ),
    "pulseSunnyCalmSummary": MessageLookupByLibrary.simpleMessage(
      "ဒီအပတ် အရာအားလုံး ချောမွေ့သလို ခံစားရသည်။",
    ),
    "pulseSunnyCalmTitle": MessageLookupByLibrary.simpleMessage(
      "ချောမွေ့စွာ လည်ပတ်နေသည်",
    ),
    "pulseThunderstormSummary": MessageLookupByLibrary.simpleMessage(
      "တင်းမာမှု မြင့်နေပါသည်။ မကြာမီ ပြန်လည်ညှိနှိုင်းပါ။",
    ),
    "pulseThunderstormTitle": MessageLookupByLibrary.simpleMessage(
      "တင်းမာမှု မြင့်မားသည်",
    ),
    "quick_add_flow_subtitle": MessageLookupByLibrary.simpleMessage(
      "တာဝန်တစ်ခု ဖန်တီးမည်",
    ),
    "quick_add_flow_title": MessageLookupByLibrary.simpleMessage("တာဝန်"),
    "quick_add_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "ဘေလ်တစ်ခု ထည့်မည်",
    ),
    "quick_add_share_title": MessageLookupByLibrary.simpleMessage("ဘေလ်"),
    "quick_add_title": MessageLookupByLibrary.simpleMessage("အမြန်ထည့်မည်"),
    "reflectiveAcknowledgementTitle": MessageLookupByLibrary.simpleMessage(
      "နားလည်ပါပြီ။",
    ),
    "reflectiveGenericPrimary": MessageLookupByLibrary.simpleMessage(
      "ဂရုတစိုက် စုစည်းနေပါသည်။",
    ),
    "reflectiveGenericSecondary": MessageLookupByLibrary.simpleMessage(
      "မပြမီ ခဏ နားနေပါ။",
    ),
    "reflectiveHouseNormsPrimary": MessageLookupByLibrary.simpleMessage(
      "ဤအိမ် မျှဝေထားသည်ကို ပြန်လည်ထင်ဟပ်နေပါသည်။",
    ),
    "reflectiveHouseNormsSecondary": MessageLookupByLibrary.simpleMessage(
      "စည်းကမ်းစာအုပ် မဟုတ်သော မျှဝေလမ်းညွှန်တစ်ခု။",
    ),
    "reflectiveHousePrimary": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်၏ မျှော်လင့်ချက်များကို စကားလုံးအဖြစ် ပြောင်းနေပါသည်။",
    ),
    "reflectiveHouseSecondary": MessageLookupByLibrary.simpleMessage(
      "မျှော်လင့်ချက်များ ရှင်းလင်းစေရန်။",
    ),
    "reflectivePersonalPrimary": MessageLookupByLibrary.simpleMessage(
      "သင်မျှဝေထားတာကို ပြန်လည်ထင်ဟပ်နေပါသည်။",
    ),
    "reflectivePersonalSecondary": MessageLookupByLibrary.simpleMessage(
      "သင့်အတွက် ဘာက သက်သောင့်သက်သာရှိသလဲဆိုတာ အခြားသူများ နားလည်စေရန်။",
    ),
    "shareCreateAmountHint": MessageLookupByLibrary.simpleMessage("0.00"),
    "shareCreateAmountLabel": MessageLookupByLibrary.simpleMessage("ပမာဏ"),
    "shareCreateCustomAmountLabel": MessageLookupByLibrary.simpleMessage(
      "ပမာဏ",
    ),
    "shareCreateCustomHelper": MessageLookupByLibrary.simpleMessage(
      "လူတစ်ဦးချင်းစီ၏ ဝေစုကို ထည့်ပါ။ စုစုပေါင်းသည် အထက်ပါ ပမာဏနှင့် တူရမည်။",
    ),
    "shareCreateCyclePeriod": m17,
    "shareCreateDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "ဥပမာ စျေးဝယ်သွားခြင်း",
    ),
    "shareCreateDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "ဖော်ပြချက်",
    ),
    "shareCreateErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "ဤအရာကို လတ်တလော ဖန်တီးရန် သင့်တွင် ခွင့်ပြုချက် မရှိပါ။",
    ),
    "shareCreateErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "ဘေလ်ကို မဖန်တီးနိုင်ခဲ့ပါ။",
    ),
    "shareCreateErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "လက်ရှိ ဘေလ်များအတွက် အခမဲ့ကန့်သတ်ချက် ပြည့်သွားပါပြီ။ ပိုမိုအသုံးပြုရန် အဆင့်မြှင့်ပါ။",
    ),
    "shareCreateErrorRecurrenceDraft": MessageLookupByLibrary.simpleMessage(
      "မူကြမ်းများကို ခွဲဝေမှု မထည့်မချင်း ထပ်တလဲလဲ မလုပ်နိုင်ပါ။",
    ),
    "shareCreateLoadError": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်အဖွဲ့ဝင်များကို မတင်နိုင်ခဲ့ပါ။",
    ),
    "shareCreateNotesHint": MessageLookupByLibrary.simpleMessage(
      "လူတိုင်း မြင်နိုင်သော ရွေးချယ်နိုင်သည့် မှတ်စု",
    ),
    "shareCreateNotesLabel": MessageLookupByLibrary.simpleMessage("မှတ်စု"),
    "shareCreateParticipantsEmpty": MessageLookupByLibrary.simpleMessage(
      "ဘေလ်တစ်ခု မျှဝေရန် အနည်းဆုံး အိမ်အဖွဲ့ဝင် 2 ယောက် လိုအပ်သည်။",
    ),
    "shareCreateRecurrenceEveryLabel": MessageLookupByLibrary.simpleMessage(
      "တိုင်း",
    ),
    "shareCreateRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "ထပ်ခါတလဲလဲ",
    ),
    "shareCreateRecurrenceToggleLabel": MessageLookupByLibrary.simpleMessage(
      "ထပ်တလဲလဲ ဖြစ်မည်",
    ),
    "shareCreateRecurrenceUnitDay": MessageLookupByLibrary.simpleMessage("နေ့"),
    "shareCreateRecurrenceUnitMonth": MessageLookupByLibrary.simpleMessage("လ"),
    "shareCreateRecurrenceUnitWeek": MessageLookupByLibrary.simpleMessage(
      "ပတ်",
    ),
    "shareCreateRecurrenceUnitYear": MessageLookupByLibrary.simpleMessage(
      "နှစ်",
    ),
    "shareCreateRetry": MessageLookupByLibrary.simpleMessage(
      "ထပ်မံကြိုးစားမည်",
    ),
    "shareCreateSplitCustom": MessageLookupByLibrary.simpleMessage(
      "ပမာဏ ရွေးမည်",
    ),
    "shareCreateSplitEqual": MessageLookupByLibrary.simpleMessage(
      "ညီမျှစွာ ခွဲမည်",
    ),
    "shareCreateSplitLabel": MessageLookupByLibrary.simpleMessage(
      "ဘယ်လို ခွဲဝေမလဲ?",
    ),
    "shareCreateStartLabel": MessageLookupByLibrary.simpleMessage(
      "ဘယ်အချိန်မှ စတင်သက်ရောက်မလဲ?",
    ),
    "shareCreateSubmit": MessageLookupByLibrary.simpleMessage("ဖန်တီးမည်"),
    "shareCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "ဘေလ် ဖန်တီးပြီးပါပြီ။",
    ),
    "shareCreateTitle": MessageLookupByLibrary.simpleMessage("ဘေလ် ထည့်မည်"),
    "shareCreateValidationAmount": MessageLookupByLibrary.simpleMessage(
      "သုညထက် ကြီးသော ပမာဏ ထည့်ပါ။",
    ),
    "shareCreateValidationCustomAmounts": MessageLookupByLibrary.simpleMessage(
      "ရွေးထားသော လူတိုင်းအတွက် မှန်ကန်သော ပမာဏ ထည့်ပါ။",
    ),
    "shareCreateValidationCustomParticipants":
        MessageLookupByLibrary.simpleMessage(
          "ဤဘေလ်အတွက် အနည်းဆုံး လူတစ်ယောက် ရွေးပါ။",
        ),
    "shareCreateValidationCustomSinglePayer":
        MessageLookupByLibrary.simpleMessage(
          "အခြားလူ အနည်းဆုံး တစ်ယောက် ထည့်ပါ။",
        ),
    "shareCreateValidationCustomSum": MessageLookupByLibrary.simpleMessage(
      "ခွဲဝေမှု စုစုပေါင်းသည် စုစုပေါင်းပမာဏနှင့် ကိုက်ညီကြောင်း သေချာစေပါ။",
    ),
    "shareCreateValidationCustomSumBreakdown": m18,
    "shareCreateValidationDescription": MessageLookupByLibrary.simpleMessage(
      "ဖော်ပြချက် ထည့်ပါ။",
    ),
    "shareCreateValidationEqualParticipants":
        MessageLookupByLibrary.simpleMessage(
          "ဤဘေလ်ကို ခွဲရန် အနည်းဆုံး လူတစ်ယောက် ရွေးပါ။",
        ),
    "shareCreateValidationRecurrence": MessageLookupByLibrary.simpleMessage(
      "ဘယ်နှကြိမ် ထပ်ဖြစ်မည်ကို ရွေးပါ။",
    ),
    "shareCreateValidationRecurrenceSplit":
        MessageLookupByLibrary.simpleMessage(
          "ထပ်တလဲလဲ မလုပ်မီ ခွဲဝေမှုပုံစံ ရွေးပါ။",
        ),
    "shareCreateValidationStartDate": MessageLookupByLibrary.simpleMessage(
      "စတင်ရက်စွဲ ရွေးပါ။",
    ),
    "shareCreateValidationStartDateRange": MessageLookupByLibrary.simpleMessage(
      "ခွင့်ပြုထားသော အကွာအဝေးအတွင်း ရက်စွဲ ရွေးပါ။",
    ),
    "shareCreatedListActiveAmount": m19,
    "shareCreatedListActiveSubtitle": m20,
    "shareCreatedListDraftBadge": MessageLookupByLibrary.simpleMessage(
      "တာဝန်မပေးထား",
    ),
    "shareCreatedListDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "လူတိုင်း မိမိဝေစုကို သိနိုင်ရန် မထုတ်ပြန်မီ ခွဲဝေပါ။",
    ),
    "shareCreatedListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "ဘေလ်များက ငွေကြေးကိစ္စကို ရှင်းလင်းစေသည်။",
    ),
    "shareCreatedListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "ဘေလ်များ မရှိသေးပါ",
    ),
    "shareCreatedListError": MessageLookupByLibrary.simpleMessage(
      "သင့်ဘေလ်များကို မတင်နိုင်ခဲ့ပါ။ ဆွဲချပြီး ပြန်လည်ရယူပါ။",
    ),
    "shareCreatedListPaidBadge": MessageLookupByLibrary.simpleMessage(
      "အပြည့်အစုံ ပေးပြီး",
    ),
    "shareCreatedListRetry": MessageLookupByLibrary.simpleMessage(
      "ပြန်ကြိုးစားမည်",
    ),
    "shareCreatedListTitle": MessageLookupByLibrary.simpleMessage(
      "သင့်ဘေလ်များ",
    ),
    "shareEditClose": MessageLookupByLibrary.simpleMessage("ပိတ်မည်"),
    "shareEditDeleteButton": MessageLookupByLibrary.simpleMessage("ဖျက်မည်"),
    "shareEditDeleteConfirm": MessageLookupByLibrary.simpleMessage("ဖျက်မည်"),
    "shareEditDeleteConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "၎င်းသည် လူတိုင်းအတွက် မူကြမ်းကို ဖယ်ရှားပါမည်။",
    ),
    "shareEditDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "ဘေလ်ကို ဖျက်မလား?",
    ),
    "shareEditDeleteError": MessageLookupByLibrary.simpleMessage(
      "ဘေလ်ကို မဖျက်နိုင်ခဲ့ပါ။",
    ),
    "shareEditDeleteSuccess": MessageLookupByLibrary.simpleMessage(
      "ဘေလ်ကို ဖျက်ပြီးပါပြီ။",
    ),
    "shareEditDisabledActive": MessageLookupByLibrary.simpleMessage(
      "လက်ရှိဘေလ်များကို မပြင်နိုင်ပါ။",
    ),
    "shareEditDisabledConverted": MessageLookupByLibrary.simpleMessage(
      "ဤဘေလ်သည် ယခု အစီအစဉ်တစ်ခု ဖြစ်သွားပြီး ဤနေရာတွင် မပြင်နိုင်တော့ပါ။",
    ),
    "shareEditDisabledGeneric": MessageLookupByLibrary.simpleMessage(
      "ဤဘေလ်ကို လတ်တလော မပြင်နိုင်ပါ။",
    ),
    "shareEditDisabledRecurringCycle": MessageLookupByLibrary.simpleMessage(
      "ထပ်ခါတလဲလဲ စက်ဝန်းများကို ဤနေရာတွင် မပြင်နိုင်ပါ။",
    ),
    "shareEditLoadError": MessageLookupByLibrary.simpleMessage(
      "ထိုမူကြမ်းကို မတင်နိုင်ခဲ့ပါ။",
    ),
    "shareEditNotAllowed": MessageLookupByLibrary.simpleMessage(
      "တစ်ယောက်ယောက်က ဒီဘေလ်ကို ယူမချင်း လော့ခ်ထားမည်။",
    ),
    "shareEditSplitsLocked": MessageLookupByLibrary.simpleMessage(
      "တစ်ယောက်ယောက်က ပေးပြီးသွားသောကြောင့် ခွဲဝေမှုများ လော့ခ်ထားပါသည်။ ဖော်ပြချက်နှင့် မှတ်စုများကိုသာ ပြင်နိုင်သေးသည်။",
    ),
    "shareEditSubmit": MessageLookupByLibrary.simpleMessage("အပ်ဒိတ်လုပ်မည်"),
    "shareEditSuccess": MessageLookupByLibrary.simpleMessage(
      "ဘေလ်ကို အပ်ဒိတ်လုပ်ပြီးပါပြီ။",
    ),
    "shareEditTerminateError": MessageLookupByLibrary.simpleMessage(
      "အစီအစဉ်ကို မအဆုံးသတ်နိုင်ခဲ့ပါ။",
    ),
    "shareEditTerminatePlan": MessageLookupByLibrary.simpleMessage(
      "အစီအစဉ်ကို အဆုံးသတ်မည်",
    ),
    "shareEditTerminatePlanBusy": MessageLookupByLibrary.simpleMessage(
      "အဆုံးသတ်နေသည်...",
    ),
    "shareEditTerminatePlanConfirm": MessageLookupByLibrary.simpleMessage(
      "အစီအစဉ် အဆုံးသတ်မည်",
    ),
    "shareEditTerminatePlanMessage": MessageLookupByLibrary.simpleMessage(
      "၎င်းသည် အနာဂတ် ဘေလ်စက်ဝန်းများကို ရပ်တန့်စေမည်။",
    ),
    "shareEditTerminatePlanTitle": MessageLookupByLibrary.simpleMessage(
      "ထပ်ခါတလဲလဲ အစီအစဉ်ကို အဆုံးသတ်မလား?",
    ),
    "shareEditTerminateSuccess": MessageLookupByLibrary.simpleMessage(
      "အစီအစဉ် ပြီးဆုံးပြီးပါပြီ။",
    ),
    "shareEditTitle": MessageLookupByLibrary.simpleMessage("ဘေလ် ပြင်မည်"),
    "shareOwedDetailEmpty": MessageLookupByLibrary.simpleMessage(
      "ဤလူနှင့် ပတ်သက်ပြီး သင်ရှင်းလင်းပြီးပါပြီ။",
    ),
    "shareOwedDetailError": MessageLookupByLibrary.simpleMessage(
      "ဤပေးချေမှုကို ရှင်းပြီးဟု မမှတ်နိုင်ခဲ့ပါ။",
    ),
    "shareOwedDetailPaid": MessageLookupByLibrary.simpleMessage(
      "ရှင်းပြီးဟု မှတ်မည်",
    ),
    "shareOwedDetailSuccess": MessageLookupByLibrary.simpleMessage(
      "ရှင်းပြီးဟု မှတ်ထားပြီးပါပြီ။",
    ),
    "shareOwedDetailTitle": MessageLookupByLibrary.simpleMessage("ဖြေရှင်းရန်"),
    "sharePaidDetailAcknowledge": MessageLookupByLibrary.simpleMessage(
      "လက်ခံရရှိကြောင်း အတည်ပြုမည်",
    ),
    "sharePaidDetailAcknowledgeError": MessageLookupByLibrary.simpleMessage(
      "ဤပေးချေမှုကို အတည်မပြုနိုင်ခဲ့ပါ။",
    ),
    "sharePaidDetailAcknowledging": MessageLookupByLibrary.simpleMessage(
      "အတည်ပြုနေသည်...",
    ),
    "shoppingAllItemsBought": MessageLookupByLibrary.simpleMessage(
      "အားလုံး ဝယ်ပြီးပါပြီ",
    ),
    "shoppingAmountHint": MessageLookupByLibrary.simpleMessage(
      "ဥပမာ ဘူး 2 ဘူး",
    ),
    "shoppingAmountLabel": MessageLookupByLibrary.simpleMessage("အရေအတွက်"),
    "shoppingArchiveCta": MessageLookupByLibrary.simpleMessage(
      "ဝယ်ပြီးပစ္စည်းများ",
    ),
    "shoppingArchiveDraftBillCreated": MessageLookupByLibrary.simpleMessage(
      "မူကြမ်းဘေလ် ဖန်တီးပြီးပါပြီ",
    ),
    "shoppingArchiveItemsBought": MessageLookupByLibrary.simpleMessage(
      "ပစ္စည်းများကို ဝယ်ပြီးဟု မှတ်ပြီး ဖယ်ရှားလိုက်ပါပြီ",
    ),
    "shoppingArchiveShareNo": MessageLookupByLibrary.simpleMessage("မလုပ်ပါ"),
    "shoppingArchiveSharePromptBody": MessageLookupByLibrary.simpleMessage(
      "ဤပစ္စည်းများမှ မူကြမ်းဘေလ်တစ်ခု ဖန်တီးမလား?",
    ),
    "shoppingArchiveSharePromptTitle": MessageLookupByLibrary.simpleMessage(
      "ဘေလ် ဖန်တီးမလား?",
    ),
    "shoppingArchiveShareYes": MessageLookupByLibrary.simpleMessage("ဟုတ်ကဲ့"),
    "shoppingCardSubtitle": m21,
    "shoppingCardTitle": MessageLookupByLibrary.simpleMessage("စျေးဝယ်စာရင်း"),
    "shoppingContextHint": MessageLookupByLibrary.simpleMessage(
      "အမှတ်တံဆိပ်၊ အရွယ်အစား သို့မဟုတ် မှတ်စု",
    ),
    "shoppingContextLabel": MessageLookupByLibrary.simpleMessage("မှတ်စု"),
    "shoppingCreateTitle": MessageLookupByLibrary.simpleMessage(
      "စျေးဝယ်ပစ္စည်း ထည့်မည်",
    ),
    "shoppingDelete": MessageLookupByLibrary.simpleMessage("ပစ္စည်း ဖျက်မည်"),
    "shoppingDeleteConfirmBody": MessageLookupByLibrary.simpleMessage(
      "၎င်းကို မျှဝေစျေးဝယ်စာရင်းမှ ဖယ်ရှားပါမည်။",
    ),
    "shoppingDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "ဤပစ္စည်းကို ဖျက်မလား?",
    ),
    "shoppingDetailTitle": MessageLookupByLibrary.simpleMessage(
      "စျေးဝယ်ပစ္စည်း",
    ),
    "shoppingEditTitle": MessageLookupByLibrary.simpleMessage(
      "စျေးဝယ်ပစ္စည်း ပြင်မည်",
    ),
    "shoppingEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "စျေးဝယ်ပစ္စည်း မရှိသေးပါ။",
    ),
    "shoppingErrorItemAlreadyCompletedByOther":
        MessageLookupByLibrary.simpleMessage(
          "တစ်ယောက်ယောက်က ဒီပစ္စည်းကို ဝယ်ပြီးဟု အမှတ်ထားပြီးပါပြီ။",
        ),
    "shoppingListTitle": MessageLookupByLibrary.simpleMessage("စျေးဝယ်စာရင်း"),
    "shoppingMarkCompleteCta": MessageLookupByLibrary.simpleMessage(
      "ဝယ်ပြီးဟု မှတ်မည်",
    ),
    "shoppingNameHint": MessageLookupByLibrary.simpleMessage("ဥပမာ နို့"),
    "shoppingNameLabel": MessageLookupByLibrary.simpleMessage("အမည်"),
    "shoppingPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "ဓာတ်ပုံထည့်မည်",
    ),
    "shoppingPhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "ဓာတ်ပုံထည့်ပါ",
    ),
    "shoppingPhotoReplaceLabel": MessageLookupByLibrary.simpleMessage(
      "အခြားသူများ မှန်ကန်သောပစ္စည်းကို ဝယ်နိုင်ရန် ကူညီပါ",
    ),
    "shoppingSubmitAdd": MessageLookupByLibrary.simpleMessage("ပစ္စည်းထည့်မည်"),
    "shoppingSubmitEdit": MessageLookupByLibrary.simpleMessage(
      "ပြောင်းလဲမှုများ သိမ်းမည်",
    ),
    "shoppingTabPending": MessageLookupByLibrary.simpleMessage("ဝယ်ရန်"),
    "shoppingValidationName": MessageLookupByLibrary.simpleMessage(
      "ပစ္စည်းအမည် ထည့်ပါ။",
    ),
    "startReturningSubtitle": MessageLookupByLibrary.simpleMessage(
      "ဘာလုပ်ချင်ပါသလဲ?",
    ),
    "startReturningTitle": m22,
    "todayAddSheetFlow": MessageLookupByLibrary.simpleMessage("တာဝန် ထည့်မည်"),
    "todayAddSheetShare": MessageLookupByLibrary.simpleMessage("ဘေလ် ထည့်မည်"),
    "todayAddSheetShopping": MessageLookupByLibrary.simpleMessage(
      "စျေးဝယ်ပစ္စည်း ထည့်မည်",
    ),
    "todayAddSheetTitle": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်ထဲသို့ ထည့်မည်",
    ),
    "todayEmptyBody": MessageLookupByLibrary.simpleMessage(
      "လတ်တလော သင့်အာရုံစိုက်မှု လိုအပ်တာ မရှိပါ။",
    ),
    "todayEmptyCardBadge": MessageLookupByLibrary.simpleMessage(
      "နည်းနည်း အနားယူပါ",
    ),
    "todayEmptyCardTitle": MessageLookupByLibrary.simpleMessage(
      "အားလုံး အဆင်ပြေပါပြီ",
    ),
    "todayFlatmateInviteSubtitle": MessageLookupByLibrary.simpleMessage(
      "တစ်မျိုးတည်း နားလည်ပြီး တာဝန်များကို မျှဝေပါ။",
    ),
    "todayFlatmateInviteTitle": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်ဖော်များကို ဖိတ်ခေါ်ပါ",
    ),
    "todayFlowBadgeNew": MessageLookupByLibrary.simpleMessage("ယနေ့ အသစ်"),
    "todayFlowSectionTitle": MessageLookupByLibrary.simpleMessage("တာဝန်များ"),
    "todayFlowSeeAll": m23,
    "todayFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "ယနေ့ အာရုံစိုက်ရန်လိုသော အရာများမှာ —",
    ),
    "todayFlowTabActive": MessageLookupByLibrary.simpleMessage("လက်ရှိ"),
    "todayFlowTabDrafts": MessageLookupByLibrary.simpleMessage("မူကြမ်းများ"),
    "todayGratitudeHouseCta": MessageLookupByLibrary.simpleMessage(
      "အိမ်ကျေးဇူးတင်စကားများ",
    ),
    "todayGratitudePersonalCta": MessageLookupByLibrary.simpleMessage(
      "ကျွန်ုပ်၏ ကျေးဇူးတင်စကားများ",
    ),
    "todayGratitudeSectionTitle": MessageLookupByLibrary.simpleMessage(
      "ကျေးဇူးတင်စကားများ",
    ),
    "todayGratitudeUnreadBody": MessageLookupByLibrary.simpleMessage(
      "ကျေးဇူးတင်စကားအသစ်များ သင့်ကို စောင့်နေပါသည်။",
    ),
    "todayInviteFriendsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Kinly ကို သူငယ်ချင်းများနှင့် မျှဝေပါ။",
    ),
    "todayInviteFriendsTitle": MessageLookupByLibrary.simpleMessage(
      "သူငယ်ချင်းများကို Kinly သို့ ဖိတ်ခေါ်ပါ",
    ),
    "todayInviteNotNow": MessageLookupByLibrary.simpleMessage("အခုမလုပ်သေးပါ"),
    "todayInviteShareCta": MessageLookupByLibrary.simpleMessage(
      "ဖိတ်ခေါ်မှု မျှဝေမည်",
    ),
    "todayMemberCapPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "အိမ်ကို အဆင့်မြှင့်မည်",
    ),
    "todayMemberCapResolutionFailed": m24,
    "todayMemberCapResolutionJoined": m25,
    "todayMemberCapResolutionSuperseded": m26,
    "todayMemberCapResolutionUnknownName": MessageLookupByLibrary.simpleMessage(
      "တစ်ယောက်ယောက်",
    ),
    "todayMemberCapSecondaryCta": MessageLookupByLibrary.simpleMessage(
      "လျစ်လျူရှုမည်",
    ),
    "todayMemberCapSubtitle": m27,
    "todayMemberCapSubtitleGeneric": MessageLookupByLibrary.simpleMessage(
      "လူပိုထည့်ရန် အဆင့်မြှင့်ပါ။",
    ),
    "todayMemberCapTitle": MessageLookupByLibrary.simpleMessage(
      "တစ်ယောက်ယောက်က သင့်အိမ်သို့ ဝင်ချင်နေပါသည်",
    ),
    "todayShareActiveSubtitle": m28,
    "todayShareError": MessageLookupByLibrary.simpleMessage(
      "လတ်တလော ဘေလ်များကို မပြန်လည်ရယူနိုင်ခဲ့ပါ။",
    ),
    "todaySharePaidSubtitle": MessageLookupByLibrary.simpleMessage(
      "ရှင်းပြီး ပမာဏ",
    ),
    "todaySharePaidUnseen": m29,
    "todayShareSectionTitle": MessageLookupByLibrary.simpleMessage("ဘေလ်များ"),
    "todayShareTabActive": MessageLookupByLibrary.simpleMessage("ဖြေရှင်းရန်"),
    "todayShareTabDrafts": MessageLookupByLibrary.simpleMessage("မူကြမ်းများ"),
    "todayShareTabPaidToMe": MessageLookupByLibrary.simpleMessage("ရှင်းပြီး"),
    "vibeCozySocialSummary": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်သည် နွေးထွေးပြီး အတူတကွ တည်ငြိမ်သလို ခံစားရပါသည်။",
    ),
    "vibeCozySocialTitle": MessageLookupByLibrary.simpleMessage(
      "နွေးနွေးထွေးထွေး လူမှုရေး",
    ),
    "vibeDefaultSummary": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်သည် မျှတသလို ခံစားရပါသည်။",
    ),
    "vibeDefaultTitle": MessageLookupByLibrary.simpleMessage("မျှတသောအိမ်"),
    "vibeEasygoingSummary": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်သည် သက်သောင့်သက်သာနှင့် လိုက်လျောညီထွေဖြစ်သလို ခံစားရပါသည်။",
    ),
    "vibeEasygoingTitle": MessageLookupByLibrary.simpleMessage(
      "ပေါ့ပေါ့ပါးပါး စီးဆင်းမှု",
    ),
    "vibeIndependentSummary": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်သည် ကိုယ်ပိုင်နေရာနှင့် တိတ်ဆိတ်မှုကို တန်ဖိုးထားပါသည်။",
    ),
    "vibeIndependentTitle": MessageLookupByLibrary.simpleMessage(
      "ကိုယ်ပိုင်နေရာရှိသော အေးချမ်းမှု",
    ),
    "vibeInsufficientSummary": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ် vibe ကို ကြည့်ရန် အကြိုက်များကို ဖြည့်ပါ။",
    ),
    "vibeInsufficientTitle": MessageLookupByLibrary.simpleMessage(
      "ဒေတာ မလုံလောက်သေးပါ",
    ),
    "vibeMixedSummary": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်တွင် နေထိုင်မှုပုံစံများ ရောနှောနေပါသည်။",
    ),
    "vibeMixedTitle": MessageLookupByLibrary.simpleMessage("ရောနှောအိမ်"),
    "vibeQuietCareSummary": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်သည် တည်ငြိမ်ပြီး နူးညံ့သလို ခံစားရပါသည်။",
    ),
    "vibeQuietCareTitle": MessageLookupByLibrary.simpleMessage(
      "တိတ်ဆိတ်စွာ ဂရုစိုက်ခြင်း",
    ),
    "vibeSocialSummary": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်သည် တက်ကြွပြီး လူမှုရေးဆန်သလို ခံစားရပါသည်။",
    ),
    "vibeSocialTitle": MessageLookupByLibrary.simpleMessage("လူမှုရေးစွမ်းအင်"),
    "vibeSteadySummary": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်သည် တည်ငြိမ်ပြီး အမြဲတမ်းတူညီသလို ခံစားရပါသည်။",
    ),
    "vibeSteadyTitle": MessageLookupByLibrary.simpleMessage(
      "တည်ငြိမ်သော အေးချမ်းမှု",
    ),
    "vibeStructuredSummary": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်သည် အစီအစဉ်များနှင့် ပုံမှန်လုပ်ရိုးလုပ်စဉ်များဖြင့် ပိုကောင်းစွာ လည်ပတ်သည်။",
    ),
    "vibeStructuredTitle": MessageLookupByLibrary.simpleMessage(
      "ဖွဲ့စည်းထားသော လှုပ်ရှားမှုစည်းချက်",
    ),
    "vibeWarmSocialSummary": MessageLookupByLibrary.simpleMessage(
      "သင့်အိမ်သည် နွေးထွေးပြီး ကြိုဆိုသလို ခံစားရပါသည်။",
    ),
    "vibeWarmSocialTitle": MessageLookupByLibrary.simpleMessage(
      "နွေးထွေးသော လူမှုရေး",
    ),
    "weeklyRewriteCta": MessageLookupByLibrary.simpleMessage(
      "Kinly ဖြင့် တည်ငြိမ်စွာ ပို့မည်",
    ),
    "welcome_create": MessageLookupByLibrary.simpleMessage(
      "အိမ်တစ်ခု ဖန်တီးမည်",
    ),
    "welcome_join": MessageLookupByLibrary.simpleMessage(
      "အိမ်တစ်ခုသို့ ဝင်မည်",
    ),
    "welcome_title": MessageLookupByLibrary.simpleMessage(
      "Kinly မှ ကြိုဆိုပါသည်",
    ),
  };
}
