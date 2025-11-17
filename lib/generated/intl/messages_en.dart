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

  static String m0(code) => "Joined with code: ${code}";

  static String m1(homeId, role) => "Current home: ${homeId} • Role: ${role}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("Kinly"),
    "create_failed_generic": MessageLookupByLibrary.simpleMessage(
      "Could not create the home. Try again.",
    ),
    "create_submit": MessageLookupByLibrary.simpleMessage("Create home"),
    "create_subtitle": MessageLookupByLibrary.simpleMessage(
      "We\'ll spin up your home instantly. You can rename and invite later.",
    ),
    "create_success": MessageLookupByLibrary.simpleMessage("Home created!"),
    "create_title": MessageLookupByLibrary.simpleMessage("Create Home"),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage(
      "Join failed. Please try again.",
    ),
    "join_hint": MessageLookupByLibrary.simpleMessage("Enter invite code"),
    "join_submit": MessageLookupByLibrary.simpleMessage("Join"),
    "join_success": m0,
    "join_title": MessageLookupByLibrary.simpleMessage("Join Home"),
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
      "You\'re already part of a home.",
    ),
    "membership_status_checking": MessageLookupByLibrary.simpleMessage(
      "Checking membership status…",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "You haven\'t joined a home yet.",
    ),
    "navExplore": MessageLookupByLibrary.simpleMessage("Explore"),
    "navHub": MessageLookupByLibrary.simpleMessage("Hub"),
    "navToday": MessageLookupByLibrary.simpleMessage("Today"),
    "quick_add_fair_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "Record a fairness entry",
    ),
    "quick_add_fair_share_title": MessageLookupByLibrary.simpleMessage(
      "Fair Share",
    ),
    "quick_add_flow_subtitle": MessageLookupByLibrary.simpleMessage(
      "Add a task to Flow",
    ),
    "quick_add_flow_title": MessageLookupByLibrary.simpleMessage("Flow"),
    "quick_add_poll_subtitle": MessageLookupByLibrary.simpleMessage(
      "Create a quick home poll",
    ),
    "quick_add_poll_title": MessageLookupByLibrary.simpleMessage("Poll"),
    "quick_add_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "Log a shared expense",
    ),
    "quick_add_share_title": MessageLookupByLibrary.simpleMessage("Share"),
    "quick_add_title": MessageLookupByLibrary.simpleMessage("Quick Add"),
    "today_home_details": m1,
    "today_no_membership": MessageLookupByLibrary.simpleMessage(
      "No active home yet. Create or join to see today\'s view.",
    ),
    "today_title": MessageLookupByLibrary.simpleMessage("Today"),
    "welcome_create": MessageLookupByLibrary.simpleMessage("Create a Home"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("Join a Home"),
    "welcome_title": MessageLookupByLibrary.simpleMessage("Welcome to Kinly"),
  };
}
