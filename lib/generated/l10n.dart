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
    final name =
        (locale.countryCode?.isEmpty ?? false)
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

  /// `Starting Kinly ({env})`
  String bootstrap_initializing(String env) {
    return Intl.message(
      'Starting Kinly ($env)',
      name: 'bootstrap_initializing',
      desc: '',
      args: [env],
    );
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

  /// `That invite code doesn't look right.`
  String get join_error_invalid_code {
    return Intl.message(
      'That invite code doesn\'t look right.',
      name: 'join_error_invalid_code',
      desc: '',
      args: [],
    );
  }

  /// `That invite is no longer active. Ask the owner for a new code.`
  String get join_error_inactive_invite {
    return Intl.message(
      'That invite is no longer active. Ask the owner for a new code.',
      name: 'join_error_inactive_invite',
      desc: '',
      args: [],
    );
  }

  /// `You're already in another home. Leave it before joining a new one.`
  String get join_error_already_in_other_home {
    return Intl.message(
      'You\'re already in another home. Leave it before joining a new one.',
      name: 'join_error_already_in_other_home',
      desc: '',
      args: [],
    );
  }

  /// `This home has reached its member limit. Ask the owner to upgrade or remove a member.`
  String get join_error_paywall_limit {
    return Intl.message(
      'This home has reached its member limit. Ask the owner to upgrade or remove a member.',
      name: 'join_error_paywall_limit',
      desc: '',
      args: [],
    );
  }

  /// `Please sign in to join this home.`
  String get join_error_unauthorized {
    return Intl.message(
      'Please sign in to join this home.',
      name: 'join_error_unauthorized',
      desc: '',
      args: [],
    );
  }

  /// `You don't have permission to join this home.`
  String get join_error_forbidden {
    return Intl.message(
      'You don\'t have permission to join this home.',
      name: 'join_error_forbidden',
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

  /// ` & `
  String get login_consent_connector {
    return Intl.message(
      ' & ',
      name: 'login_consent_connector',
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

  /// `We couldn't refresh your home membership. Please try again.`
  String get authMembershipLoadFailed {
    return Intl.message(
      'We couldn\'t refresh your home membership. Please try again.',
      name: 'authMembershipLoadFailed',
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

  /// `You're offline`
  String get offline_title {
    return Intl.message(
      'You\'re offline',
      name: 'offline_title',
      desc: '',
      args: [],
    );
  }

  /// `Kinly needs an internet connection. Check your signal and try again.`
  String get offline_body {
    return Intl.message(
      'Kinly needs an internet connection. Check your signal and try again.',
      name: 'offline_body',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get offline_retry {
    return Intl.message('Try again', name: 'offline_retry', desc: '', args: []);
  }

  /// `Update required`
  String get force_update_title {
    return Intl.message(
      'Update required',
      name: 'force_update_title',
      desc: '',
      args: [],
    );
  }

  /// `This version of Kinly is no longer supported. Please install the newest release to continue.`
  String get force_update_body {
    return Intl.message(
      'This version of Kinly is no longer supported. Please install the newest release to continue.',
      name: 'force_update_body',
      desc: '',
      args: [],
    );
  }

  /// `What's new`
  String get force_update_notes_label {
    return Intl.message(
      'What\'s new',
      name: 'force_update_notes_label',
      desc: '',
      args: [],
    );
  }

  /// `Update Kinly`
  String get force_update_button {
    return Intl.message(
      'Update Kinly',
      name: 'force_update_button',
      desc: '',
      args: [],
    );
  }

  /// `Your version: {client}\nLatest version: {current}`
  String force_update_version_details(String client, String current) {
    return Intl.message(
      'Your version: $client\nLatest version: $current',
      name: 'force_update_version_details',
      desc: '',
      args: [client, current],
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

  /// `morning`
  String get greetingPartMorning {
    return Intl.message(
      'morning',
      name: 'greetingPartMorning',
      desc: '',
      args: [],
    );
  }

  /// `afternoon`
  String get greetingPartAfternoon {
    return Intl.message(
      'afternoon',
      name: 'greetingPartAfternoon',
      desc: '',
      args: [],
    );
  }

  /// `evening`
  String get greetingPartEvening {
    return Intl.message(
      'evening',
      name: 'greetingPartEvening',
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

  /// `Flow`
  String get todayFlowSectionTitle {
    return Intl.message(
      'Flow',
      name: 'todayFlowSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get todayFlowTabActive {
    return Intl.message(
      'Active',
      name: 'todayFlowTabActive',
      desc: '',
      args: [],
    );
  }

  /// `Drafts`
  String get todayFlowTabDrafts {
    return Intl.message(
      'Drafts',
      name: 'todayFlowTabDrafts',
      desc: '',
      args: [],
    );
  }

  /// `See all ({count})`
  String todayFlowSeeAll(int count) {
    return Intl.message(
      'See all ($count)',
      name: 'todayFlowSeeAll',
      desc: '',
      args: [count],
    );
  }

  /// `new today`
  String get todayFlowBadgeNew {
    return Intl.message(
      'new today',
      name: 'todayFlowBadgeNew',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get todayShareSectionTitle {
    return Intl.message(
      'Share',
      name: 'todayShareSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `upcoming`
  String get todayShareBadgeUpcoming {
    return Intl.message(
      'upcoming',
      name: 'todayShareBadgeUpcoming',
      desc: '',
      args: [],
    );
  }

  /// `See all expenses`
  String get todayShareSeeAll {
    return Intl.message(
      'See all expenses',
      name: 'todayShareSeeAll',
      desc: '',
      args: [],
    );
  }

  /// `Shared groceries from yesterday`
  String get todayShareSampleGroceries {
    return Intl.message(
      'Shared groceries from yesterday',
      name: 'todayShareSampleGroceries',
      desc: '',
      args: [],
    );
  }

  /// `Rent reminder coming up`
  String get todayShareSampleRent {
    return Intl.message(
      'Rent reminder coming up',
      name: 'todayShareSampleRent',
      desc: '',
      args: [],
    );
  }

  /// `Internet bill this week`
  String get todayShareSampleInternet {
    return Intl.message(
      'Internet bill this week',
      name: 'todayShareSampleInternet',
      desc: '',
      args: [],
    );
  }

  /// `Nothing to see here yet. As you log expenses or start drafts, they'll appear in Share.`
  String get todayShareEmptyState {
    return Intl.message(
      'Nothing to see here yet. As you log expenses or start drafts, they\'ll appear in Share.',
      name: 'todayShareEmptyState',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get todayShareTabActive {
    return Intl.message(
      'Active',
      name: 'todayShareTabActive',
      desc: '',
      args: [],
    );
  }

  /// `Drafts`
  String get todayShareTabDrafts {
    return Intl.message(
      'Drafts',
      name: 'todayShareTabDrafts',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't refresh Share right now.`
  String get todayShareError {
    return Intl.message(
      'We couldn\'t refresh Share right now.',
      name: 'todayShareError',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, one {{count} payment pending} other {{count} payments pending}}`
  String todayShareActiveSubtitle(int count) {
    return Intl.plural(
      count,
      one: '$count payment pending',
      other: '$count payments pending',
      name: 'todayShareActiveSubtitle',
      desc: '',
      args: [count],
    );
  }

  /// `Finish the split to publish this expense.`
  String get todayShareDraftSubtitle {
    return Intl.message(
      'Finish the split to publish this expense.',
      name: 'todayShareDraftSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Pending payment`
  String get shareOwedDetailTitle {
    return Intl.message(
      'Pending payment',
      name: 'shareOwedDetailTitle',
      desc: '',
      args: [],
    );
  }

  /// `Select the expense you just settled.`
  String get shareOwedDetailSubtitle {
    return Intl.message(
      'Select the expense you just settled.',
      name: 'shareOwedDetailSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `You're all caught up with this person.`
  String get shareOwedDetailEmpty {
    return Intl.message(
      'You\'re all caught up with this person.',
      name: 'shareOwedDetailEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Select an expense to continue.`
  String get shareOwedDetailSelectionLabel {
    return Intl.message(
      'Select an expense to continue.',
      name: 'shareOwedDetailSelectionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Mark as paid`
  String get shareOwedDetailPaid {
    return Intl.message(
      'Mark as paid',
      name: 'shareOwedDetailPaid',
      desc: '',
      args: [],
    );
  }

  /// `Payment recorded.`
  String get shareOwedDetailSuccess {
    return Intl.message(
      'Payment recorded.',
      name: 'shareOwedDetailSuccess',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't mark that share paid. Try again.`
  String get shareOwedDetailError {
    return Intl.message(
      'We couldn\'t mark that share paid. Try again.',
      name: 'shareOwedDetailError',
      desc: '',
      args: [],
    );
  }

  /// `Finish draft`
  String get shareEditTitle {
    return Intl.message(
      'Finish draft',
      name: 'shareEditTitle',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get shareEditSubmit {
    return Intl.message('Update', name: 'shareEditSubmit', desc: '', args: []);
  }

  /// `Share updated.`
  String get shareEditSuccess {
    return Intl.message(
      'Share updated.',
      name: 'shareEditSuccess',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't load that draft.`
  String get shareEditLoadError {
    return Intl.message(
      'We couldn\'t load that draft.',
      name: 'shareEditLoadError',
      desc: '',
      args: [],
    );
  }

  /// `This share can’t be edited anymore because it's already locked.`
  String get shareEditNotAllowed {
    return Intl.message(
      'This share can’t be edited anymore because it\'s already locked.',
      name: 'shareEditNotAllowed',
      desc: '',
      args: [],
    );
  }

  /// `Splits are locked because someone already paid. You can still update the description and notes.`
  String get shareEditSplitsLocked {
    return Intl.message(
      'Splits are locked because someone already paid. You can still update the description and notes.',
      name: 'shareEditSplitsLocked',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get shareEditClose {
    return Intl.message('Close', name: 'shareEditClose', desc: '', args: []);
  }

  /// `Delete`
  String get shareEditDeleteButton {
    return Intl.message(
      'Delete',
      name: 'shareEditDeleteButton',
      desc: '',
      args: [],
    );
  }

  /// `Delete this share?`
  String get shareEditDeleteConfirmTitle {
    return Intl.message(
      'Delete this share?',
      name: 'shareEditDeleteConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `This removes the draft for everyone.`
  String get shareEditDeleteConfirmMessage {
    return Intl.message(
      'This removes the draft for everyone.',
      name: 'shareEditDeleteConfirmMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get shareEditDeleteCancel {
    return Intl.message(
      'Cancel',
      name: 'shareEditDeleteCancel',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get shareEditDeleteConfirm {
    return Intl.message(
      'Delete',
      name: 'shareEditDeleteConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't delete this share. Try again.`
  String get shareEditDeleteError {
    return Intl.message(
      'Couldn\'t delete this share. Try again.',
      name: 'shareEditDeleteError',
      desc: '',
      args: [],
    );
  }

  /// `Share deleted.`
  String get shareEditDeleteSuccess {
    return Intl.message(
      'Share deleted.',
      name: 'shareEditDeleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Create share`
  String get shareCreateTitle {
    return Intl.message(
      'Create share',
      name: 'shareCreateTitle',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get shareCreateDescriptionLabel {
    return Intl.message(
      'Description',
      name: 'shareCreateDescriptionLabel',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Grocery run`
  String get shareCreateDescriptionHint {
    return Intl.message(
      'e.g. Grocery run',
      name: 'shareCreateDescriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get shareCreateAmountLabel {
    return Intl.message(
      'Amount',
      name: 'shareCreateAmountLabel',
      desc: '',
      args: [],
    );
  }

  /// `0.00`
  String get shareCreateAmountHint {
    return Intl.message(
      '0.00',
      name: 'shareCreateAmountHint',
      desc: '',
      args: [],
    );
  }

  /// `Split type`
  String get shareCreateSplitLabel {
    return Intl.message(
      'Split type',
      name: 'shareCreateSplitLabel',
      desc: '',
      args: [],
    );
  }

  /// `Split automatically`
  String get shareCreateSplitEqual {
    return Intl.message(
      'Split automatically',
      name: 'shareCreateSplitEqual',
      desc: '',
      args: [],
    );
  }

  /// `Custom split`
  String get shareCreateSplitCustom {
    return Intl.message(
      'Custom split',
      name: 'shareCreateSplitCustom',
      desc: '',
      args: [],
    );
  }

  /// `Who's sharing?`
  String get shareCreateParticipantsLabel {
    return Intl.message(
      'Who\'s sharing?',
      name: 'shareCreateParticipantsLabel',
      desc: '',
      args: [],
    );
  }

  /// `You need at least two household members to split an expense.`
  String get shareCreateParticipantsEmpty {
    return Intl.message(
      'You need at least two household members to split an expense.',
      name: 'shareCreateParticipantsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get shareCreateNotesLabel {
    return Intl.message(
      'Notes',
      name: 'shareCreateNotesLabel',
      desc: '',
      args: [],
    );
  }

  /// `Optional context everyone can see`
  String get shareCreateNotesHint {
    return Intl.message(
      'Optional context everyone can see',
      name: 'shareCreateNotesHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter what each person owes. The total must match the amount above.`
  String get shareCreateCustomHelper {
    return Intl.message(
      'Enter what each person owes. The total must match the amount above.',
      name: 'shareCreateCustomHelper',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get shareCreateCustomAmountLabel {
    return Intl.message(
      'Amount',
      name: 'shareCreateCustomAmountLabel',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get shareCreateSubmit {
    return Intl.message(
      'Create',
      name: 'shareCreateSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Enter a description.`
  String get shareCreateValidationDescription {
    return Intl.message(
      'Enter a description.',
      name: 'shareCreateValidationDescription',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid amount greater than zero.`
  String get shareCreateValidationAmount {
    return Intl.message(
      'Enter a valid amount greater than zero.',
      name: 'shareCreateValidationAmount',
      desc: '',
      args: [],
    );
  }

  /// `Choose how you want to split this expense.`
  String get shareCreateValidationSplit {
    return Intl.message(
      'Choose how you want to split this expense.',
      name: 'shareCreateValidationSplit',
      desc: '',
      args: [],
    );
  }

  /// `Select at least two people to split the amount.`
  String get shareCreateValidationEqualParticipants {
    return Intl.message(
      'Select at least two people to split the amount.',
      name: 'shareCreateValidationEqualParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Custom split needs at least two people.`
  String get shareCreateValidationCustomParticipants {
    return Intl.message(
      'Custom split needs at least two people.',
      name: 'shareCreateValidationCustomParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid amount for each selected person.`
  String get shareCreateValidationCustomAmounts {
    return Intl.message(
      'Enter a valid amount for each selected person.',
      name: 'shareCreateValidationCustomAmounts',
      desc: '',
      args: [],
    );
  }

  /// `Custom shares must add up to the amount above.`
  String get shareCreateValidationCustomSum {
    return Intl.message(
      'Custom shares must add up to the amount above.',
      name: 'shareCreateValidationCustomSum',
      desc: '',
      args: [],
    );
  }

  /// `One person can't cover the entire amount when using a custom split.`
  String get shareCreateValidationCustomSinglePayer {
    return Intl.message(
      'One person can\'t cover the entire amount when using a custom split.',
      name: 'shareCreateValidationCustomSinglePayer',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't load your household members.`
  String get shareCreateLoadError {
    return Intl.message(
      'We couldn\'t load your household members.',
      name: 'shareCreateLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get shareCreateRetry {
    return Intl.message(
      'Try again',
      name: 'shareCreateRetry',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't create share. Try again.`
  String get shareCreateErrorGeneric {
    return Intl.message(
      'Couldn\'t create share. Try again.',
      name: 'shareCreateErrorGeneric',
      desc: '',
      args: [],
    );
  }

  /// `You don't have permission to create this share right now.`
  String get shareCreateErrorForbidden {
    return Intl.message(
      'You don\'t have permission to create this share right now.',
      name: 'shareCreateErrorForbidden',
      desc: '',
      args: [],
    );
  }

  /// `Share created.`
  String get shareCreateSuccess {
    return Intl.message(
      'Share created.',
      name: 'shareCreateSuccess',
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

  /// `Pick a date between today and a year from now.`
  String get flowChoreValidationDate {
    return Intl.message(
      'Pick a date between today and a year from now.',
      name: 'flowChoreValidationDate',
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

  /// `Enter a valid link that starts with http or https.`
  String get flowChoreValidationHowToUrl {
    return Intl.message(
      'Enter a valid link that starts with http or https.',
      name: 'flowChoreValidationHowToUrl',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't open that link. Try again.`
  String get flowChoreHowToLaunchError {
    return Intl.message(
      'We couldn\'t open that link. Try again.',
      name: 'flowChoreHowToLaunchError',
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

  /// `Add a photo to show what great looks like`
  String get flowChorePhotoPlaceholder {
    return Intl.message(
      'Add a photo to show what great looks like',
      name: 'flowChorePhotoPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Camera permission is required to take a photo.`
  String get flowChorePhotoPermissionDenied {
    return Intl.message(
      'Camera permission is required to take a photo.',
      name: 'flowChorePhotoPermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Open settings`
  String get flowChorePhotoPermissionOpenSettings {
    return Intl.message(
      'Open settings',
      name: 'flowChorePhotoPermissionOpenSettings',
      desc: '',
      args: [],
    );
  }

  /// `Could not upload the photo. Try again.`
  String get flowChorePhotoUploadError {
    return Intl.message(
      'Could not upload the photo. Try again.',
      name: 'flowChorePhotoUploadError',
      desc: '',
      args: [],
    );
  }

  /// `Could not load photo`
  String get flowChorePhotoLoadError {
    return Intl.message(
      'Could not load photo',
      name: 'flowChorePhotoLoadError',
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

  /// `Delete chore`
  String get flowChoreDeleteButton {
    return Intl.message(
      'Delete chore',
      name: 'flowChoreDeleteButton',
      desc: '',
      args: [],
    );
  }

  /// `Delete this chore?`
  String get flowChoreDeleteDialogTitle {
    return Intl.message(
      'Delete this chore?',
      name: 'flowChoreDeleteDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `This removes the flow for everyone in your home.`
  String get flowChoreDeleteDialogMessage {
    return Intl.message(
      'This removes the flow for everyone in your home.',
      name: 'flowChoreDeleteDialogMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get flowChoreDeleteCancel {
    return Intl.message(
      'Cancel',
      name: 'flowChoreDeleteCancel',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get flowChoreDeleteConfirm {
    return Intl.message(
      'Delete',
      name: 'flowChoreDeleteConfirm',
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
    return Intl.message('Retry', name: 'flowChoreRetry', desc: '', args: []);
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

  /// `Chore details`
  String get flowChoreDetailTitle {
    return Intl.message(
      'Chore details',
      name: 'flowChoreDetailTitle',
      desc: '',
      args: [],
    );
  }

  /// `Unassigned`
  String get flowChoreDetailUnassigned {
    return Intl.message(
      'Unassigned',
      name: 'flowChoreDetailUnassigned',
      desc: '',
      args: [],
    );
  }

  /// `No notes yet.`
  String get flowChoreDetailNoNotes {
    return Intl.message(
      'No notes yet.',
      name: 'flowChoreDetailNoNotes',
      desc: '',
      args: [],
    );
  }

  /// `No how-to link provided.`
  String get flowChoreDetailNoHowTo {
    return Intl.message(
      'No how-to link provided.',
      name: 'flowChoreDetailNoHowTo',
      desc: '',
      args: [],
    );
  }

  /// `Complete task`
  String get flowChoreDetailCompleteButton {
    return Intl.message(
      'Complete task',
      name: 'flowChoreDetailCompleteButton',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't complete the chore. Please try again.`
  String get flowChoreDetailCompletionError {
    return Intl.message(
      'Couldn\'t complete the chore. Please try again.',
      name: 'flowChoreDetailCompletionError',
      desc: '',
      args: [],
    );
  }

  /// `More details`
  String get flowChoreDetailMoreInfoTitle {
    return Intl.message(
      'More details',
      name: 'flowChoreDetailMoreInfoTitle',
      desc: '',
      args: [],
    );
  }

  /// `Expectation photo`
  String get flowChoreExpectationPhotoLabel {
    return Intl.message(
      'Expectation photo',
      name: 'flowChoreExpectationPhotoLabel',
      desc: '',
      args: [],
    );
  }

  /// `Nothing in Flow yet`
  String get flowListEmptyTitle {
    return Intl.message(
      'Nothing in Flow yet',
      name: 'flowListEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add your first routine so everyone knows what to do.`
  String get flowListEmptySubtitle {
    return Intl.message(
      'Add your first routine so everyone knows what to do.',
      name: 'flowListEmptySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Draft`
  String get flowListDraftLabel {
    return Intl.message(
      'Draft',
      name: 'flowListDraftLabel',
      desc: '',
      args: [],
    );
  }

  /// `Overdue`
  String get flowListOverdueLabel {
    return Intl.message(
      'Overdue',
      name: 'flowListOverdueLabel',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't load Flow tasks. Pull to refresh.`
  String get flowListError {
    return Intl.message(
      'We couldn\'t load Flow tasks. Pull to refresh.',
      name: 'flowListError',
      desc: '',
      args: [],
    );
  }

  /// `Discover what's next`
  String get exploreIntroTitle {
    return Intl.message(
      'Discover what\'s next',
      name: 'exploreIntroTitle',
      desc: '',
      args: [],
    );
  }

  /// `Explore more ways to keep your home feeling lighter.`
  String get exploreIntroSubtitle {
    return Intl.message(
      'Explore more ways to keep your home feeling lighter.',
      name: 'exploreIntroSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Review every Flow task and keep chores moving`
  String get exploreFlowSubtitle {
    return Intl.message(
      'Review every Flow task and keep chores moving',
      name: 'exploreFlowSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `See every Share you've created and track payments.`
  String get exploreShareSubtitle {
    return Intl.message(
      'See every Share you\'ve created and track payments.',
      name: 'exploreShareSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Your shares`
  String get shareCreatedListTitle {
    return Intl.message(
      'Your shares',
      name: 'shareCreatedListTitle',
      desc: '',
      args: [],
    );
  }

  /// `No shares yet`
  String get shareCreatedListEmptyTitle {
    return Intl.message(
      'No shares yet',
      name: 'shareCreatedListEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create a Share to see it listed here.`
  String get shareCreatedListEmptySubtitle {
    return Intl.message(
      'Create a Share to see it listed here.',
      name: 'shareCreatedListEmptySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't load your shares. Pull to refresh.`
  String get shareCreatedListError {
    return Intl.message(
      'We couldn\'t load your shares. Pull to refresh.',
      name: 'shareCreatedListError',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get shareCreatedListRetry {
    return Intl.message(
      'Try again',
      name: 'shareCreatedListRetry',
      desc: '',
      args: [],
    );
  }

  /// `{paid} of {total} paid`
  String shareCreatedListActiveSubtitle(int paid, int total) {
    return Intl.message(
      '$paid of $total paid',
      name: 'shareCreatedListActiveSubtitle',
      desc: '',
      args: [paid, total],
    );
  }

  /// `{paidAmount} of {totalAmount} collected`
  String shareCreatedListActiveAmount(String paidAmount, String totalAmount) {
    return Intl.message(
      '$paidAmount of $totalAmount collected',
      name: 'shareCreatedListActiveAmount',
      desc: '',
      args: [paidAmount, totalAmount],
    );
  }

  /// `Split it to assign each person before publishing.`
  String get shareCreatedListDraftSubtitle {
    return Intl.message(
      'Split it to assign each person before publishing.',
      name: 'shareCreatedListDraftSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Unassigned`
  String get shareCreatedListDraftBadge {
    return Intl.message(
      'Unassigned',
      name: 'shareCreatedListDraftBadge',
      desc: '',
      args: [],
    );
  }

  /// `Paid off`
  String get shareCreatedListPaidBadge {
    return Intl.message(
      'Paid off',
      name: 'shareCreatedListPaidBadge',
      desc: '',
      args: [],
    );
  }

  /// `Profile & home`
  String get profileSettingsTitle {
    return Intl.message(
      'Profile & home',
      name: 'profileSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Manage your account preferences and home access.`
  String get profileSettingsSubtitle {
    return Intl.message(
      'Manage your account preferences and home access.',
      name: 'profileSettingsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile`
  String get profileIdentityTitle {
    return Intl.message(
      'Edit profile',
      name: 'profileIdentityTitle',
      desc: '',
      args: [],
    );
  }

  /// `Pick a username and avatar for your home.`
  String get profileIdentitySubtitle {
    return Intl.message(
      'Pick a username and avatar for your home.',
      name: 'profileIdentitySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get profileIdentityUsernameLabel {
    return Intl.message(
      'Username',
      name: 'profileIdentityUsernameLabel',
      desc: '',
      args: [],
    );
  }

  /// `letters, numbers, . or _`
  String get profileIdentityUsernameHint {
    return Intl.message(
      'letters, numbers, . or _',
      name: 'profileIdentityUsernameHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter a username to continue.`
  String get profileIdentityUsernameEmptyError {
    return Intl.message(
      'Enter a username to continue.',
      name: 'profileIdentityUsernameEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `Use 3-30 lowercase letters or numbers. You can include dots or underscores in the middle.`
  String get profileIdentityUsernameFormatError {
    return Intl.message(
      'Use 3-30 lowercase letters or numbers. You can include dots or underscores in the middle.',
      name: 'profileIdentityUsernameFormatError',
      desc: '',
      args: [],
    );
  }

  /// `That username is already taken. Try a different one.`
  String get profileIdentityUsernameTakenError {
    return Intl.message(
      'That username is already taken. Try a different one.',
      name: 'profileIdentityUsernameTakenError',
      desc: '',
      args: [],
    );
  }

  /// `Pick an avatar`
  String get profileIdentityAvatarSectionTitle {
    return Intl.message(
      'Pick an avatar',
      name: 'profileIdentityAvatarSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Each avatar is unique inside your home.`
  String get profileIdentityAvatarSectionDescription {
    return Intl.message(
      'Each avatar is unique inside your home.',
      name: 'profileIdentityAvatarSectionDescription',
      desc: '',
      args: [],
    );
  }

  /// `No avatars are available right now. Try again soon.`
  String get profileIdentityAvatarEmpty {
    return Intl.message(
      'No avatars are available right now. Try again soon.',
      name: 'profileIdentityAvatarEmpty',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't load your profile right now.`
  String get profileIdentityLoadError {
    return Intl.message(
      'We couldn\'t load your profile right now.',
      name: 'profileIdentityLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get profileIdentityRetry {
    return Intl.message(
      'Retry',
      name: 'profileIdentityRetry',
      desc: '',
      args: [],
    );
  }

  /// `Save changes`
  String get profileIdentitySaveButton {
    return Intl.message(
      'Save changes',
      name: 'profileIdentitySaveButton',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated.`
  String get profileIdentitySuccessMessage {
    return Intl.message(
      'Profile updated.',
      name: 'profileIdentitySuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `your username`
  String get profileIdentityUsernamePreviewFallback {
    return Intl.message(
      'your username',
      name: 'profileIdentityUsernamePreviewFallback',
      desc: '',
      args: [],
    );
  }

  /// `Leave home`
  String get profileLeaveHomeTitle {
    return Intl.message(
      'Leave home',
      name: 'profileLeaveHomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Stop sharing with this home. Owners must transfer ownership first.`
  String get profileLeaveHomeSubtitle {
    return Intl.message(
      'Stop sharing with this home. Owners must transfer ownership first.',
      name: 'profileLeaveHomeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Checking your home members…`
  String get profileLeaveEligibilityLoading {
    return Intl.message(
      'Checking your home members…',
      name: 'profileLeaveEligibilityLoading',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't load your home members. Try again.`
  String get profileLeaveEligibilityError {
    return Intl.message(
      'We couldn\'t load your home members. Try again.',
      name: 'profileLeaveEligibilityError',
      desc: '',
      args: [],
    );
  }

  /// `You're the last member. Leaving will deactivate this home for everyone.`
  String get profileLeaveOwnerSoloMessage {
    return Intl.message(
      'You\'re the last member. Leaving will deactivate this home for everyone.',
      name: 'profileLeaveOwnerSoloMessage',
      desc: '',
      args: [],
    );
  }

  /// `No one else can take ownership right now. Try again later.`
  String get profileLeaveOwnerNoEligibleMembers {
    return Intl.message(
      'No one else can take ownership right now. Try again later.',
      name: 'profileLeaveOwnerNoEligibleMembers',
      desc: '',
      args: [],
    );
  }

  /// `Transfer ownership`
  String get profileLeaveTransferSheetTitle {
    return Intl.message(
      'Transfer ownership',
      name: 'profileLeaveTransferSheetTitle',
      desc: '',
      args: [],
    );
  }

  /// `Select who should become the new owner before you leave.`
  String get profileLeaveTransferSheetSubtitle {
    return Intl.message(
      'Select who should become the new owner before you leave.',
      name: 'profileLeaveTransferSheetSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Ownership transferred. Finishing your leave…`
  String get profileLeaveTransferSuccessMessage {
    return Intl.message(
      'Ownership transferred. Finishing your leave…',
      name: 'profileLeaveTransferSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Info Hub`
  String get profileInfoHubTitle {
    return Intl.message(
      'Info Hub',
      name: 'profileInfoHubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Open the Kinly Notion hub in-app.`
  String get profileInfoHubSubtitle {
    return Intl.message(
      'Open the Kinly Notion hub in-app.',
      name: 'profileInfoHubSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `The Info Hub couldn't load. Check your connection.`
  String get profileInfoHubLoadError {
    return Intl.message(
      'The Info Hub couldn\'t load. Check your connection.',
      name: 'profileInfoHubLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Contact us`
  String get profileContactUsTitle {
    return Intl.message(
      'Contact us',
      name: 'profileContactUsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Email support@makinglifeeasie.com`
  String get profileContactUsSubtitle {
    return Intl.message(
      'Email support@makinglifeeasie.com',
      name: 'profileContactUsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Contact us`
  String get profileContactEmailSubject {
    return Intl.message(
      'Contact us',
      name: 'profileContactEmailSubject',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't open your email app. Try again.`
  String get profileContactLaunchError {
    return Intl.message(
      'We couldn\'t open your email app. Try again.',
      name: 'profileContactLaunchError',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get profileLogoutTitle {
    return Intl.message(
      'Log out',
      name: 'profileLogoutTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign out of Kinly on this device.`
  String get profileLogoutSubtitle {
    return Intl.message(
      'Sign out of Kinly on this device.',
      name: 'profileLogoutSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign out?`
  String get profileLogoutDialogTitle {
    return Intl.message(
      'Sign out?',
      name: 'profileLogoutDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `You'll need to sign in again to access your home.`
  String get profileLogoutDialogMessage {
    return Intl.message(
      'You\'ll need to sign in again to access your home.',
      name: 'profileLogoutDialogMessage',
      desc: '',
      args: [],
    );
  }

  /// `Delete account`
  String get profileDeleteAccountTitle {
    return Intl.message(
      'Delete account',
      name: 'profileDeleteAccountTitle',
      desc: '',
      args: [],
    );
  }

  /// `Remove your Kinly account and profile data.`
  String get profileDeleteAccountSubtitle {
    return Intl.message(
      'Remove your Kinly account and profile data.',
      name: 'profileDeleteAccountSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Leave this home?`
  String get profileConfirmLeaveTitle {
    return Intl.message(
      'Leave this home?',
      name: 'profileConfirmLeaveTitle',
      desc: '',
      args: [],
    );
  }

  /// `You'll lose access to Flow, shared history, and invites.`
  String get profileConfirmLeaveMessage {
    return Intl.message(
      'You\'ll lose access to Flow, shared history, and invites.',
      name: 'profileConfirmLeaveMessage',
      desc: '',
      args: [],
    );
  }

  /// `Delete your account?`
  String get profileConfirmDeleteTitle {
    return Intl.message(
      'Delete your account?',
      name: 'profileConfirmDeleteTitle',
      desc: '',
      args: [],
    );
  }

  /// `This removes your account and signs you out. This cannot be undone.`
  String get profileConfirmDeleteMessage {
    return Intl.message(
      'This removes your account and signs you out. This cannot be undone.',
      name: 'profileConfirmDeleteMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get profileActionCancel {
    return Intl.message(
      'Cancel',
      name: 'profileActionCancel',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get profileActionConfirm {
    return Intl.message(
      'Continue',
      name: 'profileActionConfirm',
      desc: '',
      args: [],
    );
  }

  /// `You left your home.`
  String get profileLeaveSuccessMessage {
    return Intl.message(
      'You left your home.',
      name: 'profileLeaveSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Your account will be deleted shortly. We'll sign you out.`
  String get profileDeleteSuccessMessage {
    return Intl.message(
      'Your account will be deleted shortly. We\'ll sign you out.',
      name: 'profileDeleteSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong. Please try again.`
  String get profileGenericError {
    return Intl.message(
      'Something went wrong. Please try again.',
      name: 'profileGenericError',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't find your current home. Try again.`
  String get profileMissingHomeError {
    return Intl.message(
      'We couldn\'t find your current home. Try again.',
      name: 'profileMissingHomeError',
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
