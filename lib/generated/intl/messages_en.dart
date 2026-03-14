// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(env) => "Starting Kinly (${env})";

  static String m1(time) => "Scheduled for ${time}";

  static String m2(current) => "Demo access: ${current} of 7 taps";

  static String m3(appName) => "Made with ${appName} - Together feels lighter";

  static String m4(link) =>
      "A few shoutouts from our Kinly home. Download the app: ${link}";

  static String m5(weeks) =>
      "${Intl.plural(weeks, zero: 'This week', one: '# week ago', other: '# weeks ago')}";

  static String m6(partOfDay, name) => "Good ${partOfDay}, ${name}";

  static String m7(answered, total) =>
      "Based on ${answered} of ${total} members";

  static String m30(reference) => "Reference: ${reference}";

  static String m31(date) => "Reminder for ${date}";

  static String m32(start, end) => "${start} to ${end}";

  static String m8(current, total) => "${current}/${total}";

  static String m9(link) =>
      "Sharing our Kinly home pulse. Download the app: ${link}";

  static String m10(date) => "Updated ${date}";

  static String m11(link) =>
      "Sharing our Kinly home vibe. Download the app: ${link}";

  static String m12(link) => "Make shared living easier with Kinly: ${link}";

  static String m13(code, link) =>
      "Join our Kinly home with this invite code: ${code}\n\nDownload Kinly: ${link}";

  static String m14(code) => "Joined your home.";

  static String m15(price) => "${price} per month";

  static String m16(current, total) => "${current}/${total}";

  static String m17(period) => "Applies to ${period}";

  static String m18(total, included, difference) =>
      "Split doesn\'t match. Total: ${total}. Included: ${included}. Difference: ${difference}.";

  static String m19(paidAmount, totalAmount) =>
      "${paidAmount} of ${totalAmount} collected";

  static String m20(paid, total) => "${paid} of ${total} paid";

  static String m21(count) =>
      "${Intl.plural(count, one: '${count} item to buy', other: '${count} items to buy')}";

  static String m22(name) => "Hi ${name}";

  static String m23(count) =>
      "See all ${Intl.plural(count, one: '(#)', other: '(#)')}";

  static String m33(date) => "Reminder for ${date}";

  static String m24(name) => "Couldn\'t complete ${name}\'s request.";

  static String m25(name) => "${name} joined your home.";

  static String m26(name) => "${name} joined another home.";

  static String m27(names) =>
      "${names} wants to join your home. Upgrade for unlimited members.";

  static String m28(count) =>
      "${Intl.plural(count, one: '${count} payment pending', other: '${count} to settle')}";

  static String m29(count) =>
      "${Intl.plural(count, one: '${count} new payment to you', other: '${count} new payments to you')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("Kinly"),
    "authMembershipLoadFailed": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t refresh your home membership.",
    ),
    "bootstrap_initializing": m0,
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "connectionNotificationsPermissionBlocked":
        MessageLookupByLibrary.simpleMessage(
          "Turn on notifications in your phone settings first.",
        ),
    "connectionNotificationsTimeLabel": MessageLookupByLibrary.simpleMessage(
      "Reminder time",
    ),
    "connectionNotificationsTimeSubtitle": m1,
    "connectionNotificationsToggleSubtitleOff":
        MessageLookupByLibrary.simpleMessage(
          "Turn on reminders for your home.",
        ),
    "connectionNotificationsToggleSubtitleOn":
        MessageLookupByLibrary.simpleMessage("Get one reminder each day."),
    "connectionNotificationsToggleTitle": MessageLookupByLibrary.simpleMessage(
      "Daily reminders",
    ),
    "connectionSettingsGenericError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t update notification settings.",
    ),
    "connectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Control daily reminders and timing.",
    ),
    "connectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Notifications",
    ),
    "create_failed_generic": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t create the home.",
    ),
    "demoAccess": MessageLookupByLibrary.simpleMessage("Demo Access"),
    "demoAccessEmail": MessageLookupByLibrary.simpleMessage("Email"),
    "demoAccessError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t sign in. Check your credentials.",
    ),
    "demoAccessPassword": MessageLookupByLibrary.simpleMessage("Password"),
    "demoAccessSubmit": MessageLookupByLibrary.simpleMessage("Sign in"),
    "demoAccessTapHint": m2,
    "exploreFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "See what needs doing and who\'s doing it.",
    ),
    "exploreIntroSubtitle": MessageLookupByLibrary.simpleMessage(
      "Keep shared things clear.",
    ),
    "exploreShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "See every bill you\'ve created and track collections.",
    ),
    "exploreShoppingSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Shopping list",
    ),
    "exploreShoppingSubtitle": MessageLookupByLibrary.simpleMessage(
      "View and manage shared shopping items.",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage(
      "Who\'s doing this?",
    ),
    "flowChoreCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "Task created.",
    ),
    "flowChoreCreateTitle": MessageLookupByLibrary.simpleMessage("Add Task"),
    "flowChoreDeleteButton": MessageLookupByLibrary.simpleMessage(
      "Delete Task",
    ),
    "flowChoreDeleteConfirm": MessageLookupByLibrary.simpleMessage("Delete"),
    "flowChoreDeleteDialogMessage": MessageLookupByLibrary.simpleMessage(
      "This removes the task for everyone in your home.",
    ),
    "flowChoreDeleteDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Delete this task?",
    ),
    "flowChoreDetailCompleteButton": MessageLookupByLibrary.simpleMessage(
      "Mark complete",
    ),
    "flowChoreDetailCompletionError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t complete this task.",
    ),
    "flowChoreDetailCompletionSuccess": MessageLookupByLibrary.simpleMessage(
      "Task completed.",
    ),
    "flowChoreDetailMoreInfoTitle": MessageLookupByLibrary.simpleMessage(
      "Helpful details",
    ),
    "flowChoreDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Task details",
    ),
    "flowChoreDetailUnassigned": MessageLookupByLibrary.simpleMessage(
      "Unassigned",
    ),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage("Edit Task"),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "That person isn\'t part of this home right now.",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "You don\'t have permission to change this task.",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t save this task.",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "That photo doesn\'t belong to this home.",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "Choose a valid start date.",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "This task is not editable right now.",
    ),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "You\'ve reached the free limit for active tasks. Upgrade for more.",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "You\'ve reached the free limit for task photos. Upgrade for more.",
    ),
    "flowChoreExpectationPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Reference photo",
    ),
    "flowChoreHowToHint": MessageLookupByLibrary.simpleMessage(
      "Add a link if there\'s a specific way",
    ),
    "flowChoreHowToLabel": MessageLookupByLibrary.simpleMessage(
      "How to do it (optional)",
    ),
    "flowChoreHowToLaunchError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t open that link.",
    ),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load this task.",
    ),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage(
      "e.g. Bin night, clean the fridge, water plants",
    ),
    "flowChoreNameLabel": MessageLookupByLibrary.simpleMessage(
      "What needs to be done?",
    ),
    "flowChoreNotesHint": MessageLookupByLibrary.simpleMessage(
      "Anything that helps others do this",
    ),
    "flowChoreNotesLabel": MessageLookupByLibrary.simpleMessage(
      "Why it matters",
    ),
    "flowChorePhotoLabel": MessageLookupByLibrary.simpleMessage(
      "What good looks like",
    ),
    "flowChorePhotoLoadError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load photo.",
    ),
    "flowChorePhotoPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "Allow camera access to take a photo.",
    ),
    "flowChorePhotoPermissionOpenSettings":
        MessageLookupByLibrary.simpleMessage("Open settings"),
    "flowChorePhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Add a photo to keep everyone aligned",
    ),
    "flowChorePhotoUploadError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t upload the photo.",
    ),
    "flowChoreRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "How often does this happen?",
    ),
    "flowChoreRecurrenceNone": MessageLookupByLibrary.simpleMessage("One time"),
    "flowChoreRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "flowChoreStartLabel": MessageLookupByLibrary.simpleMessage(
      "When will it happen?",
    ),
    "flowChoreSubmitCreate": MessageLookupByLibrary.simpleMessage(
      "Create task",
    ),
    "flowChoreSubmitUpdate": MessageLookupByLibrary.simpleMessage(
      "Save changes",
    ),
    "flowChoreUpdateSuccess": MessageLookupByLibrary.simpleMessage(
      "Task updated.",
    ),
    "flowChoreValidationAssignee": MessageLookupByLibrary.simpleMessage(
      "Choose someone.",
    ),
    "flowChoreValidationDate": MessageLookupByLibrary.simpleMessage(
      "Choose a date within the next year.",
    ),
    "flowChoreValidationHowToUrl": MessageLookupByLibrary.simpleMessage(
      "Enter a valid link starting with http or https.",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage(
      "Enter a task name.",
    ),
    "flowChoreViewTitle": MessageLookupByLibrary.simpleMessage("View Task"),
    "flowListDraftLabel": MessageLookupByLibrary.simpleMessage("Draft"),
    "flowListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Tasks keep everyone aligned.",
    ),
    "flowListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Nothing here yet",
    ),
    "flowListError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load tasks. Pull to refresh.",
    ),
    "flowListOverdueLabel": MessageLookupByLibrary.simpleMessage(
      "Needs attention",
    ),
    "flowListTabCurrent": MessageLookupByLibrary.simpleMessage("Current"),
    "flowListTabFuture": MessageLookupByLibrary.simpleMessage("Upcoming"),
    "force_update_body": MessageLookupByLibrary.simpleMessage(
      "This version of Kinly is no longer supported. Update to continue.",
    ),
    "force_update_button": MessageLookupByLibrary.simpleMessage("Update Kinly"),
    "force_update_title": MessageLookupByLibrary.simpleMessage("Update needed"),
    "friendDefaultName": MessageLookupByLibrary.simpleMessage("friend"),
    "gratitudeWallEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Add a shoutout from this week.",
    ),
    "gratitudeWallEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "No shoutouts yet",
    ),
    "gratitudeWallErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load shoutouts right now.",
    ),
    "gratitudeWallFooter": m3,
    "gratitudeWallHouseTab": MessageLookupByLibrary.simpleMessage("House"),
    "gratitudeWallPersonalSummary": MessageLookupByLibrary.simpleMessage(
      "A private place for quick thanks.",
    ),
    "gratitudeWallPersonalTab": MessageLookupByLibrary.simpleMessage("Mine"),
    "gratitudeWallPersonalTitle": MessageLookupByLibrary.simpleMessage(
      "My Shoutouts",
    ),
    "gratitudeWallRetry": MessageLookupByLibrary.simpleMessage("Try again"),
    "gratitudeWallShareCta": MessageLookupByLibrary.simpleMessage("Share"),
    "gratitudeWallShareError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t share right now.",
    ),
    "gratitudeWallShareMessage": m4,
    "gratitudeWallShareTitle": MessageLookupByLibrary.simpleMessage(
      "House shoutouts",
    ),
    "gratitudeWallStatsHomes": MessageLookupByLibrary.simpleMessage("Homes"),
    "gratitudeWallStatsMentions": MessageLookupByLibrary.simpleMessage(
      "Shoutouts",
    ),
    "gratitudeWallStatsPeople": MessageLookupByLibrary.simpleMessage("People"),
    "gratitudeWallWeeksAgo": m5,
    "greetingPartOfDay": m6,
    "harmonyCommentHint": MessageLookupByLibrary.simpleMessage(
      "Add context if helpful",
    ),
    "harmonyCommentLabel": MessageLookupByLibrary.simpleMessage(
      "Optional note",
    ),
    "harmonyErrorAlreadySubmitted": MessageLookupByLibrary.simpleMessage(
      "You\'ve already submitted this week.",
    ),
    "harmonyErrorCommentRequiredForMention":
        MessageLookupByLibrary.simpleMessage(
          "Add a short note before sending this mention.",
        ),
    "harmonyErrorCommentRequiredForPublicWall":
        MessageLookupByLibrary.simpleMessage(
          "Add a short note before posting this shoutout.",
        ),
    "harmonyErrorComplaintNeedsSentence": MessageLookupByLibrary.simpleMessage(
      "Add a clear sentence.",
    ),
    "harmonyErrorComplaintTooBrief": MessageLookupByLibrary.simpleMessage(
      "Write a short sentence so it\'s clear.",
    ),
    "harmonyErrorComplaintTooShort": MessageLookupByLibrary.simpleMessage(
      "Add a bit more detail.",
    ),
    "harmonyErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "Weekly feedback isn\'t available right now.",
    ),
    "harmonyErrorSingleMentionRequired": MessageLookupByLibrary.simpleMessage(
      "Choose one person for this note.",
    ),
    "harmonyErrorUnknown": MessageLookupByLibrary.simpleMessage(
      "Something went wrong.",
    ),
    "harmonyFeedbackSingleHousemateHint": MessageLookupByLibrary.simpleMessage(
      "Type @ to mention 1 housemate.",
    ),
    "harmonyMoodCloudy": MessageLookupByLibrary.simpleMessage("Cloudy"),
    "harmonyMoodPartiallySunny": MessageLookupByLibrary.simpleMessage(
      "Partly sunny",
    ),
    "harmonyMoodRainy": MessageLookupByLibrary.simpleMessage("Rainy"),
    "harmonyMoodSunny": MessageLookupByLibrary.simpleMessage("Sunny"),
    "harmonyMoodThunderstorm": MessageLookupByLibrary.simpleMessage(
      "Thunderstorm",
    ),
    "harmonyQuestion": MessageLookupByLibrary.simpleMessage(
      "What went well or needs adjusting this week?",
    ),
    "harmonyShareLabel": MessageLookupByLibrary.simpleMessage(
      "Visible to everyone in the home",
    ),
    "harmonySubmitCta": MessageLookupByLibrary.simpleMessage("Save"),
    "harmonySubmitSuccess": MessageLookupByLibrary.simpleMessage("Saved"),
    "homeVibeCoverage": m7,
    "homeVibeTitle": MessageLookupByLibrary.simpleMessage("Home Vibe"),
    "houseDirectoryAccountReference": m30,
    "houseDirectoryAccountReferenceHint": MessageLookupByLibrary.simpleMessage(
      "Add the account number, customer ID, or tenancy reference",
    ),
    "houseDirectoryAccountReferenceLabel": MessageLookupByLibrary.simpleMessage(
      "Account reference",
    ),
    "houseDirectoryActionFailed": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t save those changes.",
    ),
    "houseDirectoryAddLink": MessageLookupByLibrary.simpleMessage("Add link"),
    "houseDirectoryAddService": MessageLookupByLibrary.simpleMessage(
      "Add service",
    ),
    "houseDirectoryAddWifi": MessageLookupByLibrary.simpleMessage("Add wifi"),
    "houseDirectoryCopySsid": MessageLookupByLibrary.simpleMessage("Copy SSID"),
    "houseDirectoryCustomLabel": MessageLookupByLibrary.simpleMessage(
      "Custom label",
    ),
    "houseDirectoryCustomLabelHint": MessageLookupByLibrary.simpleMessage(
      "Use a clear name like cleaner, parking, or storage",
    ),
    "houseDirectoryCustomTag": MessageLookupByLibrary.simpleMessage(
      "Custom tag",
    ),
    "houseDirectoryCustomTagHint": MessageLookupByLibrary.simpleMessage(
      "Add a short label if none of the preset tags fit",
    ),
    "houseDirectoryDateUnknown": MessageLookupByLibrary.simpleMessage(
      "Unknown",
    ),
    "houseDirectoryDelete": MessageLookupByLibrary.simpleMessage("Archive"),
    "houseDirectoryEdit": MessageLookupByLibrary.simpleMessage("Edit"),
    "houseDirectoryEditLink": MessageLookupByLibrary.simpleMessage("Edit link"),
    "houseDirectoryEditService": MessageLookupByLibrary.simpleMessage(
      "Edit service",
    ),
    "houseDirectoryEditWifi": MessageLookupByLibrary.simpleMessage("Edit wifi"),
    "houseDirectoryEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Save wifi, rent, services, and links here.",
    ),
    "houseDirectoryEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Shared home details live here.",
    ),
    "houseDirectoryEndDate": MessageLookupByLibrary.simpleMessage("End date"),
    "houseDirectoryLinkArchived": MessageLookupByLibrary.simpleMessage(
      "Link archived.",
    ),
    "houseDirectoryLinkLabel": MessageLookupByLibrary.simpleMessage(
      "Provider link",
    ),
    "houseDirectoryLinkOther": MessageLookupByLibrary.simpleMessage("Other"),
    "houseDirectoryLinkSaved": MessageLookupByLibrary.simpleMessage(
      "Link saved.",
    ),
    "houseDirectoryLinkTitleHint": MessageLookupByLibrary.simpleMessage(
      "Name the link so everyone knows what it opens",
    ),
    "houseDirectoryLinksEmpty": MessageLookupByLibrary.simpleMessage(
      "No links added yet.",
    ),
    "houseDirectoryLinksTitle": MessageLookupByLibrary.simpleMessage(
      "Key links",
    ),
    "houseDirectoryLoadError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load House directory.",
    ),
    "houseDirectoryNotes": MessageLookupByLibrary.simpleMessage("Notes"),
    "houseDirectoryNotesHint": MessageLookupByLibrary.simpleMessage(
      "Add anything helpful, like billing dates, plan details, or contact steps",
    ),
    "houseDirectoryOpenLink": MessageLookupByLibrary.simpleMessage("Open link"),
    "houseDirectoryOpenLinkError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t open that link.",
    ),
    "houseDirectoryPasswordHelper": MessageLookupByLibrary.simpleMessage(
      "Leave blank to save as an open network.",
    ),
    "houseDirectoryPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "Password",
    ),
    "houseDirectoryProviderHint": MessageLookupByLibrary.simpleMessage(
      "Who manages this service, like your power or internet company",
    ),
    "houseDirectoryProviderLabel": MessageLookupByLibrary.simpleMessage(
      "Provider name",
    ),
    "houseDirectoryProviderLinkHint": MessageLookupByLibrary.simpleMessage(
      "Paste the login, portal, or payment link for this service",
    ),
    "houseDirectoryReminderAcknowledged": MessageLookupByLibrary.simpleMessage(
      "Reminder acknowledged.",
    ),
    "houseDirectoryReminderDismissed": MessageLookupByLibrary.simpleMessage(
      "Reminder dismissed.",
    ),
    "houseDirectoryReminderDue": m31,
    "houseDirectoryReminderOffset": MessageLookupByLibrary.simpleMessage(
      "Reminder offset",
    ),
    "houseDirectoryReminderOffsetUnit": MessageLookupByLibrary.simpleMessage(
      "Offset unit",
    ),
    "houseDirectoryReminderOffsetUnitNone":
        MessageLookupByLibrary.simpleMessage("Default"),
    "houseDirectoryRentEmpty": MessageLookupByLibrary.simpleMessage(
      "No rent details added yet.",
    ),
    "houseDirectoryRentTitle": MessageLookupByLibrary.simpleMessage("Rent"),
    "houseDirectoryRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "houseDirectorySave": MessageLookupByLibrary.simpleMessage("Save"),
    "houseDirectoryServiceArchived": MessageLookupByLibrary.simpleMessage(
      "Service archived.",
    ),
    "houseDirectoryServiceOther": MessageLookupByLibrary.simpleMessage("Other"),
    "houseDirectoryServiceSaved": MessageLookupByLibrary.simpleMessage(
      "Service saved.",
    ),
    "houseDirectoryServiceTypeLabel": MessageLookupByLibrary.simpleMessage(
      "Service type",
    ),
    "houseDirectoryServicesEmpty": MessageLookupByLibrary.simpleMessage(
      "No services added yet.",
    ),
    "houseDirectoryServicesTitle": MessageLookupByLibrary.simpleMessage(
      "Utilities and services",
    ),
    "houseDirectorySsidCopied": MessageLookupByLibrary.simpleMessage(
      "SSID copied.",
    ),
    "houseDirectorySsidLabel": MessageLookupByLibrary.simpleMessage("SSID"),
    "houseDirectoryStartDate": MessageLookupByLibrary.simpleMessage(
      "Start date",
    ),
    "houseDirectoryTagLabel": MessageLookupByLibrary.simpleMessage("Tag"),
    "houseDirectoryTermRange": m32,
    "houseDirectoryTitle": MessageLookupByLibrary.simpleMessage(
      "House directory",
    ),
    "houseDirectoryTitleLabel": MessageLookupByLibrary.simpleMessage("Title"),
    "houseDirectoryUrlHint": MessageLookupByLibrary.simpleMessage(
      "Paste the full web address for the portal or resource",
    ),
    "houseDirectoryUrlLabel": MessageLookupByLibrary.simpleMessage("URL"),
    "houseDirectoryValidationCustomLabel": MessageLookupByLibrary.simpleMessage(
      "Enter a custom label.",
    ),
    "houseDirectoryValidationCustomTag": MessageLookupByLibrary.simpleMessage(
      "Enter a custom tag.",
    ),
    "houseDirectoryValidationDateRange": MessageLookupByLibrary.simpleMessage(
      "Pick an end date after the start date.",
    ),
    "houseDirectoryValidationLinkFields": MessageLookupByLibrary.simpleMessage(
      "Enter a title and URL.",
    ),
    "houseDirectoryValidationProvider": MessageLookupByLibrary.simpleMessage(
      "Enter a provider name.",
    ),
    "houseDirectoryValidationReminderOffset":
        MessageLookupByLibrary.simpleMessage("Enter a valid reminder offset."),
    "houseDirectoryValidationRentDates": MessageLookupByLibrary.simpleMessage(
      "Rent needs both start and end dates.",
    ),
    "houseDirectoryValidationUrl": MessageLookupByLibrary.simpleMessage(
      "Enter a valid http or https URL.",
    ),
    "houseDirectoryWifiMaskedHint": MessageLookupByLibrary.simpleMessage(
      "Password stays hidden in the app. Expand to copy the QR payload.",
    ),
    "houseDirectoryWifiMemberEmpty": MessageLookupByLibrary.simpleMessage(
      "No wifi details have been added yet.",
    ),
    "houseDirectoryWifiOwnerEmpty": MessageLookupByLibrary.simpleMessage(
      "Add your home wifi so everyone can find it here.",
    ),
    "houseDirectoryWifiSaved": MessageLookupByLibrary.simpleMessage(
      "Wifi details saved.",
    ),
    "houseDirectoryWifiTitle": MessageLookupByLibrary.simpleMessage("Wifi"),
    "houseNormCopyUrlCta": MessageLookupByLibrary.simpleMessage("Copy URL"),
    "houseNormDoneCta": MessageLookupByLibrary.simpleMessage("Done"),
    "houseNormEditTitle": MessageLookupByLibrary.simpleMessage(
      "Edit house norms",
    ),
    "houseNormGenerationFailed": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t generate house norms right now.",
    ),
    "houseNormOnboardingBack": MessageLookupByLibrary.simpleMessage("Back"),
    "houseNormOnboardingProgress": m8,
    "houseNormOnboardingSubmit": MessageLookupByLibrary.simpleMessage(
      "Generate",
    ),
    "houseNormOnboardingTitle": MessageLookupByLibrary.simpleMessage(
      "House vibe",
    ),
    "houseNormPromptCta": MessageLookupByLibrary.simpleMessage("Generate"),
    "houseNormPromptSubtitle": MessageLookupByLibrary.simpleMessage(
      "Turn your answers into a shared guide.",
    ),
    "houseNormPromptTitle": MessageLookupByLibrary.simpleMessage(
      "Create house norms",
    ),
    "houseNormPublishCta": MessageLookupByLibrary.simpleMessage(
      "Publish to web",
    ),
    "houseNormReportEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Generate house norms to see them.",
    ),
    "houseNormReportEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "House norms not ready",
    ),
    "houseNormReportErrorBody": MessageLookupByLibrary.simpleMessage(
      "Please try again.",
    ),
    "houseNormReportErrorTitle": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load house norms",
    ),
    "houseNormReportTitle": MessageLookupByLibrary.simpleMessage("House norms"),
    "houseNormRepublishCta": MessageLookupByLibrary.simpleMessage("Republish"),
    "houseNormScenarioGuestsOption1": MessageLookupByLibrary.simpleMessage(
      "Ask first",
    ),
    "houseNormScenarioGuestsOption2": MessageLookupByLibrary.simpleMessage(
      "Give a heads-up",
    ),
    "houseNormScenarioGuestsOption3": MessageLookupByLibrary.simpleMessage(
      "Totally normal",
    ),
    "houseNormScenarioGuestsQuestion": MessageLookupByLibrary.simpleMessage(
      "Bringing guests?",
    ),
    "houseNormScenarioHomeIdentityOption1":
        MessageLookupByLibrary.simpleMessage("Calm home"),
    "houseNormScenarioHomeIdentityOption2":
        MessageLookupByLibrary.simpleMessage("Balanced home"),
    "houseNormScenarioHomeIdentityOption3":
        MessageLookupByLibrary.simpleMessage("Social home"),
    "houseNormScenarioHomeIdentityQuestion":
        MessageLookupByLibrary.simpleMessage("Best description?"),
    "houseNormScenarioPropertyContextOption1":
        MessageLookupByLibrary.simpleMessage("Owned"),
    "houseNormScenarioPropertyContextOption2":
        MessageLookupByLibrary.simpleMessage("Whole rental"),
    "houseNormScenarioPropertyContextOption3":
        MessageLookupByLibrary.simpleMessage("Room rental"),
    "houseNormScenarioPropertyContextQuestion":
        MessageLookupByLibrary.simpleMessage("This home is:"),
    "houseNormScenarioRelationshipModelOption1":
        MessageLookupByLibrary.simpleMessage("Housemates"),
    "houseNormScenarioRelationshipModelOption2":
        MessageLookupByLibrary.simpleMessage("Family"),
    "houseNormScenarioRelationshipModelOption3":
        MessageLookupByLibrary.simpleMessage("Mixed"),
    "houseNormScenarioRelationshipModelQuestion":
        MessageLookupByLibrary.simpleMessage("Who\'s living here?"),
    "houseNormScenarioRepairOption1": MessageLookupByLibrary.simpleMessage(
      "Talk early",
    ),
    "houseNormScenarioRepairOption2": MessageLookupByLibrary.simpleMessage(
      "Pick the moment",
    ),
    "houseNormScenarioRepairOption3": MessageLookupByLibrary.simpleMessage(
      "Let small things pass",
    ),
    "houseNormScenarioRepairQuestion": MessageLookupByLibrary.simpleMessage(
      "Tension?",
    ),
    "houseNormScenarioResponsibilityOption1":
        MessageLookupByLibrary.simpleMessage("Clear agreements"),
    "houseNormScenarioResponsibilityOption2":
        MessageLookupByLibrary.simpleMessage("Whoever notices"),
    "houseNormScenarioResponsibilityOption3":
        MessageLookupByLibrary.simpleMessage("Everyone handles their own"),
    "houseNormScenarioResponsibilityQuestion":
        MessageLookupByLibrary.simpleMessage("Small home tasks?"),
    "houseNormScenarioRhythmOption1": MessageLookupByLibrary.simpleMessage(
      "Wind down",
    ),
    "houseNormScenarioRhythmOption2": MessageLookupByLibrary.simpleMessage(
      "Depends",
    ),
    "houseNormScenarioRhythmOption3": MessageLookupByLibrary.simpleMessage(
      "People do their thing",
    ),
    "houseNormScenarioRhythmQuestion": MessageLookupByLibrary.simpleMessage(
      "At night?",
    ),
    "houseNormScenarioSharedSpacesOption1":
        MessageLookupByLibrary.simpleMessage("Clean"),
    "houseNormScenarioSharedSpacesOption2":
        MessageLookupByLibrary.simpleMessage("Lived-in"),
    "houseNormScenarioSharedSpacesOption3":
        MessageLookupByLibrary.simpleMessage("Messy is fine"),
    "houseNormScenarioSharedSpacesQuestion":
        MessageLookupByLibrary.simpleMessage("Kitchen at night?"),
    "houseNormSectionEditLabel": MessageLookupByLibrary.simpleMessage(
      "Edit this section",
    ),
    "houseNormSectionEmptyError": MessageLookupByLibrary.simpleMessage(
      "Add text before saving.",
    ),
    "houseNormSectionFallbackTitle": MessageLookupByLibrary.simpleMessage(
      "Section",
    ),
    "houseNormSectionGuestsSocialTitle": MessageLookupByLibrary.simpleMessage(
      "Guests and social flow",
    ),
    "houseNormSectionHomeIdentityTitle": MessageLookupByLibrary.simpleMessage(
      "Home identity",
    ),
    "houseNormSectionRepairStyleTitle": MessageLookupByLibrary.simpleMessage(
      "Repair style",
    ),
    "houseNormSectionResponsibilityFlowTitle":
        MessageLookupByLibrary.simpleMessage("Responsibility flow"),
    "houseNormSectionRhythmQuietTitle": MessageLookupByLibrary.simpleMessage(
      "Rhythm and quiet",
    ),
    "houseNormSectionSaveCta": MessageLookupByLibrary.simpleMessage("Save"),
    "houseNormSectionSaveFailed": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t save that update.",
    ),
    "houseNormSectionSaveSuccess": MessageLookupByLibrary.simpleMessage(
      "Section updated.",
    ),
    "houseNormSectionSharedSpacesTitle": MessageLookupByLibrary.simpleMessage(
      "Shared spaces",
    ),
    "houseNormShareSubject": MessageLookupByLibrary.simpleMessage(
      "Our house norms",
    ),
    "houseNormShareUrlCta": MessageLookupByLibrary.simpleMessage("Share URL"),
    "houseNormSummaryFramingLabel": MessageLookupByLibrary.simpleMessage(
      "Summary",
    ),
    "houseNormSummarySubtitle": MessageLookupByLibrary.simpleMessage(
      "A guide, not a rulebook.",
    ),
    "houseNormSummaryTitle": MessageLookupByLibrary.simpleMessage(
      "House norms",
    ),
    "houseNormUrlCopied": MessageLookupByLibrary.simpleMessage(
      "House norms URL copied.",
    ),
    "houseNormViewTitle": MessageLookupByLibrary.simpleMessage(
      "View house norms",
    ),
    "housePulseCardHeader": MessageLookupByLibrary.simpleMessage(
      "Weekly home pulse",
    ),
    "housePulseShareCta": MessageLookupByLibrary.simpleMessage("Share pulse"),
    "housePulseShareMessage": m9,
    "housePulseShareTitle": MessageLookupByLibrary.simpleMessage(
      "Sharing our Kinly home pulse",
    ),
    "housePulseUpdatedOn": m10,
    "houseVibeShareCta": MessageLookupByLibrary.simpleMessage("Share vibe"),
    "houseVibeShareError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t share right now.",
    ),
    "houseVibeShareMessage": m11,
    "houseVibeShareTitle": MessageLookupByLibrary.simpleMessage("Home vibe"),
    "hubCardGratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "Quick thanks from your home.",
    ),
    "hubCardGratitudeWallTitle": MessageLookupByLibrary.simpleMessage(
      "Shoutouts",
    ),
    "hubCodeCopied": MessageLookupByLibrary.simpleMessage("Invite code copied"),
    "hubError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load Home Hub.",
    ),
    "hubHouseDirectorySubtitle": MessageLookupByLibrary.simpleMessage(
      "Wifi, services, links, and renewal reminders.",
    ),
    "hubHouseDirectoryTitle": MessageLookupByLibrary.simpleMessage(
      "House directory",
    ),
    "hubHouseNormsSubtitle": MessageLookupByLibrary.simpleMessage(
      "A guide for how this home works.",
    ),
    "hubHouseNormsTitle": MessageLookupByLibrary.simpleMessage("House norms"),
    "hubInviteCta": MessageLookupByLibrary.simpleMessage("Invite"),
    "hubInviteUnavailable": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load invite.",
    ),
    "hubMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "No active members yet.",
    ),
    "hubPreferencesSubtitle": MessageLookupByLibrary.simpleMessage(
      "How each person likes shared living to work.",
    ),
    "hubPreferencesTitle": MessageLookupByLibrary.simpleMessage("Preferences"),
    "hubQrSubtitle": MessageLookupByLibrary.simpleMessage(
      "Scan to download Kinly",
    ),
    "hubQrTitle": MessageLookupByLibrary.simpleMessage("Share the app"),
    "hubRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "hubRotateError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t rotate invite.",
    ),
    "hubRotateInvite": MessageLookupByLibrary.simpleMessage("Rotate invite"),
    "hubRotateSuccess": MessageLookupByLibrary.simpleMessage("Invite rotated"),
    "hubShareAppBody": m12,
    "hubShareAppCta": MessageLookupByLibrary.simpleMessage("Share Kinly"),
    "hubShareAppTitle": MessageLookupByLibrary.simpleMessage("Get Kinly"),
    "hubShareInviteBody": m13,
    "hubShareInviteTitle": MessageLookupByLibrary.simpleMessage(
      "Invite to my Kinly home",
    ),
    "join_blocked_body": MessageLookupByLibrary.simpleMessage(
      "We\'ve notified the home owner.",
    ),
    "join_blocked_cta": MessageLookupByLibrary.simpleMessage("Done"),
    "join_blocked_title": MessageLookupByLibrary.simpleMessage(
      "This home isn\'t accepting new members right now",
    ),
    "join_error_already_in_other_home": MessageLookupByLibrary.simpleMessage(
      "Leave your current home first.",
    ),
    "join_error_forbidden": MessageLookupByLibrary.simpleMessage(
      "You don\'t have permission to join this home.",
    ),
    "join_error_inactive_invite": MessageLookupByLibrary.simpleMessage(
      "That invite has expired. Ask the owner for a new one.",
    ),
    "join_error_invalid_code": MessageLookupByLibrary.simpleMessage(
      "That invite code looks wrong.",
    ),
    "join_error_paywall_limit": MessageLookupByLibrary.simpleMessage(
      "This home has reached its member limit. Ask the owner to upgrade or remove someone.",
    ),
    "join_error_unauthorized": MessageLookupByLibrary.simpleMessage(
      "Sign in to join this home.",
    ),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t join this home.",
    ),
    "join_hint": MessageLookupByLibrary.simpleMessage(
      "Enter invite code (e.g. ABC123)",
    ),
    "join_submit": MessageLookupByLibrary.simpleMessage("Join"),
    "join_success": m14,
    "join_title": MessageLookupByLibrary.simpleMessage("Join Home"),
    "login_consent_connector": MessageLookupByLibrary.simpleMessage(" & "),
    "login_consent_prefix": MessageLookupByLibrary.simpleMessage(
      "I agree to the ",
    ),
    "login_privacy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "login_tagline": MessageLookupByLibrary.simpleMessage(
      "Together feels lighter",
    ),
    "login_terms": MessageLookupByLibrary.simpleMessage("Service Terms"),
    "login_with_apple": MessageLookupByLibrary.simpleMessage(
      "Continue with Apple",
    ),
    "login_with_google": MessageLookupByLibrary.simpleMessage(
      "Continue with Google",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("Sign out"),
    "membership_status_active": MessageLookupByLibrary.simpleMessage(
      "You\'re connected to a home.",
    ),
    "membership_status_checking": MessageLookupByLibrary.simpleMessage(
      "Connecting to your home...",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "Create or join a home.",
    ),
    "mentionFieldHint": MessageLookupByLibrary.simpleMessage(
      "Type @ to mention someone",
    ),
    "navExplore": MessageLookupByLibrary.simpleMessage("Manage"),
    "navHub": MessageLookupByLibrary.simpleMessage("Home Hub"),
    "navToday": MessageLookupByLibrary.simpleMessage("Today"),
    "npsCannotSkip": MessageLookupByLibrary.simpleMessage(
      "Choose a score to continue.",
    ),
    "npsDescription": MessageLookupByLibrary.simpleMessage(
      "0 means not at all. 10 means it made a real difference.",
    ),
    "npsEmailSubject": MessageLookupByLibrary.simpleMessage(
      "How could Kinly better support your home?",
    ),
    "npsLaunchError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t open the next step.",
    ),
    "npsScaleHighLabel": MessageLookupByLibrary.simpleMessage(
      "10 Made a real difference",
    ),
    "npsScaleLowLabel": MessageLookupByLibrary.simpleMessage("0 Not at all"),
    "npsSubmitErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "Feedback isn\'t available right now.",
    ),
    "npsSubmitErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t send your feedback.",
    ),
    "npsSubmitErrorInvalidScore": MessageLookupByLibrary.simpleMessage(
      "Choose a number between 0 and 10.",
    ),
    "npsSubmitErrorNotRequired": MessageLookupByLibrary.simpleMessage(
      "You don\'t need to share feedback right now.",
    ),
    "npsTitle": MessageLookupByLibrary.simpleMessage(
      "Has Kinly helped your home run more smoothly?",
    ),
    "offline_body": MessageLookupByLibrary.simpleMessage(
      "No internet connection. Try again.",
    ),
    "offline_retry": MessageLookupByLibrary.simpleMessage("Try again"),
    "offline_title": MessageLookupByLibrary.simpleMessage("You\'re offline"),
    "paywallBulletFlows": MessageLookupByLibrary.simpleMessage(
      "Unlimited tasks",
    ),
    "paywallBulletMembers": MessageLookupByLibrary.simpleMessage(
      "Unlimited members",
    ),
    "paywallBulletPhotos": MessageLookupByLibrary.simpleMessage(
      "Unlimited task photos",
    ),
    "paywallBulletShares": MessageLookupByLibrary.simpleMessage(
      "Unlimited bills",
    ),
    "paywallBulletShoppingPhotos": MessageLookupByLibrary.simpleMessage(
      "Unlimited shopping photos",
    ),
    "paywallErrorTitle": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load paywall.",
    ),
    "paywallFeatureUnlimitedSharedExpensePhotos":
        MessageLookupByLibrary.simpleMessage("Unlimited bill photos"),
    "paywallPriceCaption": MessageLookupByLibrary.simpleMessage(
      "One home plan. No hidden tiers.",
    ),
    "paywallPricePerMonth": m15,
    "paywallPriceUnavailable": MessageLookupByLibrary.simpleMessage(
      "Pricing isn\'t available right now.",
    ),
    "paywallPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "Upgrade to Premium",
    ),
    "paywallPurchaseFailed": MessageLookupByLibrary.simpleMessage(
      "Purchase not completed.",
    ),
    "paywallPurchaseSuccess": MessageLookupByLibrary.simpleMessage(
      "You\'re now on Kinly Premium.",
    ),
    "paywallRestoreCta": MessageLookupByLibrary.simpleMessage(
      "Restore purchases",
    ),
    "paywallRetryLabel": MessageLookupByLibrary.simpleMessage("Retry"),
    "paywallSecondaryCta": MessageLookupByLibrary.simpleMessage(
      "Stay on free plan",
    ),
    "paywallSubtitle": MessageLookupByLibrary.simpleMessage(
      "Less than 0.5% of your rent.",
    ),
    "paywallTitle": MessageLookupByLibrary.simpleMessage(
      "Keep your home running smoothly",
    ),
    "personalMentionsTitle": MessageLookupByLibrary.simpleMessage(
      "Personal mentions",
    ),
    "personalProfileLoadError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load your personal profile.",
    ),
    "personalProfileMentions": MessageLookupByLibrary.simpleMessage(
      "Personal mentions",
    ),
    "personalProfilePreferences": MessageLookupByLibrary.simpleMessage(
      "Personal preferences",
    ),
    "personalProfileTitle": MessageLookupByLibrary.simpleMessage(
      "Your profile",
    ),
    "planFreeLabel": MessageLookupByLibrary.simpleMessage("Upgrade to Premium"),
    "planPremiumActiveBody": MessageLookupByLibrary.simpleMessage(
      "Enjoy unlimited access to all features.",
    ),
    "planPremiumActiveTitle": MessageLookupByLibrary.simpleMessage(
      "You\'re on Premium",
    ),
    "planPremiumLabel": MessageLookupByLibrary.simpleMessage("Premium"),
    "preferenceOnboardingBack": MessageLookupByLibrary.simpleMessage("Back"),
    "preferenceOnboardingProgress": m16,
    "preferenceOnboardingSubmit": MessageLookupByLibrary.simpleMessage("Save"),
    "preferenceOnboardingTitle": MessageLookupByLibrary.simpleMessage(
      "Your vibe",
    ),
    "preferencePromptCta": MessageLookupByLibrary.simpleMessage("Start"),
    "preferencePromptSubtitle": MessageLookupByLibrary.simpleMessage(
      "Help your home understand what works for you.",
    ),
    "preferencePromptTitle": MessageLookupByLibrary.simpleMessage(
      "Set your vibe",
    ),
    "preferenceReportDoneCta": MessageLookupByLibrary.simpleMessage("Done"),
    "preferenceReportEditCta": MessageLookupByLibrary.simpleMessage("Edit"),
    "preferenceReportEditError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t save that update.",
    ),
    "preferenceReportEditSectionDone": MessageLookupByLibrary.simpleMessage(
      "Done",
    ),
    "preferenceReportEditSectionHint": MessageLookupByLibrary.simpleMessage(
      "Write what feels right",
    ),
    "preferenceReportEditSectionPrompt": MessageLookupByLibrary.simpleMessage(
      "Edit this section.",
    ),
    "preferenceReportEditTitle": MessageLookupByLibrary.simpleMessage(
      "Edit preferences",
    ),
    "preferenceReportEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Complete your preferences to generate your report.",
    ),
    "preferenceReportEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Preferences not ready",
    ),
    "preferenceReportErrorBody": MessageLookupByLibrary.simpleMessage(
      "Please try again.",
    ),
    "preferenceReportErrorTitle": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load report",
    ),
    "preferenceReportGenerationFailed": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t finish your preference reflection. Go back and try again.",
    ),
    "preferenceReportGenerationMissing": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t finish your preference reflection. Try again soon.",
    ),
    "preferenceReportReadOnlyNote": MessageLookupByLibrary.simpleMessage(
      "This shows what feels comfortable for them.",
    ),
    "preferenceReportTitle": MessageLookupByLibrary.simpleMessage(
      "Your preferences",
    ),
    "preferenceReportViewTitle": MessageLookupByLibrary.simpleMessage(
      "View preferences",
    ),
    "preferenceScenarioCleanlinessSharedSpaceOption1":
        MessageLookupByLibrary.simpleMessage("Keep tidy"),
    "preferenceScenarioCleanlinessSharedSpaceOption2":
        MessageLookupByLibrary.simpleMessage("A little messy"),
    "preferenceScenarioCleanlinessSharedSpaceOption3":
        MessageLookupByLibrary.simpleMessage("Mess is fine"),
    "preferenceScenarioCleanlinessSharedSpaceQuestion":
        MessageLookupByLibrary.simpleMessage("Shared space?"),
    "preferenceScenarioCommunicationChannelOption1":
        MessageLookupByLibrary.simpleMessage("Text"),
    "preferenceScenarioCommunicationChannelOption2":
        MessageLookupByLibrary.simpleMessage("In person"),
    "preferenceScenarioCommunicationChannelOption3":
        MessageLookupByLibrary.simpleMessage("Call"),
    "preferenceScenarioCommunicationChannelQuestion":
        MessageLookupByLibrary.simpleMessage("Best way to reach you?"),
    "preferenceScenarioCommunicationDirectnessOption1":
        MessageLookupByLibrary.simpleMessage("Be gentle"),
    "preferenceScenarioCommunicationDirectnessOption2":
        MessageLookupByLibrary.simpleMessage("Depends"),
    "preferenceScenarioCommunicationDirectnessOption3":
        MessageLookupByLibrary.simpleMessage("Be direct"),
    "preferenceScenarioCommunicationDirectnessQuestion":
        MessageLookupByLibrary.simpleMessage("When something\'s wrong?"),
    "preferenceScenarioConflictResolutionOption1":
        MessageLookupByLibrary.simpleMessage("Cool off first"),
    "preferenceScenarioConflictResolutionOption2":
        MessageLookupByLibrary.simpleMessage("Check in later"),
    "preferenceScenarioConflictResolutionOption3":
        MessageLookupByLibrary.simpleMessage("Talk early"),
    "preferenceScenarioConflictResolutionQuestion":
        MessageLookupByLibrary.simpleMessage("If something\'s off?"),
    "preferenceScenarioEnvironmentLightOption1":
        MessageLookupByLibrary.simpleMessage("Soft"),
    "preferenceScenarioEnvironmentLightOption2":
        MessageLookupByLibrary.simpleMessage("Balanced"),
    "preferenceScenarioEnvironmentLightOption3":
        MessageLookupByLibrary.simpleMessage("Bright"),
    "preferenceScenarioEnvironmentLightQuestion":
        MessageLookupByLibrary.simpleMessage("Lighting?"),
    "preferenceScenarioEnvironmentNoiseOption1":
        MessageLookupByLibrary.simpleMessage("Quiet please"),
    "preferenceScenarioEnvironmentNoiseOption2":
        MessageLookupByLibrary.simpleMessage("Normal noise"),
    "preferenceScenarioEnvironmentNoiseOption3":
        MessageLookupByLibrary.simpleMessage("Lively is fine"),
    "preferenceScenarioEnvironmentNoiseQuestion":
        MessageLookupByLibrary.simpleMessage("Noise level?"),
    "preferenceScenarioEnvironmentScentOption1":
        MessageLookupByLibrary.simpleMessage("Sensitive"),
    "preferenceScenarioEnvironmentScentOption2":
        MessageLookupByLibrary.simpleMessage("Neutral"),
    "preferenceScenarioEnvironmentScentOption3":
        MessageLookupByLibrary.simpleMessage("Doesn\'t bother me"),
    "preferenceScenarioEnvironmentScentQuestion":
        MessageLookupByLibrary.simpleMessage("Strong smells?"),
    "preferenceScenarioPrivacyNotificationsOption1":
        MessageLookupByLibrary.simpleMessage("Please don\'t"),
    "preferenceScenarioPrivacyNotificationsOption2":
        MessageLookupByLibrary.simpleMessage("Important only"),
    "preferenceScenarioPrivacyNotificationsOption3":
        MessageLookupByLibrary.simpleMessage("Anytime"),
    "preferenceScenarioPrivacyNotificationsQuestion":
        MessageLookupByLibrary.simpleMessage("Messages at night?"),
    "preferenceScenarioPrivacyRoomEntryOption1":
        MessageLookupByLibrary.simpleMessage("Knock first"),
    "preferenceScenarioPrivacyRoomEntryOption2":
        MessageLookupByLibrary.simpleMessage("Usually knock"),
    "preferenceScenarioPrivacyRoomEntryOption3":
        MessageLookupByLibrary.simpleMessage("Open door"),
    "preferenceScenarioPrivacyRoomEntryQuestion":
        MessageLookupByLibrary.simpleMessage("Entering your room?"),
    "preferenceScenarioRoutinePlanningOption1":
        MessageLookupByLibrary.simpleMessage("Structured"),
    "preferenceScenarioRoutinePlanningOption2":
        MessageLookupByLibrary.simpleMessage("Some structure"),
    "preferenceScenarioRoutinePlanningOption3":
        MessageLookupByLibrary.simpleMessage("Go with the flow"),
    "preferenceScenarioRoutinePlanningQuestion":
        MessageLookupByLibrary.simpleMessage("Daily life?"),
    "preferenceScenarioScheduleQuietHoursOption1":
        MessageLookupByLibrary.simpleMessage("Quiet nights"),
    "preferenceScenarioScheduleQuietHoursOption2":
        MessageLookupByLibrary.simpleMessage("Depends"),
    "preferenceScenarioScheduleQuietHoursOption3":
        MessageLookupByLibrary.simpleMessage("Active is fine"),
    "preferenceScenarioScheduleQuietHoursQuestion":
        MessageLookupByLibrary.simpleMessage("Evenings?"),
    "preferenceScenarioScheduleSleepTimingOption1":
        MessageLookupByLibrary.simpleMessage("Early bird"),
    "preferenceScenarioScheduleSleepTimingOption2":
        MessageLookupByLibrary.simpleMessage("In between"),
    "preferenceScenarioScheduleSleepTimingOption3":
        MessageLookupByLibrary.simpleMessage("Night owl"),
    "preferenceScenarioScheduleSleepTimingQuestion":
        MessageLookupByLibrary.simpleMessage("Sleep style?"),
    "preferenceScenarioSocialHostingOption1":
        MessageLookupByLibrary.simpleMessage("Rare"),
    "preferenceScenarioSocialHostingOption2":
        MessageLookupByLibrary.simpleMessage("Sometimes"),
    "preferenceScenarioSocialHostingOption3":
        MessageLookupByLibrary.simpleMessage("Often"),
    "preferenceScenarioSocialHostingQuestion":
        MessageLookupByLibrary.simpleMessage("Guests?"),
    "preferenceScenarioSocialTogethernessOption1":
        MessageLookupByLibrary.simpleMessage("Mostly solo"),
    "preferenceScenarioSocialTogethernessOption2":
        MessageLookupByLibrary.simpleMessage("Mix of both"),
    "preferenceScenarioSocialTogethernessOption3":
        MessageLookupByLibrary.simpleMessage("Hang out a lot"),
    "preferenceScenarioSocialTogethernessQuestion":
        MessageLookupByLibrary.simpleMessage("Home energy?"),
    "profileActionConfirm": MessageLookupByLibrary.simpleMessage("Leave home"),
    "profileActionConfirmDelete": MessageLookupByLibrary.simpleMessage(
      "Delete account",
    ),
    "profileConfirmDeleteMessage": MessageLookupByLibrary.simpleMessage(
      "This deletes your account and signs you out. This is permanent.",
    ),
    "profileConfirmDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "Delete your account?",
    ),
    "profileConfirmLeaveMessage": MessageLookupByLibrary.simpleMessage(
      "You\'ll lose access to tasks, history, and invites.",
    ),
    "profileConfirmLeaveTitle": MessageLookupByLibrary.simpleMessage(
      "Leave this home?",
    ),
    "profileConnectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Manage reminders and alerts.",
    ),
    "profileConnectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Notifications",
    ),
    "profileContactEmailSubject": MessageLookupByLibrary.simpleMessage(
      "Contact us",
    ),
    "profileContactLaunchError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t open your email app.",
    ),
    "profileContactUsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Email support@makinglifeeasie.com",
    ),
    "profileContactUsTitle": MessageLookupByLibrary.simpleMessage("Contact us"),
    "profileDeleteAccountSubtitle": MessageLookupByLibrary.simpleMessage(
      "Delete your Kinly account and data.",
    ),
    "profileDeleteAccountTitle": MessageLookupByLibrary.simpleMessage(
      "Delete account",
    ),
    "profileDeleteSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Your account will be deleted shortly. We\'ll sign you out.",
    ),
    "profileGenericError": MessageLookupByLibrary.simpleMessage(
      "Something went wrong.",
    ),
    "profileIdentityAvatarEmpty": MessageLookupByLibrary.simpleMessage(
      "No avatars are available right now.",
    ),
    "profileIdentityAvatarSectionDescription":
        MessageLookupByLibrary.simpleMessage(
          "Use a different avatar for each person in your home.",
        ),
    "profileIdentityAvatarSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Choose an avatar",
    ),
    "profileIdentityLoadError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load your profile.",
    ),
    "profileIdentityRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "profileIdentitySaveButton": MessageLookupByLibrary.simpleMessage(
      "Save changes",
    ),
    "profileIdentitySubtitle": MessageLookupByLibrary.simpleMessage(
      "Choose a username and avatar.",
    ),
    "profileIdentitySuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Profile updated.",
    ),
    "profileIdentityTitle": MessageLookupByLibrary.simpleMessage(
      "Edit profile",
    ),
    "profileIdentityUsernameEmptyError": MessageLookupByLibrary.simpleMessage(
      "Enter a username.",
    ),
    "profileIdentityUsernameFormatError": MessageLookupByLibrary.simpleMessage(
      "Use 3-30 lowercase letters or numbers. Dots and underscores can go in the middle.",
    ),
    "profileIdentityUsernameHint": MessageLookupByLibrary.simpleMessage(
      "letters, numbers, . or _",
    ),
    "profileIdentityUsernameLabel": MessageLookupByLibrary.simpleMessage(
      "Username",
    ),
    "profileIdentityUsernamePreviewFallback":
        MessageLookupByLibrary.simpleMessage("your username"),
    "profileIdentityUsernameTakenError": MessageLookupByLibrary.simpleMessage(
      "That username is taken.",
    ),
    "profileInfoHubLoadError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load the Info Hub. Check your connection.",
    ),
    "profileInfoHubSubtitle": MessageLookupByLibrary.simpleMessage(
      "Open the Kinly Notion hub in-app.",
    ),
    "profileInfoHubTitle": MessageLookupByLibrary.simpleMessage("Info Hub"),
    "profileKickActionConfirm": MessageLookupByLibrary.simpleMessage(
      "Remove member",
    ),
    "profileKickMemberSubtitle": MessageLookupByLibrary.simpleMessage(
      "Choose who loses access to this home.",
    ),
    "profileKickMemberTitle": MessageLookupByLibrary.simpleMessage(
      "Remove a member",
    ),
    "profileKickNoMembers": MessageLookupByLibrary.simpleMessage(
      "No other members to remove right now.",
    ),
    "profileKickOwnerOnly": MessageLookupByLibrary.simpleMessage(
      "Only the home owner can remove members.",
    ),
    "profileKickSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "Choose a member to remove. They\'ll lose access right away.",
    ),
    "profileKickSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Remove a member",
    ),
    "profileKickSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "They no longer have access to this home.",
    ),
    "profileLeaveEligibilityError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load your home members.",
    ),
    "profileLeaveEligibilityLoading": MessageLookupByLibrary.simpleMessage(
      "Checking home members...",
    ),
    "profileLeaveHomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "You\'ll leave this shared Kinly space.",
    ),
    "profileLeaveHomeTitle": MessageLookupByLibrary.simpleMessage("Leave home"),
    "profileLeaveOwnerNoEligibleMembers": MessageLookupByLibrary.simpleMessage(
      "No one else can take ownership right now.",
    ),
    "profileLeaveOwnerSoloMessage": MessageLookupByLibrary.simpleMessage(
      "You\'re the last member. Leaving will deactivate this home.",
    ),
    "profileLeaveSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "You left your home.",
    ),
    "profileLeaveTransferSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "Choose who becomes the new owner before you leave.",
    ),
    "profileLeaveTransferSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Transfer ownership",
    ),
    "profileLeaveTransferSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Ownership transferred. Finishing leave...",
    ),
    "profileLogoutSubtitle": MessageLookupByLibrary.simpleMessage(
      "Sign out of Kinly on this device.",
    ),
    "profileLogoutTitle": MessageLookupByLibrary.simpleMessage("Sign out"),
    "profileMissingHomeError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t find your current home.",
    ),
    "profileSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Manage your account and home access.",
    ),
    "profileSettingsTitle": MessageLookupByLibrary.simpleMessage("Profile"),
    "profile_deactivated_message": MessageLookupByLibrary.simpleMessage(
      "Your profile is off. Sign in with another email.",
    ),
    "pulseCloudySteadySummary": MessageLookupByLibrary.simpleMessage(
      "Some things worked. Some didn\'t.",
    ),
    "pulseCloudySteadyTitle": MessageLookupByLibrary.simpleMessage("Mixed"),
    "pulseCloudyTenseSummary": MessageLookupByLibrary.simpleMessage(
      "Some tension came up this week.",
    ),
    "pulseCloudyTenseTitle": MessageLookupByLibrary.simpleMessage(
      "Needs attention",
    ),
    "pulseFormingSummary": MessageLookupByLibrary.simpleMessage(
      "A few more check-ins will give a clearer picture.",
    ),
    "pulseFormingTitle": MessageLookupByLibrary.simpleMessage("Still forming"),
    "pulsePartlySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "Mostly steady, with some room to improve.",
    ),
    "pulsePartlySupportedTitle": MessageLookupByLibrary.simpleMessage(
      "Okay overall",
    ),
    "pulseRainySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "It may be time for a small reset.",
    ),
    "pulseRainySupportedTitle": MessageLookupByLibrary.simpleMessage(
      "Reset recommended",
    ),
    "pulseRainyUnsupportedSummary": MessageLookupByLibrary.simpleMessage(
      "There\'s noticeable friction right now.",
    ),
    "pulseRainyUnsupportedTitle": MessageLookupByLibrary.simpleMessage(
      "Reset needed",
    ),
    "pulseSunnyBumpySummary": MessageLookupByLibrary.simpleMessage(
      "Mostly smooth, with a few bumps.",
    ),
    "pulseSunnyBumpyTitle": MessageLookupByLibrary.simpleMessage(
      "Mostly smooth",
    ),
    "pulseSunnyCalmSummary": MessageLookupByLibrary.simpleMessage(
      "Things felt smooth this week.",
    ),
    "pulseSunnyCalmTitle": MessageLookupByLibrary.simpleMessage(
      "Running smoothly",
    ),
    "pulseThunderstormSummary": MessageLookupByLibrary.simpleMessage(
      "Tension is high. Reset soon.",
    ),
    "pulseThunderstormTitle": MessageLookupByLibrary.simpleMessage(
      "Tension high",
    ),
    "quick_add_flow_subtitle": MessageLookupByLibrary.simpleMessage(
      "Create a task",
    ),
    "quick_add_flow_title": MessageLookupByLibrary.simpleMessage("Task"),
    "quick_add_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "Add a bill",
    ),
    "quick_add_share_title": MessageLookupByLibrary.simpleMessage("Bill"),
    "quick_add_title": MessageLookupByLibrary.simpleMessage("Quick Add"),
    "reflectiveAcknowledgementTitle": MessageLookupByLibrary.simpleMessage(
      "Got it.",
    ),
    "reflectiveGenericPrimary": MessageLookupByLibrary.simpleMessage(
      "Putting this together with care.",
    ),
    "reflectiveGenericSecondary": MessageLookupByLibrary.simpleMessage(
      "A short pause before we show it.",
    ),
    "reflectiveHouseNormsPrimary": MessageLookupByLibrary.simpleMessage(
      "Reflecting what this home shared.",
    ),
    "reflectiveHouseNormsSecondary": MessageLookupByLibrary.simpleMessage(
      "A shared guide, not a rulebook.",
    ),
    "reflectiveHousePrimary": MessageLookupByLibrary.simpleMessage(
      "Putting your home\'s expectations into words.",
    ),
    "reflectiveHouseSecondary": MessageLookupByLibrary.simpleMessage(
      "So expectations are clear.",
    ),
    "reflectivePersonalPrimary": MessageLookupByLibrary.simpleMessage(
      "Reflecting what you shared.",
    ),
    "reflectivePersonalSecondary": MessageLookupByLibrary.simpleMessage(
      "So others understand what feels comfortable to you.",
    ),
    "shareCreateAmountHint": MessageLookupByLibrary.simpleMessage("0.00"),
    "shareCreateAmountLabel": MessageLookupByLibrary.simpleMessage("Amount"),
    "shareCreateCustomAmountLabel": MessageLookupByLibrary.simpleMessage(
      "Amount",
    ),
    "shareCreateCustomHelper": MessageLookupByLibrary.simpleMessage(
      "Enter each person\'s share. Total equals the amount above.",
    ),
    "shareCreateCyclePeriod": m17,
    "shareCreateDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "e.g. Grocery run",
    ),
    "shareCreateDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "Description",
    ),
    "shareCreateErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "You don\'t have permission to create this right now.",
    ),
    "shareCreateErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t create bill.",
    ),
    "shareCreateErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "You\'ve reached the free limit for active bills. Upgrade for more.",
    ),
    "shareCreateErrorRecurrenceDraft": MessageLookupByLibrary.simpleMessage(
      "Drafts do not repeat until you add a split.",
    ),
    "shareCreateLoadError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load your home members.",
    ),
    "shareCreateNotesHint": MessageLookupByLibrary.simpleMessage(
      "Optional note everyone can see",
    ),
    "shareCreateNotesLabel": MessageLookupByLibrary.simpleMessage("Notes"),
    "shareCreateParticipantsEmpty": MessageLookupByLibrary.simpleMessage(
      "You need at least two home members to share a bill.",
    ),
    "shareCreateRecurrenceEveryLabel": MessageLookupByLibrary.simpleMessage(
      "Every",
    ),
    "shareCreateRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "Repeat",
    ),
    "shareCreateRecurrenceToggleLabel": MessageLookupByLibrary.simpleMessage(
      "Recurring",
    ),
    "shareCreateRecurrenceUnitDay": MessageLookupByLibrary.simpleMessage("Day"),
    "shareCreateRecurrenceUnitMonth": MessageLookupByLibrary.simpleMessage(
      "Month",
    ),
    "shareCreateRecurrenceUnitWeek": MessageLookupByLibrary.simpleMessage(
      "Week",
    ),
    "shareCreateRecurrenceUnitYear": MessageLookupByLibrary.simpleMessage(
      "Year",
    ),
    "shareCreateRetry": MessageLookupByLibrary.simpleMessage("Try again"),
    "shareCreateSplitCustom": MessageLookupByLibrary.simpleMessage(
      "Choose amounts",
    ),
    "shareCreateSplitEqual": MessageLookupByLibrary.simpleMessage(
      "Split evenly",
    ),
    "shareCreateSplitLabel": MessageLookupByLibrary.simpleMessage(
      "How do you want to split this?",
    ),
    "shareCreateStartLabel": MessageLookupByLibrary.simpleMessage(
      "When does this apply?",
    ),
    "shareCreateSubmit": MessageLookupByLibrary.simpleMessage("Create"),
    "shareCreateSuccess": MessageLookupByLibrary.simpleMessage("Bill created."),
    "shareCreateTitle": MessageLookupByLibrary.simpleMessage("Add Bill"),
    "shareCreateValidationAmount": MessageLookupByLibrary.simpleMessage(
      "Enter an amount greater than zero.",
    ),
    "shareCreateValidationCustomAmounts": MessageLookupByLibrary.simpleMessage(
      "Enter a valid amount for each selected person.",
    ),
    "shareCreateValidationCustomParticipants":
        MessageLookupByLibrary.simpleMessage(
          "Select at least one person for this bill.",
        ),
    "shareCreateValidationCustomSinglePayer":
        MessageLookupByLibrary.simpleMessage("Add at least one other person."),
    "shareCreateValidationCustomSum": MessageLookupByLibrary.simpleMessage(
      "Make sure the split adds up to the total amount.",
    ),
    "shareCreateValidationCustomSumBreakdown": m18,
    "shareCreateValidationDescription": MessageLookupByLibrary.simpleMessage(
      "Enter a description.",
    ),
    "shareCreateValidationEqualParticipants":
        MessageLookupByLibrary.simpleMessage(
          "Select at least one person to split this bill.",
        ),
    "shareCreateValidationRecurrence": MessageLookupByLibrary.simpleMessage(
      "Choose how often this repeats.",
    ),
    "shareCreateValidationRecurrenceSplit":
        MessageLookupByLibrary.simpleMessage(
          "Choose a split before making this recurring.",
        ),
    "shareCreateValidationStartDate": MessageLookupByLibrary.simpleMessage(
      "Choose a start date.",
    ),
    "shareCreateValidationStartDateRange": MessageLookupByLibrary.simpleMessage(
      "Choose a date in the allowed range.",
    ),
    "shareCreatedListActiveAmount": m19,
    "shareCreatedListActiveSubtitle": m20,
    "shareCreatedListDraftBadge": MessageLookupByLibrary.simpleMessage(
      "Unassigned",
    ),
    "shareCreatedListDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "Split it before publishing so everyone knows their part.",
    ),
    "shareCreatedListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Bills keep money clear.",
    ),
    "shareCreatedListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "No bills yet",
    ),
    "shareCreatedListError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load your bills. Pull to refresh.",
    ),
    "shareCreatedListPaidBadge": MessageLookupByLibrary.simpleMessage(
      "Paid off",
    ),
    "shareCreatedListRetry": MessageLookupByLibrary.simpleMessage("Try again"),
    "shareCreatedListTitle": MessageLookupByLibrary.simpleMessage("Your bills"),
    "shareEditClose": MessageLookupByLibrary.simpleMessage("Close"),
    "shareEditDeleteButton": MessageLookupByLibrary.simpleMessage("Delete"),
    "shareEditDeleteConfirm": MessageLookupByLibrary.simpleMessage("Delete"),
    "shareEditDeleteConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "This removes the draft for everyone.",
    ),
    "shareEditDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Delete bill?",
    ),
    "shareEditDeleteError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t delete bill.",
    ),
    "shareEditDeleteSuccess": MessageLookupByLibrary.simpleMessage(
      "Bill deleted.",
    ),
    "shareEditDisabledActive": MessageLookupByLibrary.simpleMessage(
      "Active bills are not editable.",
    ),
    "shareEditDisabledConverted": MessageLookupByLibrary.simpleMessage(
      "This bill is now a plan and is not editable here.",
    ),
    "shareEditDisabledGeneric": MessageLookupByLibrary.simpleMessage(
      "This bill is not editable right now.",
    ),
    "shareEditDisabledRecurringCycle": MessageLookupByLibrary.simpleMessage(
      "Recurring cycles are not editable here.",
    ),
    "shareEditLoadError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load that draft.",
    ),
    "shareEditNotAllowed": MessageLookupByLibrary.simpleMessage(
      "This stays locked until someone takes this bill.",
    ),
    "shareEditSplitsLocked": MessageLookupByLibrary.simpleMessage(
      "Splits are locked because someone already paid. You can still update the description and notes.",
    ),
    "shareEditSubmit": MessageLookupByLibrary.simpleMessage("Update"),
    "shareEditSuccess": MessageLookupByLibrary.simpleMessage("Bill updated."),
    "shareEditTerminateError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t end the plan.",
    ),
    "shareEditTerminatePlan": MessageLookupByLibrary.simpleMessage("End plan"),
    "shareEditTerminatePlanBusy": MessageLookupByLibrary.simpleMessage(
      "Ending...",
    ),
    "shareEditTerminatePlanConfirm": MessageLookupByLibrary.simpleMessage(
      "End plan",
    ),
    "shareEditTerminatePlanMessage": MessageLookupByLibrary.simpleMessage(
      "This stops future bill cycles.",
    ),
    "shareEditTerminatePlanTitle": MessageLookupByLibrary.simpleMessage(
      "End recurring plan?",
    ),
    "shareEditTerminateSuccess": MessageLookupByLibrary.simpleMessage(
      "Plan ended.",
    ),
    "shareEditTitle": MessageLookupByLibrary.simpleMessage("Edit Bill"),
    "shareOwedDetailEmpty": MessageLookupByLibrary.simpleMessage(
      "You\'re all caught up with this person.",
    ),
    "shareOwedDetailError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t mark this payment as settled.",
    ),
    "shareOwedDetailPaid": MessageLookupByLibrary.simpleMessage(
      "Mark as settled",
    ),
    "shareOwedDetailSuccess": MessageLookupByLibrary.simpleMessage(
      "Marked settled.",
    ),
    "shareOwedDetailTitle": MessageLookupByLibrary.simpleMessage("To settle"),
    "sharePaidDetailAcknowledge": MessageLookupByLibrary.simpleMessage(
      "Acknowledge receipt",
    ),
    "sharePaidDetailAcknowledgeError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t acknowledge this payment.",
    ),
    "sharePaidDetailAcknowledging": MessageLookupByLibrary.simpleMessage(
      "Acknowledging...",
    ),
    "shoppingAllItemsBought": MessageLookupByLibrary.simpleMessage(
      "Everything bought",
    ),
    "shoppingAmountHint": MessageLookupByLibrary.simpleMessage(
      "e.g. 2 cartons",
    ),
    "shoppingAmountLabel": MessageLookupByLibrary.simpleMessage("Amount"),
    "shoppingArchiveCta": MessageLookupByLibrary.simpleMessage("Bought items"),
    "shoppingArchiveDraftBillCreated": MessageLookupByLibrary.simpleMessage(
      "Draft bill created",
    ),
    "shoppingArchiveItemsBought": MessageLookupByLibrary.simpleMessage(
      "Items marked bought and removed",
    ),
    "shoppingArchiveShareNo": MessageLookupByLibrary.simpleMessage("No"),
    "shoppingArchiveSharePromptBody": MessageLookupByLibrary.simpleMessage(
      "Create a draft bill from these items?",
    ),
    "shoppingArchiveSharePromptTitle": MessageLookupByLibrary.simpleMessage(
      "Create bill?",
    ),
    "shoppingArchiveShareYes": MessageLookupByLibrary.simpleMessage("Yes"),
    "shoppingCardSubtitle": m21,
    "shoppingCardTitle": MessageLookupByLibrary.simpleMessage("Shopping list"),
    "shoppingContextHint": MessageLookupByLibrary.simpleMessage(
      "Brand, size, or notes",
    ),
    "shoppingContextLabel": MessageLookupByLibrary.simpleMessage("Notes"),
    "shoppingCreateTitle": MessageLookupByLibrary.simpleMessage(
      "Add shopping item",
    ),
    "shoppingDelete": MessageLookupByLibrary.simpleMessage("Delete item"),
    "shoppingDeleteConfirmBody": MessageLookupByLibrary.simpleMessage(
      "This removes it from the shared shopping list.",
    ),
    "shoppingDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Delete this item?",
    ),
    "shoppingDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Shopping item",
    ),
    "shoppingEditTitle": MessageLookupByLibrary.simpleMessage(
      "Edit shopping item",
    ),
    "shoppingEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "No shopping items.",
    ),
    "shoppingErrorItemAlreadyCompletedByOther":
        MessageLookupByLibrary.simpleMessage(
          "Someone already marked this bought.",
        ),
    "shoppingListTitle": MessageLookupByLibrary.simpleMessage("Shopping list"),
    "shoppingMarkCompleteCta": MessageLookupByLibrary.simpleMessage(
      "Mark bought",
    ),
    "shoppingNameHint": MessageLookupByLibrary.simpleMessage("e.g. Milk"),
    "shoppingNameLabel": MessageLookupByLibrary.simpleMessage("Name"),
    "shoppingPhotoLabel": MessageLookupByLibrary.simpleMessage("Add photo"),
    "shoppingPhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Add a photo",
    ),
    "shoppingPhotoReplaceLabel": MessageLookupByLibrary.simpleMessage(
      "Help others buy the right item",
    ),
    "shoppingSubmitAdd": MessageLookupByLibrary.simpleMessage("Add item"),
    "shoppingSubmitEdit": MessageLookupByLibrary.simpleMessage("Save changes"),
    "shoppingTabPending": MessageLookupByLibrary.simpleMessage("To buy"),
    "shoppingValidationName": MessageLookupByLibrary.simpleMessage(
      "Enter an item name.",
    ),
    "startReturningSubtitle": MessageLookupByLibrary.simpleMessage(
      "What do you want to do?",
    ),
    "startReturningTitle": m22,
    "todayAddSheetFlow": MessageLookupByLibrary.simpleMessage("Add Task"),
    "todayAddSheetShare": MessageLookupByLibrary.simpleMessage("Add Bill"),
    "todayAddSheetShopping": MessageLookupByLibrary.simpleMessage(
      "Add Shopping Item",
    ),
    "todayAddSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Add to your home",
    ),
    "todayEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Nothing needs your attention right now.",
    ),
    "todayEmptyCardBadge": MessageLookupByLibrary.simpleMessage(
      "Take a breather",
    ),
    "todayEmptyCardTitle": MessageLookupByLibrary.simpleMessage(
      "All caught up",
    ),
    "todayFlatmateInviteSubtitle": MessageLookupByLibrary.simpleMessage(
      "Stay aligned and share responsibilities.",
    ),
    "todayFlatmateInviteTitle": MessageLookupByLibrary.simpleMessage(
      "Invite your flatmates",
    ),
    "todayFlowBadgeNew": MessageLookupByLibrary.simpleMessage("new today"),
    "todayFlowSectionTitle": MessageLookupByLibrary.simpleMessage("Tasks"),
    "todayFlowSeeAll": m23,
    "todayFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "Here\'s what needs attention today.",
    ),
    "todayFlowTabActive": MessageLookupByLibrary.simpleMessage("Active"),
    "todayFlowTabDrafts": MessageLookupByLibrary.simpleMessage("Drafts"),
    "todayGratitudeHouseCta": MessageLookupByLibrary.simpleMessage(
      "House shoutouts",
    ),
    "todayGratitudePersonalCta": MessageLookupByLibrary.simpleMessage(
      "My shoutouts",
    ),
    "todayGratitudeSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Shoutouts",
    ),
    "todayGratitudeUnreadBody": MessageLookupByLibrary.simpleMessage(
      "New shoutouts are waiting for you.",
    ),
    "todayHouseDirectoryAcknowledgeCta": MessageLookupByLibrary.simpleMessage(
      "Acknowledge",
    ),
    "todayHouseDirectoryDismissCta": MessageLookupByLibrary.simpleMessage(
      "Dismiss",
    ),
    "todayHouseDirectoryOpenCta": MessageLookupByLibrary.simpleMessage(
      "Open directory",
    ),
    "todayHouseDirectoryReminderDue": m33,
    "todayHouseDirectoryRemindersTitle": MessageLookupByLibrary.simpleMessage(
      "Renewal reminders",
    ),
    "todayInviteFriendsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Share Kinly with friends.",
    ),
    "todayInviteFriendsTitle": MessageLookupByLibrary.simpleMessage(
      "Invite friends to Kinly",
    ),
    "todayInviteNotNow": MessageLookupByLibrary.simpleMessage("Not now"),
    "todayInviteShareCta": MessageLookupByLibrary.simpleMessage("Share invite"),
    "todayMemberCapPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "Upgrade home",
    ),
    "todayMemberCapResolutionFailed": m24,
    "todayMemberCapResolutionJoined": m25,
    "todayMemberCapResolutionSuperseded": m26,
    "todayMemberCapResolutionUnknownName": MessageLookupByLibrary.simpleMessage(
      "Someone",
    ),
    "todayMemberCapSecondaryCta": MessageLookupByLibrary.simpleMessage(
      "Ignore",
    ),
    "todayMemberCapSubtitle": m27,
    "todayMemberCapSubtitleGeneric": MessageLookupByLibrary.simpleMessage(
      "Upgrade to add more people.",
    ),
    "todayMemberCapTitle": MessageLookupByLibrary.simpleMessage(
      "Someone wants to join your home",
    ),
    "todayShareActiveSubtitle": m28,
    "todayShareError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t refresh bills right now.",
    ),
    "todaySharePaidSubtitle": MessageLookupByLibrary.simpleMessage(
      "Settled amount",
    ),
    "todaySharePaidUnseen": m29,
    "todayShareSectionTitle": MessageLookupByLibrary.simpleMessage("Bills"),
    "todayShareTabActive": MessageLookupByLibrary.simpleMessage("To settle"),
    "todayShareTabDrafts": MessageLookupByLibrary.simpleMessage("Drafts"),
    "todayShareTabPaidToMe": MessageLookupByLibrary.simpleMessage("Settled"),
    "vibeCozySocialSummary": MessageLookupByLibrary.simpleMessage(
      "Your home feels cozy and calm together.",
    ),
    "vibeCozySocialTitle": MessageLookupByLibrary.simpleMessage("Cozy social"),
    "vibeDefaultSummary": MessageLookupByLibrary.simpleMessage(
      "Your home feels balanced.",
    ),
    "vibeDefaultTitle": MessageLookupByLibrary.simpleMessage("Balanced home"),
    "vibeEasygoingSummary": MessageLookupByLibrary.simpleMessage(
      "Your home feels relaxed and flexible.",
    ),
    "vibeEasygoingTitle": MessageLookupByLibrary.simpleMessage(
      "Easygoing flow",
    ),
    "vibeIndependentSummary": MessageLookupByLibrary.simpleMessage(
      "Your home values space and quiet.",
    ),
    "vibeIndependentTitle": MessageLookupByLibrary.simpleMessage(
      "Independent calm",
    ),
    "vibeInsufficientSummary": MessageLookupByLibrary.simpleMessage(
      "Complete preferences to see your home vibe.",
    ),
    "vibeInsufficientTitle": MessageLookupByLibrary.simpleMessage(
      "Not enough data yet",
    ),
    "vibeMixedSummary": MessageLookupByLibrary.simpleMessage(
      "Your home has mixed living styles.",
    ),
    "vibeMixedTitle": MessageLookupByLibrary.simpleMessage("Mixed home"),
    "vibeQuietCareSummary": MessageLookupByLibrary.simpleMessage(
      "Your home feels calm and gentle.",
    ),
    "vibeQuietCareTitle": MessageLookupByLibrary.simpleMessage("Quiet care"),
    "vibeSocialSummary": MessageLookupByLibrary.simpleMessage(
      "Your home feels active and social.",
    ),
    "vibeSocialTitle": MessageLookupByLibrary.simpleMessage("Social energy"),
    "vibeSteadySummary": MessageLookupByLibrary.simpleMessage(
      "Your home feels steady and consistent.",
    ),
    "vibeSteadyTitle": MessageLookupByLibrary.simpleMessage("Steady calm"),
    "vibeStructuredSummary": MessageLookupByLibrary.simpleMessage(
      "Your home works best with routines and plans.",
    ),
    "vibeStructuredTitle": MessageLookupByLibrary.simpleMessage(
      "Structured rhythm",
    ),
    "vibeWarmSocialSummary": MessageLookupByLibrary.simpleMessage(
      "Your home feels warm and welcoming.",
    ),
    "vibeWarmSocialTitle": MessageLookupByLibrary.simpleMessage("Warm social"),
    "weeklyRewriteCta": MessageLookupByLibrary.simpleMessage(
      "Send calmly with Kinly",
    ),
    "welcome_create": MessageLookupByLibrary.simpleMessage("Create a Home"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("Join a Home"),
    "welcome_title": MessageLookupByLibrary.simpleMessage("Welcome to Kinly"),
  };
}
