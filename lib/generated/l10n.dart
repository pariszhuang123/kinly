// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Kinly`
  String get app_title {
    return Intl.message('Kinly', name: 'app_title', desc: '', args: []);
  }

  /// `Welcome to Kinly`
  String get welcome_title {
    return Intl.message(
      'Welcome to Kinly',
      name: 'welcome_title',
      desc: '',
      args: [],
    );
  }

  /// `Create a Home`
  String get welcome_create {
    return Intl.message(
      'Create a Home',
      name: 'welcome_create',
      desc: '',
      args: [],
    );
  }

  /// `Join a Home`
  String get welcome_join {
    return Intl.message(
      'Join a Home',
      name: 'welcome_join',
      desc: '',
      args: [],
    );
  }

  /// `Create Home`
  String get create_title {
    return Intl.message(
      'Create Home',
      name: 'create_title',
      desc: '',
      args: [],
    );
  }

  /// `We'll spin up your home instantly. You can rename and invite later.`
  String get create_subtitle {
    return Intl.message(
      'We\'ll spin up your home instantly. You can rename and invite later.',
      name: 'create_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Create home`
  String get create_submit {
    return Intl.message(
      'Create home',
      name: 'create_submit',
      desc: '',
      args: [],
    );
  }

  /// `Home created!`
  String get create_success {
    return Intl.message(
      'Home created!',
      name: 'create_success',
      desc: '',
      args: [],
    );
  }

  /// `Could not create the home. Try again.`
  String get create_failed_generic {
    return Intl.message(
      'Could not create the home. Try again.',
      name: 'create_failed_generic',
      desc: '',
      args: [],
    );
  }

  /// `Join Home`
  String get join_title {
    return Intl.message('Join Home', name: 'join_title', desc: '', args: []);
  }

  /// `Enter invite code`
  String get join_hint {
    return Intl.message(
      'Enter invite code',
      name: 'join_hint',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get join_submit {
    return Intl.message('Join', name: 'join_submit', desc: '', args: []);
  }

  /// `Joined with code: {code}`
  String join_success(String code) {
    return Intl.message(
      'Joined with code: $code',
      name: 'join_success',
      desc: 'Snackbar message displayed when the user joins successfully',
      args: [code],
    );
  }

  /// `Join failed. Please try again.`
  String get join_failed_generic {
    return Intl.message(
      'Join failed. Please try again.',
      name: 'join_failed_generic',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today_title {
    return Intl.message('Today', name: 'today_title', desc: '', args: []);
  }

  /// `Quick Add`
  String get quick_add_title {
    return Intl.message(
      'Quick Add',
      name: 'quick_add_title',
      desc: '',
      args: [],
    );
  }

  /// `Flow`
  String get quick_add_flow_title {
    return Intl.message(
      'Flow',
      name: 'quick_add_flow_title',
      desc: '',
      args: [],
    );
  }

  /// `Add a task to Flow`
  String get quick_add_flow_subtitle {
    return Intl.message(
      'Add a task to Flow',
      name: 'quick_add_flow_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get quick_add_share_title {
    return Intl.message(
      'Share',
      name: 'quick_add_share_title',
      desc: '',
      args: [],
    );
  }

  /// `Log a shared expense`
  String get quick_add_share_subtitle {
    return Intl.message(
      'Log a shared expense',
      name: 'quick_add_share_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Poll`
  String get quick_add_poll_title {
    return Intl.message(
      'Poll',
      name: 'quick_add_poll_title',
      desc: '',
      args: [],
    );
  }

  /// `Create a quick home poll`
  String get quick_add_poll_subtitle {
    return Intl.message(
      'Create a quick home poll',
      name: 'quick_add_poll_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Fair Share`
  String get quick_add_fair_share_title {
    return Intl.message(
      'Fair Share',
      name: 'quick_add_fair_share_title',
      desc: '',
      args: [],
    );
  }

  /// `Record a fairness entry`
  String get quick_add_fair_share_subtitle {
    return Intl.message(
      'Record a fairness entry',
      name: 'quick_add_fair_share_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Add to your home`
  String get todayAddSheetTitle {
    return Intl.message(
      'Add to your home',
      name: 'todayAddSheetTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add task (Flow)`
  String get todayAddSheetFlow {
    return Intl.message(
      'Add task (Flow)',
      name: 'todayAddSheetFlow',
      desc: '',
      args: [],
    );
  }

  /// `Add expense (Share)`
  String get todayAddSheetShare {
    return Intl.message(
      'Add expense (Share)',
      name: 'todayAddSheetShare',
      desc: '',
      args: [],
    );
  }

  /// `Share expenses coming soon.`
  String get todayAddShareComingSoon {
    return Intl.message(
      'Share expenses coming soon.',
      name: 'todayAddShareComingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Together feels lighter`
  String get login_tagline {
    return Intl.message(
      'Together feels lighter',
      name: 'login_tagline',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Google`
  String get login_with_google {
    return Intl.message(
      'Continue with Google',
      name: 'login_with_google',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Apple`
  String get login_with_apple {
    return Intl.message(
      'Continue with Apple',
      name: 'login_with_apple',
      desc: '',
      args: [],
    );
  }

  /// `I have read and agree to the `
  String get login_consent_prefix {
    return Intl.message(
      'I have read and agree to the ',
      name: 'login_consent_prefix',
      desc: '',
      args: [],
    );
  }

  /// `Service Terms`
  String get login_terms {
    return Intl.message(
      'Service Terms',
      name: 'login_terms',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get login_privacy {
    return Intl.message(
      'Privacy Policy',
      name: 'login_privacy',
      desc: '',
      args: [],
    );
  }

  /// `Sign out`
  String get logout {
    return Intl.message('Sign out', name: 'logout', desc: '', args: []);
  }

  /// `Checking membership status…`
  String get membership_status_checking {
    return Intl.message(
      'Checking membership status…',
      name: 'membership_status_checking',
      desc: '',
      args: [],
    );
  }

  /// `You haven't joined a home yet.`
  String get membership_status_none {
    return Intl.message(
      'You haven\'t joined a home yet.',
      name: 'membership_status_none',
      desc: '',
      args: [],
    );
  }

  /// `You're already part of a home.`
  String get membership_status_active {
    return Intl.message(
      'You\'re already part of a home.',
      name: 'membership_status_active',
      desc: '',
      args: [],
    );
  }

  /// `No active home yet. Create or join to see today's view.`
  String get today_no_membership {
    return Intl.message(
      'No active home yet. Create or join to see today\'s view.',
      name: 'today_no_membership',
      desc: '',
      args: [],
    );
  }

  /// `Current home: {homeId} • Role: {role}`
  String today_home_details(String homeId, String role) {
    return Intl.message(
      'Current home: $homeId • Role: $role',
      name: 'today_home_details',
      desc: '',
      args: [homeId, role],
    );
  }

  /// `Today`
  String get navToday {
    return Intl.message('Today', name: 'navToday', desc: '', args: []);
  }

  /// `Explore`
  String get navExplore {
    return Intl.message('Explore', name: 'navExplore', desc: '', args: []);
  }

  /// `Hub`
  String get navHub {
    return Intl.message('Hub', name: 'navHub', desc: '', args: []);
  }

  /// `You're all caught up for today ✨`
  String get todayEmptyCardTitle {
    return Intl.message(
      'You\'re all caught up for today ✨',
      name: 'todayEmptyCardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Take a breather`
  String get todayEmptyCardBadge {
    return Intl.message(
      'Take a breather',
      name: 'todayEmptyCardBadge',
      desc: '',
      args: [],
    );
  }

  /// `Enjoy the calm — Kinly will let you know when something needs your attention.`
  String get todayEmptyBody {
    return Intl.message(
      'Enjoy the calm — Kinly will let you know when something needs your attention.',
      name: 'todayEmptyBody',
      desc: '',
      args: [],
    );
  }

  /// `friend`
  String get friendDefaultName {
    return Intl.message(
      'friend',
      name: 'friendDefaultName',
      desc: '',
      args: [],
    );
  }

  /// `?`
  String get unknownInitial {
    return Intl.message('?', name: 'unknownInitial', desc: '', args: []);
  }

  /// `Good {partOfDay}, {name}`
  String greetingPartOfDay(Object partOfDay, Object name) {
    return Intl.message(
      'Good $partOfDay, $name',
      name: 'greetingPartOfDay',
      desc: '',
      args: [partOfDay, name],
    );
  }

  /// `part of day (morning/afternoon/evening)`
  String get greetingPartOfDay_partOfDay {
    return Intl.message(
      'part of day (morning/afternoon/evening)',
      name: 'greetingPartOfDay_partOfDay',
      desc: '',
      args: [],
    );
  }

  /// `name`
  String get greetingPartOfDay_name {
    return Intl.message(
      'name',
      name: 'greetingPartOfDay_name',
      desc: '',
      args: [],
    );
  }

  /// `Here's what's flowing in your home today.`
  String get todayFlowSubtitle {
    return Intl.message(
      'Here\'s what\'s flowing in your home today.',
      name: 'todayFlowSubtitle',
      desc: '',
      args: [],
    );
  }
  /// `Add Flow chore`
  String get flowChoreCreateTitle {
    return Intl.message(
      'Add Flow chore',
      name: 'flowChoreCreateTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit Flow chore`
  String get flowChoreEditTitle {
    return Intl.message(
      'Edit Flow chore',
      name: 'flowChoreEditTitle',
      desc: '',
      args: [],
    );
  }

  /// `Task name`
  String get flowChoreNameLabel {
    return Intl.message(
      'Task name',
      name: 'flowChoreNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Give your task a short, clear title`
  String get flowChoreNameHint {
    return Intl.message(
      'Give your task a short, clear title',
      name: 'flowChoreNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Give the chore a name.`
  String get flowChoreValidationName {
    return Intl.message(
      'Give the chore a name.',
      name: 'flowChoreValidationName',
      desc: '',
      args: [],
    );
  }

  /// `Assign to`
  String get flowChoreAssigneeLabel {
    return Intl.message(
      'Assign to',
      name: 'flowChoreAssigneeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Unassigned`
  String get flowChoreAssigneeUnassigned {
    return Intl.message(
      'Unassigned',
      name: 'flowChoreAssigneeUnassigned',
      desc: '',
      args: [],
    );
  }

  /// `Pick someone to assign this chore to.`
  String get flowChoreValidationAssignee {
    return Intl.message(
      'Pick someone to assign this chore to.',
      name: 'flowChoreValidationAssignee',
      desc: '',
      args: [],
    );
  }

  /// `Start date`
  String get flowChoreStartLabel {
    return Intl.message(
      'Start date',
      name: 'flowChoreStartLabel',
      desc: '',
      args: [],
    );
  }

  /// `Recurrence`
  String get flowChoreRecurrenceLabel {
    return Intl.message(
      'Recurrence',
      name: 'flowChoreRecurrenceLabel',
      desc: '',
      args: [],
    );
  }

  /// `One time`
  String get flowChoreRecurrenceNone {
    return Intl.message(
      'One time',
      name: 'flowChoreRecurrenceNone',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get flowChoreRecurrenceDaily {
    return Intl.message(
      'Daily',
      name: 'flowChoreRecurrenceDaily',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get flowChoreRecurrenceWeekly {
    return Intl.message(
      'Weekly',
      name: 'flowChoreRecurrenceWeekly',
      desc: '',
      args: [],
    );
  }

  /// `Every 2 weeks`
  String get flowChoreRecurrenceEvery2Weeks {
    return Intl.message(
      'Every 2 weeks',
      name: 'flowChoreRecurrenceEvery2Weeks',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get flowChoreRecurrenceMonthly {
    return Intl.message(
      'Monthly',
      name: 'flowChoreRecurrenceMonthly',
      desc: '',
      args: [],
    );
  }

  /// `Every 2 months`
  String get flowChoreRecurrenceEvery2Months {
    return Intl.message(
      'Every 2 months',
      name: 'flowChoreRecurrenceEvery2Months',
      desc: '',
      args: [],
    );
  }

  /// `Annual`
  String get flowChoreRecurrenceAnnual {
    return Intl.message(
      'Annual',
      name: 'flowChoreRecurrenceAnnual',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get flowChoreNotesLabel {
    return Intl.message(
      'Notes',
      name: 'flowChoreNotesLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add optional context or reminders`
  String get flowChoreNotesHint {
    return Intl.message(
      'Add optional context or reminders',
      name: 'flowChoreNotesHint',
      desc: '',
      args: [],
    );
  }

  /// `How-to link`
  String get flowChoreHowToLabel {
    return Intl.message(
      'How-to link',
      name: 'flowChoreHowToLabel',
      desc: '',
      args: [],
    );
  }

  /// `Paste a video or document link (optional)`
  String get flowChoreHowToHint {
    return Intl.message(
      'Paste a video or document link (optional)',
      name: 'flowChoreHowToHint',
      desc: '',
      args: [],
    );
  }

  /// `Expectation photo`
  String get flowChorePhotoLabel {
    return Intl.message(
      'Expectation photo',
      name: 'flowChorePhotoLabel',
      desc: '',
      args: [],
    );
  }

  /// `storage/households/... (optional)`
  String get flowChorePhotoHint {
    return Intl.message(
      'storage/households/... (optional)',
      name: 'flowChorePhotoHint',
      desc: '',
      args: [],
    );
  }

  /// `Add chore`
  String get flowChoreSubmitCreate {
    return Intl.message(
      'Add chore',
      name: 'flowChoreSubmitCreate',
      desc: '',
      args: [],
    );
  }

  /// `Save chore`
  String get flowChoreSubmitUpdate {
    return Intl.message(
      'Save chore',
      name: 'flowChoreSubmitUpdate',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't load this chore. Please try again.`
  String get flowChoreLoadError {
    return Intl.message(
      'We couldn\'t load this chore. Please try again.',
      name: 'flowChoreLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get flowChoreRetry {
    return Intl.message(
      'Retry',
      name: 'flowChoreRetry',
      desc: '',
      args: [],
    );
  }

  /// `You've hit the free limit for active chores. Upgrade to add more.`
  String get flowChoreErrorPaywallActiveCap {
    return Intl.message(
      'You\'ve hit the free limit for active chores. Upgrade to add more.',
      name: 'flowChoreErrorPaywallActiveCap',
      desc: '',
      args: [],
    );
  }

  /// `You've hit the free limit for expectation photos. Remove one or upgrade.`
  String get flowChoreErrorPaywallMediaCap {
    return Intl.message(
      'You\'ve hit the free limit for expectation photos. Remove one or upgrade.',
      name: 'flowChoreErrorPaywallMediaCap',
      desc: '',
      args: [],
    );
  }

  /// `That member can't be assigned right now.`
  String get flowChoreErrorAssigneeNotMember {
    return Intl.message(
      'That member can\'t be assigned right now.',
      name: 'flowChoreErrorAssigneeNotMember',
      desc: '',
      args: [],
    );
  }

  /// `You don't have permission to change this chore.`
  String get flowChoreErrorForbidden {
    return Intl.message(
      'You don\'t have permission to change this chore.',
      name: 'flowChoreErrorForbidden',
      desc: '',
      args: [],
    );
  }

  /// `That photo path isn't valid for this home.`
  String get flowChoreErrorInvalidPhoto {
    return Intl.message(
      'That photo path isn\'t valid for this home.',
      name: 'flowChoreErrorInvalidPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Pick a valid start date.`
  String get flowChoreErrorInvalidStart {
    return Intl.message(
      'Pick a valid start date.',
      name: 'flowChoreErrorInvalidStart',
      desc: '',
      args: [],
    );
  }

  /// `This chore can't be updated right now.`
  String get flowChoreErrorInvalidState {
    return Intl.message(
      'This chore can\'t be updated right now.',
      name: 'flowChoreErrorInvalidState',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't save the chore. Please try again.`
  String get flowChoreErrorGeneric {
    return Intl.message(
      'Couldn\'t save the chore. Please try again.',
      name: 'flowChoreErrorGeneric',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
