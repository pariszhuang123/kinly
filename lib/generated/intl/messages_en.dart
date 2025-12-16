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

  static String m2(client, current) =>
      "Your version: ${client}\nLatest version: ${current}";

  static String m3(appName) => "Made with ${appName} - Together feels lighter";

  static String m4(link) =>
      "Sharing a glimpse of our Kinly gratitude wall. Download the app: ${link}";

  static String m5(time) => "${time} today";

  static String m6(count) =>
      "Gratitude wall ${Intl.plural(count, one: '(#)', other: '(#)')}";

  static String m7(weeks) =>
      "${Intl.plural(weeks, zero: 'This week', one: '# week ago', other: '# weeks ago')}";

  static String m8(partOfDay, name) => "Good ${partOfDay}, ${name}";

  static String m9(link) => "Share Kinly so sharing feels lighter: ${link}";

  static String m10(code, link) =>
      "Welcome to our Kinly home! Enter this invite code: ${code}\n\nDownload the Kinly app: ${link}";

  static String m11(code) => "Joined with code: ${code}";

  static String m12(price) => "${price} per month for your whole home.";

  static String m13(paidAmount, totalAmount) =>
      "${paidAmount} of ${totalAmount} collected";

  static String m14(paid, total) => "${paid} of ${total} paid";

  static String m15(count) =>
      "See all ${Intl.plural(count, one: '(#)', other: '(#)')}";

  static String m16(count) =>
      "${Intl.plural(count, one: '${count} payment pending', other: '${count} to settle')}";

  static String m17(homeId, role) => "Current home: ${homeId} • Role: ${role}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("Kinly"),
    "authMembershipLoadFailed": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t refresh your home membership. Please try again.",
    ),
    "bootstrap_initializing": m0,
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
      "Could not create the home. Try again.",
    ),
    "create_submit": MessageLookupByLibrary.simpleMessage("Create home"),
    "create_subtitle": MessageLookupByLibrary.simpleMessage(
      "We\'ll spin up your home instantly. You can rename and invite later.",
    ),
    "create_success": MessageLookupByLibrary.simpleMessage("Home created!"),
    "create_title": MessageLookupByLibrary.simpleMessage("Create Home"),
    "dopamineFlowAffirmation": MessageLookupByLibrary.simpleMessage(
      "Thanks, your home feels lighter.",
    ),
    "exploreFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "Review every Flow and keep flows moving",
    ),
    "exploreIntroSubtitle": MessageLookupByLibrary.simpleMessage(
      "Explore more ways to keep your home feeling lighter.",
    ),
    "exploreIntroTitle": MessageLookupByLibrary.simpleMessage(
      "Discover what\'s next",
    ),
    "exploreShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "See every Bill you\'ve created and track collections.",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage(
      "Who’s taking this on?",
    ),
    "flowChoreAssigneeUnassigned": MessageLookupByLibrary.simpleMessage(
      "Open to anyone",
    ),
    "flowChoreCreateTitle": MessageLookupByLibrary.simpleMessage("Add Flow"),
    "flowChoreDeleteButton": MessageLookupByLibrary.simpleMessage(
      "Delete flow",
    ),
    "flowChoreDeleteCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
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
      "Couldn\'t complete the flow. Please try again.",
    ),
    "flowChoreDetailMoreInfoTitle": MessageLookupByLibrary.simpleMessage(
      "Helpful context",
    ),
    "flowChoreDetailNoHowTo": MessageLookupByLibrary.simpleMessage(
      "No guide links provided.",
    ),
    "flowChoreDetailNoNotes": MessageLookupByLibrary.simpleMessage(
      "No context provided.",
    ),
    "flowChoreDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Flow details",
    ),
    "flowChoreDetailUnassigned": MessageLookupByLibrary.simpleMessage(
      "Unassigned",
    ),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage("Edit Flow"),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "That member isn\'t part of this home right now.",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "You don\'t have permission to change this flow.",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t save the flow. Please try again.",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "That photo path isn\'t valid for this home.",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "Pick a valid start date.",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "This flow isn\'t updateable right now.",
    ),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "You\'re at the free limit for active flows. Upgrade for more space.",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "You\'re at the free limit for expectation photos. Upgrade for more space.",
    ),
    "flowChoreExpectationPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Expectation photo",
    ),
    "flowChoreHowToHint": MessageLookupByLibrary.simpleMessage(
      "Add a link to help someone to follow",
    ),
    "flowChoreHowToLabel": MessageLookupByLibrary.simpleMessage("Guide link"),
    "flowChoreHowToLaunchError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t open that link. Try again.",
    ),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t load this flow. Please try again.",
    ),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage(
      "Eg. Bin night, clean the fridge, water plants",
    ),
    "flowChoreNameLabel": MessageLookupByLibrary.simpleMessage(
      "What are we agreeing on?",
    ),
    "flowChoreNotesHint": MessageLookupByLibrary.simpleMessage(
      "Anything that helps others understand the flow",
    ),
    "flowChoreNotesLabel": MessageLookupByLibrary.simpleMessage(
      "Why this matters",
    ),
    "flowChorePhotoHint": MessageLookupByLibrary.simpleMessage(
      "storage/households/... (optional)",
    ),
    "flowChorePhotoLabel": MessageLookupByLibrary.simpleMessage(
      "What \'great\' looks like",
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
    "flowChoreRecurrenceAnnual": MessageLookupByLibrary.simpleMessage("Annual"),
    "flowChoreRecurrenceDaily": MessageLookupByLibrary.simpleMessage("Daily"),
    "flowChoreRecurrenceEvery2Months": MessageLookupByLibrary.simpleMessage(
      "Every 2 months",
    ),
    "flowChoreRecurrenceEvery2Weeks": MessageLookupByLibrary.simpleMessage(
      "Every 2 weeks",
    ),
    "flowChoreRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "How often does this come up?",
    ),
    "flowChoreRecurrenceMonthly": MessageLookupByLibrary.simpleMessage(
      "Monthly",
    ),
    "flowChoreRecurrenceNone": MessageLookupByLibrary.simpleMessage("One time"),
    "flowChoreRecurrenceWeekly": MessageLookupByLibrary.simpleMessage("Weekly"),
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
    "flowChoreValidationAssignee": MessageLookupByLibrary.simpleMessage(
      "Choose someone, or leave it open for anyone.",
    ),
    "flowChoreValidationDate": MessageLookupByLibrary.simpleMessage(
      "Pick a date up to a year from today.",
    ),
    "flowChoreValidationHowToUrl": MessageLookupByLibrary.simpleMessage(
      "Enter a valid link that starts with http or https.",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage(
      "Give the flow a name.",
    ),
    "flowListDraftLabel": MessageLookupByLibrary.simpleMessage("Draft"),
    "flowListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Create your first flow so everyone feels clear and aligned.",
    ),
    "flowListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Nothing in Flow yet",
    ),
    "flowListError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t load Flow. Pull to refresh.",
    ),
    "flowListOverdueLabel": MessageLookupByLibrary.simpleMessage("Past date"),
    "force_update_body": MessageLookupByLibrary.simpleMessage(
      "This version of Kinly is no longer supported. Please install the newest release to continue.",
    ),
    "force_update_button": MessageLookupByLibrary.simpleMessage("Update Kinly"),
    "force_update_notes_label": MessageLookupByLibrary.simpleMessage(
      "What\'s new",
    ),
    "force_update_title": MessageLookupByLibrary.simpleMessage("Update needed"),
    "force_update_version_details": m2,
    "friendDefaultName": MessageLookupByLibrary.simpleMessage("friend"),
    "gratitudeWallEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Share a sunny moment to start filling the wall.",
    ),
    "gratitudeWallEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "No gratitude posts yet",
    ),
    "gratitudeWallFooter": m3,
    "gratitudeWallKinlySubtitle": MessageLookupByLibrary.simpleMessage(
      "Kinly helps your home share small moments of gratitude.",
    ),
    "gratitudeWallPoweredBy": MessageLookupByLibrary.simpleMessage(
      "Powered by",
    ),
    "gratitudeWallRetry": MessageLookupByLibrary.simpleMessage("Try again"),
    "gratitudeWallShareCta": MessageLookupByLibrary.simpleMessage(
      "Share this wall",
    ),
    "gratitudeWallShareError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t share right now. Please try again.",
    ),
    "gratitudeWallShareMessage": m4,
    "gratitudeWallShareTitle": MessageLookupByLibrary.simpleMessage(
      "Gratitude wall",
    ),
    "gratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "Shared moments from your home.",
    ),
    "gratitudeWallTimestamp": m5,
    "gratitudeWallTitle": MessageLookupByLibrary.simpleMessage(
      "Gratitude wall",
    ),
    "gratitudeWallTitleCount": m6,
    "gratitudeWallWeeksAgo": m7,
    "greetingPartAfternoon": MessageLookupByLibrary.simpleMessage("afternoon"),
    "greetingPartEvening": MessageLookupByLibrary.simpleMessage("evening"),
    "greetingPartMorning": MessageLookupByLibrary.simpleMessage("morning"),
    "greetingPartOfDay": m8,
    "harmonyCommentHint": MessageLookupByLibrary.simpleMessage(
      "What’s been contributing to this feeling at home?",
    ),
    "harmonyCommentLabel": MessageLookupByLibrary.simpleMessage(
      "Anything you’d like to share?",
    ),
    "harmonyEntryCta": MessageLookupByLibrary.simpleMessage(
      "Share this week\'s mood",
    ),
    "harmonyEntryError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t open harmony feedback. Try again.",
    ),
    "harmonyErrorAlreadySubmitted": MessageLookupByLibrary.simpleMessage(
      "You\'ve already shared your mood for this week.",
    ),
    "harmonyErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "You are unable to submit feedback for this home.",
    ),
    "harmonyErrorSelectMood": MessageLookupByLibrary.simpleMessage(
      "Pick a mood before submitting.",
    ),
    "harmonyErrorUnknown": MessageLookupByLibrary.simpleMessage(
      "Something went wrong. Please try again.",
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
      "How\'s your home feeling this week?",
    ),
    "harmonyShareLabel": MessageLookupByLibrary.simpleMessage(
      "Share this with the home",
    ),
    "harmonySubmitCta": MessageLookupByLibrary.simpleMessage("Send feedback"),
    "harmonySubmitSuccess": MessageLookupByLibrary.simpleMessage(
      "Thanks! Your feedback was saved.",
    ),
    "harmonySubtext": MessageLookupByLibrary.simpleMessage(
      "Pick the weather that best matches your vibe and leave an optional note.",
    ),
    "harmonyTitle": MessageLookupByLibrary.simpleMessage(
      "Weekly house harmony",
    ),
    "hubCardGratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "Read quick thank-yous and small moments of appreciation.",
    ),
    "hubCardGratitudeWallTitle": MessageLookupByLibrary.simpleMessage(
      "Gratitude Wall",
    ),
    "hubCodeCopied": MessageLookupByLibrary.simpleMessage("Invite code copied"),
    "hubCopyCode": MessageLookupByLibrary.simpleMessage("Copy invite code"),
    "hubError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load Hub. Please try again.",
    ),
    "hubInviteCta": MessageLookupByLibrary.simpleMessage("Invite"),
    "hubInviteUnavailable": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t load invite. Please try again.",
    ),
    "hubMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "No active members yet.",
    ),
    "hubMembersSubtitle": MessageLookupByLibrary.simpleMessage(
      "People currently active in this home.",
    ),
    "hubMembersTitle": MessageLookupByLibrary.simpleMessage("Home members"),
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
    "hubShareAppBody": m9,
    "hubShareAppCta": MessageLookupByLibrary.simpleMessage("Share Kinly"),
    "hubShareAppTitle": MessageLookupByLibrary.simpleMessage(
      "Get the Kinly app",
    ),
    "hubShareInviteBody": m10,
    "hubShareInviteTitle": MessageLookupByLibrary.simpleMessage(
      "Invite to my Kinly home",
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
    "join_hint": MessageLookupByLibrary.simpleMessage("Enter invite code"),
    "join_submit": MessageLookupByLibrary.simpleMessage("Join"),
    "join_success": m11,
    "join_title": MessageLookupByLibrary.simpleMessage("Join Home"),
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
      "You’re already connected to a home.",
    ),
    "membership_status_checking": MessageLookupByLibrary.simpleMessage(
      "Checking membership status...",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "You haven\'t joined a home yet.",
    ),
    "navExplore": MessageLookupByLibrary.simpleMessage("Explore"),
    "navHub": MessageLookupByLibrary.simpleMessage("Hub"),
    "navToday": MessageLookupByLibrary.simpleMessage("Today"),
    "npsCannotSkip": MessageLookupByLibrary.simpleMessage(
      "You need to pick a score to continue.",
    ),
    "npsDescription": MessageLookupByLibrary.simpleMessage(
      "Net Promoter Score helps us learn how we\'re doing. Pick a number from 0 (not likely) to 10 (extremely likely).",
    ),
    "npsEmailSubject": MessageLookupByLibrary.simpleMessage(
      "What can we improve?",
    ),
    "npsLaunchError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t open the next step.",
    ),
    "npsScaleHighLabel": MessageLookupByLibrary.simpleMessage(
      "10 Extremely likely",
    ),
    "npsScaleLowLabel": MessageLookupByLibrary.simpleMessage("0 Not likely"),
    "npsSubmitErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "You\'re not allowed to submit feedback right now.",
    ),
    "npsSubmitErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t send your feedback. Please try again.",
    ),
    "npsSubmitErrorInvalidScore": MessageLookupByLibrary.simpleMessage(
      "Please pick a score between 0 and 10.",
    ),
    "npsSubmitErrorNotRequired": MessageLookupByLibrary.simpleMessage(
      "This feedback isn\'t needed right now.",
    ),
    "npsTitle": MessageLookupByLibrary.simpleMessage(
      "How likely are you to recommend Kinly to a friend?",
    ),
    "offline_body": MessageLookupByLibrary.simpleMessage(
      "Kinly needs an internet connection. Check your signal and try again.",
    ),
    "offline_retry": MessageLookupByLibrary.simpleMessage("Try again"),
    "offline_title": MessageLookupByLibrary.simpleMessage("You\'re offline"),
    "paywallBulletFlows": MessageLookupByLibrary.simpleMessage(
      "Unlimited flows",
    ),
    "paywallBulletMembers": MessageLookupByLibrary.simpleMessage(
      "Unlimited home members",
    ),
    "paywallBulletPhotos": MessageLookupByLibrary.simpleMessage(
      "Unlimited flow photos",
    ),
    "paywallBulletShares": MessageLookupByLibrary.simpleMessage(
      "Unlimited shared expenses",
    ),
    "paywallErrorTitle": MessageLookupByLibrary.simpleMessage(
      "Unable to load paywall.",
    ),
    "paywallPriceCaption": MessageLookupByLibrary.simpleMessage(
      "One home plan, no hidden tiers.",
    ),
    "paywallPricePerMonth": m12,
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
      "Your home-level upgrade for less than 0.5% of your rent.",
    ),
    "paywallTitle": MessageLookupByLibrary.simpleMessage(
      "Bring more harmony to your home",
    ),
    "profileActionCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "profileActionConfirm": MessageLookupByLibrary.simpleMessage("Leave Home"),
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
      "You\'ll lose access to Flow, history, and invites.",
    ),
    "profileConfirmLeaveTitle": MessageLookupByLibrary.simpleMessage(
      "Leave this home?",
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
      "Choose who will lose access to this home.",
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
      "Select a member to remove. They\'ll lose access right away.",
    ),
    "profileKickSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Remove a member",
    ),
    "profileKickSuccessClose": MessageLookupByLibrary.simpleMessage(
      "Back to settings",
    ),
    "profileKickSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "They no longer have access to this home.",
    ),
    "profileKickSuccessTitle": MessageLookupByLibrary.simpleMessage(
      "Member removed",
    ),
    "profileLeaveEligibilityError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t load your home members. Try again.",
    ),
    "profileLeaveEligibilityLoading": MessageLookupByLibrary.simpleMessage(
      "Checking your home members...",
    ),
    "profileLeaveHomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Leaving this home means stepping out of your shared Kinly space.",
    ),
    "profileLeaveHomeTitle": MessageLookupByLibrary.simpleMessage("Leave home"),
    "profileLeaveOwnerNoEligibleMembers": MessageLookupByLibrary.simpleMessage(
      "No one else can take ownership right now. Try again later.",
    ),
    "profileLeaveOwnerSoloMessage": MessageLookupByLibrary.simpleMessage(
      "You\'re the last member. Leaving will deactivate this home for everyone.",
    ),
    "profileLeaveSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "You left your home.",
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
    "profileLogoutDialogMessage": MessageLookupByLibrary.simpleMessage(
      "You\'ll need to sign in again to access your home.",
    ),
    "profileLogoutDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Sign out?",
    ),
    "profileLogoutSubtitle": MessageLookupByLibrary.simpleMessage(
      "Sign out of Kinly on this device.",
    ),
    "profileLogoutTitle": MessageLookupByLibrary.simpleMessage("Sign out"),
    "profileMissingHomeError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t find your current home. Try again.",
    ),
    "profileSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Manage your account preferences and home access.",
    ),
    "profileSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Profile & home",
    ),
    "quick_add_fair_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "Note a fairness entry",
    ),
    "quick_add_fair_share_title": MessageLookupByLibrary.simpleMessage(
      "Fair Share",
    ),
    "quick_add_flow_subtitle": MessageLookupByLibrary.simpleMessage(
      "Create a flow",
    ),
    "quick_add_flow_title": MessageLookupByLibrary.simpleMessage("Flow"),
    "quick_add_poll_subtitle": MessageLookupByLibrary.simpleMessage(
      "Create a quick home poll",
    ),
    "quick_add_poll_title": MessageLookupByLibrary.simpleMessage("Poll"),
    "quick_add_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "Add a Share",
    ),
    "quick_add_share_title": MessageLookupByLibrary.simpleMessage("Share"),
    "quick_add_title": MessageLookupByLibrary.simpleMessage("Quick Add"),
    "shareCreateAmountHint": MessageLookupByLibrary.simpleMessage("0.00"),
    "shareCreateAmountLabel": MessageLookupByLibrary.simpleMessage("Amount"),
    "shareCreateCustomAmountLabel": MessageLookupByLibrary.simpleMessage(
      "Amount",
    ),
    "shareCreateCustomHelper": MessageLookupByLibrary.simpleMessage(
      "Enter each person\'s part. Make sure the total matches the amount above.",
    ),
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
    "shareCreateParticipantsLabel": MessageLookupByLibrary.simpleMessage(
      "Who\'s sharing?",
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
    "shareCreateSubmit": MessageLookupByLibrary.simpleMessage("Create"),
    "shareCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "Share created.",
    ),
    "shareCreateTitle": MessageLookupByLibrary.simpleMessage("Create"),
    "shareCreateValidationAmount": MessageLookupByLibrary.simpleMessage(
      "Enter a valid amount greater than zero.",
    ),
    "shareCreateValidationCustomAmounts": MessageLookupByLibrary.simpleMessage(
      "Enter a valid amount for each selected person.",
    ),
    "shareCreateValidationCustomParticipants":
        MessageLookupByLibrary.simpleMessage(
          "Custom split needs at least two people.",
        ),
    "shareCreateValidationCustomSinglePayer": MessageLookupByLibrary.simpleMessage(
      "Share the amount between at least two people when using a custom split.",
    ),
    "shareCreateValidationCustomSum": MessageLookupByLibrary.simpleMessage(
      "Make sure the custom split adds up to the amount above.",
    ),
    "shareCreateValidationDescription": MessageLookupByLibrary.simpleMessage(
      "Enter a description.",
    ),
    "shareCreateValidationEqualParticipants":
        MessageLookupByLibrary.simpleMessage(
          "Select at least two people to split the amount.",
        ),
    "shareCreateValidationSplit": MessageLookupByLibrary.simpleMessage(
      "Choose how you want to share.",
    ),
    "shareCreatedListActiveAmount": m13,
    "shareCreatedListActiveSubtitle": m14,
    "shareCreatedListDraftBadge": MessageLookupByLibrary.simpleMessage(
      "Unassigned",
    ),
    "shareCreatedListDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "Split it so everyone knows their part before publishing.",
    ),
    "shareCreatedListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Create a Bill to see it listed here.",
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
    "shareEditDeleteCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
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
      "Share deleted.",
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
    "shareEditSuccess": MessageLookupByLibrary.simpleMessage("Share updated."),
    "shareEditTitle": MessageLookupByLibrary.simpleMessage("Edit Share"),
    "shareOwedDetailEmpty": MessageLookupByLibrary.simpleMessage(
      "You\'re all caught up with this person.",
    ),
    "shareOwedDetailError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t mark that share paid. Try again.",
    ),
    "shareOwedDetailPaid": MessageLookupByLibrary.simpleMessage(
      "Mark as settled",
    ),
    "shareOwedDetailSelectionLabel": MessageLookupByLibrary.simpleMessage(
      "Select who to share with.",
    ),
    "shareOwedDetailSubtitle": MessageLookupByLibrary.simpleMessage(
      "Select the bill you just settled.",
    ),
    "shareOwedDetailSuccess": MessageLookupByLibrary.simpleMessage("Settled."),
    "shareOwedDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Awaiting settle",
    ),
    "todayAddSheetFlow": MessageLookupByLibrary.simpleMessage("Add Flow"),
    "todayAddSheetShare": MessageLookupByLibrary.simpleMessage("Add Share"),
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
      "Invite them so you can stay aligned and share the load.",
    ),
    "todayFlatmateInviteTitle": MessageLookupByLibrary.simpleMessage(
      "Bring your home into Kinly",
    ),
    "todayFlowBadgeNew": MessageLookupByLibrary.simpleMessage("new today"),
    "todayFlowSectionTitle": MessageLookupByLibrary.simpleMessage("Flow"),
    "todayFlowSeeAll": m15,
    "todayFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "Here\'s what\'s flowing in your home today.",
    ),
    "todayFlowTabActive": MessageLookupByLibrary.simpleMessage("Active"),
    "todayFlowTabDrafts": MessageLookupByLibrary.simpleMessage("Drafts"),
    "todayGratitudeOpenCta": MessageLookupByLibrary.simpleMessage("View wall"),
    "todayGratitudeSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Home Gratitude wall",
    ),
    "todayGratitudeUnreadBody": MessageLookupByLibrary.simpleMessage(
      "New gratitude posts are waiting for you.",
    ),
    "todayInviteFriendsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Share Kinly with a friend so they can bring more harmony to their home too.",
    ),
    "todayInviteFriendsTitle": MessageLookupByLibrary.simpleMessage(
      "Invite friends to Kinly",
    ),
    "todayInviteNotNow": MessageLookupByLibrary.simpleMessage("Not now"),
    "todayInviteShareCta": MessageLookupByLibrary.simpleMessage("Share invite"),
    "todayShareActiveSubtitle": m16,
    "todayShareBadgeUpcoming": MessageLookupByLibrary.simpleMessage("upcoming"),
    "todayShareDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "Split based on the bill share.",
    ),
    "todayShareEmptyState": MessageLookupByLibrary.simpleMessage(
      "Nothing to see here yet.",
    ),
    "todayShareError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t refresh Share right now.",
    ),
    "todayShareSampleGroceries": MessageLookupByLibrary.simpleMessage(
      "Shared groceries from yesterday",
    ),
    "todayShareSampleInternet": MessageLookupByLibrary.simpleMessage(
      "Internet bill this week",
    ),
    "todayShareSampleRent": MessageLookupByLibrary.simpleMessage(
      "Rent reminder coming up",
    ),
    "todayShareSectionTitle": MessageLookupByLibrary.simpleMessage("Share"),
    "todayShareSeeAll": MessageLookupByLibrary.simpleMessage("See all bills"),
    "todayShareTabActive": MessageLookupByLibrary.simpleMessage("Active"),
    "todayShareTabDrafts": MessageLookupByLibrary.simpleMessage("Drafts"),
    "today_home_details": m17,
    "today_no_membership": MessageLookupByLibrary.simpleMessage(
      "No active home yet. Create or join to see today\'s view.",
    ),
    "today_title": MessageLookupByLibrary.simpleMessage("Today"),
    "unknownInitial": MessageLookupByLibrary.simpleMessage("?"),
    "welcome_create": MessageLookupByLibrary.simpleMessage("Create a Home"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("Join a Home"),
    "welcome_title": MessageLookupByLibrary.simpleMessage("Welcome to Kinly"),
  };
}
