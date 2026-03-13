// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static String m0(env) => "正在启动 Kinly（${env}）";

  static String m1(time) => "已安排在 ${time}";

  static String m2(current) => "演示入口：已点击 ${current} / 7 次";

  static String m3(appName) => "由 ${appName} 制作 · 一起住，轻松一点";

  static String m4(link) => "这是我们在 Kinly 家庭里的几句感谢。下载应用：${link}";

  static String m5(weeks) =>
      "${Intl.plural(weeks, zero: '本周', one: '# 周前', other: '# 周前')}";

  static String m6(partOfDay, name) => "${partOfDay}好，${name}";

  static String m7(answered, total) => "已有 ${answered}/${total} 位成员完成填写";

  static String m8(current, total) => "${current}/${total}";

  static String m9(link) => "这是我们在 Kinly 的家庭脉搏。下载应用：${link}";

  static String m10(date) => "更新于 ${date}";

  static String m11(link) => "这是我们的 Kinly 家庭氛围。下载应用：${link}";

  static String m12(link) => "用 Kinly，让共享生活更轻松：${link}";

  static String m13(code, link) =>
      "使用这个邀请码加入我们的 Kinly 家庭：${code}\n\n下载 Kinly：${link}";

  static String m14(code) => "你已成功加入家庭。";

  static String m15(price) => "每月 ${price}";

  static String m16(current, total) => "${current}/${total}";

  static String m17(period) => "适用周期：${period}";

  static String m18(total, included, difference) =>
      "分摊金额不一致。总额：${total}，已分配：${included}，差额：${difference}。";

  static String m19(paidAmount, totalAmount) =>
      "已收 ${paidAmount} / 共 ${totalAmount}";

  static String m20(paid, total) => "已支付 ${paid}/${total}";

  static String m21(count) =>
      "${Intl.plural(count, one: '${count} 件待购买', other: '${count} 件待购买')}";

  static String m22(name) => "你好，${name}";

  static String m23(count) =>
      "查看全部 ${Intl.plural(count, one: '(#)', other: '(#)')}";

  static String m24(name) => "暂时无法完成 ${name} 的加入请求。";

  static String m25(name) => "${name} 已加入你的家庭。";

  static String m26(name) => "${name} 已加入其他家庭。";

  static String m27(names) => "${names} 想加入你的家庭。升级后可支持无限成员。";

  static String m28(count) =>
      "${Intl.plural(count, one: '${count} 笔待付款', other: '${count} 笔待结算')}";

  static String m29(count) =>
      "${Intl.plural(count, one: '${count} 笔新收款', other: '${count} 笔新收款')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("Kinly"),
    "authMembershipLoadFailed": MessageLookupByLibrary.simpleMessage(
      "暂时无法刷新你的家庭信息。",
    ),
    "bootstrap_initializing": m0,
    "close": MessageLookupByLibrary.simpleMessage("关闭"),
    "connectionNotificationsPermissionBlocked":
        MessageLookupByLibrary.simpleMessage("请先到手机系统设置里开启通知权限。"),
    "connectionNotificationsTimeLabel": MessageLookupByLibrary.simpleMessage(
      "提醒时间",
    ),
    "connectionNotificationsTimeSubtitle": m1,
    "connectionNotificationsToggleSubtitleOff":
        MessageLookupByLibrary.simpleMessage("开启提醒，帮助你留意家庭事项。"),
    "connectionNotificationsToggleSubtitleOn":
        MessageLookupByLibrary.simpleMessage("每天接收一次提醒。"),
    "connectionNotificationsToggleTitle": MessageLookupByLibrary.simpleMessage(
      "每日提醒",
    ),
    "connectionSettingsGenericError": MessageLookupByLibrary.simpleMessage(
      "暂时无法更新通知设置。",
    ),
    "connectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "设置每日提醒与提醒时间。",
    ),
    "connectionSettingsTitle": MessageLookupByLibrary.simpleMessage("通知设置"),
    "create_failed_generic": MessageLookupByLibrary.simpleMessage("暂时无法创建家庭。"),
    "demoAccess": MessageLookupByLibrary.simpleMessage("演示入口"),
    "demoAccessEmail": MessageLookupByLibrary.simpleMessage("邮箱"),
    "demoAccessError": MessageLookupByLibrary.simpleMessage("暂时无法登录，请检查账号信息。"),
    "demoAccessPassword": MessageLookupByLibrary.simpleMessage("密码"),
    "demoAccessSubmit": MessageLookupByLibrary.simpleMessage("登录"),
    "demoAccessTapHint": m2,
    "exploreFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "查看有哪些任务、由谁负责。",
    ),
    "exploreIntroSubtitle": MessageLookupByLibrary.simpleMessage("把共享的事说清楚。"),
    "exploreShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "查看你创建的账单并跟进收款情况。",
    ),
    "exploreShoppingSectionTitle": MessageLookupByLibrary.simpleMessage("购物清单"),
    "exploreShoppingSubtitle": MessageLookupByLibrary.simpleMessage(
      "查看和管理共享购物项目。",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage("由谁来做？"),
    "flowChoreCreateSuccess": MessageLookupByLibrary.simpleMessage("任务已创建。"),
    "flowChoreCreateTitle": MessageLookupByLibrary.simpleMessage("添加任务"),
    "flowChoreDeleteButton": MessageLookupByLibrary.simpleMessage("删除任务"),
    "flowChoreDeleteConfirm": MessageLookupByLibrary.simpleMessage("删除"),
    "flowChoreDeleteDialogMessage": MessageLookupByLibrary.simpleMessage(
      "删除后，这个任务会从整个家庭中移除。",
    ),
    "flowChoreDeleteDialogTitle": MessageLookupByLibrary.simpleMessage(
      "要删除这个任务吗？",
    ),
    "flowChoreDetailCompleteButton": MessageLookupByLibrary.simpleMessage(
      "标记完成",
    ),
    "flowChoreDetailCompletionError": MessageLookupByLibrary.simpleMessage(
      "暂时无法完成这个任务。",
    ),
    "flowChoreDetailCompletionSuccess": MessageLookupByLibrary.simpleMessage(
      "任务已完成。",
    ),
    "flowChoreDetailMoreInfoTitle": MessageLookupByLibrary.simpleMessage(
      "补充说明",
    ),
    "flowChoreDetailTitle": MessageLookupByLibrary.simpleMessage("任务详情"),
    "flowChoreDetailUnassigned": MessageLookupByLibrary.simpleMessage("未分配"),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage("编辑任务"),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "这个人目前不在你的家庭中。",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "你目前没有权限修改这个任务。",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "暂时无法保存这个任务。",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "这张照片不属于这个家庭。",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "请选择有效的开始日期。",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "这个任务当前无法编辑。",
    ),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "免费版的进行中任务数量已达上限，升级后可继续添加。",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "免费版的任务照片数量已达上限，升级后可继续添加。",
    ),
    "flowChoreExpectationPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "参考照片",
    ),
    "flowChoreHowToHint": MessageLookupByLibrary.simpleMessage(
      "如果有固定做法，可以贴上链接",
    ),
    "flowChoreHowToLabel": MessageLookupByLibrary.simpleMessage("怎么做（可选）"),
    "flowChoreHowToLaunchError": MessageLookupByLibrary.simpleMessage(
      "暂时无法打开这个链接。",
    ),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage("暂时无法加载这个任务。"),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage("例如：倒垃圾、清冰箱、浇植物"),
    "flowChoreNameLabel": MessageLookupByLibrary.simpleMessage("需要做什么？"),
    "flowChoreNotesHint": MessageLookupByLibrary.simpleMessage("补充一些背景，方便大家理解"),
    "flowChoreNotesLabel": MessageLookupByLibrary.simpleMessage("为什么重要"),
    "flowChorePhotoLabel": MessageLookupByLibrary.simpleMessage("理想参考图"),
    "flowChorePhotoLoadError": MessageLookupByLibrary.simpleMessage(
      "暂时无法加载照片。",
    ),
    "flowChorePhotoPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "请开启相机权限后再拍照。",
    ),
    "flowChorePhotoPermissionOpenSettings":
        MessageLookupByLibrary.simpleMessage("前往设置"),
    "flowChorePhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "添加照片，让大家更清楚完成标准",
    ),
    "flowChorePhotoUploadError": MessageLookupByLibrary.simpleMessage(
      "暂时无法上传照片。",
    ),
    "flowChoreRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "这个任务多久发生一次？",
    ),
    "flowChoreRecurrenceNone": MessageLookupByLibrary.simpleMessage("一次性"),
    "flowChoreRetry": MessageLookupByLibrary.simpleMessage("重试"),
    "flowChoreStartLabel": MessageLookupByLibrary.simpleMessage("什么时候进行？"),
    "flowChoreSubmitCreate": MessageLookupByLibrary.simpleMessage("创建任务"),
    "flowChoreSubmitUpdate": MessageLookupByLibrary.simpleMessage("保存修改"),
    "flowChoreUpdateSuccess": MessageLookupByLibrary.simpleMessage("任务已更新。"),
    "flowChoreValidationAssignee": MessageLookupByLibrary.simpleMessage(
      "请选择一位成员。",
    ),
    "flowChoreValidationDate": MessageLookupByLibrary.simpleMessage(
      "请选择未来一年内的日期。",
    ),
    "flowChoreValidationHowToUrl": MessageLookupByLibrary.simpleMessage(
      "请输入以 http 或 https 开头的有效链接。",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage("请输入任务名称。"),
    "flowChoreViewTitle": MessageLookupByLibrary.simpleMessage("查看任务"),
    "flowListDraftLabel": MessageLookupByLibrary.simpleMessage("草稿"),
    "flowListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "任务可以帮助大家更清楚地分工。",
    ),
    "flowListEmptyTitle": MessageLookupByLibrary.simpleMessage("这里还没有内容"),
    "flowListError": MessageLookupByLibrary.simpleMessage("暂时无法加载任务，下拉可刷新。"),
    "flowListOverdueLabel": MessageLookupByLibrary.simpleMessage("需要留意"),
    "flowListTabCurrent": MessageLookupByLibrary.simpleMessage("当前"),
    "flowListTabFuture": MessageLookupByLibrary.simpleMessage("即将开始"),
    "force_update_body": MessageLookupByLibrary.simpleMessage(
      "当前版本的 Kinly 已不再支持，请更新后继续使用。",
    ),
    "force_update_button": MessageLookupByLibrary.simpleMessage("更新 Kinly"),
    "force_update_title": MessageLookupByLibrary.simpleMessage("需要更新"),
    "friendDefaultName": MessageLookupByLibrary.simpleMessage("朋友"),
    "gratitudeWallEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "写下一句这周值得感谢的话吧。",
    ),
    "gratitudeWallEmptyTitle": MessageLookupByLibrary.simpleMessage("还没有感谢"),
    "gratitudeWallErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "暂时无法加载感谢内容。",
    ),
    "gratitudeWallFooter": m3,
    "gratitudeWallHouseTab": MessageLookupByLibrary.simpleMessage("家庭"),
    "gratitudeWallPersonalSummary": MessageLookupByLibrary.simpleMessage(
      "留给自己的一个小小感谢角落。",
    ),
    "gratitudeWallPersonalTab": MessageLookupByLibrary.simpleMessage("我的"),
    "gratitudeWallPersonalTitle": MessageLookupByLibrary.simpleMessage("我的感谢"),
    "gratitudeWallRetry": MessageLookupByLibrary.simpleMessage("重试"),
    "gratitudeWallShareCta": MessageLookupByLibrary.simpleMessage("分享"),
    "gratitudeWallShareError": MessageLookupByLibrary.simpleMessage("暂时无法分享。"),
    "gratitudeWallShareMessage": m4,
    "gratitudeWallShareTitle": MessageLookupByLibrary.simpleMessage("家庭感谢"),
    "gratitudeWallStatsHomes": MessageLookupByLibrary.simpleMessage("家庭数"),
    "gratitudeWallStatsMentions": MessageLookupByLibrary.simpleMessage("感谢次数"),
    "gratitudeWallStatsPeople": MessageLookupByLibrary.simpleMessage("提及人数"),
    "gratitudeWallWeeksAgo": m5,
    "greetingPartOfDay": m6,
    "harmonyCommentHint": MessageLookupByLibrary.simpleMessage(
      "如果有帮助，可以补充一点背景",
    ),
    "harmonyCommentLabel": MessageLookupByLibrary.simpleMessage("可选备注"),
    "harmonyErrorAlreadySubmitted": MessageLookupByLibrary.simpleMessage(
      "你本周已经提交过了。",
    ),
    "harmonyErrorCommentRequiredForMention":
        MessageLookupByLibrary.simpleMessage("请先写一点说明，再发送这条提及。"),
    "harmonyErrorCommentRequiredForPublicWall":
        MessageLookupByLibrary.simpleMessage("发到公开墙前，请先补上一句内容。"),
    "harmonyErrorComplaintNeedsSentence": MessageLookupByLibrary.simpleMessage(
      "请补上一句清楚的话。",
    ),
    "harmonyErrorComplaintTooBrief": MessageLookupByLibrary.simpleMessage(
      "请写成一句简短的话，让意思更明确。",
    ),
    "harmonyErrorComplaintTooShort": MessageLookupByLibrary.simpleMessage(
      "再多写一点会更清楚。",
    ),
    "harmonyErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "目前暂时无法使用每周反馈。",
    ),
    "harmonyErrorSingleMentionRequired": MessageLookupByLibrary.simpleMessage(
      "这条内容只能选择 1 位成员。",
    ),
    "harmonyErrorUnknown": MessageLookupByLibrary.simpleMessage("出了点问题，请稍后再试。"),
    "harmonyFeedbackSingleHousemateHint": MessageLookupByLibrary.simpleMessage(
      "输入 @ 可提及 1 位室友。",
    ),
    "harmonyMoodCloudy": MessageLookupByLibrary.simpleMessage("多云"),
    "harmonyMoodPartiallySunny": MessageLookupByLibrary.simpleMessage("局部晴朗"),
    "harmonyMoodRainy": MessageLookupByLibrary.simpleMessage("下雨"),
    "harmonyMoodSunny": MessageLookupByLibrary.simpleMessage("晴朗"),
    "harmonyMoodThunderstorm": MessageLookupByLibrary.simpleMessage("雷雨"),
    "harmonyQuestion": MessageLookupByLibrary.simpleMessage(
      "这周有什么地方做得不错，或需要调整？",
    ),
    "harmonyShareLabel": MessageLookupByLibrary.simpleMessage("家庭内所有人可见"),
    "harmonySubmitCta": MessageLookupByLibrary.simpleMessage("保存"),
    "harmonySubmitSuccess": MessageLookupByLibrary.simpleMessage("已保存"),
    "homeVibeCoverage": m7,
    "homeVibeTitle": MessageLookupByLibrary.simpleMessage("家庭氛围"),
    "houseNormCopyUrlCta": MessageLookupByLibrary.simpleMessage("复制链接"),
    "houseNormDoneCta": MessageLookupByLibrary.simpleMessage("完成"),
    "houseNormEditTitle": MessageLookupByLibrary.simpleMessage("编辑家庭共识"),
    "houseNormGenerationFailed": MessageLookupByLibrary.simpleMessage(
      "暂时无法生成家庭共识。",
    ),
    "houseNormOnboardingBack": MessageLookupByLibrary.simpleMessage("返回"),
    "houseNormOnboardingProgress": m8,
    "houseNormOnboardingSubmit": MessageLookupByLibrary.simpleMessage("生成"),
    "houseNormOnboardingTitle": MessageLookupByLibrary.simpleMessage("家庭氛围"),
    "houseNormPromptCta": MessageLookupByLibrary.simpleMessage("开始生成"),
    "houseNormPromptSubtitle": MessageLookupByLibrary.simpleMessage(
      "把大家的回答整理成一份共享指南。",
    ),
    "houseNormPromptTitle": MessageLookupByLibrary.simpleMessage("生成家庭共识"),
    "houseNormPublishCta": MessageLookupByLibrary.simpleMessage("发布到网页"),
    "houseNormReportEmptyBody": MessageLookupByLibrary.simpleMessage(
      "生成后即可在这里查看。",
    ),
    "houseNormReportEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "家庭共识尚未生成",
    ),
    "houseNormReportErrorBody": MessageLookupByLibrary.simpleMessage("请稍后再试。"),
    "houseNormReportErrorTitle": MessageLookupByLibrary.simpleMessage(
      "暂时无法加载家庭共识",
    ),
    "houseNormReportTitle": MessageLookupByLibrary.simpleMessage("家庭共识"),
    "houseNormRepublishCta": MessageLookupByLibrary.simpleMessage("重新发布"),
    "houseNormScenarioGuestsOption1": MessageLookupByLibrary.simpleMessage(
      "最好先问一下",
    ),
    "houseNormScenarioGuestsOption2": MessageLookupByLibrary.simpleMessage(
      "提前说一声",
    ),
    "houseNormScenarioGuestsOption3": MessageLookupByLibrary.simpleMessage(
      "很正常，不用特别说明",
    ),
    "houseNormScenarioGuestsQuestion": MessageLookupByLibrary.simpleMessage(
      "带朋友来家里时：",
    ),
    "houseNormScenarioHomeIdentityOption1":
        MessageLookupByLibrary.simpleMessage("安静型家庭"),
    "houseNormScenarioHomeIdentityOption2":
        MessageLookupByLibrary.simpleMessage("平衡型家庭"),
    "houseNormScenarioHomeIdentityOption3":
        MessageLookupByLibrary.simpleMessage("社交型家庭"),
    "houseNormScenarioHomeIdentityQuestion":
        MessageLookupByLibrary.simpleMessage("这个家更像："),
    "houseNormScenarioPropertyContextOption1":
        MessageLookupByLibrary.simpleMessage("自住房"),
    "houseNormScenarioPropertyContextOption2":
        MessageLookupByLibrary.simpleMessage("整租"),
    "houseNormScenarioPropertyContextOption3":
        MessageLookupByLibrary.simpleMessage("分租"),
    "houseNormScenarioPropertyContextQuestion":
        MessageLookupByLibrary.simpleMessage("这个家目前是："),
    "houseNormScenarioRelationshipModelOption1":
        MessageLookupByLibrary.simpleMessage("室友"),
    "houseNormScenarioRelationshipModelOption2":
        MessageLookupByLibrary.simpleMessage("家人"),
    "houseNormScenarioRelationshipModelOption3":
        MessageLookupByLibrary.simpleMessage("混合"),
    "houseNormScenarioRelationshipModelQuestion":
        MessageLookupByLibrary.simpleMessage("住在这里的是："),
    "houseNormScenarioRepairOption1": MessageLookupByLibrary.simpleMessage(
      "尽早说开",
    ),
    "houseNormScenarioRepairOption2": MessageLookupByLibrary.simpleMessage(
      "挑适合的时候再说",
    ),
    "houseNormScenarioRepairOption3": MessageLookupByLibrary.simpleMessage(
      "小事就先放过去",
    ),
    "houseNormScenarioRepairQuestion": MessageLookupByLibrary.simpleMessage(
      "如果有一点摩擦：",
    ),
    "houseNormScenarioResponsibilityOption1":
        MessageLookupByLibrary.simpleMessage("说清楚由谁负责"),
    "houseNormScenarioResponsibilityOption2":
        MessageLookupByLibrary.simpleMessage("谁看到谁处理"),
    "houseNormScenarioResponsibilityOption3":
        MessageLookupByLibrary.simpleMessage("大家各管各的"),
    "houseNormScenarioResponsibilityQuestion":
        MessageLookupByLibrary.simpleMessage("家里的小事通常怎么处理？"),
    "houseNormScenarioRhythmOption1": MessageLookupByLibrary.simpleMessage(
      "慢慢安静下来",
    ),
    "houseNormScenarioRhythmOption2": MessageLookupByLibrary.simpleMessage(
      "看情况",
    ),
    "houseNormScenarioRhythmOption3": MessageLookupByLibrary.simpleMessage(
      "大家各自活动",
    ),
    "houseNormScenarioRhythmQuestion": MessageLookupByLibrary.simpleMessage(
      "到了晚上，这个家的节奏通常是：",
    ),
    "houseNormScenarioSharedSpacesOption1":
        MessageLookupByLibrary.simpleMessage("整洁一些"),
    "houseNormScenarioSharedSpacesOption2":
        MessageLookupByLibrary.simpleMessage("有生活感就好"),
    "houseNormScenarioSharedSpacesOption3":
        MessageLookupByLibrary.simpleMessage("乱一点也没关系"),
    "houseNormScenarioSharedSpacesQuestion":
        MessageLookupByLibrary.simpleMessage("晚上厨房更适合保持："),
    "houseNormSectionEditLabel": MessageLookupByLibrary.simpleMessage("编辑这一部分"),
    "houseNormSectionEmptyError": MessageLookupByLibrary.simpleMessage(
      "请先输入内容再保存。",
    ),
    "houseNormSectionFallbackTitle": MessageLookupByLibrary.simpleMessage("章节"),
    "houseNormSectionGuestsSocialTitle": MessageLookupByLibrary.simpleMessage(
      "来访与社交",
    ),
    "houseNormSectionHomeIdentityTitle": MessageLookupByLibrary.simpleMessage(
      "这个家的感觉",
    ),
    "houseNormSectionRepairStyleTitle": MessageLookupByLibrary.simpleMessage(
      "修复与沟通",
    ),
    "houseNormSectionResponsibilityFlowTitle":
        MessageLookupByLibrary.simpleMessage("责任分工"),
    "houseNormSectionRhythmQuietTitle": MessageLookupByLibrary.simpleMessage(
      "节奏与安静",
    ),
    "houseNormSectionSaveCta": MessageLookupByLibrary.simpleMessage("保存"),
    "houseNormSectionSaveFailed": MessageLookupByLibrary.simpleMessage(
      "暂时无法保存这次更新。",
    ),
    "houseNormSectionSaveSuccess": MessageLookupByLibrary.simpleMessage("已更新。"),
    "houseNormSectionSharedSpacesTitle": MessageLookupByLibrary.simpleMessage(
      "共享空间",
    ),
    "houseNormShareSubject": MessageLookupByLibrary.simpleMessage("我们的家庭共识"),
    "houseNormShareUrlCta": MessageLookupByLibrary.simpleMessage("分享链接"),
    "houseNormSummaryFramingLabel": MessageLookupByLibrary.simpleMessage("总结"),
    "houseNormSummarySubtitle": MessageLookupByLibrary.simpleMessage(
      "它不是规则书，而是一份彼此更好相处的指南。",
    ),
    "houseNormSummaryTitle": MessageLookupByLibrary.simpleMessage("家庭共识"),
    "houseNormUrlCopied": MessageLookupByLibrary.simpleMessage("家庭共识链接已复制。"),
    "houseNormViewTitle": MessageLookupByLibrary.simpleMessage("查看家庭共识"),
    "housePulseCardHeader": MessageLookupByLibrary.simpleMessage("每周家庭脉搏"),
    "housePulseShareCta": MessageLookupByLibrary.simpleMessage("分享脉搏"),
    "housePulseShareMessage": m9,
    "housePulseShareTitle": MessageLookupByLibrary.simpleMessage(
      "分享我们的 Kinly 家庭脉搏",
    ),
    "housePulseUpdatedOn": m10,
    "houseVibeShareCta": MessageLookupByLibrary.simpleMessage("分享氛围"),
    "houseVibeShareError": MessageLookupByLibrary.simpleMessage("暂时无法分享。"),
    "houseVibeShareMessage": m11,
    "houseVibeShareTitle": MessageLookupByLibrary.simpleMessage("家庭氛围"),
    "hubCardGratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "记录这个家里小小的感谢。",
    ),
    "hubCardGratitudeWallTitle": MessageLookupByLibrary.simpleMessage("感谢墙"),
    "hubCodeCopied": MessageLookupByLibrary.simpleMessage("邀请码已复制"),
    "hubError": MessageLookupByLibrary.simpleMessage("暂时无法加载家庭中心。"),
    "hubHouseNormsSubtitle": MessageLookupByLibrary.simpleMessage(
      "看看这个家希望怎样一起生活。",
    ),
    "hubHouseNormsTitle": MessageLookupByLibrary.simpleMessage("家庭共识"),
    "hubInviteCta": MessageLookupByLibrary.simpleMessage("邀请成员"),
    "hubInviteUnavailable": MessageLookupByLibrary.simpleMessage("暂时无法加载邀请码。"),
    "hubMembersEmpty": MessageLookupByLibrary.simpleMessage("目前还没有活跃成员。"),
    "hubPreferencesSubtitle": MessageLookupByLibrary.simpleMessage(
      "看看每个人喜欢怎样的共享生活方式。",
    ),
    "hubPreferencesTitle": MessageLookupByLibrary.simpleMessage("生活偏好"),
    "hubQrSubtitle": MessageLookupByLibrary.simpleMessage("扫码下载 Kinly"),
    "hubQrTitle": MessageLookupByLibrary.simpleMessage("分享应用"),
    "hubRetry": MessageLookupByLibrary.simpleMessage("重试"),
    "hubRotateError": MessageLookupByLibrary.simpleMessage("暂时无法更新邀请码。"),
    "hubRotateInvite": MessageLookupByLibrary.simpleMessage("更换邀请码"),
    "hubRotateSuccess": MessageLookupByLibrary.simpleMessage("邀请码已更新"),
    "hubShareAppBody": m12,
    "hubShareAppCta": MessageLookupByLibrary.simpleMessage("分享 Kinly"),
    "hubShareAppTitle": MessageLookupByLibrary.simpleMessage("获取 Kinly"),
    "hubShareInviteBody": m13,
    "hubShareInviteTitle": MessageLookupByLibrary.simpleMessage(
      "邀请加入我的 Kinly 家庭",
    ),
    "join_blocked_body": MessageLookupByLibrary.simpleMessage("我们已经通知房主了。"),
    "join_blocked_cta": MessageLookupByLibrary.simpleMessage("知道了"),
    "join_blocked_title": MessageLookupByLibrary.simpleMessage(
      "这个家庭目前暂时无法加入新成员",
    ),
    "join_error_already_in_other_home": MessageLookupByLibrary.simpleMessage(
      "请先退出你当前加入的家庭。",
    ),
    "join_error_forbidden": MessageLookupByLibrary.simpleMessage(
      "你目前没有权限加入这个家庭。",
    ),
    "join_error_inactive_invite": MessageLookupByLibrary.simpleMessage(
      "这个邀请码已失效，请联系房主获取新的邀请码。",
    ),
    "join_error_invalid_code": MessageLookupByLibrary.simpleMessage(
      "这个邀请码看起来不对。",
    ),
    "join_error_paywall_limit": MessageLookupByLibrary.simpleMessage(
      "这个家庭已达到成员上限，请房主升级或移除成员后再试。",
    ),
    "join_error_unauthorized": MessageLookupByLibrary.simpleMessage(
      "请先登录后再加入家庭。",
    ),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage("暂时无法加入这个家庭。"),
    "join_hint": MessageLookupByLibrary.simpleMessage("输入邀请码（例如：ABC123）"),
    "join_submit": MessageLookupByLibrary.simpleMessage("加入"),
    "join_success": m14,
    "join_title": MessageLookupByLibrary.simpleMessage("加入家庭"),
    "login_consent_connector": MessageLookupByLibrary.simpleMessage("和"),
    "login_consent_prefix": MessageLookupByLibrary.simpleMessage("我同意"),
    "login_privacy": MessageLookupByLibrary.simpleMessage("隐私政策"),
    "login_tagline": MessageLookupByLibrary.simpleMessage("一起住，轻松一点"),
    "login_terms": MessageLookupByLibrary.simpleMessage("服务条款"),
    "login_with_apple": MessageLookupByLibrary.simpleMessage("使用 Apple 继续"),
    "login_with_google": MessageLookupByLibrary.simpleMessage("使用 Google 继续"),
    "logout": MessageLookupByLibrary.simpleMessage("退出登录"),
    "membership_status_active": MessageLookupByLibrary.simpleMessage(
      "你已连接到一个家庭。",
    ),
    "membership_status_checking": MessageLookupByLibrary.simpleMessage(
      "正在连接你的家庭...",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "创建或加入一个家庭。",
    ),
    "mentionFieldHint": MessageLookupByLibrary.simpleMessage("输入 @ 提及某个人"),
    "navExplore": MessageLookupByLibrary.simpleMessage("管理"),
    "navHub": MessageLookupByLibrary.simpleMessage("家庭中心"),
    "navToday": MessageLookupByLibrary.simpleMessage("今天"),
    "npsCannotSkip": MessageLookupByLibrary.simpleMessage("请选择一个分数后再继续。"),
    "npsDescription": MessageLookupByLibrary.simpleMessage(
      "0 表示完全没有帮助，10 表示真的带来了明显改变。",
    ),
    "npsEmailSubject": MessageLookupByLibrary.simpleMessage(
      "Kinly 还可以怎样更好地支持你的家庭？",
    ),
    "npsLaunchError": MessageLookupByLibrary.simpleMessage("暂时无法打开下一步。"),
    "npsScaleHighLabel": MessageLookupByLibrary.simpleMessage("10 真的有明显帮助"),
    "npsScaleLowLabel": MessageLookupByLibrary.simpleMessage("0 完全没有帮助"),
    "npsSubmitErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "目前暂时无法提交反馈。",
    ),
    "npsSubmitErrorGeneric": MessageLookupByLibrary.simpleMessage("暂时无法发送反馈。"),
    "npsSubmitErrorInvalidScore": MessageLookupByLibrary.simpleMessage(
      "请选择 0 到 10 之间的分数。",
    ),
    "npsSubmitErrorNotRequired": MessageLookupByLibrary.simpleMessage(
      "你现在暂时不需要填写这项反馈。",
    ),
    "npsTitle": MessageLookupByLibrary.simpleMessage("Kinly 是否让你的家庭运转得更顺一点？"),
    "offline_body": MessageLookupByLibrary.simpleMessage("当前没有网络连接，请稍后重试。"),
    "offline_retry": MessageLookupByLibrary.simpleMessage("再试一次"),
    "offline_title": MessageLookupByLibrary.simpleMessage("你当前处于离线状态"),
    "paywallBulletFlows": MessageLookupByLibrary.simpleMessage("无限任务"),
    "paywallBulletMembers": MessageLookupByLibrary.simpleMessage("无限成员"),
    "paywallBulletPhotos": MessageLookupByLibrary.simpleMessage("无限任务照片"),
    "paywallBulletShares": MessageLookupByLibrary.simpleMessage("无限账单"),
    "paywallBulletShoppingPhotos": MessageLookupByLibrary.simpleMessage(
      "无限购物照片",
    ),
    "paywallErrorTitle": MessageLookupByLibrary.simpleMessage("暂时无法加载订阅信息。"),
    "paywallFeatureUnlimitedSharedExpensePhotos":
        MessageLookupByLibrary.simpleMessage("无限账单照片"),
    "paywallPriceCaption": MessageLookupByLibrary.simpleMessage(
      "一个家庭方案，没有隐藏等级。",
    ),
    "paywallPricePerMonth": m15,
    "paywallPriceUnavailable": MessageLookupByLibrary.simpleMessage(
      "目前暂时无法显示价格。",
    ),
    "paywallPrimaryCta": MessageLookupByLibrary.simpleMessage("升级到 Premium"),
    "paywallPurchaseFailed": MessageLookupByLibrary.simpleMessage("购买未完成。"),
    "paywallPurchaseSuccess": MessageLookupByLibrary.simpleMessage(
      "你已成功升级到 Kinly Premium。",
    ),
    "paywallRestoreCta": MessageLookupByLibrary.simpleMessage("恢复购买"),
    "paywallRetryLabel": MessageLookupByLibrary.simpleMessage("重试"),
    "paywallSecondaryCta": MessageLookupByLibrary.simpleMessage("继续使用免费版"),
    "paywallSubtitle": MessageLookupByLibrary.simpleMessage("不到房租的 0.5%。"),
    "paywallTitle": MessageLookupByLibrary.simpleMessage("让共享生活更顺一点"),
    "personalMentionsTitle": MessageLookupByLibrary.simpleMessage("个人提及"),
    "personalProfileLoadError": MessageLookupByLibrary.simpleMessage(
      "暂时无法加载你的个人资料。",
    ),
    "personalProfileMentions": MessageLookupByLibrary.simpleMessage("个人提及"),
    "personalProfilePreferences": MessageLookupByLibrary.simpleMessage("个人偏好"),
    "personalProfileTitle": MessageLookupByLibrary.simpleMessage("你的资料"),
    "planFreeLabel": MessageLookupByLibrary.simpleMessage("升级到 Premium"),
    "planPremiumActiveBody": MessageLookupByLibrary.simpleMessage(
      "尽情使用所有无限制功能。",
    ),
    "planPremiumActiveTitle": MessageLookupByLibrary.simpleMessage(
      "你正在使用 Premium",
    ),
    "planPremiumLabel": MessageLookupByLibrary.simpleMessage("Premium"),
    "preferenceOnboardingBack": MessageLookupByLibrary.simpleMessage("返回"),
    "preferenceOnboardingProgress": m16,
    "preferenceOnboardingSubmit": MessageLookupByLibrary.simpleMessage("保存"),
    "preferenceOnboardingTitle": MessageLookupByLibrary.simpleMessage("你的生活偏好"),
    "preferencePromptCta": MessageLookupByLibrary.simpleMessage("开始填写"),
    "preferencePromptSubtitle": MessageLookupByLibrary.simpleMessage(
      "帮助这个家更了解什么方式让你住得舒服。",
    ),
    "preferencePromptTitle": MessageLookupByLibrary.simpleMessage("设置你的生活风格"),
    "preferenceReportDoneCta": MessageLookupByLibrary.simpleMessage("完成"),
    "preferenceReportEditCta": MessageLookupByLibrary.simpleMessage("编辑"),
    "preferenceReportEditError": MessageLookupByLibrary.simpleMessage(
      "暂时无法保存这次更新。",
    ),
    "preferenceReportEditSectionDone": MessageLookupByLibrary.simpleMessage(
      "完成",
    ),
    "preferenceReportEditSectionHint": MessageLookupByLibrary.simpleMessage(
      "写下对你来说更舒服的方式",
    ),
    "preferenceReportEditSectionPrompt": MessageLookupByLibrary.simpleMessage(
      "编辑这一部分",
    ),
    "preferenceReportEditTitle": MessageLookupByLibrary.simpleMessage("编辑偏好"),
    "preferenceReportEmptyBody": MessageLookupByLibrary.simpleMessage(
      "完成偏好设置后，就能生成你的个人报告。",
    ),
    "preferenceReportEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "偏好报告尚未生成",
    ),
    "preferenceReportErrorBody": MessageLookupByLibrary.simpleMessage("请稍后重试。"),
    "preferenceReportErrorTitle": MessageLookupByLibrary.simpleMessage(
      "暂时无法加载报告",
    ),
    "preferenceReportGenerationFailed": MessageLookupByLibrary.simpleMessage(
      "暂时无法生成你的偏好整理，请返回后重试。",
    ),
    "preferenceReportGenerationMissing": MessageLookupByLibrary.simpleMessage(
      "暂时无法完成你的偏好整理，请稍后再试。",
    ),
    "preferenceReportReadOnlyNote": MessageLookupByLibrary.simpleMessage(
      "这能帮助别人理解什么方式会让他们更舒服。",
    ),
    "preferenceReportTitle": MessageLookupByLibrary.simpleMessage("你的偏好报告"),
    "preferenceReportViewTitle": MessageLookupByLibrary.simpleMessage("查看偏好"),
    "preferenceScenarioCleanlinessSharedSpaceOption1":
        MessageLookupByLibrary.simpleMessage("尽量整洁"),
    "preferenceScenarioCleanlinessSharedSpaceOption2":
        MessageLookupByLibrary.simpleMessage("稍微乱一点也可以"),
    "preferenceScenarioCleanlinessSharedSpaceOption3":
        MessageLookupByLibrary.simpleMessage("乱一点也没关系"),
    "preferenceScenarioCleanlinessSharedSpaceQuestion":
        MessageLookupByLibrary.simpleMessage("你希望共享空间保持到什么程度？"),
    "preferenceScenarioCommunicationChannelOption1":
        MessageLookupByLibrary.simpleMessage("发消息"),
    "preferenceScenarioCommunicationChannelOption2":
        MessageLookupByLibrary.simpleMessage("当面说"),
    "preferenceScenarioCommunicationChannelOption3":
        MessageLookupByLibrary.simpleMessage("打电话"),
    "preferenceScenarioCommunicationChannelQuestion":
        MessageLookupByLibrary.simpleMessage("别人怎么联系你最合适？"),
    "preferenceScenarioCommunicationDirectnessOption1":
        MessageLookupByLibrary.simpleMessage("温和一点"),
    "preferenceScenarioCommunicationDirectnessOption2":
        MessageLookupByLibrary.simpleMessage("看情况"),
    "preferenceScenarioCommunicationDirectnessOption3":
        MessageLookupByLibrary.simpleMessage("直接一点也没关系"),
    "preferenceScenarioCommunicationDirectnessQuestion":
        MessageLookupByLibrary.simpleMessage("如果有问题，你希望别人怎么说？"),
    "preferenceScenarioConflictResolutionOption1":
        MessageLookupByLibrary.simpleMessage("先冷静一下"),
    "preferenceScenarioConflictResolutionOption2":
        MessageLookupByLibrary.simpleMessage("晚一点再聊"),
    "preferenceScenarioConflictResolutionOption3":
        MessageLookupByLibrary.simpleMessage("尽早说清楚"),
    "preferenceScenarioConflictResolutionQuestion":
        MessageLookupByLibrary.simpleMessage("如果有点不对劲，你更希望怎么处理？"),
    "preferenceScenarioEnvironmentLightOption1":
        MessageLookupByLibrary.simpleMessage("柔和一点"),
    "preferenceScenarioEnvironmentLightOption2":
        MessageLookupByLibrary.simpleMessage("适中就好"),
    "preferenceScenarioEnvironmentLightOption3":
        MessageLookupByLibrary.simpleMessage("明亮一点"),
    "preferenceScenarioEnvironmentLightQuestion":
        MessageLookupByLibrary.simpleMessage("你更喜欢怎样的光线？"),
    "preferenceScenarioEnvironmentNoiseOption1":
        MessageLookupByLibrary.simpleMessage("希望安静一点"),
    "preferenceScenarioEnvironmentNoiseOption2":
        MessageLookupByLibrary.simpleMessage("正常就好"),
    "preferenceScenarioEnvironmentNoiseOption3":
        MessageLookupByLibrary.simpleMessage("热闹一点也可以"),
    "preferenceScenarioEnvironmentNoiseQuestion":
        MessageLookupByLibrary.simpleMessage("你更喜欢怎样的噪音程度？"),
    "preferenceScenarioEnvironmentScentOption1":
        MessageLookupByLibrary.simpleMessage("比较敏感"),
    "preferenceScenarioEnvironmentScentOption2":
        MessageLookupByLibrary.simpleMessage("还好"),
    "preferenceScenarioEnvironmentScentOption3":
        MessageLookupByLibrary.simpleMessage("不太在意"),
    "preferenceScenarioEnvironmentScentQuestion":
        MessageLookupByLibrary.simpleMessage("对气味敏感吗？"),
    "preferenceScenarioPrivacyNotificationsOption1":
        MessageLookupByLibrary.simpleMessage("尽量不要"),
    "preferenceScenarioPrivacyNotificationsOption2":
        MessageLookupByLibrary.simpleMessage("重要的事可以"),
    "preferenceScenarioPrivacyNotificationsOption3":
        MessageLookupByLibrary.simpleMessage("随时都可以"),
    "preferenceScenarioPrivacyNotificationsQuestion":
        MessageLookupByLibrary.simpleMessage("晚上发消息给你可以吗？"),
    "preferenceScenarioPrivacyRoomEntryOption1":
        MessageLookupByLibrary.simpleMessage("一定要先敲门"),
    "preferenceScenarioPrivacyRoomEntryOption2":
        MessageLookupByLibrary.simpleMessage("通常先敲门"),
    "preferenceScenarioPrivacyRoomEntryOption3":
        MessageLookupByLibrary.simpleMessage("门开着就可以"),
    "preferenceScenarioPrivacyRoomEntryQuestion":
        MessageLookupByLibrary.simpleMessage("进入你的房间时，希望别人怎么做？"),
    "preferenceScenarioRoutinePlanningOption1":
        MessageLookupByLibrary.simpleMessage("有规划一点"),
    "preferenceScenarioRoutinePlanningOption2":
        MessageLookupByLibrary.simpleMessage("有一点结构就好"),
    "preferenceScenarioRoutinePlanningOption3":
        MessageLookupByLibrary.simpleMessage("顺其自然"),
    "preferenceScenarioRoutinePlanningQuestion":
        MessageLookupByLibrary.simpleMessage("你偏好的生活方式？"),
    "preferenceScenarioScheduleQuietHoursOption1":
        MessageLookupByLibrary.simpleMessage("希望安静一点"),
    "preferenceScenarioScheduleQuietHoursOption2":
        MessageLookupByLibrary.simpleMessage("看情况"),
    "preferenceScenarioScheduleQuietHoursOption3":
        MessageLookupByLibrary.simpleMessage("活动多一点也可以"),
    "preferenceScenarioScheduleQuietHoursQuestion":
        MessageLookupByLibrary.simpleMessage("晚上的家庭节奏？"),
    "preferenceScenarioScheduleSleepTimingOption1":
        MessageLookupByLibrary.simpleMessage("早睡早起型"),
    "preferenceScenarioScheduleSleepTimingOption2":
        MessageLookupByLibrary.simpleMessage("中间型"),
    "preferenceScenarioScheduleSleepTimingOption3":
        MessageLookupByLibrary.simpleMessage("夜猫子型"),
    "preferenceScenarioScheduleSleepTimingQuestion":
        MessageLookupByLibrary.simpleMessage("你的作息习惯？"),
    "preferenceScenarioSocialHostingOption1":
        MessageLookupByLibrary.simpleMessage("尽量少一点"),
    "preferenceScenarioSocialHostingOption2":
        MessageLookupByLibrary.simpleMessage("偶尔可以"),
    "preferenceScenarioSocialHostingOption3":
        MessageLookupByLibrary.simpleMessage("常常也可以"),
    "preferenceScenarioSocialHostingQuestion":
        MessageLookupByLibrary.simpleMessage("带朋友来家里的频率？"),
    "preferenceScenarioSocialTogethernessOption1":
        MessageLookupByLibrary.simpleMessage("各自为主"),
    "preferenceScenarioSocialTogethernessOption2":
        MessageLookupByLibrary.simpleMessage("两者都可以"),
    "preferenceScenarioSocialTogethernessOption3":
        MessageLookupByLibrary.simpleMessage("喜欢常常一起互动"),
    "preferenceScenarioSocialTogethernessQuestion":
        MessageLookupByLibrary.simpleMessage("你喜欢怎样的家庭互动感？"),
    "profileActionConfirm": MessageLookupByLibrary.simpleMessage("退出家庭"),
    "profileActionConfirmDelete": MessageLookupByLibrary.simpleMessage("删除账号"),
    "profileConfirmDeleteMessage": MessageLookupByLibrary.simpleMessage(
      "此操作会删除你的账号并退出登录，而且无法恢复。",
    ),
    "profileConfirmDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "要删除你的账号吗？",
    ),
    "profileConfirmLeaveMessage": MessageLookupByLibrary.simpleMessage(
      "退出后，你将无法继续查看任务、历史记录和邀请码。",
    ),
    "profileConfirmLeaveTitle": MessageLookupByLibrary.simpleMessage(
      "要退出这个家庭吗？",
    ),
    "profileConnectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "管理提醒和通知。",
    ),
    "profileConnectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "通知设置",
    ),
    "profileContactEmailSubject": MessageLookupByLibrary.simpleMessage(
      "联系 Kinly",
    ),
    "profileContactLaunchError": MessageLookupByLibrary.simpleMessage(
      "暂时无法打开邮件应用。",
    ),
    "profileContactUsSubtitle": MessageLookupByLibrary.simpleMessage(
      "发送邮件至 support@makinglifeeasie.com",
    ),
    "profileContactUsTitle": MessageLookupByLibrary.simpleMessage("联系我们"),
    "profileDeleteAccountSubtitle": MessageLookupByLibrary.simpleMessage(
      "删除你的 Kinly 账号与相关数据。",
    ),
    "profileDeleteAccountTitle": MessageLookupByLibrary.simpleMessage("删除账号"),
    "profileDeleteSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "你的账号即将删除，我们会将你退出登录。",
    ),
    "profileGenericError": MessageLookupByLibrary.simpleMessage("出了点问题，请稍后再试。"),
    "profileIdentityAvatarEmpty": MessageLookupByLibrary.simpleMessage(
      "目前没有可用头像。",
    ),
    "profileIdentityAvatarSectionDescription":
        MessageLookupByLibrary.simpleMessage("同一家庭中的每个人都可以使用不同头像。"),
    "profileIdentityAvatarSectionTitle": MessageLookupByLibrary.simpleMessage(
      "选择头像",
    ),
    "profileIdentityLoadError": MessageLookupByLibrary.simpleMessage(
      "暂时无法加载你的个人资料。",
    ),
    "profileIdentityRetry": MessageLookupByLibrary.simpleMessage("重试"),
    "profileIdentitySaveButton": MessageLookupByLibrary.simpleMessage("保存修改"),
    "profileIdentitySubtitle": MessageLookupByLibrary.simpleMessage(
      "设置你的用户名和头像。",
    ),
    "profileIdentitySuccessMessage": MessageLookupByLibrary.simpleMessage(
      "个人资料已更新。",
    ),
    "profileIdentityTitle": MessageLookupByLibrary.simpleMessage("编辑个人资料"),
    "profileIdentityUsernameEmptyError": MessageLookupByLibrary.simpleMessage(
      "请输入用户名。",
    ),
    "profileIdentityUsernameFormatError": MessageLookupByLibrary.simpleMessage(
      "请使用 3-30 位小写字母或数字，中间可包含 . 和 _。",
    ),
    "profileIdentityUsernameHint": MessageLookupByLibrary.simpleMessage(
      "字母、数字、. 或 _",
    ),
    "profileIdentityUsernameLabel": MessageLookupByLibrary.simpleMessage("用户名"),
    "profileIdentityUsernamePreviewFallback":
        MessageLookupByLibrary.simpleMessage("你的用户名"),
    "profileIdentityUsernameTakenError": MessageLookupByLibrary.simpleMessage(
      "这个用户名已被使用。",
    ),
    "profileInfoHubLoadError": MessageLookupByLibrary.simpleMessage(
      "暂时无法加载信息中心，请检查网络。",
    ),
    "profileInfoHubSubtitle": MessageLookupByLibrary.simpleMessage(
      "在应用内打开 Kinly Notion 信息中心。",
    ),
    "profileInfoHubTitle": MessageLookupByLibrary.simpleMessage("信息中心"),
    "profileKickActionConfirm": MessageLookupByLibrary.simpleMessage("移除成员"),
    "profileKickMemberSubtitle": MessageLookupByLibrary.simpleMessage(
      "选择一位成员并移除其访问权限。",
    ),
    "profileKickMemberTitle": MessageLookupByLibrary.simpleMessage("移除成员"),
    "profileKickNoMembers": MessageLookupByLibrary.simpleMessage(
      "目前没有其他成员可移除。",
    ),
    "profileKickOwnerOnly": MessageLookupByLibrary.simpleMessage("只有房主可以移除成员。"),
    "profileKickSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "选择要移除的成员，对方会立即失去访问权限。",
    ),
    "profileKickSheetTitle": MessageLookupByLibrary.simpleMessage("移除成员"),
    "profileKickSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "对方已失去这个家庭的访问权限。",
    ),
    "profileLeaveEligibilityError": MessageLookupByLibrary.simpleMessage(
      "暂时无法加载家庭成员。",
    ),
    "profileLeaveEligibilityLoading": MessageLookupByLibrary.simpleMessage(
      "正在检查家庭成员...",
    ),
    "profileLeaveHomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "你将离开当前这个共享家庭空间。",
    ),
    "profileLeaveHomeTitle": MessageLookupByLibrary.simpleMessage("退出家庭"),
    "profileLeaveOwnerNoEligibleMembers": MessageLookupByLibrary.simpleMessage(
      "目前没有可转移为房主的成员。",
    ),
    "profileLeaveOwnerSoloMessage": MessageLookupByLibrary.simpleMessage(
      "你是最后一位成员。退出后，这个家庭会被停用。",
    ),
    "profileLeaveSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "你已退出这个家庭。",
    ),
    "profileLeaveTransferSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "请先选择新的房主，再退出家庭。",
    ),
    "profileLeaveTransferSheetTitle": MessageLookupByLibrary.simpleMessage(
      "转移房主身份",
    ),
    "profileLeaveTransferSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "房主身份已转移，正在完成退出流程...",
    ),
    "profileLogoutSubtitle": MessageLookupByLibrary.simpleMessage(
      "在这台设备上退出 Kinly。",
    ),
    "profileLogoutTitle": MessageLookupByLibrary.simpleMessage("退出登录"),
    "profileMissingHomeError": MessageLookupByLibrary.simpleMessage(
      "暂时找不到你当前的家庭。",
    ),
    "profileSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "管理你的账号与家庭权限。",
    ),
    "profileSettingsTitle": MessageLookupByLibrary.simpleMessage("个人设置"),
    "profile_deactivated_message": MessageLookupByLibrary.simpleMessage(
      "你的资料已停用，请使用其他邮箱登录。",
    ),
    "pulseCloudySteadySummary": MessageLookupByLibrary.simpleMessage(
      "有些地方运作得不错，有些地方还不太顺。",
    ),
    "pulseCloudySteadyTitle": MessageLookupByLibrary.simpleMessage("有点混合"),
    "pulseCloudyTenseSummary": MessageLookupByLibrary.simpleMessage(
      "这周出现了一些紧张感。",
    ),
    "pulseCloudyTenseTitle": MessageLookupByLibrary.simpleMessage("需要留意"),
    "pulseFormingSummary": MessageLookupByLibrary.simpleMessage(
      "再多几次反馈后，画面会更清楚。",
    ),
    "pulseFormingTitle": MessageLookupByLibrary.simpleMessage("还在形成中"),
    "pulsePartlySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "大致稳定，但还有一些可以改善的地方。",
    ),
    "pulsePartlySupportedTitle": MessageLookupByLibrary.simpleMessage("整体还可以"),
    "pulseRainySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "现在也许适合做一次小小重整。",
    ),
    "pulseRainySupportedTitle": MessageLookupByLibrary.simpleMessage("建议小调整"),
    "pulseRainyUnsupportedSummary": MessageLookupByLibrary.simpleMessage(
      "目前摩擦感已经比较明显。",
    ),
    "pulseRainyUnsupportedTitle": MessageLookupByLibrary.simpleMessage("需要重整"),
    "pulseSunnyBumpySummary": MessageLookupByLibrary.simpleMessage(
      "整体还不错，只是有一点小起伏。",
    ),
    "pulseSunnyBumpyTitle": MessageLookupByLibrary.simpleMessage("大致顺利"),
    "pulseSunnyCalmSummary": MessageLookupByLibrary.simpleMessage("这周整体感觉挺顺。"),
    "pulseSunnyCalmTitle": MessageLookupByLibrary.simpleMessage("运行顺畅"),
    "pulseThunderstormSummary": MessageLookupByLibrary.simpleMessage(
      "当前紧张感较高，建议尽快做一次重整。",
    ),
    "pulseThunderstormTitle": MessageLookupByLibrary.simpleMessage("紧张偏高"),
    "quick_add_flow_subtitle": MessageLookupByLibrary.simpleMessage("新增一个任务"),
    "quick_add_flow_title": MessageLookupByLibrary.simpleMessage("任务"),
    "quick_add_share_subtitle": MessageLookupByLibrary.simpleMessage("新增一笔账单"),
    "quick_add_share_title": MessageLookupByLibrary.simpleMessage("账单"),
    "quick_add_title": MessageLookupByLibrary.simpleMessage("快速添加"),
    "reflectiveAcknowledgementTitle": MessageLookupByLibrary.simpleMessage(
      "收到。",
    ),
    "reflectiveGenericPrimary": MessageLookupByLibrary.simpleMessage(
      "我们正在认真整理中。",
    ),
    "reflectiveGenericSecondary": MessageLookupByLibrary.simpleMessage(
      "请稍等一下，很快就好。",
    ),
    "reflectiveHouseNormsPrimary": MessageLookupByLibrary.simpleMessage(
      "正在整理这个家共同表达的内容。",
    ),
    "reflectiveHouseNormsSecondary": MessageLookupByLibrary.simpleMessage(
      "它是一份共享指南，而不是规则书。",
    ),
    "reflectiveHousePrimary": MessageLookupByLibrary.simpleMessage(
      "正在把这个家的期待整理成文字。",
    ),
    "reflectiveHouseSecondary": MessageLookupByLibrary.simpleMessage(
      "让彼此的期待更清楚。",
    ),
    "reflectivePersonalPrimary": MessageLookupByLibrary.simpleMessage(
      "正在整理你刚刚分享的内容。",
    ),
    "reflectivePersonalSecondary": MessageLookupByLibrary.simpleMessage(
      "让别人更容易理解，什么方式会让你住得更舒服。",
    ),
    "shareCreateAmountHint": MessageLookupByLibrary.simpleMessage("0.00"),
    "shareCreateAmountLabel": MessageLookupByLibrary.simpleMessage("金额"),
    "shareCreateCustomAmountLabel": MessageLookupByLibrary.simpleMessage("金额"),
    "shareCreateCustomHelper": MessageLookupByLibrary.simpleMessage(
      "请输入每个人应分摊的金额，总额需与上方金额一致。",
    ),
    "shareCreateCyclePeriod": m17,
    "shareCreateDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "例如：超市采购",
    ),
    "shareCreateDescriptionLabel": MessageLookupByLibrary.simpleMessage("账单说明"),
    "shareCreateErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "你目前没有权限创建这张账单。",
    ),
    "shareCreateErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "暂时无法创建账单。",
    ),
    "shareCreateErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "免费版的进行中账单数量已达上限，升级后可继续添加。",
    ),
    "shareCreateErrorRecurrenceDraft": MessageLookupByLibrary.simpleMessage(
      "草稿在设置分摊前不会重复生成。",
    ),
    "shareCreateLoadError": MessageLookupByLibrary.simpleMessage("暂时无法加载家庭成员。"),
    "shareCreateNotesHint": MessageLookupByLibrary.simpleMessage("可选，所有人都能看到"),
    "shareCreateNotesLabel": MessageLookupByLibrary.simpleMessage("备注"),
    "shareCreateParticipantsEmpty": MessageLookupByLibrary.simpleMessage(
      "至少需要两位家庭成员才能分摊账单。",
    ),
    "shareCreateRecurrenceEveryLabel": MessageLookupByLibrary.simpleMessage(
      "每",
    ),
    "shareCreateRecurrenceLabel": MessageLookupByLibrary.simpleMessage("重复"),
    "shareCreateRecurrenceToggleLabel": MessageLookupByLibrary.simpleMessage(
      "周期重复",
    ),
    "shareCreateRecurrenceUnitDay": MessageLookupByLibrary.simpleMessage("天"),
    "shareCreateRecurrenceUnitMonth": MessageLookupByLibrary.simpleMessage("月"),
    "shareCreateRecurrenceUnitWeek": MessageLookupByLibrary.simpleMessage("周"),
    "shareCreateRecurrenceUnitYear": MessageLookupByLibrary.simpleMessage("年"),
    "shareCreateRetry": MessageLookupByLibrary.simpleMessage("重试"),
    "shareCreateSplitCustom": MessageLookupByLibrary.simpleMessage("自定义金额"),
    "shareCreateSplitEqual": MessageLookupByLibrary.simpleMessage("平均分摊"),
    "shareCreateSplitLabel": MessageLookupByLibrary.simpleMessage("你想怎么分摊？"),
    "shareCreateStartLabel": MessageLookupByLibrary.simpleMessage("从什么时候开始？"),
    "shareCreateSubmit": MessageLookupByLibrary.simpleMessage("创建"),
    "shareCreateSuccess": MessageLookupByLibrary.simpleMessage("账单已创建。"),
    "shareCreateTitle": MessageLookupByLibrary.simpleMessage("添加账单"),
    "shareCreateValidationAmount": MessageLookupByLibrary.simpleMessage(
      "请输入大于 0 的金额。",
    ),
    "shareCreateValidationCustomAmounts": MessageLookupByLibrary.simpleMessage(
      "请为每位选中的成员输入有效金额。",
    ),
    "shareCreateValidationCustomParticipants":
        MessageLookupByLibrary.simpleMessage("请至少选择一位成员参与账单。"),
    "shareCreateValidationCustomSinglePayer":
        MessageLookupByLibrary.simpleMessage("请至少再添加一位其他成员。"),
    "shareCreateValidationCustomSum": MessageLookupByLibrary.simpleMessage(
      "请确认分摊总额与账单金额一致。",
    ),
    "shareCreateValidationCustomSumBreakdown": m18,
    "shareCreateValidationDescription": MessageLookupByLibrary.simpleMessage(
      "请输入账单说明。",
    ),
    "shareCreateValidationEqualParticipants":
        MessageLookupByLibrary.simpleMessage("请至少选择一位成员分摊账单。"),
    "shareCreateValidationRecurrence": MessageLookupByLibrary.simpleMessage(
      "请选择重复频率。",
    ),
    "shareCreateValidationRecurrenceSplit":
        MessageLookupByLibrary.simpleMessage("设置周期账单前，请先选择分摊方式。"),
    "shareCreateValidationStartDate": MessageLookupByLibrary.simpleMessage(
      "请选择开始日期。",
    ),
    "shareCreateValidationStartDateRange": MessageLookupByLibrary.simpleMessage(
      "请选择允许范围内的日期。",
    ),
    "shareCreatedListActiveAmount": m19,
    "shareCreatedListActiveSubtitle": m20,
    "shareCreatedListDraftBadge": MessageLookupByLibrary.simpleMessage("未分配"),
    "shareCreatedListDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "先设置好分摊方式，再发布给大家。",
    ),
    "shareCreatedListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "账单能让金钱往来更清楚。",
    ),
    "shareCreatedListEmptyTitle": MessageLookupByLibrary.simpleMessage("还没有账单"),
    "shareCreatedListError": MessageLookupByLibrary.simpleMessage(
      "暂时无法加载你的账单，下拉可刷新。",
    ),
    "shareCreatedListPaidBadge": MessageLookupByLibrary.simpleMessage("已结清"),
    "shareCreatedListRetry": MessageLookupByLibrary.simpleMessage("重试"),
    "shareCreatedListTitle": MessageLookupByLibrary.simpleMessage("你的账单"),
    "shareEditClose": MessageLookupByLibrary.simpleMessage("关闭"),
    "shareEditDeleteButton": MessageLookupByLibrary.simpleMessage("删除"),
    "shareEditDeleteConfirm": MessageLookupByLibrary.simpleMessage("删除"),
    "shareEditDeleteConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "删除后，这份草稿会从所有人那里移除。",
    ),
    "shareEditDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "要删除这张账单吗？",
    ),
    "shareEditDeleteError": MessageLookupByLibrary.simpleMessage("暂时无法删除账单。"),
    "shareEditDeleteSuccess": MessageLookupByLibrary.simpleMessage("账单已删除。"),
    "shareEditDisabledActive": MessageLookupByLibrary.simpleMessage(
      "进行中的账单暂时无法编辑。",
    ),
    "shareEditDisabledConverted": MessageLookupByLibrary.simpleMessage(
      "这张账单已变成计划，无法在这里编辑。",
    ),
    "shareEditDisabledGeneric": MessageLookupByLibrary.simpleMessage(
      "这张账单目前无法编辑。",
    ),
    "shareEditDisabledRecurringCycle": MessageLookupByLibrary.simpleMessage(
      "周期账单无法在这里编辑。",
    ),
    "shareEditLoadError": MessageLookupByLibrary.simpleMessage("暂时无法加载这份草稿。"),
    "shareEditNotAllowed": MessageLookupByLibrary.simpleMessage(
      "在有人接手这张账单前，它会保持锁定。",
    ),
    "shareEditSplitsLocked": MessageLookupByLibrary.simpleMessage(
      "由于已经有人付款，分摊金额已锁定。你仍可修改描述和备注。",
    ),
    "shareEditSubmit": MessageLookupByLibrary.simpleMessage("更新"),
    "shareEditSuccess": MessageLookupByLibrary.simpleMessage("账单已更新。"),
    "shareEditTerminateError": MessageLookupByLibrary.simpleMessage(
      "暂时无法结束这个计划。",
    ),
    "shareEditTerminatePlan": MessageLookupByLibrary.simpleMessage("结束计划"),
    "shareEditTerminatePlanBusy": MessageLookupByLibrary.simpleMessage(
      "结束中...",
    ),
    "shareEditTerminatePlanConfirm": MessageLookupByLibrary.simpleMessage(
      "结束计划",
    ),
    "shareEditTerminatePlanMessage": MessageLookupByLibrary.simpleMessage(
      "结束后将不会再生成新的账单周期。",
    ),
    "shareEditTerminatePlanTitle": MessageLookupByLibrary.simpleMessage(
      "要结束这个周期计划吗？",
    ),
    "shareEditTerminateSuccess": MessageLookupByLibrary.simpleMessage("计划已结束。"),
    "shareEditTitle": MessageLookupByLibrary.simpleMessage("编辑账单"),
    "shareOwedDetailEmpty": MessageLookupByLibrary.simpleMessage(
      "你和这个人之间目前都结清了。",
    ),
    "shareOwedDetailError": MessageLookupByLibrary.simpleMessage("暂时无法标记为已结清。"),
    "shareOwedDetailPaid": MessageLookupByLibrary.simpleMessage("标记为已结清"),
    "shareOwedDetailSuccess": MessageLookupByLibrary.simpleMessage("已标记为已结清。"),
    "shareOwedDetailTitle": MessageLookupByLibrary.simpleMessage("待结算"),
    "sharePaidDetailAcknowledge": MessageLookupByLibrary.simpleMessage("确认已收到"),
    "sharePaidDetailAcknowledgeError": MessageLookupByLibrary.simpleMessage(
      "暂时无法确认这笔收款。",
    ),
    "sharePaidDetailAcknowledging": MessageLookupByLibrary.simpleMessage(
      "确认中...",
    ),
    "shoppingAllItemsBought": MessageLookupByLibrary.simpleMessage("全部买好了"),
    "shoppingAmountHint": MessageLookupByLibrary.simpleMessage("例如：2 盒"),
    "shoppingAmountLabel": MessageLookupByLibrary.simpleMessage("数量"),
    "shoppingArchiveCta": MessageLookupByLibrary.simpleMessage("已购买"),
    "shoppingArchiveDraftBillCreated": MessageLookupByLibrary.simpleMessage(
      "账单草稿已创建",
    ),
    "shoppingArchiveItemsBought": MessageLookupByLibrary.simpleMessage(
      "已标记购买并移除",
    ),
    "shoppingArchiveShareNo": MessageLookupByLibrary.simpleMessage("不用了"),
    "shoppingArchiveSharePromptBody": MessageLookupByLibrary.simpleMessage(
      "要根据这些项目生成一份账单草稿吗？",
    ),
    "shoppingArchiveSharePromptTitle": MessageLookupByLibrary.simpleMessage(
      "要创建账单吗？",
    ),
    "shoppingArchiveShareYes": MessageLookupByLibrary.simpleMessage("创建"),
    "shoppingCardSubtitle": m21,
    "shoppingCardTitle": MessageLookupByLibrary.simpleMessage("购物清单"),
    "shoppingContextHint": MessageLookupByLibrary.simpleMessage("品牌、规格或其他说明"),
    "shoppingContextLabel": MessageLookupByLibrary.simpleMessage("备注"),
    "shoppingCreateTitle": MessageLookupByLibrary.simpleMessage("添加购物项目"),
    "shoppingDelete": MessageLookupByLibrary.simpleMessage("删除项目"),
    "shoppingDeleteConfirmBody": MessageLookupByLibrary.simpleMessage(
      "删除后，它会从共享购物清单中移除。",
    ),
    "shoppingDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "要删除这个项目吗？",
    ),
    "shoppingDetailTitle": MessageLookupByLibrary.simpleMessage("购物项目"),
    "shoppingEditTitle": MessageLookupByLibrary.simpleMessage("编辑购物项目"),
    "shoppingEmptyTitle": MessageLookupByLibrary.simpleMessage("目前还没有购物项目。"),
    "shoppingErrorItemAlreadyCompletedByOther":
        MessageLookupByLibrary.simpleMessage("有人已经把它标记为已购买了。"),
    "shoppingListTitle": MessageLookupByLibrary.simpleMessage("购物清单"),
    "shoppingMarkCompleteCta": MessageLookupByLibrary.simpleMessage("标记为已购买"),
    "shoppingNameHint": MessageLookupByLibrary.simpleMessage("例如：牛奶"),
    "shoppingNameLabel": MessageLookupByLibrary.simpleMessage("名称"),
    "shoppingPhotoLabel": MessageLookupByLibrary.simpleMessage("添加照片"),
    "shoppingPhotoPlaceholder": MessageLookupByLibrary.simpleMessage("添加一张照片"),
    "shoppingPhotoReplaceLabel": MessageLookupByLibrary.simpleMessage(
      "帮助室友买对商品",
    ),
    "shoppingSubmitAdd": MessageLookupByLibrary.simpleMessage("添加项目"),
    "shoppingSubmitEdit": MessageLookupByLibrary.simpleMessage("保存修改"),
    "shoppingTabPending": MessageLookupByLibrary.simpleMessage("待购买"),
    "shoppingValidationName": MessageLookupByLibrary.simpleMessage("请输入商品名称。"),
    "startReturningSubtitle": MessageLookupByLibrary.simpleMessage("今天想先处理什么？"),
    "startReturningTitle": m22,
    "todayAddSheetFlow": MessageLookupByLibrary.simpleMessage("添加任务"),
    "todayAddSheetShare": MessageLookupByLibrary.simpleMessage("添加账单"),
    "todayAddSheetShopping": MessageLookupByLibrary.simpleMessage("添加购物项"),
    "todayAddSheetTitle": MessageLookupByLibrary.simpleMessage("添加到家庭"),
    "todayEmptyBody": MessageLookupByLibrary.simpleMessage("目前没有需要你处理的事情。"),
    "todayEmptyCardBadge": MessageLookupByLibrary.simpleMessage("可以喘口气了"),
    "todayEmptyCardTitle": MessageLookupByLibrary.simpleMessage("都处理好了"),
    "todayFlatmateInviteSubtitle": MessageLookupByLibrary.simpleMessage(
      "让分工更清楚，让生活更顺一点。",
    ),
    "todayFlatmateInviteTitle": MessageLookupByLibrary.simpleMessage("邀请你的室友"),
    "todayFlowBadgeNew": MessageLookupByLibrary.simpleMessage("今日新增"),
    "todayFlowSectionTitle": MessageLookupByLibrary.simpleMessage("任务"),
    "todayFlowSeeAll": m23,
    "todayFlowSubtitle": MessageLookupByLibrary.simpleMessage("这是今天需要留意的内容。"),
    "todayFlowTabActive": MessageLookupByLibrary.simpleMessage("进行中"),
    "todayFlowTabDrafts": MessageLookupByLibrary.simpleMessage("草稿"),
    "todayGratitudeHouseCta": MessageLookupByLibrary.simpleMessage("家庭感谢"),
    "todayGratitudePersonalCta": MessageLookupByLibrary.simpleMessage("我的感谢"),
    "todayGratitudeSectionTitle": MessageLookupByLibrary.simpleMessage("感谢"),
    "todayGratitudeUnreadBody": MessageLookupByLibrary.simpleMessage(
      "你有新的感谢还没看。",
    ),
    "todayInviteFriendsSubtitle": MessageLookupByLibrary.simpleMessage(
      "把 Kinly 分享给朋友。",
    ),
    "todayInviteFriendsTitle": MessageLookupByLibrary.simpleMessage(
      "邀请朋友使用 Kinly",
    ),
    "todayInviteNotNow": MessageLookupByLibrary.simpleMessage("暂时不用"),
    "todayInviteShareCta": MessageLookupByLibrary.simpleMessage("发送邀请"),
    "todayMemberCapPrimaryCta": MessageLookupByLibrary.simpleMessage("升级家庭方案"),
    "todayMemberCapResolutionFailed": m24,
    "todayMemberCapResolutionJoined": m25,
    "todayMemberCapResolutionSuperseded": m26,
    "todayMemberCapResolutionUnknownName": MessageLookupByLibrary.simpleMessage(
      "有人",
    ),
    "todayMemberCapSecondaryCta": MessageLookupByLibrary.simpleMessage("暂时忽略"),
    "todayMemberCapSubtitle": m27,
    "todayMemberCapSubtitleGeneric": MessageLookupByLibrary.simpleMessage(
      "升级后可添加更多成员。",
    ),
    "todayMemberCapTitle": MessageLookupByLibrary.simpleMessage("有人想加入你的家庭"),
    "todayShareActiveSubtitle": m28,
    "todayShareError": MessageLookupByLibrary.simpleMessage("暂时无法刷新账单。"),
    "todaySharePaidSubtitle": MessageLookupByLibrary.simpleMessage("已结清金额"),
    "todaySharePaidUnseen": m29,
    "todayShareSectionTitle": MessageLookupByLibrary.simpleMessage("账单"),
    "todayShareTabActive": MessageLookupByLibrary.simpleMessage("待结算"),
    "todayShareTabDrafts": MessageLookupByLibrary.simpleMessage("草稿"),
    "todayShareTabPaidToMe": MessageLookupByLibrary.simpleMessage("已结清"),
    "vibeCozySocialSummary": MessageLookupByLibrary.simpleMessage(
      "这个家相处起来轻松又温暖。",
    ),
    "vibeCozySocialTitle": MessageLookupByLibrary.simpleMessage("温馨相处"),
    "vibeDefaultSummary": MessageLookupByLibrary.simpleMessage("这个家的整体节奏比较平衡。"),
    "vibeDefaultTitle": MessageLookupByLibrary.simpleMessage("平衡型家庭"),
    "vibeEasygoingSummary": MessageLookupByLibrary.simpleMessage(
      "这个家的风格比较放松、灵活。",
    ),
    "vibeEasygoingTitle": MessageLookupByLibrary.simpleMessage("轻松随性"),
    "vibeIndependentSummary": MessageLookupByLibrary.simpleMessage(
      "这个家更重视空间感和安静。",
    ),
    "vibeIndependentTitle": MessageLookupByLibrary.simpleMessage("独立安静"),
    "vibeInsufficientSummary": MessageLookupByLibrary.simpleMessage(
      "完成偏好设置后，就能看到这个家的整体氛围。",
    ),
    "vibeInsufficientTitle": MessageLookupByLibrary.simpleMessage("资料还不够"),
    "vibeMixedSummary": MessageLookupByLibrary.simpleMessage("这个家的生活方式比较多元。"),
    "vibeMixedTitle": MessageLookupByLibrary.simpleMessage("混合型家庭"),
    "vibeQuietCareSummary": MessageLookupByLibrary.simpleMessage(
      "这个家整体偏安静、温和。",
    ),
    "vibeQuietCareTitle": MessageLookupByLibrary.simpleMessage("安静温和"),
    "vibeSocialSummary": MessageLookupByLibrary.simpleMessage(
      "这个家整体比较活跃、喜欢互动。",
    ),
    "vibeSocialTitle": MessageLookupByLibrary.simpleMessage("社交活力"),
    "vibeSteadySummary": MessageLookupByLibrary.simpleMessage("这个家的节奏稳定、相处平和。"),
    "vibeSteadyTitle": MessageLookupByLibrary.simpleMessage("稳定平静"),
    "vibeStructuredSummary": MessageLookupByLibrary.simpleMessage(
      "这个家更适合有规律、有安排的生活方式。",
    ),
    "vibeStructuredTitle": MessageLookupByLibrary.simpleMessage("有序节奏"),
    "vibeWarmSocialSummary": MessageLookupByLibrary.simpleMessage(
      "这个家给人的感觉温暖又欢迎彼此。",
    ),
    "vibeWarmSocialTitle": MessageLookupByLibrary.simpleMessage("温暖社交"),
    "weeklyRewriteCta": MessageLookupByLibrary.simpleMessage("用 Kinly 更平和地表达"),
    "welcome_create": MessageLookupByLibrary.simpleMessage("创建共享家庭"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("加入共享家庭"),
    "welcome_title": MessageLookupByLibrary.simpleMessage("欢迎使用 Kinly"),
  };
}
