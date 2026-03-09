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

  static String m8(current, total) => "Question ${current} of ${total}";

  static String m9(link) =>
      "Sharing our Kinly house pulse. Download the app: ${link}";

  static String m10(date) => "Updated ${date}";

  static String m11(link) =>
      "Sharing our Kinly house vibe. Download the app: ${link}";

  static String m12(link) => "Share Kinly so together feels lighter: ${link}";

  static String m13(code, link) =>
      "Welcome to our Kinly house! Enter this invite code: ${code}\n\nDownload the Kinly app: ${link}";

  static String m14(code) => "You\'re in. Welcome to your household!";

  static String m15(price) => "${price} per month.";

  static String m16(current, total) => "Question ${current} of ${total}";

  static String m17(period) => "Applies to ${period}";

  static String m18(total, included, difference) =>
      "Custom split does not match. Total: ${total}. Included: ${included}. Difference: ${difference}.";

  static String m19(paidAmount, totalAmount) =>
      "${paidAmount} of ${totalAmount} collected";

  static String m20(paid, total) => "${paid} of ${total} paid";

  static String m21(count) =>
      "${Intl.plural(count, one: '${count} item to check', other: '${count} items to check')}";

  static String m22(name) => "Hi ${name}";

  static String m23(count) =>
      "See all ${Intl.plural(count, one: '(#)', other: '(#)')}";

  static String m24(name) => "We could not complete ${name}\'s request.";

  static String m25(name) => "${name} joined your home.";

  static String m26(name) => "${name} joined another home.";

  static String m27(names) =>
      "${names} wants to join your home. Upgrade to support unlimited members.";

  static String m28(count) =>
      "${Intl.plural(count, one: '${count} payment pending', other: '${count} to settle')}";

  static String m29(count) =>
      "${Intl.plural(count, one: '${count} new payment to you', other: '${count} new payments to you')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("Kinly"),
    "authMembershipLoadFailed": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t refresh your home membership. Please try again.",
    ),
    "bootstrap_initializing": m0,
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "connectionNotificationsPermissionBlocked":
        MessageLookupByLibrary.simpleMessage(
          "Turn on notifications in your phone settings to use this.",
        ),
    "connectionNotificationsTimeLabel": MessageLookupByLibrary.simpleMessage(
      "Reminder time",
    ),
    "connectionNotificationsTimeSubtitle": m1,
    "connectionNotificationsToggleSubtitleOff":
        MessageLookupByLibrary.simpleMessage(
          "Turn on reminders about your home.",
        ),
    "connectionNotificationsToggleSubtitleOn":
        MessageLookupByLibrary.simpleMessage("Get one reminder each day."),
    "connectionNotificationsToggleTitle": MessageLookupByLibrary.simpleMessage(
      "Daily notifications",
    ),
    "connectionSettingsGenericError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t update connection settings. Try again.",
    ),
    "connectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Control daily reminders and notification timing.",
    ),
    "connectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Connection settings",
    ),
    "create_failed_generic": MessageLookupByLibrary.simpleMessage(
      "Could not create the house. Try again.",
    ),
    "demoAccess": MessageLookupByLibrary.simpleMessage("Demo Access"),
    "demoAccessEmail": MessageLookupByLibrary.simpleMessage("Email"),
    "demoAccessError": MessageLookupByLibrary.simpleMessage(
      "Could not sign in. Please check your credentials.",
    ),
    "demoAccessPassword": MessageLookupByLibrary.simpleMessage("Password"),
    "demoAccessSubmit": MessageLookupByLibrary.simpleMessage("Sign in"),
    "demoAccessTapHint": m2,
    "exploreFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "See what needs doing and who\'s taking care of it.",
    ),
    "exploreIntroSubtitle": MessageLookupByLibrary.simpleMessage(
      "Update status and details to keep shared things clear.",
    ),
    "exploreShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "See every Bill you\'ve created and track collections.",
    ),
    "exploreShoppingSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Shopping list",
    ),
    "exploreShoppingSubtitle": MessageLookupByLibrary.simpleMessage(
      "View and manage your shared shopping items.",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage(
      "Who\'s handling this?",
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
      "This removes the flow for everyone in your home.",
    ),
    "flowChoreDeleteDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Delete this flow?",
    ),
    "flowChoreDetailCompleteButton": MessageLookupByLibrary.simpleMessage(
      "Mark complete",
    ),
    "flowChoreDetailCompletionError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t complete this task. Please try again.",
    ),
    "flowChoreDetailCompletionSuccess": MessageLookupByLibrary.simpleMessage(
      "Task completed.",
    ),
    "flowChoreDetailMoreInfoTitle": MessageLookupByLibrary.simpleMessage(
      "Helpful context",
    ),
    "flowChoreDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Task details",
    ),
    "flowChoreDetailUnassigned": MessageLookupByLibrary.simpleMessage(
      "Unassigned",
    ),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage("Edit Task"),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "That member isn\'t part of this home right now.",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "You don\'t have permission to change this flow.",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t save this flow. Please try again.",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "That photo path isn\'t valid for this home.",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "Pick a valid start date.",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "This flow is not available to update right now.",
    ),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "You\'re at the free limit for active flows. Upgrade for more space.",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "You\'re at the free limit for flow photos. Upgrade for more space.",
    ),
    "flowChoreExpectationPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Reference photo",
    ),
    "flowChoreHowToHint": MessageLookupByLibrary.simpleMessage(
      "Add a link if there\'s a specific way to do it",
    ),
    "flowChoreHowToLabel": MessageLookupByLibrary.simpleMessage(
      "How to do it (optional)",
    ),
    "flowChoreHowToLaunchError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t open that link. Try again.",
    ),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t load this task. Please try again.",
    ),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage(
      "Eg. Bin night, clean the fridge, water plants",
    ),
    "flowChoreNameLabel": MessageLookupByLibrary.simpleMessage(
      "What needs to be done?",
    ),
    "flowChoreNotesHint": MessageLookupByLibrary.simpleMessage(
      "Anything that helps others do this easily",
    ),
    "flowChoreNotesLabel": MessageLookupByLibrary.simpleMessage(
      "Why this matters",
    ),
    "flowChorePhotoLabel": MessageLookupByLibrary.simpleMessage(
      "What good looks like",
    ),
    "flowChorePhotoLoadError": MessageLookupByLibrary.simpleMessage(
      "Could not load photo",
    ),
    "flowChorePhotoPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "Allow camera access to take a photo.",
    ),
    "flowChorePhotoPermissionOpenSettings":
        MessageLookupByLibrary.simpleMessage("Open settings"),
    "flowChorePhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "A photo can help everyone stay aligned",
    ),
    "flowChorePhotoUploadError": MessageLookupByLibrary.simpleMessage(
      "Could not upload the photo. Try again.",
    ),
    "flowChoreRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "How often does this come up?",
    ),
    "flowChoreRecurrenceNone": MessageLookupByLibrary.simpleMessage("One time"),
    "flowChoreRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "flowChoreStartLabel": MessageLookupByLibrary.simpleMessage(
      "When does this come up? ",
    ),
    "flowChoreSubmitCreate": MessageLookupByLibrary.simpleMessage(
      "Create flow",
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
      "Pick a date up to a year from today.",
    ),
    "flowChoreValidationHowToUrl": MessageLookupByLibrary.simpleMessage(
      "Enter a valid link that starts with http or https.",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage(
      "Name this task.",
    ),
    "flowChoreViewTitle": MessageLookupByLibrary.simpleMessage("View Task"),
    "flowListDraftLabel": MessageLookupByLibrary.simpleMessage("Draft"),
    "flowListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Tasks to keep everyone aligned.",
    ),
    "flowListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Nothing here yet",
    ),
    "flowListError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t load tasks. Pull to refresh.",
    ),
    "flowListOverdueLabel": MessageLookupByLibrary.simpleMessage(
      "Needs attention",
    ),
    "flowListTabCurrent": MessageLookupByLibrary.simpleMessage("Current"),
    "flowListTabFuture": MessageLookupByLibrary.simpleMessage("Upcoming"),
    "force_update_body": MessageLookupByLibrary.simpleMessage(
      "This version of Kinly is no longer supported. Please install the newest release to continue.",
    ),
    "force_update_button": MessageLookupByLibrary.simpleMessage("Update Kinly"),
    "force_update_title": MessageLookupByLibrary.simpleMessage("Update needed"),
    "friendDefaultName": MessageLookupByLibrary.simpleMessage("friend"),
    "gratitudeWallEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Quick thanks live here.\n\nAdd one from this week.",
    ),
    "gratitudeWallEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "No shoutouts yet",
    ),
    "gratitudeWallErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Unable to load shoutouts right now.",
    ),
    "gratitudeWallFooter": m3,
    "gratitudeWallHouseTab": MessageLookupByLibrary.simpleMessage("House"),
    "gratitudeWallPersonalSummary": MessageLookupByLibrary.simpleMessage(
      "A private place to save quick thanks.",
    ),
    "gratitudeWallPersonalTab": MessageLookupByLibrary.simpleMessage("Mine"),
    "gratitudeWallPersonalTitle": MessageLookupByLibrary.simpleMessage(
      "My Shoutouts",
    ),
    "gratitudeWallRetry": MessageLookupByLibrary.simpleMessage("Try again"),
    "gratitudeWallShareCta": MessageLookupByLibrary.simpleMessage("Share"),
    "gratitudeWallShareError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t share right now. Please try again.",
    ),
    "gratitudeWallShareMessage": m4,
    "gratitudeWallShareTitle": MessageLookupByLibrary.simpleMessage(
      "House shoutouts",
    ),
    "gratitudeWallStatsHomes": MessageLookupByLibrary.simpleMessage("Houses"),
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
          "Add a short note to send this mention.",
        ),
    "harmonyErrorCommentRequiredForPublicWall":
        MessageLookupByLibrary.simpleMessage(
          "Add a short note to post this shoutout.",
        ),
    "harmonyErrorComplaintNeedsSentence": MessageLookupByLibrary.simpleMessage(
      "Add a clear sentence so it\'s easier to understand.",
    ),
    "harmonyErrorComplaintTooBrief": MessageLookupByLibrary.simpleMessage(
      "Write a short sentence so it\'s easier to understand.",
    ),
    "harmonyErrorComplaintTooShort": MessageLookupByLibrary.simpleMessage(
      "Add a little more detail so it\'s clear.",
    ),
    "harmonyErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "Submitting for this home is unavailable.",
    ),
    "harmonyErrorSingleMentionRequired": MessageLookupByLibrary.simpleMessage(
      "Choose one person for this note.",
    ),
    "harmonyErrorUnknown": MessageLookupByLibrary.simpleMessage(
      "Something went wrong. Please try again.",
    ),
    "harmonyFeedbackSingleHousemateHint": MessageLookupByLibrary.simpleMessage(
      "Type @ to provide feedback to 1 housemate.",
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
      "Anything to appreciate or adjust this week?",
    ),
    "harmonyShareLabel": MessageLookupByLibrary.simpleMessage(
      "Visible to everyone in the home",
    ),
    "harmonySubmitCta": MessageLookupByLibrary.simpleMessage("Save"),
    "harmonySubmitSuccess": MessageLookupByLibrary.simpleMessage("Saved"),
    "homeVibeCoverage": m7,
    "homeVibeTitle": MessageLookupByLibrary.simpleMessage("House Vibe"),
    "houseNormCopyUrlCta": MessageLookupByLibrary.simpleMessage("Copy URL"),
    "houseNormDoneCta": MessageLookupByLibrary.simpleMessage("Done"),
    "houseNormEditTitle": MessageLookupByLibrary.simpleMessage(
      "Edit house norms",
    ),
    "houseNormGenerationFailed": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t generate house norms right now. Please try again.",
    ),
    "houseNormOnboardingBack": MessageLookupByLibrary.simpleMessage("Back"),
    "houseNormOnboardingProgress": m8,
    "houseNormOnboardingSubmit": MessageLookupByLibrary.simpleMessage(
      "Generate house norms",
    ),
    "houseNormOnboardingTitle": MessageLookupByLibrary.simpleMessage(
      "House norms",
    ),
    "houseNormPromptCta": MessageLookupByLibrary.simpleMessage(
      "Create house norms",
    ),
    "houseNormPromptSubtitle": MessageLookupByLibrary.simpleMessage(
      "Write a shared starting point for how your home tends to work.",
    ),
    "houseNormPromptTitle": MessageLookupByLibrary.simpleMessage(
      "Create house norms",
    ),
    "houseNormPublishCta": MessageLookupByLibrary.simpleMessage(
      "Publish to web",
    ),
    "houseNormReportEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Generate house norms to see your shared starting point.",
    ),
    "houseNormReportEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "House norms not ready",
    ),
    "houseNormReportErrorBody": MessageLookupByLibrary.simpleMessage(
      "Please try again.",
    ),
    "houseNormReportErrorTitle": MessageLookupByLibrary.simpleMessage(
      "Could not load house norms",
    ),
    "houseNormReportTitle": MessageLookupByLibrary.simpleMessage("House norms"),
    "houseNormRepublishCta": MessageLookupByLibrary.simpleMessage("Republish"),
    "houseNormScenarioGuestsOption1": MessageLookupByLibrary.simpleMessage(
      "It\'s planned and talked about first",
    ),
    "houseNormScenarioGuestsOption2": MessageLookupByLibrary.simpleMessage(
      "A heads-up is enough",
    ),
    "houseNormScenarioGuestsOption3": MessageLookupByLibrary.simpleMessage(
      "That\'s part of daily life here",
    ),
    "houseNormScenarioGuestsQuestion": MessageLookupByLibrary.simpleMessage(
      "A friend or partner wants to come over. What usually feels right?",
    ),
    "houseNormScenarioHomeIdentityOption1":
        MessageLookupByLibrary.simpleMessage("A calm place to recharge"),
    "houseNormScenarioHomeIdentityOption2":
        MessageLookupByLibrary.simpleMessage(
          "A balance of quiet time and togetherness",
        ),
    "houseNormScenarioHomeIdentityOption3":
        MessageLookupByLibrary.simpleMessage(
          "A lively place where people come and go",
        ),
    "houseNormScenarioHomeIdentityQuestion":
        MessageLookupByLibrary.simpleMessage(
          "On a good day, this house feels most like...",
        ),
    "houseNormScenarioPropertyContextOption1":
        MessageLookupByLibrary.simpleMessage("We own this home"),
    "houseNormScenarioPropertyContextOption2":
        MessageLookupByLibrary.simpleMessage("We rent this whole home"),
    "houseNormScenarioPropertyContextOption3":
        MessageLookupByLibrary.simpleMessage("We rent rooms in a shared home"),
    "houseNormScenarioPropertyContextQuestion":
        MessageLookupByLibrary.simpleMessage(
          "Are you renting or do you own this house?",
        ),
    "houseNormScenarioRelationshipModelOption1":
        MessageLookupByLibrary.simpleMessage("Housemates"),
    "houseNormScenarioRelationshipModelOption2":
        MessageLookupByLibrary.simpleMessage("Family"),
    "houseNormScenarioRelationshipModelOption3":
        MessageLookupByLibrary.simpleMessage("Family and housemates"),
    "houseNormScenarioRelationshipModelQuestion":
        MessageLookupByLibrary.simpleMessage(
          "Who\'s sharing this home together?",
        ),
    "houseNormScenarioRepairOption1": MessageLookupByLibrary.simpleMessage(
      "Talking it through sooner rather than later",
    ),
    "houseNormScenarioRepairOption2": MessageLookupByLibrary.simpleMessage(
      "Checking in gently when the moment feels right",
    ),
    "houseNormScenarioRepairOption3": MessageLookupByLibrary.simpleMessage(
      "Letting small things pass unless they build up",
    ),
    "houseNormScenarioRepairQuestion": MessageLookupByLibrary.simpleMessage(
      "Something feels a bit off between people. What helps most?",
    ),
    "houseNormScenarioResponsibilityOption1":
        MessageLookupByLibrary.simpleMessage(
          "We usually have clear agreements",
        ),
    "houseNormScenarioResponsibilityOption2":
        MessageLookupByLibrary.simpleMessage(
          "Someone takes care of it when they notice",
        ),
    "houseNormScenarioResponsibilityOption3":
        MessageLookupByLibrary.simpleMessage(
          "Everyone mostly looks after their own things",
        ),
    "houseNormScenarioResponsibilityQuestion":
        MessageLookupByLibrary.simpleMessage(
          "Something small needs doing around the house. What tends to happen?",
        ),
    "houseNormScenarioRhythmOption1": MessageLookupByLibrary.simpleMessage(
      "Things wind down so the home can rest",
    ),
    "houseNormScenarioRhythmOption2": MessageLookupByLibrary.simpleMessage(
      "It depends - some nights are quieter than others",
    ),
    "houseNormScenarioRhythmOption3": MessageLookupByLibrary.simpleMessage(
      "Everyone keeps doing their thing",
    ),
    "houseNormScenarioRhythmQuestion": MessageLookupByLibrary.simpleMessage(
      "It is nighttime, and someone is still active at home. What usually feels okay?",
    ),
    "houseNormScenarioSharedSpacesOption1":
        MessageLookupByLibrary.simpleMessage("Mostly clear and ready to use"),
    "houseNormScenarioSharedSpacesOption2":
        MessageLookupByLibrary.simpleMessage("Lived-in, but reset later"),
    "houseNormScenarioSharedSpacesOption3":
        MessageLookupByLibrary.simpleMessage(
          "A bit messy is fine - it\'s a shared home",
        ),
    "houseNormScenarioSharedSpacesQuestion": MessageLookupByLibrary.simpleMessage(
      "You walk into the kitchen at the end of the day. What feels most comfortable?",
    ),
    "houseNormSectionEditLabel": MessageLookupByLibrary.simpleMessage(
      "Adjust this section",
    ),
    "houseNormSectionEmptyError": MessageLookupByLibrary.simpleMessage(
      "Please add text before saving.",
    ),
    "houseNormSectionFallbackTitle": MessageLookupByLibrary.simpleMessage(
      "Section",
    ),
    "houseNormSectionGuestsSocialTitle": MessageLookupByLibrary.simpleMessage(
      "Guests and social flow",
    ),
    "houseNormSectionHomeIdentityTitle": MessageLookupByLibrary.simpleMessage(
      "House identity",
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
      "We couldn\'t save that update.",
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
      "Summary framing",
    ),
    "houseNormSummarySubtitle": MessageLookupByLibrary.simpleMessage(
      "A shared starting point - not a rulebook.",
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
      "Weekly house pulse",
    ),
    "housePulseShareCta": MessageLookupByLibrary.simpleMessage("Share pulse"),
    "housePulseShareMessage": m9,
    "housePulseShareTitle": MessageLookupByLibrary.simpleMessage(
      "Sharing our Kinly house pulse",
    ),
    "housePulseUpdatedOn": m10,
    "houseVibeShareCta": MessageLookupByLibrary.simpleMessage("Share vibe"),
    "houseVibeShareError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t share right now. Please try again.",
    ),
    "houseVibeShareMessage": m11,
    "houseVibeShareTitle": MessageLookupByLibrary.simpleMessage("House vibe"),
    "hubCardGratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "Quick thanks from your home.",
    ),
    "hubCardGratitudeWallTitle": MessageLookupByLibrary.simpleMessage(
      "Shoutouts",
    ),
    "hubCodeCopied": MessageLookupByLibrary.simpleMessage("Invite code copied"),
    "hubError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load House Hub. Please try again.",
    ),
    "hubHouseNormsSubtitle": MessageLookupByLibrary.simpleMessage(
      "A shared starting point for how this home tends to work.",
    ),
    "hubHouseNormsTitle": MessageLookupByLibrary.simpleMessage("House norms"),
    "hubInviteCta": MessageLookupByLibrary.simpleMessage("Invite"),
    "hubInviteUnavailable": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load invite. Please try again.",
    ),
    "hubMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "No active members yet.",
    ),
    "hubPreferencesSubtitle": MessageLookupByLibrary.simpleMessage(
      "How each person prefers shared living to work.",
    ),
    "hubPreferencesTitle": MessageLookupByLibrary.simpleMessage(
      "Personal preferences",
    ),
    "hubQrSubtitle": MessageLookupByLibrary.simpleMessage(
      "Scan to download Kinly",
    ),
    "hubQrTitle": MessageLookupByLibrary.simpleMessage("Share the app"),
    "hubRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "hubRotateError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t rotate invite. Try again.",
    ),
    "hubRotateInvite": MessageLookupByLibrary.simpleMessage("Rotate invite"),
    "hubRotateSuccess": MessageLookupByLibrary.simpleMessage("Invite rotated"),
    "hubShareAppBody": m12,
    "hubShareAppCta": MessageLookupByLibrary.simpleMessage("Share Kinly"),
    "hubShareAppTitle": MessageLookupByLibrary.simpleMessage(
      "Get the Kinly app",
    ),
    "hubShareInviteBody": m13,
    "hubShareInviteTitle": MessageLookupByLibrary.simpleMessage(
      "Invite to my Kinly house",
    ),
    "join_blocked_body": MessageLookupByLibrary.simpleMessage(
      "WeÃ¢â‚¬â„¢ve notified the home owner.",
    ),
    "join_blocked_cta": MessageLookupByLibrary.simpleMessage("Done"),
    "join_blocked_title": MessageLookupByLibrary.simpleMessage(
      "This home isnÃ¢â‚¬â„¢t accepting new members right now",
    ),
    "join_error_already_in_other_home": MessageLookupByLibrary.simpleMessage(
      "Leave your current home to join a new one",
    ),
    "join_error_forbidden": MessageLookupByLibrary.simpleMessage(
      "You don\'t have permission to join this home.",
    ),
    "join_error_inactive_invite": MessageLookupByLibrary.simpleMessage(
      "That invite is no longer active. Ask the owner for a new code.",
    ),
    "join_error_invalid_code": MessageLookupByLibrary.simpleMessage(
      "That invite code doesn\'t look right.",
    ),
    "join_error_paywall_limit": MessageLookupByLibrary.simpleMessage(
      "This home has reached its member limit. Ask the owner to upgrade or remove a member.",
    ),
    "join_error_unauthorized": MessageLookupByLibrary.simpleMessage(
      "Please sign in to join this home.",
    ),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t join this home. Please try again.",
    ),
    "join_hint": MessageLookupByLibrary.simpleMessage(
      "Enter invite code Eg. ABC123",
    ),
    "join_submit": MessageLookupByLibrary.simpleMessage("Join"),
    "join_success": m14,
    "join_title": MessageLookupByLibrary.simpleMessage("Join Household"),
    "login_consent_connector": MessageLookupByLibrary.simpleMessage(" & "),
    "login_consent_prefix": MessageLookupByLibrary.simpleMessage(
      "I have read and agree to the ",
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
      "Connecting you to your homeÃ¢â‚¬Â¦",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "Your shared home starts here.",
    ),
    "mentionFieldHint": MessageLookupByLibrary.simpleMessage(
      "Type @ to mention someone",
    ),
    "navExplore": MessageLookupByLibrary.simpleMessage("Manage"),
    "navHub": MessageLookupByLibrary.simpleMessage("House Hub"),
    "navToday": MessageLookupByLibrary.simpleMessage("Today"),
    "npsCannotSkip": MessageLookupByLibrary.simpleMessage(
      "Please choose a score to continue.",
    ),
    "npsDescription": MessageLookupByLibrary.simpleMessage(
      "0 means not at all. 10 means it\'s made a real difference.",
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
      "Feedback is unavailable right now.",
    ),
    "npsSubmitErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t send your feedback. Please try again.",
    ),
    "npsSubmitErrorInvalidScore": MessageLookupByLibrary.simpleMessage(
      "Please pick a number between 0 and 10.",
    ),
    "npsSubmitErrorNotRequired": MessageLookupByLibrary.simpleMessage(
      "You don\'t need to share feedback right now.",
    ),
    "npsTitle": MessageLookupByLibrary.simpleMessage(
      "Has Kinly helped your home run more smoothly?",
    ),
    "offline_body": MessageLookupByLibrary.simpleMessage(
      "Kinly needs an internet connection. Check your signal and try again.",
    ),
    "offline_retry": MessageLookupByLibrary.simpleMessage("Try again"),
    "offline_title": MessageLookupByLibrary.simpleMessage("You\'re offline"),
    "paywallBulletFlows": MessageLookupByLibrary.simpleMessage(
      "Unlimited tasks",
    ),
    "paywallBulletMembers": MessageLookupByLibrary.simpleMessage(
      "Unlimited home members",
    ),
    "paywallBulletPhotos": MessageLookupByLibrary.simpleMessage(
      "Unlimited task photos",
    ),
    "paywallBulletShares": MessageLookupByLibrary.simpleMessage(
      "Unlimited shared expenses",
    ),
    "paywallBulletShoppingPhotos": MessageLookupByLibrary.simpleMessage(
      "Unlimited shopping list photos",
    ),
    "paywallErrorTitle": MessageLookupByLibrary.simpleMessage(
      "Unable to load paywall.",
    ),
    "paywallFeatureUnlimitedSharedExpensePhotos":
        MessageLookupByLibrary.simpleMessage("Unlimited shared expense photos"),
    "paywallPriceCaption": MessageLookupByLibrary.simpleMessage(
      "One home plan, no hidden tiers.",
    ),
    "paywallPricePerMonth": m15,
    "paywallPriceUnavailable": MessageLookupByLibrary.simpleMessage(
      "Pricing not available right now.",
    ),
    "paywallPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "Upgrade to Kinly Premium",
    ),
    "paywallPurchaseFailed": MessageLookupByLibrary.simpleMessage(
      "Purchase not completed - you can try again anytime.",
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
      "Costs less than 0.5% of your rent.",
    ),
    "paywallTitle": MessageLookupByLibrary.simpleMessage(
      "Keep your home running smoothly",
    ),
    "personalMentionsTitle": MessageLookupByLibrary.simpleMessage(
      "Personal mentions",
    ),
    "personalProfileLoadError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t load your personal profile right now. Please try again.",
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
    "preferenceOnboardingSubmit": MessageLookupByLibrary.simpleMessage(
      "Save preferences",
    ),
    "preferenceOnboardingTitle": MessageLookupByLibrary.simpleMessage(
      "Personal preferences",
    ),
    "preferencePromptCta": MessageLookupByLibrary.simpleMessage(
      "Start preferences",
    ),
    "preferencePromptSubtitle": MessageLookupByLibrary.simpleMessage(
      "Set up your personal preferences so your home can learn how you like things.",
    ),
    "preferencePromptTitle": MessageLookupByLibrary.simpleMessage(
      "Share your preferences",
    ),
    "preferenceReportDoneCta": MessageLookupByLibrary.simpleMessage("Done"),
    "preferenceReportEditCta": MessageLookupByLibrary.simpleMessage("Edit"),
    "preferenceReportEditError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t save that update.",
    ),
    "preferenceReportEditSectionDone": MessageLookupByLibrary.simpleMessage(
      "Done",
    ),
    "preferenceReportEditSectionHint": MessageLookupByLibrary.simpleMessage(
      "Write what feels right for you",
    ),
    "preferenceReportEditSectionPrompt": MessageLookupByLibrary.simpleMessage(
      "Adjust the wording for this section.",
    ),
    "preferenceReportEditTitle": MessageLookupByLibrary.simpleMessage(
      "Edit preferences",
    ),
    "preferenceReportEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Complete your preferences to generate your report.",
    ),
    "preferenceReportEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Preference report not ready",
    ),
    "preferenceReportErrorBody": MessageLookupByLibrary.simpleMessage(
      "Please try again.",
    ),
    "preferenceReportErrorTitle": MessageLookupByLibrary.simpleMessage(
      "Could not load report",
    ),
    "preferenceReportGenerationFailed": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t finish your preference reflection. Head back and try again.",
    ),
    "preferenceReportGenerationMissing": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t finish your preference reflection. Please try again soon.",
    ),
    "preferenceReportReadOnlyNote": MessageLookupByLibrary.simpleMessage(
      "This shows what feels comfortable for them.",
    ),
    "preferenceReportTitle": MessageLookupByLibrary.simpleMessage(
      "Your preference report",
    ),
    "preferenceReportViewTitle": MessageLookupByLibrary.simpleMessage(
      "View preferences",
    ),
    "preferenceScenarioCleanlinessSharedSpaceOption1":
        MessageLookupByLibrary.simpleMessage(
          "I feel best when things are kept fairly tidy",
        ),
    "preferenceScenarioCleanlinessSharedSpaceOption2":
        MessageLookupByLibrary.simpleMessage("Some clutter is okay day-to-day"),
    "preferenceScenarioCleanlinessSharedSpaceOption3":
        MessageLookupByLibrary.simpleMessage(
          "I\'m relaxed about mess in shared areas",
        ),
    "preferenceScenarioCleanlinessSharedSpaceQuestion":
        MessageLookupByLibrary.simpleMessage(
          "In shared spaces, what level of tidiness works for you?",
        ),
    "preferenceScenarioCommunicationChannelOption1":
        MessageLookupByLibrary.simpleMessage("Messaging or text"),
    "preferenceScenarioCommunicationChannelOption2":
        MessageLookupByLibrary.simpleMessage(
          "Talking in person when it comes up",
        ),
    "preferenceScenarioCommunicationChannelOption3":
        MessageLookupByLibrary.simpleMessage("A quick call feels easiest"),
    "preferenceScenarioCommunicationChannelQuestion":
        MessageLookupByLibrary.simpleMessage(
          "When you need to coordinate at home, what works best for you?",
        ),
    "preferenceScenarioCommunicationDirectnessOption1":
        MessageLookupByLibrary.simpleMessage(
          "Gently, with context or easing in",
        ),
    "preferenceScenarioCommunicationDirectnessOption2":
        MessageLookupByLibrary.simpleMessage(
          "A mix - it depends on the situation",
        ),
    "preferenceScenarioCommunicationDirectnessOption3":
        MessageLookupByLibrary.simpleMessage("Directly and clearly"),
    "preferenceScenarioCommunicationDirectnessQuestion":
        MessageLookupByLibrary.simpleMessage(
          "When someone bring something up to you, how would you prefer to receive it?",
        ),
    "preferenceScenarioConflictResolutionOption1":
        MessageLookupByLibrary.simpleMessage("Taking time to cool off first"),
    "preferenceScenarioConflictResolutionOption2":
        MessageLookupByLibrary.simpleMessage(
          "Gently checking in at the right moment",
        ),
    "preferenceScenarioConflictResolutionOption3":
        MessageLookupByLibrary.simpleMessage(
          "Talking it through sooner rather than later",
        ),
    "preferenceScenarioConflictResolutionQuestion":
        MessageLookupByLibrary.simpleMessage(
          "If something needs addressing at home, what helps most?",
        ),
    "preferenceScenarioEnvironmentLightOption1":
        MessageLookupByLibrary.simpleMessage("Softer or dimmer lighting"),
    "preferenceScenarioEnvironmentLightOption2":
        MessageLookupByLibrary.simpleMessage("Balanced, natural lighting"),
    "preferenceScenarioEnvironmentLightOption3":
        MessageLookupByLibrary.simpleMessage("Bright, well-lit spaces"),
    "preferenceScenarioEnvironmentLightQuestion":
        MessageLookupByLibrary.simpleMessage(
          "In shared areas, what lighting do you prefer?",
        ),
    "preferenceScenarioEnvironmentNoiseOption1":
        MessageLookupByLibrary.simpleMessage(
          "I\'m most comfortable when things are generally quiet",
        ),
    "preferenceScenarioEnvironmentNoiseOption2":
        MessageLookupByLibrary.simpleMessage(
          "A moderate level of everyday noise feels fine",
        ),
    "preferenceScenarioEnvironmentNoiseOption3":
        MessageLookupByLibrary.simpleMessage(
          "Noise doesn\'t bother me much - lively spaces are okay",
        ),
    "preferenceScenarioEnvironmentNoiseQuestion":
        MessageLookupByLibrary.simpleMessage(
          "How comfortable are you with background noise in shared spaces?",
        ),
    "preferenceScenarioEnvironmentScentOption1":
        MessageLookupByLibrary.simpleMessage(
          "I\'m quite sensitive to strong scents",
        ),
    "preferenceScenarioEnvironmentScentOption2":
        MessageLookupByLibrary.simpleMessage("I\'m mostly neutral"),
    "preferenceScenarioEnvironmentScentOption3":
        MessageLookupByLibrary.simpleMessage(
          "Strong scents don\'t really bother me",
        ),
    "preferenceScenarioEnvironmentScentQuestion":
        MessageLookupByLibrary.simpleMessage(
          "How comfortable are you with strong scents (candles, cooking, cleaners)?",
        ),
    "preferenceScenarioPrivacyNotificationsOption1":
        MessageLookupByLibrary.simpleMessage(
          "I prefer not to be contacted after quiet hours",
        ),
    "preferenceScenarioPrivacyNotificationsOption2":
        MessageLookupByLibrary.simpleMessage(
          "Limited or important messages are okay",
        ),
    "preferenceScenarioPrivacyNotificationsOption3":
        MessageLookupByLibrary.simpleMessage(
          "I\'m fine being contacted anytime",
        ),
    "preferenceScenarioPrivacyNotificationsQuestion":
        MessageLookupByLibrary.simpleMessage(
          "How do you feel about messages at night?",
        ),
    "preferenceScenarioPrivacyRoomEntryOption1":
        MessageLookupByLibrary.simpleMessage(
          "I prefer people to ask or knock first",
        ),
    "preferenceScenarioPrivacyRoomEntryOption2":
        MessageLookupByLibrary.simpleMessage(
          "Asking is nice, but flexibility is okay",
        ),
    "preferenceScenarioPrivacyRoomEntryOption3":
        MessageLookupByLibrary.simpleMessage(
          "I\'m generally comfortable with open access",
        ),
    "preferenceScenarioPrivacyRoomEntryQuestion":
        MessageLookupByLibrary.simpleMessage(
          "Before entering someone\'s room, what feels right to you?",
        ),
    "preferenceScenarioRoutinePlanningOption1":
        MessageLookupByLibrary.simpleMessage(
          "Having plans and structure helps me",
        ),
    "preferenceScenarioRoutinePlanningOption2":
        MessageLookupByLibrary.simpleMessage(
          "A mix of planning and spontaneity",
        ),
    "preferenceScenarioRoutinePlanningOption3":
        MessageLookupByLibrary.simpleMessage("Going with the flow feels best"),
    "preferenceScenarioRoutinePlanningQuestion":
        MessageLookupByLibrary.simpleMessage(
          "When it comes to daily life at home, what feels most natural to you?",
        ),
    "preferenceScenarioScheduleQuietHoursOption1":
        MessageLookupByLibrary.simpleMessage(
          "Evenings tend to be quieter for me",
        ),
    "preferenceScenarioScheduleQuietHoursOption2":
        MessageLookupByLibrary.simpleMessage(
          "It depends - some nights are quieter than others",
        ),
    "preferenceScenarioScheduleQuietHoursOption3":
        MessageLookupByLibrary.simpleMessage(
          "Nighttime activity doesn\'t usually bother me",
        ),
    "preferenceScenarioScheduleQuietHoursQuestion":
        MessageLookupByLibrary.simpleMessage(
          "In the evenings, what usually works best for you?",
        ),
    "preferenceScenarioScheduleSleepTimingOption1":
        MessageLookupByLibrary.simpleMessage("Earlier nights and mornings"),
    "preferenceScenarioScheduleSleepTimingOption2":
        MessageLookupByLibrary.simpleMessage("Somewhere in the middle"),
    "preferenceScenarioScheduleSleepTimingOption3":
        MessageLookupByLibrary.simpleMessage("Later nights and mornings"),
    "preferenceScenarioScheduleSleepTimingQuestion":
        MessageLookupByLibrary.simpleMessage(
          "Are you more of an early bird or a night owl?",
        ),
    "preferenceScenarioSocialHostingOption1":
        MessageLookupByLibrary.simpleMessage(
          "I\'m most comfortable with guests being rare",
        ),
    "preferenceScenarioSocialHostingOption2":
        MessageLookupByLibrary.simpleMessage("Occasional guests feel fine"),
    "preferenceScenarioSocialHostingOption3":
        MessageLookupByLibrary.simpleMessage(
          "Frequent guests are okay with me",
        ),
    "preferenceScenarioSocialHostingQuestion":
        MessageLookupByLibrary.simpleMessage(
          "How do you feel about guests coming over to the home?",
        ),
    "preferenceScenarioSocialTogethernessOption1":
        MessageLookupByLibrary.simpleMessage("Mostly doing my own thing"),
    "preferenceScenarioSocialTogethernessOption2":
        MessageLookupByLibrary.simpleMessage(
          "A mix of shared time and solo time",
        ),
    "preferenceScenarioSocialTogethernessOption3":
        MessageLookupByLibrary.simpleMessage("Spending time together often"),
    "preferenceScenarioSocialTogethernessQuestion":
        MessageLookupByLibrary.simpleMessage(
          "At home, what balance works best for you?",
        ),
    "profileActionConfirm": MessageLookupByLibrary.simpleMessage("Leave House"),
    "profileActionConfirmDelete": MessageLookupByLibrary.simpleMessage(
      "Delete account",
    ),
    "profileConfirmDeleteMessage": MessageLookupByLibrary.simpleMessage(
      "This removes your account and signs you out. You won\'t be able to undo this.",
    ),
    "profileConfirmDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "Delete your account?",
    ),
    "profileConfirmLeaveMessage": MessageLookupByLibrary.simpleMessage(
      "You\'ll lose access to tasks, history, and invites.",
    ),
    "profileConfirmLeaveTitle": MessageLookupByLibrary.simpleMessage(
      "Leave this house?",
    ),
    "profileConnectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Manage notifications and reminders.",
    ),
    "profileConnectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Connection settings",
    ),
    "profileContactEmailSubject": MessageLookupByLibrary.simpleMessage(
      "Contact us",
    ),
    "profileContactLaunchError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t open your email app. Try again.",
    ),
    "profileContactUsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Email support@makinglifeeasie.com",
    ),
    "profileContactUsTitle": MessageLookupByLibrary.simpleMessage("Contact us"),
    "profileDeleteAccountSubtitle": MessageLookupByLibrary.simpleMessage(
      "Remove your Kinly account and profile data.",
    ),
    "profileDeleteAccountTitle": MessageLookupByLibrary.simpleMessage(
      "Delete account",
    ),
    "profileDeleteSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Your account will be deleted shortly. We\'ll sign you out.",
    ),
    "profileGenericError": MessageLookupByLibrary.simpleMessage(
      "Something went wrong. Please try again.",
    ),
    "profileIdentityAvatarEmpty": MessageLookupByLibrary.simpleMessage(
      "No avatars are available right now. Try again soon.",
    ),
    "profileIdentityAvatarSectionDescription":
        MessageLookupByLibrary.simpleMessage(
          "Each avatar is unique inside your home.",
        ),
    "profileIdentityAvatarSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Pick an avatar",
    ),
    "profileIdentityLoadError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t load your profile right now.",
    ),
    "profileIdentityRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "profileIdentitySaveButton": MessageLookupByLibrary.simpleMessage(
      "Save changes",
    ),
    "profileIdentitySubtitle": MessageLookupByLibrary.simpleMessage(
      "Pick a username and avatar for your home.",
    ),
    "profileIdentitySuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Profile updated.",
    ),
    "profileIdentityTitle": MessageLookupByLibrary.simpleMessage(
      "Edit profile",
    ),
    "profileIdentityUsernameEmptyError": MessageLookupByLibrary.simpleMessage(
      "Enter a username to continue.",
    ),
    "profileIdentityUsernameFormatError": MessageLookupByLibrary.simpleMessage(
      "Use 3-30 lowercase letters or numbers. You can include dots or underscores in the middle.",
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
      "That username is taken. Try a different one.",
    ),
    "profileInfoHubLoadError": MessageLookupByLibrary.simpleMessage(
      "The Info Hub couldn\'t load. Check your connection.",
    ),
    "profileInfoHubSubtitle": MessageLookupByLibrary.simpleMessage(
      "Open the Kinly Notion hub in-app.",
    ),
    "profileInfoHubTitle": MessageLookupByLibrary.simpleMessage("Info Hub"),
    "profileKickActionConfirm": MessageLookupByLibrary.simpleMessage(
      "Remove member",
    ),
    "profileKickMemberSubtitle": MessageLookupByLibrary.simpleMessage(
      "Choose who will lose access to this house.",
    ),
    "profileKickMemberTitle": MessageLookupByLibrary.simpleMessage(
      "Remove a member",
    ),
    "profileKickNoMembers": MessageLookupByLibrary.simpleMessage(
      "No other members to remove right now.",
    ),
    "profileKickOwnerOnly": MessageLookupByLibrary.simpleMessage(
      "Only the house owner can remove members.",
    ),
    "profileKickSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "Select a member to remove. They\'ll lose access right away.",
    ),
    "profileKickSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Remove a member",
    ),
    "profileKickSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "They no longer have access to this house.",
    ),
    "profileLeaveEligibilityError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t load your house members. Try again.",
    ),
    "profileLeaveEligibilityLoading": MessageLookupByLibrary.simpleMessage(
      "Checking your house members...",
    ),
    "profileLeaveHomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Leaving this house means stepping out of your shared Kinly space.",
    ),
    "profileLeaveHomeTitle": MessageLookupByLibrary.simpleMessage(
      "Leave house",
    ),
    "profileLeaveOwnerNoEligibleMembers": MessageLookupByLibrary.simpleMessage(
      "No one else can take ownership right now. Try again later.",
    ),
    "profileLeaveOwnerSoloMessage": MessageLookupByLibrary.simpleMessage(
      "You\'re the last member. Leaving will deactivate this house.",
    ),
    "profileLeaveSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "You left your house.",
    ),
    "profileLeaveTransferSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "Select who will become the new owner before you leave.",
    ),
    "profileLeaveTransferSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Transfer ownership",
    ),
    "profileLeaveTransferSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Ownership transferred. Finishing your leave...",
    ),
    "profileLogoutSubtitle": MessageLookupByLibrary.simpleMessage(
      "Sign out of Kinly on this device.",
    ),
    "profileLogoutTitle": MessageLookupByLibrary.simpleMessage("Sign out"),
    "profileMissingHomeError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t find your current house. Try again.",
    ),
    "profileSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Manage your account preferences and home access.",
    ),
    "profileSettingsTitle": MessageLookupByLibrary.simpleMessage("Profile"),
    "profile_deactivated_message": MessageLookupByLibrary.simpleMessage(
      "Your profile is deactivated. Please sign in with another email address.",
    ),
    "pulseCloudySteadySummary": MessageLookupByLibrary.simpleMessage(
      "A mix of smooth moments and small friction.",
    ),
    "pulseCloudySteadyTitle": MessageLookupByLibrary.simpleMessage("Mixed"),
    "pulseCloudyTenseSummary": MessageLookupByLibrary.simpleMessage(
      "Some tension surfaced this week.",
    ),
    "pulseCloudyTenseTitle": MessageLookupByLibrary.simpleMessage(
      "Needs attention",
    ),
    "pulseFormingSummary": MessageLookupByLibrary.simpleMessage(
      "A few more check-ins will give a clearer picture.",
    ),
    "pulseFormingTitle": MessageLookupByLibrary.simpleMessage("Still forming"),
    "pulsePartlySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "Overall steady, with some areas to improve.",
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
      "Mostly smooth, with a few small bumps.",
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
      "Tension is high. A quick reset can help.",
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
      "A quiet moment before we show it.",
    ),
    "reflectiveHouseNormsPrimary": MessageLookupByLibrary.simpleMessage(
      "Reflecting what this house shared.",
    ),
    "reflectiveHouseNormsSecondary": MessageLookupByLibrary.simpleMessage(
      "A shared reference, not a rulebook.",
    ),
    "reflectiveHousePrimary": MessageLookupByLibrary.simpleMessage(
      "Putting the house\'s expectations into words.",
    ),
    "reflectiveHouseSecondary": MessageLookupByLibrary.simpleMessage(
      "So everyone knows what to expect.",
    ),
    "reflectivePersonalPrimary": MessageLookupByLibrary.simpleMessage(
      "Reflecting what you shared.",
    ),
    "reflectivePersonalSecondary": MessageLookupByLibrary.simpleMessage(
      "So others can understand what feels comfortable to you.",
    ),
    "shareCreateAmountHint": MessageLookupByLibrary.simpleMessage("0.00"),
    "shareCreateAmountLabel": MessageLookupByLibrary.simpleMessage("Amount"),
    "shareCreateCustomAmountLabel": MessageLookupByLibrary.simpleMessage(
      "Amount",
    ),
    "shareCreateCustomHelper": MessageLookupByLibrary.simpleMessage(
      "Enter each person\'s part. Make sure the total matches the amount above.",
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
      "Couldn\'t create. Try again.",
    ),
    "shareCreateErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "You\'re at the free limit of active bills. Upgrade for more space.",
    ),
    "shareCreateErrorRecurrenceDraft": MessageLookupByLibrary.simpleMessage(
      "Drafts canÃ¢â‚¬â„¢t repeat until you add a split.",
    ),
    "shareCreateLoadError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t load your household members.",
    ),
    "shareCreateNotesHint": MessageLookupByLibrary.simpleMessage(
      "Optional context everyone can see",
    ),
    "shareCreateNotesLabel": MessageLookupByLibrary.simpleMessage("Context"),
    "shareCreateParticipantsEmpty": MessageLookupByLibrary.simpleMessage(
      "You need at least two household members to share.",
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
      "How do we want to split this?",
    ),
    "shareCreateStartLabel": MessageLookupByLibrary.simpleMessage(
      "When does this apply?",
    ),
    "shareCreateSubmit": MessageLookupByLibrary.simpleMessage("Create"),
    "shareCreateSuccess": MessageLookupByLibrary.simpleMessage("Bill created."),
    "shareCreateTitle": MessageLookupByLibrary.simpleMessage("Add Bill"),
    "shareCreateValidationAmount": MessageLookupByLibrary.simpleMessage(
      "Enter a valid amount greater than zero.",
    ),
    "shareCreateValidationCustomAmounts": MessageLookupByLibrary.simpleMessage(
      "Enter a valid amount for each selected person.",
    ),
    "shareCreateValidationCustomParticipants":
        MessageLookupByLibrary.simpleMessage(
          "Select at least one person for this bill.",
        ),
    "shareCreateValidationCustomSinglePayer": MessageLookupByLibrary.simpleMessage(
      "You\'re the only person selected for this bill. Add at least one other person.",
    ),
    "shareCreateValidationCustomSum": MessageLookupByLibrary.simpleMessage(
      "Make sure the custom split adds up to the amount above.",
    ),
    "shareCreateValidationCustomSumBreakdown": m18,
    "shareCreateValidationDescription": MessageLookupByLibrary.simpleMessage(
      "Enter a description.",
    ),
    "shareCreateValidationEqualParticipants":
        MessageLookupByLibrary.simpleMessage(
          "Select at least one person to split the amount.",
        ),
    "shareCreateValidationRecurrence": MessageLookupByLibrary.simpleMessage(
      "Choose how often this repeats.",
    ),
    "shareCreateValidationRecurrenceSplit":
        MessageLookupByLibrary.simpleMessage(
          "Pick how to split before setting a repeat.",
        ),
    "shareCreateValidationStartDate": MessageLookupByLibrary.simpleMessage(
      "Choose a start date.",
    ),
    "shareCreateValidationStartDateRange": MessageLookupByLibrary.simpleMessage(
      "Choose a date within the allowed range.",
    ),
    "shareCreatedListActiveAmount": m19,
    "shareCreatedListActiveSubtitle": m20,
    "shareCreatedListDraftBadge": MessageLookupByLibrary.simpleMessage(
      "Unassigned",
    ),
    "shareCreatedListDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "Split it so everyone knows their part before publishing.",
    ),
    "shareCreatedListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Bills keep money clear, with no awkward reminders.",
    ),
    "shareCreatedListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "No bills yet",
    ),
    "shareCreatedListError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t load your bills. Pull to refresh.",
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
      "Delete?",
    ),
    "shareEditDeleteError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t delete. Try again.",
    ),
    "shareEditDeleteSuccess": MessageLookupByLibrary.simpleMessage(
      "Bill deleted.",
    ),
    "shareEditDisabledActive": MessageLookupByLibrary.simpleMessage(
      "Active bills are locked from edits.",
    ),
    "shareEditDisabledConverted": MessageLookupByLibrary.simpleMessage(
      "This bill is now a plan, and editing is off.",
    ),
    "shareEditDisabledGeneric": MessageLookupByLibrary.simpleMessage(
      "Editing this bill is unavailable right now.",
    ),
    "shareEditDisabledRecurringCycle": MessageLookupByLibrary.simpleMessage(
      "Recurring cycles are locked from edits here.",
    ),
    "shareEditLoadError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t load that draft.",
    ),
    "shareEditNotAllowed": MessageLookupByLibrary.simpleMessage(
      "This stays locked until someone takes this share.",
    ),
    "shareEditSplitsLocked": MessageLookupByLibrary.simpleMessage(
      "Splits are locked because someone already paid. You can still update the description and notes.",
    ),
    "shareEditSubmit": MessageLookupByLibrary.simpleMessage("Update"),
    "shareEditSuccess": MessageLookupByLibrary.simpleMessage("Bill updated."),
    "shareEditTerminateError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t terminate the plan. Try again.",
    ),
    "shareEditTerminatePlan": MessageLookupByLibrary.simpleMessage(
      "Terminate plan",
    ),
    "shareEditTerminatePlanBusy": MessageLookupByLibrary.simpleMessage(
      "Terminating...",
    ),
    "shareEditTerminatePlanConfirm": MessageLookupByLibrary.simpleMessage(
      "Terminate plan",
    ),
    "shareEditTerminatePlanMessage": MessageLookupByLibrary.simpleMessage(
      "This stops future bill cycles.",
    ),
    "shareEditTerminatePlanTitle": MessageLookupByLibrary.simpleMessage(
      "Terminate recurring plan?",
    ),
    "shareEditTerminateSuccess": MessageLookupByLibrary.simpleMessage(
      "Plan terminated.",
    ),
    "shareEditTitle": MessageLookupByLibrary.simpleMessage("Edit Bill"),
    "shareOwedDetailEmpty": MessageLookupByLibrary.simpleMessage(
      "You\'re all caught up with this person.",
    ),
    "shareOwedDetailError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t mark that share paid. Try again.",
    ),
    "shareOwedDetailPaid": MessageLookupByLibrary.simpleMessage(
      "Mark as settled",
    ),
    "shareOwedDetailSuccess": MessageLookupByLibrary.simpleMessage("Settled."),
    "shareOwedDetailTitle": MessageLookupByLibrary.simpleMessage("To settle"),
    "sharePaidDetailAcknowledge": MessageLookupByLibrary.simpleMessage(
      "Acknowledge Receipt",
    ),
    "sharePaidDetailAcknowledgeError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t acknowledge receipting the bills.",
    ),
    "sharePaidDetailAcknowledging": MessageLookupByLibrary.simpleMessage(
      "Acknowledging...",
    ),
    "shoppingAllItemsBought": MessageLookupByLibrary.simpleMessage(
      "All items bought",
    ),
    "shoppingAmountHint": MessageLookupByLibrary.simpleMessage(
      "e.g. 2 cartons",
    ),
    "shoppingAmountLabel": MessageLookupByLibrary.simpleMessage("How many"),
    "shoppingArchiveCta": MessageLookupByLibrary.simpleMessage("Items bought"),
    "shoppingArchiveDraftBillCreated": MessageLookupByLibrary.simpleMessage(
      "Draft bill created for items bought",
    ),
    "shoppingArchiveItemsBought": MessageLookupByLibrary.simpleMessage(
      "Items bought and removed from the list",
    ),
    "shoppingArchiveShareNo": MessageLookupByLibrary.simpleMessage("No"),
    "shoppingArchiveSharePromptBody": MessageLookupByLibrary.simpleMessage(
      "Do you want to create a draft bill from these items?",
    ),
    "shoppingArchiveSharePromptTitle": MessageLookupByLibrary.simpleMessage(
      "Create bill?",
    ),
    "shoppingArchiveShareYes": MessageLookupByLibrary.simpleMessage("Yes"),
    "shoppingCardSubtitle": m21,
    "shoppingCardTitle": MessageLookupByLibrary.simpleMessage("Shopping list"),
    "shoppingContextHint": MessageLookupByLibrary.simpleMessage(
      "Anything helpful (brand, size, etc.)",
    ),
    "shoppingContextLabel": MessageLookupByLibrary.simpleMessage("Notes"),
    "shoppingCreateTitle": MessageLookupByLibrary.simpleMessage(
      "Add shopping item",
    ),
    "shoppingDelete": MessageLookupByLibrary.simpleMessage("Delete item"),
    "shoppingDeleteConfirmBody": MessageLookupByLibrary.simpleMessage(
      "This removes the item from your shared shopping list.",
    ),
    "shoppingDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Delete this item?",
    ),
    "shoppingDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Shopping item",
    ),
    "shoppingEditTitle": MessageLookupByLibrary.simpleMessage(
      "Shopping item details",
    ),
    "shoppingEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "No shopping items to buy.",
    ),
    "shoppingErrorItemAlreadyCompletedByOther":
        MessageLookupByLibrary.simpleMessage(
          "Someone else already checked off this item.",
        ),
    "shoppingListTitle": MessageLookupByLibrary.simpleMessage("Shopping list"),
    "shoppingMarkCompleteCta": MessageLookupByLibrary.simpleMessage(
      "Mark as completed",
    ),
    "shoppingNameHint": MessageLookupByLibrary.simpleMessage("e.g. Milk"),
    "shoppingNameLabel": MessageLookupByLibrary.simpleMessage("Name"),
    "shoppingPhotoLabel": MessageLookupByLibrary.simpleMessage("Add a photo"),
    "shoppingPhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Add a photo to help with shopping",
    ),
    "shoppingPhotoReplaceLabel": MessageLookupByLibrary.simpleMessage(
      "Help someone to know what to buy",
    ),
    "shoppingSubmitAdd": MessageLookupByLibrary.simpleMessage("Add item"),
    "shoppingSubmitEdit": MessageLookupByLibrary.simpleMessage("Save changes"),
    "shoppingTabPending": MessageLookupByLibrary.simpleMessage("To buy"),
    "shoppingValidationName": MessageLookupByLibrary.simpleMessage(
      "Please enter an item name.",
    ),
    "startReturningSubtitle": MessageLookupByLibrary.simpleMessage(
      "What do you want to do next?",
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
      "Enjoy the calm - Kinly will let you know when something needs your attention.",
    ),
    "todayEmptyCardBadge": MessageLookupByLibrary.simpleMessage(
      "Take a breather",
    ),
    "todayEmptyCardTitle": MessageLookupByLibrary.simpleMessage(
      "All caught up today",
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
      "Hereâ€™s what needs attention today.",
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
      "Gratitude Wall",
    ),
    "todayGratitudeUnreadBody": MessageLookupByLibrary.simpleMessage(
      "New gratitude posts are waiting for you.",
    ),
    "todayInviteFriendsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Share Kinly so they can make shared living easier.",
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
      "Your home is growing. Upgrade to welcome more people.",
    ),
    "todayMemberCapTitle": MessageLookupByLibrary.simpleMessage(
      "Someone wants to join your home",
    ),
    "todayShareActiveSubtitle": m28,
    "todayShareError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t refresh Share right now.",
    ),
    "todaySharePaidSubtitle": MessageLookupByLibrary.simpleMessage(
      "Settled Amount",
    ),
    "todaySharePaidUnseen": m29,
    "todayShareSectionTitle": MessageLookupByLibrary.simpleMessage("Bill"),
    "todayShareTabActive": MessageLookupByLibrary.simpleMessage("To settle"),
    "todayShareTabDrafts": MessageLookupByLibrary.simpleMessage("Drafts"),
    "todayShareTabPaidToMe": MessageLookupByLibrary.simpleMessage("Settled"),
    "vibeCozySocialSummary": MessageLookupByLibrary.simpleMessage(
      "Your home feels cozy and calm when people spend time together.",
    ),
    "vibeCozySocialTitle": MessageLookupByLibrary.simpleMessage("Cozy social"),
    "vibeDefaultSummary": MessageLookupByLibrary.simpleMessage(
      "Your home feels easy to live in for everyone.",
    ),
    "vibeDefaultTitle": MessageLookupByLibrary.simpleMessage("A balanced home"),
    "vibeEasygoingSummary": MessageLookupByLibrary.simpleMessage(
      "Your home feels relaxed and open to change day by day.",
    ),
    "vibeEasygoingTitle": MessageLookupByLibrary.simpleMessage(
      "Easygoing flow",
    ),
    "vibeIndependentSummary": MessageLookupByLibrary.simpleMessage(
      "Your house supports space and quiet.",
    ),
    "vibeIndependentTitle": MessageLookupByLibrary.simpleMessage(
      "Independent calm",
    ),
    "vibeInsufficientSummary": MessageLookupByLibrary.simpleMessage(
      "Finish preferences to see your home vibe.",
    ),
    "vibeInsufficientTitle": MessageLookupByLibrary.simpleMessage(
      "Not enough data yet",
    ),
    "vibeMixedSummary": MessageLookupByLibrary.simpleMessage(
      "Your home shows a mix of comfort styles, influenced by how different people like to live.",
    ),
    "vibeMixedTitle": MessageLookupByLibrary.simpleMessage("A mixed home"),
    "vibeQuietCareSummary": MessageLookupByLibrary.simpleMessage(
      "Your home feels calm, with gentle energy and softer rhythms.",
    ),
    "vibeQuietCareTitle": MessageLookupByLibrary.simpleMessage("Quiet care"),
    "vibeSocialSummary": MessageLookupByLibrary.simpleMessage(
      "Your home feels active, with people together.",
    ),
    "vibeSocialTitle": MessageLookupByLibrary.simpleMessage("Social energy"),
    "vibeSteadySummary": MessageLookupByLibrary.simpleMessage(
      "Your home feels steady, with care shown through daily habits.",
    ),
    "vibeSteadyTitle": MessageLookupByLibrary.simpleMessage("Steady calm"),
    "vibeStructuredSummary": MessageLookupByLibrary.simpleMessage(
      "Your home works best with clear routines and shared plans.",
    ),
    "vibeStructuredTitle": MessageLookupByLibrary.simpleMessage(
      "Structured rhythm",
    ),
    "vibeWarmSocialSummary": MessageLookupByLibrary.simpleMessage(
      "Your home feels warm and welcoming, with people often together.",
    ),
    "vibeWarmSocialTitle": MessageLookupByLibrary.simpleMessage("Warm social"),
    "weeklyRewriteCta": MessageLookupByLibrary.simpleMessage(
      "Send calmly with Kinly",
    ),
    "welcome_create": MessageLookupByLibrary.simpleMessage("Create a House"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("Join your House"),
    "welcome_title": MessageLookupByLibrary.simpleMessage("Welcome to Kinly"),
  };
}
