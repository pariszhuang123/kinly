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

  /// `Starting Kinly ({env})`
  String bootstrap_initializing(String env) {
    return Intl.message(
      'Starting Kinly ($env)',
      name: 'bootstrap_initializing',
      desc: '',
      args: [env],
    );
  }

  /// `Hi {name}`
  String startReturningTitle(String name) {
    return Intl.message(
      'Hi $name',
      name: 'startReturningTitle',
      desc: 'Greeting shown on the Start screen for returning users.',
      args: [name],
    );
  }

  /// `What do you want to do?`
  String get startReturningSubtitle {
    return Intl.message(
      'What do you want to do?',
      name: 'startReturningSubtitle',
      desc: 'Follow-up prompt for returning users on the Start screen.',
      args: [],
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

  /// `Couldn't create the home.`
  String get create_failed_generic {
    return Intl.message(
      'Couldn\'t create the home.',
      name: 'create_failed_generic',
      desc: '',
      args: [],
    );
  }

  /// `Join Home`
  String get join_title {
    return Intl.message('Join Home', name: 'join_title', desc: '', args: []);
  }

  /// `Enter invite code (e.g. ABC123)`
  String get join_hint {
    return Intl.message(
      'Enter invite code (e.g. ABC123)',
      name: 'join_hint',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get join_submit {
    return Intl.message('Join', name: 'join_submit', desc: '', args: []);
  }

  /// `Joined your home.`
  String join_success(String code) {
    return Intl.message(
      'Joined your home.',
      name: 'join_success',
      desc: 'Snackbar message displayed when the user joins successfully',
      args: [code],
    );
  }

  /// `Couldn't join this home.`
  String get join_failed_generic {
    return Intl.message(
      'Couldn\'t join this home.',
      name: 'join_failed_generic',
      desc: '',
      args: [],
    );
  }

  /// `That invite code looks wrong.`
  String get join_error_invalid_code {
    return Intl.message(
      'That invite code looks wrong.',
      name: 'join_error_invalid_code',
      desc: '',
      args: [],
    );
  }

  /// `That invite has expired. Ask the owner for a new one.`
  String get join_error_inactive_invite {
    return Intl.message(
      'That invite has expired. Ask the owner for a new one.',
      name: 'join_error_inactive_invite',
      desc: '',
      args: [],
    );
  }

  /// `Leave your current home first.`
  String get join_error_already_in_other_home {
    return Intl.message(
      'Leave your current home first.',
      name: 'join_error_already_in_other_home',
      desc: '',
      args: [],
    );
  }

  /// `This home has reached its member limit. Ask the owner to upgrade or remove someone.`
  String get join_error_paywall_limit {
    return Intl.message(
      'This home has reached its member limit. Ask the owner to upgrade or remove someone.',
      name: 'join_error_paywall_limit',
      desc: '',
      args: [],
    );
  }

  /// `Keep your home running smoothly`
  String get paywallTitle {
    return Intl.message(
      'Keep your home running smoothly',
      name: 'paywallTitle',
      desc: '',
      args: [],
    );
  }

  /// `Less than 0.5% of your rent.`
  String get paywallSubtitle {
    return Intl.message(
      'Less than 0.5% of your rent.',
      name: 'paywallSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `One home plan. No hidden tiers.`
  String get paywallPriceCaption {
    return Intl.message(
      'One home plan. No hidden tiers.',
      name: 'paywallPriceCaption',
      desc: '',
      args: [],
    );
  }

  /// `{price} per month`
  String paywallPricePerMonth(String price) {
    return Intl.message(
      '$price per month',
      name: 'paywallPricePerMonth',
      desc: '',
      args: [price],
    );
  }

  /// `Pricing isn't available right now.`
  String get paywallPriceUnavailable {
    return Intl.message(
      'Pricing isn\'t available right now.',
      name: 'paywallPriceUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited members`
  String get paywallBulletMembers {
    return Intl.message(
      'Unlimited members',
      name: 'paywallBulletMembers',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited tasks`
  String get paywallBulletFlows {
    return Intl.message(
      'Unlimited tasks',
      name: 'paywallBulletFlows',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited task photos`
  String get paywallBulletPhotos {
    return Intl.message(
      'Unlimited task photos',
      name: 'paywallBulletPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited bill photos`
  String get paywallFeatureUnlimitedSharedExpensePhotos {
    return Intl.message(
      'Unlimited bill photos',
      name: 'paywallFeatureUnlimitedSharedExpensePhotos',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited shopping photos`
  String get paywallBulletShoppingPhotos {
    return Intl.message(
      'Unlimited shopping photos',
      name: 'paywallBulletShoppingPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited bills`
  String get paywallBulletShares {
    return Intl.message(
      'Unlimited bills',
      name: 'paywallBulletShares',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade to Premium`
  String get paywallPrimaryCta {
    return Intl.message(
      'Upgrade to Premium',
      name: 'paywallPrimaryCta',
      desc: '',
      args: [],
    );
  }

  /// `Stay on free plan`
  String get paywallSecondaryCta {
    return Intl.message(
      'Stay on free plan',
      name: 'paywallSecondaryCta',
      desc: '',
      args: [],
    );
  }

  /// `Purchase not completed.`
  String get paywallPurchaseFailed {
    return Intl.message(
      'Purchase not completed.',
      name: 'paywallPurchaseFailed',
      desc: '',
      args: [],
    );
  }

  /// `You're now on Kinly Premium.`
  String get paywallPurchaseSuccess {
    return Intl.message(
      'You\'re now on Kinly Premium.',
      name: 'paywallPurchaseSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Restore purchases`
  String get paywallRestoreCta {
    return Intl.message(
      'Restore purchases',
      name: 'paywallRestoreCta',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load paywall.`
  String get paywallErrorTitle {
    return Intl.message(
      'Couldn\'t load paywall.',
      name: 'paywallErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get paywallRetryLabel {
    return Intl.message('Retry', name: 'paywallRetryLabel', desc: '', args: []);
  }

  /// `Sign in to join this home.`
  String get join_error_unauthorized {
    return Intl.message(
      'Sign in to join this home.',
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

  /// `This home isn't accepting new members right now`
  String get join_blocked_title {
    return Intl.message(
      'This home isn\'t accepting new members right now',
      name: 'join_blocked_title',
      desc: '',
      args: [],
    );
  }

  /// `We've notified the home owner.`
  String get join_blocked_body {
    return Intl.message(
      'We\'ve notified the home owner.',
      name: 'join_blocked_body',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get join_blocked_cta {
    return Intl.message('Done', name: 'join_blocked_cta', desc: '', args: []);
  }

  /// `Someone wants to join your home`
  String get todayMemberCapTitle {
    return Intl.message(
      'Someone wants to join your home',
      name: 'todayMemberCapTitle',
      desc: '',
      args: [],
    );
  }

  /// `{names} wants to join your home. Upgrade for more members.`
  String todayMemberCapSubtitle(String names) {
    return Intl.message(
      '$names wants to join your home. Upgrade for more members.',
      name: 'todayMemberCapSubtitle',
      desc: '',
      args: [names],
    );
  }

  /// `Upgrade to add more people.`
  String get todayMemberCapSubtitleGeneric {
    return Intl.message(
      'Upgrade to add more people.',
      name: 'todayMemberCapSubtitleGeneric',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade home`
  String get todayMemberCapPrimaryCta {
    return Intl.message(
      'Upgrade home',
      name: 'todayMemberCapPrimaryCta',
      desc: '',
      args: [],
    );
  }

  /// `Ignore`
  String get todayMemberCapSecondaryCta {
    return Intl.message(
      'Ignore',
      name: 'todayMemberCapSecondaryCta',
      desc: '',
      args: [],
    );
  }

  /// `{name} joined your home.`
  String todayMemberCapResolutionJoined(String name) {
    return Intl.message(
      '$name joined your home.',
      name: 'todayMemberCapResolutionJoined',
      desc: '',
      args: [name],
    );
  }

  /// `{name} joined another home.`
  String todayMemberCapResolutionSuperseded(String name) {
    return Intl.message(
      '$name joined another home.',
      name: 'todayMemberCapResolutionSuperseded',
      desc: '',
      args: [name],
    );
  }

  /// `Couldn't complete {name}'s request.`
  String todayMemberCapResolutionFailed(String name) {
    return Intl.message(
      'Couldn\'t complete $name\'s request.',
      name: 'todayMemberCapResolutionFailed',
      desc: '',
      args: [name],
    );
  }

  /// `Someone`
  String get todayMemberCapResolutionUnknownName {
    return Intl.message(
      'Someone',
      name: 'todayMemberCapResolutionUnknownName',
      desc: '',
      args: [],
    );
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

  /// `Task`
  String get quick_add_flow_title {
    return Intl.message(
      'Task',
      name: 'quick_add_flow_title',
      desc: '',
      args: [],
    );
  }

  /// `Create a task`
  String get quick_add_flow_subtitle {
    return Intl.message(
      'Create a task',
      name: 'quick_add_flow_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Bill`
  String get quick_add_share_title {
    return Intl.message(
      'Bill',
      name: 'quick_add_share_title',
      desc: '',
      args: [],
    );
  }

  /// `Add a bill`
  String get quick_add_share_subtitle {
    return Intl.message(
      'Add a bill',
      name: 'quick_add_share_subtitle',
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

  /// `Add Task`
  String get todayAddSheetFlow {
    return Intl.message(
      'Add Task',
      name: 'todayAddSheetFlow',
      desc: '',
      args: [],
    );
  }

  /// `Add Bill`
  String get todayAddSheetShare {
    return Intl.message(
      'Add Bill',
      name: 'todayAddSheetShare',
      desc: '',
      args: [],
    );
  }

  /// `Add Shopping Item`
  String get todayAddSheetShopping {
    return Intl.message(
      'Add Shopping Item',
      name: 'todayAddSheetShopping',
      desc: '',
      args: [],
    );
  }

  /// `Shopping list`
  String get shoppingCardTitle {
    return Intl.message(
      'Shopping list',
      name: 'shoppingCardTitle',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, one {{count} item to buy} other {{count} items to buy}}`
  String shoppingCardSubtitle(int count) {
    return Intl.plural(
      count,
      one: '$count item to buy',
      other: '$count items to buy',
      name: 'shoppingCardSubtitle',
      desc: '',
      args: [count],
    );
  }

  /// `Shopping list`
  String get shoppingListTitle {
    return Intl.message(
      'Shopping list',
      name: 'shoppingListTitle',
      desc: '',
      args: [],
    );
  }

  /// `Shopping item`
  String get shoppingDetailTitle {
    return Intl.message(
      'Shopping item',
      name: 'shoppingDetailTitle',
      desc: '',
      args: [],
    );
  }

  /// `Mark bought`
  String get shoppingMarkCompleteCta {
    return Intl.message(
      'Mark bought',
      name: 'shoppingMarkCompleteCta',
      desc: '',
      args: [],
    );
  }

  /// `To buy`
  String get shoppingTabPending {
    return Intl.message(
      'To buy',
      name: 'shoppingTabPending',
      desc: '',
      args: [],
    );
  }

  /// `Everything bought`
  String get shoppingAllItemsBought {
    return Intl.message(
      'Everything bought',
      name: 'shoppingAllItemsBought',
      desc: '',
      args: [],
    );
  }

  /// `No shopping items.`
  String get shoppingEmptyTitle {
    return Intl.message(
      'No shopping items.',
      name: 'shoppingEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add shopping item`
  String get shoppingCreateTitle {
    return Intl.message(
      'Add shopping item',
      name: 'shoppingCreateTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit shopping item`
  String get shoppingEditTitle {
    return Intl.message(
      'Edit shopping item',
      name: 'shoppingEditTitle',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get shoppingNameLabel {
    return Intl.message('Name', name: 'shoppingNameLabel', desc: '', args: []);
  }

  /// `e.g. Milk`
  String get shoppingNameHint {
    return Intl.message(
      'e.g. Milk',
      name: 'shoppingNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get shoppingAmountLabel {
    return Intl.message(
      'Amount',
      name: 'shoppingAmountLabel',
      desc: '',
      args: [],
    );
  }

  /// `e.g. 2 cartons`
  String get shoppingAmountHint {
    return Intl.message(
      'e.g. 2 cartons',
      name: 'shoppingAmountHint',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get shoppingContextLabel {
    return Intl.message(
      'Notes',
      name: 'shoppingContextLabel',
      desc: '',
      args: [],
    );
  }

  /// `Brand, size, or notes`
  String get shoppingContextHint {
    return Intl.message(
      'Brand, size, or notes',
      name: 'shoppingContextHint',
      desc: '',
      args: [],
    );
  }

  /// `Add photo`
  String get shoppingPhotoLabel {
    return Intl.message(
      'Add photo',
      name: 'shoppingPhotoLabel',
      desc: '',
      args: [],
    );
  }

  /// `Help others buy the right item`
  String get shoppingPhotoReplaceLabel {
    return Intl.message(
      'Help others buy the right item',
      name: 'shoppingPhotoReplaceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add a photo`
  String get shoppingPhotoPlaceholder {
    return Intl.message(
      'Add a photo',
      name: 'shoppingPhotoPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Enter an item name.`
  String get shoppingValidationName {
    return Intl.message(
      'Enter an item name.',
      name: 'shoppingValidationName',
      desc: '',
      args: [],
    );
  }

  /// `Add item`
  String get shoppingSubmitAdd {
    return Intl.message(
      'Add item',
      name: 'shoppingSubmitAdd',
      desc: '',
      args: [],
    );
  }

  /// `Save changes`
  String get shoppingSubmitEdit {
    return Intl.message(
      'Save changes',
      name: 'shoppingSubmitEdit',
      desc: '',
      args: [],
    );
  }

  /// `Delete item`
  String get shoppingDelete {
    return Intl.message(
      'Delete item',
      name: 'shoppingDelete',
      desc: '',
      args: [],
    );
  }

  /// `Delete this item?`
  String get shoppingDeleteConfirmTitle {
    return Intl.message(
      'Delete this item?',
      name: 'shoppingDeleteConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `This removes it from the shared shopping list.`
  String get shoppingDeleteConfirmBody {
    return Intl.message(
      'This removes it from the shared shopping list.',
      name: 'shoppingDeleteConfirmBody',
      desc: '',
      args: [],
    );
  }

  /// `Someone already marked this bought.`
  String get shoppingErrorItemAlreadyCompletedByOther {
    return Intl.message(
      'Someone already marked this bought.',
      name: 'shoppingErrorItemAlreadyCompletedByOther',
      desc: '',
      args: [],
    );
  }

  /// `Bought items`
  String get shoppingArchiveCta {
    return Intl.message(
      'Bought items',
      name: 'shoppingArchiveCta',
      desc: '',
      args: [],
    );
  }

  /// `Create bill?`
  String get shoppingArchiveSharePromptTitle {
    return Intl.message(
      'Create bill?',
      name: 'shoppingArchiveSharePromptTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create a draft bill from these items?`
  String get shoppingArchiveSharePromptBody {
    return Intl.message(
      'Create a draft bill from these items?',
      name: 'shoppingArchiveSharePromptBody',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get shoppingArchiveShareYes {
    return Intl.message(
      'Yes',
      name: 'shoppingArchiveShareYes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get shoppingArchiveShareNo {
    return Intl.message(
      'No',
      name: 'shoppingArchiveShareNo',
      desc: '',
      args: [],
    );
  }

  /// `Items marked bought and removed`
  String get shoppingArchiveItemsBought {
    return Intl.message(
      'Items marked bought and removed',
      name: 'shoppingArchiveItemsBought',
      desc: '',
      args: [],
    );
  }

  /// `Draft bill created`
  String get shoppingArchiveDraftBillCreated {
    return Intl.message(
      'Draft bill created',
      name: 'shoppingArchiveDraftBillCreated',
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

  /// `I agree to the `
  String get login_consent_prefix {
    return Intl.message(
      'I agree to the ',
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

  /// `Connecting to your home...`
  String get membership_status_checking {
    return Intl.message(
      'Connecting to your home...',
      name: 'membership_status_checking',
      desc: '',
      args: [],
    );
  }

  /// `Create or join a home.`
  String get membership_status_none {
    return Intl.message(
      'Create or join a home.',
      name: 'membership_status_none',
      desc: '',
      args: [],
    );
  }

  /// `You're connected to a home.`
  String get membership_status_active {
    return Intl.message(
      'You\'re connected to a home.',
      name: 'membership_status_active',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't refresh your home membership.`
  String get authMembershipLoadFailed {
    return Intl.message(
      'Couldn\'t refresh your home membership.',
      name: 'authMembershipLoadFailed',
      desc: '',
      args: [],
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

  /// `No internet connection. Try again.`
  String get offline_body {
    return Intl.message(
      'No internet connection. Try again.',
      name: 'offline_body',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get offline_retry {
    return Intl.message('Try again', name: 'offline_retry', desc: '', args: []);
  }

  /// `Update needed`
  String get force_update_title {
    return Intl.message(
      'Update needed',
      name: 'force_update_title',
      desc: '',
      args: [],
    );
  }

  /// `This version of Kinly is no longer supported. Update to continue.`
  String get force_update_body {
    return Intl.message(
      'This version of Kinly is no longer supported. Update to continue.',
      name: 'force_update_body',
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

  /// `Today`
  String get navToday {
    return Intl.message('Today', name: 'navToday', desc: '', args: []);
  }

  /// `Manage`
  String get navExplore {
    return Intl.message('Manage', name: 'navExplore', desc: '', args: []);
  }

  /// `Home Hub`
  String get navHub {
    return Intl.message('Home Hub', name: 'navHub', desc: '', args: []);
  }

  /// `No active members yet.`
  String get hubMembersEmpty {
    return Intl.message(
      'No active members yet.',
      name: 'hubMembersEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Invite`
  String get hubInviteCta {
    return Intl.message('Invite', name: 'hubInviteCta', desc: '', args: []);
  }

  /// `Couldn't load invite.`
  String get hubInviteUnavailable {
    return Intl.message(
      'Couldn\'t load invite.',
      name: 'hubInviteUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Invite to my Kinly home`
  String get hubShareInviteTitle {
    return Intl.message(
      'Invite to my Kinly home',
      name: 'hubShareInviteTitle',
      desc: '',
      args: [],
    );
  }

  /// `Join our Kinly home with this invite code: {code}\n\nDownload Kinly: {link}`
  String hubShareInviteBody(String code, String link) {
    return Intl.message(
      'Join our Kinly home with this invite code: $code\n\nDownload Kinly: $link',
      name: 'hubShareInviteBody',
      desc: '',
      args: [code, link],
    );
  }

  /// `Get Kinly`
  String get hubShareAppTitle {
    return Intl.message(
      'Get Kinly',
      name: 'hubShareAppTitle',
      desc: '',
      args: [],
    );
  }

  /// `Make shared living easier with Kinly: {link}`
  String hubShareAppBody(String link) {
    return Intl.message(
      'Make shared living easier with Kinly: $link',
      name: 'hubShareAppBody',
      desc: '',
      args: [link],
    );
  }

  /// `Share Kinly`
  String get hubShareAppCta {
    return Intl.message(
      'Share Kinly',
      name: 'hubShareAppCta',
      desc: '',
      args: [],
    );
  }

  /// `Invite your flatmates`
  String get todayFlatmateInviteTitle {
    return Intl.message(
      'Invite your flatmates',
      name: 'todayFlatmateInviteTitle',
      desc: '',
      args: [],
    );
  }

  /// `Stay aligned and share responsibilities.`
  String get todayFlatmateInviteSubtitle {
    return Intl.message(
      'Stay aligned and share responsibilities.',
      name: 'todayFlatmateInviteSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Invite friends to Kinly`
  String get todayInviteFriendsTitle {
    return Intl.message(
      'Invite friends to Kinly',
      name: 'todayInviteFriendsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Share Kinly with friends.`
  String get todayInviteFriendsSubtitle {
    return Intl.message(
      'Share Kinly with friends.',
      name: 'todayInviteFriendsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Share invite`
  String get todayInviteShareCta {
    return Intl.message(
      'Share invite',
      name: 'todayInviteShareCta',
      desc: '',
      args: [],
    );
  }

  /// `Not now`
  String get todayInviteNotNow {
    return Intl.message(
      'Not now',
      name: 'todayInviteNotNow',
      desc: '',
      args: [],
    );
  }

  /// `Invite code copied`
  String get hubCodeCopied {
    return Intl.message(
      'Invite code copied',
      name: 'hubCodeCopied',
      desc: '',
      args: [],
    );
  }

  /// `Rotate invite`
  String get hubRotateInvite {
    return Intl.message(
      'Rotate invite',
      name: 'hubRotateInvite',
      desc: '',
      args: [],
    );
  }

  /// `Invite rotated`
  String get hubRotateSuccess {
    return Intl.message(
      'Invite rotated',
      name: 'hubRotateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't rotate invite.`
  String get hubRotateError {
    return Intl.message(
      'Couldn\'t rotate invite.',
      name: 'hubRotateError',
      desc: '',
      args: [],
    );
  }

  /// `Share the app`
  String get hubQrTitle {
    return Intl.message(
      'Share the app',
      name: 'hubQrTitle',
      desc: '',
      args: [],
    );
  }

  /// `Scan to download Kinly`
  String get hubQrSubtitle {
    return Intl.message(
      'Scan to download Kinly',
      name: 'hubQrSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Shoutouts`
  String get hubCardGratitudeWallTitle {
    return Intl.message(
      'Shoutouts',
      name: 'hubCardGratitudeWallTitle',
      desc: '',
      args: [],
    );
  }

  /// `Quick thanks from your home.`
  String get hubCardGratitudeWallSubtitle {
    return Intl.message(
      'Quick thanks from your home.',
      name: 'hubCardGratitudeWallSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Preferences`
  String get hubPreferencesTitle {
    return Intl.message(
      'Preferences',
      name: 'hubPreferencesTitle',
      desc: '',
      args: [],
    );
  }

  /// `How each person likes shared living to work.`
  String get hubPreferencesSubtitle {
    return Intl.message(
      'How each person likes shared living to work.',
      name: 'hubPreferencesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Home Vibe`
  String get homeVibeTitle {
    return Intl.message('Home Vibe', name: 'homeVibeTitle', desc: '', args: []);
  }

  /// `Based on {answered} of {total, plural, one{{total} member} other{{total} members}}`
  String homeVibeCoverage(int answered, int total) {
    return Intl.message(
      'Based on $answered of ${Intl.plural(total, one: '$total member', other: '$total members')}',
      name: 'homeVibeCoverage',
      desc: '',
      args: [answered, total],
    );
  }

  /// `Home vibe`
  String get houseVibeShareTitle {
    return Intl.message(
      'Home vibe',
      name: 'houseVibeShareTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sharing our Kinly home vibe. Download the app: {link}`
  String houseVibeShareMessage(String link) {
    return Intl.message(
      'Sharing our Kinly home vibe. Download the app: $link',
      name: 'houseVibeShareMessage',
      desc: '',
      args: [link],
    );
  }

  /// `Couldn't share right now.`
  String get houseVibeShareError {
    return Intl.message(
      'Couldn\'t share right now.',
      name: 'houseVibeShareError',
      desc: '',
      args: [],
    );
  }

  /// `Share vibe`
  String get houseVibeShareCta {
    return Intl.message(
      'Share vibe',
      name: 'houseVibeShareCta',
      desc: '',
      args: [],
    );
  }

  /// `Not enough data yet`
  String get vibeInsufficientTitle {
    return Intl.message(
      'Not enough data yet',
      name: 'vibeInsufficientTitle',
      desc: '',
      args: [],
    );
  }

  /// `Complete preferences to see your home vibe.`
  String get vibeInsufficientSummary {
    return Intl.message(
      'Complete preferences to see your home vibe.',
      name: 'vibeInsufficientSummary',
      desc: '',
      args: [],
    );
  }

  /// `Mixed home`
  String get vibeMixedTitle {
    return Intl.message(
      'Mixed home',
      name: 'vibeMixedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your home has mixed living styles.`
  String get vibeMixedSummary {
    return Intl.message(
      'Your home has mixed living styles.',
      name: 'vibeMixedSummary',
      desc: '',
      args: [],
    );
  }

  /// `Balanced home`
  String get vibeDefaultTitle {
    return Intl.message(
      'Balanced home',
      name: 'vibeDefaultTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your home feels balanced.`
  String get vibeDefaultSummary {
    return Intl.message(
      'Your home feels balanced.',
      name: 'vibeDefaultSummary',
      desc: '',
      args: [],
    );
  }

  /// `Quiet care`
  String get vibeQuietCareTitle {
    return Intl.message(
      'Quiet care',
      name: 'vibeQuietCareTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your home feels calm and gentle.`
  String get vibeQuietCareSummary {
    return Intl.message(
      'Your home feels calm and gentle.',
      name: 'vibeQuietCareSummary',
      desc: '',
      args: [],
    );
  }

  /// `Social energy`
  String get vibeSocialTitle {
    return Intl.message(
      'Social energy',
      name: 'vibeSocialTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your home feels active and social.`
  String get vibeSocialSummary {
    return Intl.message(
      'Your home feels active and social.',
      name: 'vibeSocialSummary',
      desc: '',
      args: [],
    );
  }

  /// `Warm social`
  String get vibeWarmSocialTitle {
    return Intl.message(
      'Warm social',
      name: 'vibeWarmSocialTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your home feels warm and welcoming.`
  String get vibeWarmSocialSummary {
    return Intl.message(
      'Your home feels warm and welcoming.',
      name: 'vibeWarmSocialSummary',
      desc: '',
      args: [],
    );
  }

  /// `Cozy social`
  String get vibeCozySocialTitle {
    return Intl.message(
      'Cozy social',
      name: 'vibeCozySocialTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your home feels cozy and calm together.`
  String get vibeCozySocialSummary {
    return Intl.message(
      'Your home feels cozy and calm together.',
      name: 'vibeCozySocialSummary',
      desc: '',
      args: [],
    );
  }

  /// `Steady calm`
  String get vibeSteadyTitle {
    return Intl.message(
      'Steady calm',
      name: 'vibeSteadyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your home feels steady and consistent.`
  String get vibeSteadySummary {
    return Intl.message(
      'Your home feels steady and consistent.',
      name: 'vibeSteadySummary',
      desc: '',
      args: [],
    );
  }

  /// `Structured rhythm`
  String get vibeStructuredTitle {
    return Intl.message(
      'Structured rhythm',
      name: 'vibeStructuredTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your home works best with routines and plans.`
  String get vibeStructuredSummary {
    return Intl.message(
      'Your home works best with routines and plans.',
      name: 'vibeStructuredSummary',
      desc: '',
      args: [],
    );
  }

  /// `Easygoing flow`
  String get vibeEasygoingTitle {
    return Intl.message(
      'Easygoing flow',
      name: 'vibeEasygoingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your home feels relaxed and flexible.`
  String get vibeEasygoingSummary {
    return Intl.message(
      'Your home feels relaxed and flexible.',
      name: 'vibeEasygoingSummary',
      desc: '',
      args: [],
    );
  }

  /// `Independent calm`
  String get vibeIndependentTitle {
    return Intl.message(
      'Independent calm',
      name: 'vibeIndependentTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your home values space and quiet.`
  String get vibeIndependentSummary {
    return Intl.message(
      'Your home values space and quiet.',
      name: 'vibeIndependentSummary',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load Home Hub.`
  String get hubError {
    return Intl.message(
      'Couldn\'t load Home Hub.',
      name: 'hubError',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get hubRetry {
    return Intl.message('Retry', name: 'hubRetry', desc: '', args: []);
  }

  /// `All caught up`
  String get todayEmptyCardTitle {
    return Intl.message(
      'All caught up',
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

  /// `Nothing needs your attention right now.`
  String get todayEmptyBody {
    return Intl.message(
      'Nothing needs your attention right now.',
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

  /// `{partOfDay, select, morning{Good morning, {name}} afternoon{Good afternoon, {name}} evening{Good evening, {name}} other{Hi, {name}}}`
  String greetingPartOfDay(
    String partOfDay,
    String Good,
    String Hi,
    String name,
  ) {
    return Intl.select(
      partOfDay,
      {
        'morning': 'Good morning, $name',
        'afternoon': 'Good afternoon, $name',
        'evening': 'Good evening, $name',
        'other': 'Hi, $name',
      },
      name: 'greetingPartOfDay',
      desc: '',
      args: [partOfDay, Good, Hi, name],
    );
  }

  /// `Here's what needs attention today.`
  String get todayFlowSubtitle {
    return Intl.message(
      'Here\'s what needs attention today.',
      name: 'todayFlowSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Tasks`
  String get todayFlowSectionTitle {
    return Intl.message(
      'Tasks',
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

  /// `See all {count, plural, one {(#)} other {(#)}}`
  String todayFlowSeeAll(int count) {
    return Intl.message(
      'See all ${Intl.plural(count, one: '(#)', other: '(#)')}',
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

  /// `Bills`
  String get todayShareSectionTitle {
    return Intl.message(
      'Bills',
      name: 'todayShareSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `To settle`
  String get todayShareTabActive {
    return Intl.message(
      'To settle',
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

  /// `Settled`
  String get todayShareTabPaidToMe {
    return Intl.message(
      'Settled',
      name: 'todayShareTabPaidToMe',
      desc: '',
      args: [],
    );
  }

  /// `Settled amount`
  String get todaySharePaidSubtitle {
    return Intl.message(
      'Settled amount',
      name: 'todaySharePaidSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, one {{count} new payment to you} other {{count} new payments to you}}`
  String todaySharePaidUnseen(int count) {
    return Intl.plural(
      count,
      one: '$count new payment to you',
      other: '$count new payments to you',
      name: 'todaySharePaidUnseen',
      desc:
          'Subtitle shown for paid-to-me entries when there are unseen items.',
      args: [count],
    );
  }

  /// `Couldn't refresh bills right now.`
  String get todayShareError {
    return Intl.message(
      'Couldn\'t refresh bills right now.',
      name: 'todayShareError',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, one {{count} payment pending} other {{count} to settle}}`
  String todayShareActiveSubtitle(int count) {
    return Intl.plural(
      count,
      one: '$count payment pending',
      other: '$count to settle',
      name: 'todayShareActiveSubtitle',
      desc: '',
      args: [count],
    );
  }

  /// `Shoutouts`
  String get todayGratitudeSectionTitle {
    return Intl.message(
      'Shoutouts',
      name: 'todayGratitudeSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `New shoutouts are waiting for you.`
  String get todayGratitudeUnreadBody {
    return Intl.message(
      'New shoutouts are waiting for you.',
      name: 'todayGratitudeUnreadBody',
      desc: '',
      args: [],
    );
  }

  /// `To settle`
  String get shareOwedDetailTitle {
    return Intl.message(
      'To settle',
      name: 'shareOwedDetailTitle',
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

  /// `Mark as settled`
  String get shareOwedDetailPaid {
    return Intl.message(
      'Mark as settled',
      name: 'shareOwedDetailPaid',
      desc: '',
      args: [],
    );
  }

  /// `Marked settled.`
  String get shareOwedDetailSuccess {
    return Intl.message(
      'Marked settled.',
      name: 'shareOwedDetailSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't mark this payment as settled.`
  String get shareOwedDetailError {
    return Intl.message(
      'Couldn\'t mark this payment as settled.',
      name: 'shareOwedDetailError',
      desc: '',
      args: [],
    );
  }

  /// `Acknowledge receipt`
  String get sharePaidDetailAcknowledge {
    return Intl.message(
      'Acknowledge receipt',
      name: 'sharePaidDetailAcknowledge',
      desc: '',
      args: [],
    );
  }

  /// `Acknowledging...`
  String get sharePaidDetailAcknowledging {
    return Intl.message(
      'Acknowledging...',
      name: 'sharePaidDetailAcknowledging',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't acknowledge this payment.`
  String get sharePaidDetailAcknowledgeError {
    return Intl.message(
      'Couldn\'t acknowledge this payment.',
      name: 'sharePaidDetailAcknowledgeError',
      desc: '',
      args: [],
    );
  }

  /// `Edit Bill`
  String get shareEditTitle {
    return Intl.message(
      'Edit Bill',
      name: 'shareEditTitle',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get shareEditSubmit {
    return Intl.message('Update', name: 'shareEditSubmit', desc: '', args: []);
  }

  /// `Bill updated.`
  String get shareEditSuccess {
    return Intl.message(
      'Bill updated.',
      name: 'shareEditSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load that draft.`
  String get shareEditLoadError {
    return Intl.message(
      'Couldn\'t load that draft.',
      name: 'shareEditLoadError',
      desc: '',
      args: [],
    );
  }

  /// `This stays locked until someone takes this bill.`
  String get shareEditNotAllowed {
    return Intl.message(
      'This stays locked until someone takes this bill.',
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

  /// `Delete bill?`
  String get shareEditDeleteConfirmTitle {
    return Intl.message(
      'Delete bill?',
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

  /// `Delete`
  String get shareEditDeleteConfirm {
    return Intl.message(
      'Delete',
      name: 'shareEditDeleteConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't delete bill.`
  String get shareEditDeleteError {
    return Intl.message(
      'Couldn\'t delete bill.',
      name: 'shareEditDeleteError',
      desc: '',
      args: [],
    );
  }

  /// `Bill deleted.`
  String get shareEditDeleteSuccess {
    return Intl.message(
      'Bill deleted.',
      name: 'shareEditDeleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Plan ended.`
  String get shareEditTerminateSuccess {
    return Intl.message(
      'Plan ended.',
      name: 'shareEditTerminateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `End plan`
  String get shareEditTerminatePlan {
    return Intl.message(
      'End plan',
      name: 'shareEditTerminatePlan',
      desc: '',
      args: [],
    );
  }

  /// `Ending...`
  String get shareEditTerminatePlanBusy {
    return Intl.message(
      'Ending...',
      name: 'shareEditTerminatePlanBusy',
      desc: '',
      args: [],
    );
  }

  /// `End recurring plan?`
  String get shareEditTerminatePlanTitle {
    return Intl.message(
      'End recurring plan?',
      name: 'shareEditTerminatePlanTitle',
      desc: '',
      args: [],
    );
  }

  /// `This stops future bill cycles.`
  String get shareEditTerminatePlanMessage {
    return Intl.message(
      'This stops future bill cycles.',
      name: 'shareEditTerminatePlanMessage',
      desc: '',
      args: [],
    );
  }

  /// `End plan`
  String get shareEditTerminatePlanConfirm {
    return Intl.message(
      'End plan',
      name: 'shareEditTerminatePlanConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't end the plan.`
  String get shareEditTerminateError {
    return Intl.message(
      'Couldn\'t end the plan.',
      name: 'shareEditTerminateError',
      desc: '',
      args: [],
    );
  }

  /// `This bill is now a plan and is not editable here.`
  String get shareEditDisabledConverted {
    return Intl.message(
      'This bill is now a plan and is not editable here.',
      name: 'shareEditDisabledConverted',
      desc: '',
      args: [],
    );
  }

  /// `Recurring cycles are not editable here.`
  String get shareEditDisabledRecurringCycle {
    return Intl.message(
      'Recurring cycles are not editable here.',
      name: 'shareEditDisabledRecurringCycle',
      desc: '',
      args: [],
    );
  }

  /// `Active bills are not editable.`
  String get shareEditDisabledActive {
    return Intl.message(
      'Active bills are not editable.',
      name: 'shareEditDisabledActive',
      desc: '',
      args: [],
    );
  }

  /// `This bill is not editable right now.`
  String get shareEditDisabledGeneric {
    return Intl.message(
      'This bill is not editable right now.',
      name: 'shareEditDisabledGeneric',
      desc: '',
      args: [],
    );
  }

  /// `Add Bill`
  String get shareCreateTitle {
    return Intl.message(
      'Add Bill',
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

  /// `How do you want to split this?`
  String get shareCreateSplitLabel {
    return Intl.message(
      'How do you want to split this?',
      name: 'shareCreateSplitLabel',
      desc: '',
      args: [],
    );
  }

  /// `Split evenly`
  String get shareCreateSplitEqual {
    return Intl.message(
      'Split evenly',
      name: 'shareCreateSplitEqual',
      desc: '',
      args: [],
    );
  }

  /// `Choose amounts`
  String get shareCreateSplitCustom {
    return Intl.message(
      'Choose amounts',
      name: 'shareCreateSplitCustom',
      desc: '',
      args: [],
    );
  }

  /// `You need at least two home members to share a bill.`
  String get shareCreateParticipantsEmpty {
    return Intl.message(
      'You need at least two home members to share a bill.',
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

  /// `Optional note everyone can see`
  String get shareCreateNotesHint {
    return Intl.message(
      'Optional note everyone can see',
      name: 'shareCreateNotesHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter each person's share. Total equals the amount above.`
  String get shareCreateCustomHelper {
    return Intl.message(
      'Enter each person\'s share. Total equals the amount above.',
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

  /// `When does this apply?`
  String get shareCreateStartLabel {
    return Intl.message(
      'When does this apply?',
      name: 'shareCreateStartLabel',
      desc: '',
      args: [],
    );
  }

  /// `Applies to {period}`
  String shareCreateCyclePeriod(String period) {
    return Intl.message(
      'Applies to $period',
      name: 'shareCreateCyclePeriod',
      desc: '',
      args: [period],
    );
  }

  /// `Repeat`
  String get shareCreateRecurrenceLabel {
    return Intl.message(
      'Repeat',
      name: 'shareCreateRecurrenceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Recurring`
  String get shareCreateRecurrenceToggleLabel {
    return Intl.message(
      'Recurring',
      name: 'shareCreateRecurrenceToggleLabel',
      desc: '',
      args: [],
    );
  }

  /// `Every`
  String get shareCreateRecurrenceEveryLabel {
    return Intl.message(
      'Every',
      name: 'shareCreateRecurrenceEveryLabel',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get shareCreateRecurrenceUnitDay {
    return Intl.message(
      'Day',
      name: 'shareCreateRecurrenceUnitDay',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get shareCreateRecurrenceUnitWeek {
    return Intl.message(
      'Week',
      name: 'shareCreateRecurrenceUnitWeek',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get shareCreateRecurrenceUnitMonth {
    return Intl.message(
      'Month',
      name: 'shareCreateRecurrenceUnitMonth',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get shareCreateRecurrenceUnitYear {
    return Intl.message(
      'Year',
      name: 'shareCreateRecurrenceUnitYear',
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

  /// `Enter an amount greater than zero.`
  String get shareCreateValidationAmount {
    return Intl.message(
      'Enter an amount greater than zero.',
      name: 'shareCreateValidationAmount',
      desc: '',
      args: [],
    );
  }

  /// `Select at least one person to split this bill.`
  String get shareCreateValidationEqualParticipants {
    return Intl.message(
      'Select at least one person to split this bill.',
      name: 'shareCreateValidationEqualParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Select at least one person for this bill.`
  String get shareCreateValidationCustomParticipants {
    return Intl.message(
      'Select at least one person for this bill.',
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

  /// `Make sure the split adds up to the total amount.`
  String get shareCreateValidationCustomSum {
    return Intl.message(
      'Make sure the split adds up to the total amount.',
      name: 'shareCreateValidationCustomSum',
      desc: '',
      args: [],
    );
  }

  /// `Split doesn't match. Total: {total}. Included: {included}. Difference: {difference}.`
  String shareCreateValidationCustomSumBreakdown(
    String total,
    String included,
    String difference,
  ) {
    return Intl.message(
      'Split doesn\'t match. Total: $total. Included: $included. Difference: $difference.',
      name: 'shareCreateValidationCustomSumBreakdown',
      desc: '',
      args: [total, included, difference],
    );
  }

  /// `Add at least one other person.`
  String get shareCreateValidationCustomSinglePayer {
    return Intl.message(
      'Add at least one other person.',
      name: 'shareCreateValidationCustomSinglePayer',
      desc: '',
      args: [],
    );
  }

  /// `Choose how often this repeats.`
  String get shareCreateValidationRecurrence {
    return Intl.message(
      'Choose how often this repeats.',
      name: 'shareCreateValidationRecurrence',
      desc: '',
      args: [],
    );
  }

  /// `Choose a split before making this recurring.`
  String get shareCreateValidationRecurrenceSplit {
    return Intl.message(
      'Choose a split before making this recurring.',
      name: 'shareCreateValidationRecurrenceSplit',
      desc: '',
      args: [],
    );
  }

  /// `Choose a start date.`
  String get shareCreateValidationStartDate {
    return Intl.message(
      'Choose a start date.',
      name: 'shareCreateValidationStartDate',
      desc: '',
      args: [],
    );
  }

  /// `Choose a date in the allowed range.`
  String get shareCreateValidationStartDateRange {
    return Intl.message(
      'Choose a date in the allowed range.',
      name: 'shareCreateValidationStartDateRange',
      desc: '',
      args: [],
    );
  }

  /// `Drafts do not repeat until you add a split.`
  String get shareCreateErrorRecurrenceDraft {
    return Intl.message(
      'Drafts do not repeat until you add a split.',
      name: 'shareCreateErrorRecurrenceDraft',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load your home members.`
  String get shareCreateLoadError {
    return Intl.message(
      'Couldn\'t load your home members.',
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

  /// `Couldn't create bill.`
  String get shareCreateErrorGeneric {
    return Intl.message(
      'Couldn\'t create bill.',
      name: 'shareCreateErrorGeneric',
      desc: '',
      args: [],
    );
  }

  /// `You've reached the free limit for active bills. Upgrade for more.`
  String get shareCreateErrorPaywallActiveCap {
    return Intl.message(
      'You\'ve reached the free limit for active bills. Upgrade for more.',
      name: 'shareCreateErrorPaywallActiveCap',
      desc: '',
      args: [],
    );
  }

  /// `You don't have permission to create this right now.`
  String get shareCreateErrorForbidden {
    return Intl.message(
      'You don\'t have permission to create this right now.',
      name: 'shareCreateErrorForbidden',
      desc: '',
      args: [],
    );
  }

  /// `Bill created.`
  String get shareCreateSuccess {
    return Intl.message(
      'Bill created.',
      name: 'shareCreateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Add Task`
  String get flowChoreCreateTitle {
    return Intl.message(
      'Add Task',
      name: 'flowChoreCreateTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit Task`
  String get flowChoreEditTitle {
    return Intl.message(
      'Edit Task',
      name: 'flowChoreEditTitle',
      desc: '',
      args: [],
    );
  }

  /// `View Task`
  String get flowChoreViewTitle {
    return Intl.message(
      'View Task',
      name: 'flowChoreViewTitle',
      desc: '',
      args: [],
    );
  }

  /// `What needs to be done?`
  String get flowChoreNameLabel {
    return Intl.message(
      'What needs to be done?',
      name: 'flowChoreNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Bin night, clean the fridge, water plants`
  String get flowChoreNameHint {
    return Intl.message(
      'e.g. Bin night, clean the fridge, water plants',
      name: 'flowChoreNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter a task name.`
  String get flowChoreValidationName {
    return Intl.message(
      'Enter a task name.',
      name: 'flowChoreValidationName',
      desc: '',
      args: [],
    );
  }

  /// `Who's doing this?`
  String get flowChoreAssigneeLabel {
    return Intl.message(
      'Who\'s doing this?',
      name: 'flowChoreAssigneeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose someone.`
  String get flowChoreValidationAssignee {
    return Intl.message(
      'Choose someone.',
      name: 'flowChoreValidationAssignee',
      desc: '',
      args: [],
    );
  }

  /// `When will it happen?`
  String get flowChoreStartLabel {
    return Intl.message(
      'When will it happen?',
      name: 'flowChoreStartLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose a date within the next year.`
  String get flowChoreValidationDate {
    return Intl.message(
      'Choose a date within the next year.',
      name: 'flowChoreValidationDate',
      desc: '',
      args: [],
    );
  }

  /// `How often does this happen?`
  String get flowChoreRecurrenceLabel {
    return Intl.message(
      'How often does this happen?',
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

  /// `Why it matters`
  String get flowChoreNotesLabel {
    return Intl.message(
      'Why it matters',
      name: 'flowChoreNotesLabel',
      desc: '',
      args: [],
    );
  }

  /// `Anything that helps others do this`
  String get flowChoreNotesHint {
    return Intl.message(
      'Anything that helps others do this',
      name: 'flowChoreNotesHint',
      desc: '',
      args: [],
    );
  }

  /// `How to do it (optional)`
  String get flowChoreHowToLabel {
    return Intl.message(
      'How to do it (optional)',
      name: 'flowChoreHowToLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add a link if there's a specific way`
  String get flowChoreHowToHint {
    return Intl.message(
      'Add a link if there\'s a specific way',
      name: 'flowChoreHowToHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid link starting with http or https.`
  String get flowChoreValidationHowToUrl {
    return Intl.message(
      'Enter a valid link starting with http or https.',
      name: 'flowChoreValidationHowToUrl',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't open that link.`
  String get flowChoreHowToLaunchError {
    return Intl.message(
      'Couldn\'t open that link.',
      name: 'flowChoreHowToLaunchError',
      desc: '',
      args: [],
    );
  }

  /// `What good looks like`
  String get flowChorePhotoLabel {
    return Intl.message(
      'What good looks like',
      name: 'flowChorePhotoLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add a photo to keep everyone aligned`
  String get flowChorePhotoPlaceholder {
    return Intl.message(
      'Add a photo to keep everyone aligned',
      name: 'flowChorePhotoPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Allow camera access to take a photo.`
  String get flowChorePhotoPermissionDenied {
    return Intl.message(
      'Allow camera access to take a photo.',
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

  /// `Couldn't upload the photo.`
  String get flowChorePhotoUploadError {
    return Intl.message(
      'Couldn\'t upload the photo.',
      name: 'flowChorePhotoUploadError',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load photo.`
  String get flowChorePhotoLoadError {
    return Intl.message(
      'Couldn\'t load photo.',
      name: 'flowChorePhotoLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Create task`
  String get flowChoreSubmitCreate {
    return Intl.message(
      'Create task',
      name: 'flowChoreSubmitCreate',
      desc: '',
      args: [],
    );
  }

  /// `Save changes`
  String get flowChoreSubmitUpdate {
    return Intl.message(
      'Save changes',
      name: 'flowChoreSubmitUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Delete Task`
  String get flowChoreDeleteButton {
    return Intl.message(
      'Delete Task',
      name: 'flowChoreDeleteButton',
      desc: '',
      args: [],
    );
  }

  /// `Delete this task?`
  String get flowChoreDeleteDialogTitle {
    return Intl.message(
      'Delete this task?',
      name: 'flowChoreDeleteDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `This removes the task for everyone in your home.`
  String get flowChoreDeleteDialogMessage {
    return Intl.message(
      'This removes the task for everyone in your home.',
      name: 'flowChoreDeleteDialogMessage',
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

  /// `Couldn't load this task.`
  String get flowChoreLoadError {
    return Intl.message(
      'Couldn\'t load this task.',
      name: 'flowChoreLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get flowChoreRetry {
    return Intl.message('Retry', name: 'flowChoreRetry', desc: '', args: []);
  }

  /// `You've reached the free limit for active tasks. Upgrade for more.`
  String get flowChoreErrorPaywallActiveCap {
    return Intl.message(
      'You\'ve reached the free limit for active tasks. Upgrade for more.',
      name: 'flowChoreErrorPaywallActiveCap',
      desc: '',
      args: [],
    );
  }

  /// `You've reached the free limit for task photos. Upgrade for more.`
  String get flowChoreErrorPaywallMediaCap {
    return Intl.message(
      'You\'ve reached the free limit for task photos. Upgrade for more.',
      name: 'flowChoreErrorPaywallMediaCap',
      desc: '',
      args: [],
    );
  }

  /// `That person isn't part of this home right now.`
  String get flowChoreErrorAssigneeNotMember {
    return Intl.message(
      'That person isn\'t part of this home right now.',
      name: 'flowChoreErrorAssigneeNotMember',
      desc: '',
      args: [],
    );
  }

  /// `You don't have permission to change this task.`
  String get flowChoreErrorForbidden {
    return Intl.message(
      'You don\'t have permission to change this task.',
      name: 'flowChoreErrorForbidden',
      desc: '',
      args: [],
    );
  }

  /// `That photo doesn't belong to this home.`
  String get flowChoreErrorInvalidPhoto {
    return Intl.message(
      'That photo doesn\'t belong to this home.',
      name: 'flowChoreErrorInvalidPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Choose a valid start date.`
  String get flowChoreErrorInvalidStart {
    return Intl.message(
      'Choose a valid start date.',
      name: 'flowChoreErrorInvalidStart',
      desc: '',
      args: [],
    );
  }

  /// `This task is not editable right now.`
  String get flowChoreErrorInvalidState {
    return Intl.message(
      'This task is not editable right now.',
      name: 'flowChoreErrorInvalidState',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't save this task.`
  String get flowChoreErrorGeneric {
    return Intl.message(
      'Couldn\'t save this task.',
      name: 'flowChoreErrorGeneric',
      desc: '',
      args: [],
    );
  }

  /// `Task details`
  String get flowChoreDetailTitle {
    return Intl.message(
      'Task details',
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

  /// `Mark complete`
  String get flowChoreDetailCompleteButton {
    return Intl.message(
      'Mark complete',
      name: 'flowChoreDetailCompleteButton',
      desc: '',
      args: [],
    );
  }

  /// `Task created.`
  String get flowChoreCreateSuccess {
    return Intl.message(
      'Task created.',
      name: 'flowChoreCreateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Task updated.`
  String get flowChoreUpdateSuccess {
    return Intl.message(
      'Task updated.',
      name: 'flowChoreUpdateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Task completed.`
  String get flowChoreDetailCompletionSuccess {
    return Intl.message(
      'Task completed.',
      name: 'flowChoreDetailCompletionSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't complete this task.`
  String get flowChoreDetailCompletionError {
    return Intl.message(
      'Couldn\'t complete this task.',
      name: 'flowChoreDetailCompletionError',
      desc: '',
      args: [],
    );
  }

  /// `Helpful details`
  String get flowChoreDetailMoreInfoTitle {
    return Intl.message(
      'Helpful details',
      name: 'flowChoreDetailMoreInfoTitle',
      desc: '',
      args: [],
    );
  }

  /// `Reference photo`
  String get flowChoreExpectationPhotoLabel {
    return Intl.message(
      'Reference photo',
      name: 'flowChoreExpectationPhotoLabel',
      desc: '',
      args: [],
    );
  }

  /// `Nothing here yet`
  String get flowListEmptyTitle {
    return Intl.message(
      'Nothing here yet',
      name: 'flowListEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tasks keep everyone aligned.`
  String get flowListEmptySubtitle {
    return Intl.message(
      'Tasks keep everyone aligned.',
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

  /// `Needs attention`
  String get flowListOverdueLabel {
    return Intl.message(
      'Needs attention',
      name: 'flowListOverdueLabel',
      desc: '',
      args: [],
    );
  }

  /// `Current`
  String get flowListTabCurrent {
    return Intl.message(
      'Current',
      name: 'flowListTabCurrent',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming`
  String get flowListTabFuture {
    return Intl.message(
      'Upcoming',
      name: 'flowListTabFuture',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load tasks. Pull to refresh.`
  String get flowListError {
    return Intl.message(
      'Couldn\'t load tasks. Pull to refresh.',
      name: 'flowListError',
      desc: '',
      args: [],
    );
  }

  /// `Keep shared things clear.`
  String get exploreIntroSubtitle {
    return Intl.message(
      'Keep shared things clear.',
      name: 'exploreIntroSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `See what needs doing and who's doing it.`
  String get exploreFlowSubtitle {
    return Intl.message(
      'See what needs doing and who\'s doing it.',
      name: 'exploreFlowSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `See every bill you've created and track collections.`
  String get exploreShareSubtitle {
    return Intl.message(
      'See every bill you\'ve created and track collections.',
      name: 'exploreShareSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Shopping list`
  String get exploreShoppingSectionTitle {
    return Intl.message(
      'Shopping list',
      name: 'exploreShoppingSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `View and manage shared shopping items.`
  String get exploreShoppingSubtitle {
    return Intl.message(
      'View and manage shared shopping items.',
      name: 'exploreShoppingSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Your bills`
  String get shareCreatedListTitle {
    return Intl.message(
      'Your bills',
      name: 'shareCreatedListTitle',
      desc: '',
      args: [],
    );
  }

  /// `No bills yet`
  String get shareCreatedListEmptyTitle {
    return Intl.message(
      'No bills yet',
      name: 'shareCreatedListEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Bills keep money clear.`
  String get shareCreatedListEmptySubtitle {
    return Intl.message(
      'Bills keep money clear.',
      name: 'shareCreatedListEmptySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load your bills. Pull to refresh.`
  String get shareCreatedListError {
    return Intl.message(
      'Couldn\'t load your bills. Pull to refresh.',
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

  /// `{paid} of {total, plural, one{{total} payment} other{{total} payments}} paid`
  String shareCreatedListActiveSubtitle(int paid, int total) {
    return Intl.message(
      '$paid of ${Intl.plural(total, one: '$total payment', other: '$total payments')} paid',
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

  /// `Split it before publishing so everyone knows their part.`
  String get shareCreatedListDraftSubtitle {
    return Intl.message(
      'Split it before publishing so everyone knows their part.',
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

  /// `Profile`
  String get profileSettingsTitle {
    return Intl.message(
      'Profile',
      name: 'profileSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Manage your account and home access.`
  String get profileSettingsSubtitle {
    return Intl.message(
      'Manage your account and home access.',
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

  /// `Choose a username and avatar.`
  String get profileIdentitySubtitle {
    return Intl.message(
      'Choose a username and avatar.',
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

  /// `Enter a username.`
  String get profileIdentityUsernameEmptyError {
    return Intl.message(
      'Enter a username.',
      name: 'profileIdentityUsernameEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `Use 3-30 lowercase letters or numbers. Dots and underscores can go in the middle.`
  String get profileIdentityUsernameFormatError {
    return Intl.message(
      'Use 3-30 lowercase letters or numbers. Dots and underscores can go in the middle.',
      name: 'profileIdentityUsernameFormatError',
      desc: '',
      args: [],
    );
  }

  /// `That username is taken.`
  String get profileIdentityUsernameTakenError {
    return Intl.message(
      'That username is taken.',
      name: 'profileIdentityUsernameTakenError',
      desc: '',
      args: [],
    );
  }

  /// `Choose an avatar`
  String get profileIdentityAvatarSectionTitle {
    return Intl.message(
      'Choose an avatar',
      name: 'profileIdentityAvatarSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Use a different avatar for each person in your home.`
  String get profileIdentityAvatarSectionDescription {
    return Intl.message(
      'Use a different avatar for each person in your home.',
      name: 'profileIdentityAvatarSectionDescription',
      desc: '',
      args: [],
    );
  }

  /// `No avatars are available right now.`
  String get profileIdentityAvatarEmpty {
    return Intl.message(
      'No avatars are available right now.',
      name: 'profileIdentityAvatarEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load your profile.`
  String get profileIdentityLoadError {
    return Intl.message(
      'Couldn\'t load your profile.',
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

  /// `You'll leave this shared Kinly space.`
  String get profileLeaveHomeSubtitle {
    return Intl.message(
      'You\'ll leave this shared Kinly space.',
      name: 'profileLeaveHomeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Checking home members...`
  String get profileLeaveEligibilityLoading {
    return Intl.message(
      'Checking home members...',
      name: 'profileLeaveEligibilityLoading',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load your home members.`
  String get profileLeaveEligibilityError {
    return Intl.message(
      'Couldn\'t load your home members.',
      name: 'profileLeaveEligibilityError',
      desc: '',
      args: [],
    );
  }

  /// `You're the last member. Leaving will deactivate this home.`
  String get profileLeaveOwnerSoloMessage {
    return Intl.message(
      'You\'re the last member. Leaving will deactivate this home.',
      name: 'profileLeaveOwnerSoloMessage',
      desc: '',
      args: [],
    );
  }

  /// `No one else can take ownership right now.`
  String get profileLeaveOwnerNoEligibleMembers {
    return Intl.message(
      'No one else can take ownership right now.',
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

  /// `Choose who becomes the new owner before you leave.`
  String get profileLeaveTransferSheetSubtitle {
    return Intl.message(
      'Choose who becomes the new owner before you leave.',
      name: 'profileLeaveTransferSheetSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Remove a member`
  String get profileKickMemberTitle {
    return Intl.message(
      'Remove a member',
      name: 'profileKickMemberTitle',
      desc: '',
      args: [],
    );
  }

  /// `Choose who loses access to this home.`
  String get profileKickMemberSubtitle {
    return Intl.message(
      'Choose who loses access to this home.',
      name: 'profileKickMemberSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Remove a member`
  String get profileKickSheetTitle {
    return Intl.message(
      'Remove a member',
      name: 'profileKickSheetTitle',
      desc: '',
      args: [],
    );
  }

  /// `Choose a member to remove. They'll lose access right away.`
  String get profileKickSheetSubtitle {
    return Intl.message(
      'Choose a member to remove. They\'ll lose access right away.',
      name: 'profileKickSheetSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Remove member`
  String get profileKickActionConfirm {
    return Intl.message(
      'Remove member',
      name: 'profileKickActionConfirm',
      desc: '',
      args: [],
    );
  }

  /// `No other members to remove right now.`
  String get profileKickNoMembers {
    return Intl.message(
      'No other members to remove right now.',
      name: 'profileKickNoMembers',
      desc: '',
      args: [],
    );
  }

  /// `Only the home owner can remove members.`
  String get profileKickOwnerOnly {
    return Intl.message(
      'Only the home owner can remove members.',
      name: 'profileKickOwnerOnly',
      desc: '',
      args: [],
    );
  }

  /// `They no longer have access to this home.`
  String get profileKickSuccessMessage {
    return Intl.message(
      'They no longer have access to this home.',
      name: 'profileKickSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Ownership transferred. Finishing leave...`
  String get profileLeaveTransferSuccessMessage {
    return Intl.message(
      'Ownership transferred. Finishing leave...',
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

  /// `Couldn't load the Info Hub. Check your connection.`
  String get profileInfoHubLoadError {
    return Intl.message(
      'Couldn\'t load the Info Hub. Check your connection.',
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

  /// `Notifications`
  String get profileConnectionSettingsTitle {
    return Intl.message(
      'Notifications',
      name: 'profileConnectionSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Manage reminders and alerts.`
  String get profileConnectionSettingsSubtitle {
    return Intl.message(
      'Manage reminders and alerts.',
      name: 'profileConnectionSettingsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get connectionSettingsTitle {
    return Intl.message(
      'Notifications',
      name: 'connectionSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Control daily reminders and timing.`
  String get connectionSettingsSubtitle {
    return Intl.message(
      'Control daily reminders and timing.',
      name: 'connectionSettingsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't update notification settings.`
  String get connectionSettingsGenericError {
    return Intl.message(
      'Couldn\'t update notification settings.',
      name: 'connectionSettingsGenericError',
      desc: '',
      args: [],
    );
  }

  /// `Daily reminders`
  String get connectionNotificationsToggleTitle {
    return Intl.message(
      'Daily reminders',
      name: 'connectionNotificationsToggleTitle',
      desc: '',
      args: [],
    );
  }

  /// `Get one reminder each day.`
  String get connectionNotificationsToggleSubtitleOn {
    return Intl.message(
      'Get one reminder each day.',
      name: 'connectionNotificationsToggleSubtitleOn',
      desc: '',
      args: [],
    );
  }

  /// `Turn on reminders for your home.`
  String get connectionNotificationsToggleSubtitleOff {
    return Intl.message(
      'Turn on reminders for your home.',
      name: 'connectionNotificationsToggleSubtitleOff',
      desc: '',
      args: [],
    );
  }

  /// `Turn on notifications in your phone settings first.`
  String get connectionNotificationsPermissionBlocked {
    return Intl.message(
      'Turn on notifications in your phone settings first.',
      name: 'connectionNotificationsPermissionBlocked',
      desc: '',
      args: [],
    );
  }

  /// `Reminder time`
  String get connectionNotificationsTimeLabel {
    return Intl.message(
      'Reminder time',
      name: 'connectionNotificationsTimeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Scheduled for {time}`
  String connectionNotificationsTimeSubtitle(String time) {
    return Intl.message(
      'Scheduled for $time',
      name: 'connectionNotificationsTimeSubtitle',
      desc: '',
      args: [time],
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

  /// `Your profile is off. Sign in with another email.`
  String get profile_deactivated_message {
    return Intl.message(
      'Your profile is off. Sign in with another email.',
      name: 'profile_deactivated_message',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't open your email app.`
  String get profileContactLaunchError {
    return Intl.message(
      'Couldn\'t open your email app.',
      name: 'profileContactLaunchError',
      desc: '',
      args: [],
    );
  }

  /// `Sign out`
  String get profileLogoutTitle {
    return Intl.message(
      'Sign out',
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

  /// `Delete account`
  String get profileDeleteAccountTitle {
    return Intl.message(
      'Delete account',
      name: 'profileDeleteAccountTitle',
      desc: '',
      args: [],
    );
  }

  /// `Delete your Kinly account and data.`
  String get profileDeleteAccountSubtitle {
    return Intl.message(
      'Delete your Kinly account and data.',
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

  /// `You'll lose access to tasks, history, and invites.`
  String get profileConfirmLeaveMessage {
    return Intl.message(
      'You\'ll lose access to tasks, history, and invites.',
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

  /// `This deletes your account and signs you out. This is permanent.`
  String get profileConfirmDeleteMessage {
    return Intl.message(
      'This deletes your account and signs you out. This is permanent.',
      name: 'profileConfirmDeleteMessage',
      desc: '',
      args: [],
    );
  }

  /// `Delete account`
  String get profileActionConfirmDelete {
    return Intl.message(
      'Delete account',
      name: 'profileActionConfirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Leave home`
  String get profileActionConfirm {
    return Intl.message(
      'Leave home',
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

  /// `Something went wrong.`
  String get profileGenericError {
    return Intl.message(
      'Something went wrong.',
      name: 'profileGenericError',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't find your current home.`
  String get profileMissingHomeError {
    return Intl.message(
      'Couldn\'t find your current home.',
      name: 'profileMissingHomeError',
      desc: '',
      args: [],
    );
  }

  /// `What went well or needs adjusting this week?`
  String get harmonyQuestion {
    return Intl.message(
      'What went well or needs adjusting this week?',
      name: 'harmonyQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Sunny`
  String get harmonyMoodSunny {
    return Intl.message('Sunny', name: 'harmonyMoodSunny', desc: '', args: []);
  }

  /// `Partly sunny`
  String get harmonyMoodPartiallySunny {
    return Intl.message(
      'Partly sunny',
      name: 'harmonyMoodPartiallySunny',
      desc: '',
      args: [],
    );
  }

  /// `Cloudy`
  String get harmonyMoodCloudy {
    return Intl.message(
      'Cloudy',
      name: 'harmonyMoodCloudy',
      desc: '',
      args: [],
    );
  }

  /// `Rainy`
  String get harmonyMoodRainy {
    return Intl.message('Rainy', name: 'harmonyMoodRainy', desc: '', args: []);
  }

  /// `Thunderstorm`
  String get harmonyMoodThunderstorm {
    return Intl.message(
      'Thunderstorm',
      name: 'harmonyMoodThunderstorm',
      desc: '',
      args: [],
    );
  }

  /// `Optional note`
  String get harmonyCommentLabel {
    return Intl.message(
      'Optional note',
      name: 'harmonyCommentLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add context if helpful`
  String get harmonyCommentHint {
    return Intl.message(
      'Add context if helpful',
      name: 'harmonyCommentHint',
      desc: '',
      args: [],
    );
  }

  /// `Type @ to mention 1 housemate.`
  String get harmonyFeedbackSingleHousemateHint {
    return Intl.message(
      'Type @ to mention 1 housemate.',
      name: 'harmonyFeedbackSingleHousemateHint',
      desc: '',
      args: [],
    );
  }

  /// `Visible to everyone in the home`
  String get harmonyShareLabel {
    return Intl.message(
      'Visible to everyone in the home',
      name: 'harmonyShareLabel',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get harmonySubmitCta {
    return Intl.message('Save', name: 'harmonySubmitCta', desc: '', args: []);
  }

  /// `Saved`
  String get harmonySubmitSuccess {
    return Intl.message(
      'Saved',
      name: 'harmonySubmitSuccess',
      desc: '',
      args: [],
    );
  }

  /// `You've already submitted this week.`
  String get harmonyErrorAlreadySubmitted {
    return Intl.message(
      'You\'ve already submitted this week.',
      name: 'harmonyErrorAlreadySubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Weekly feedback isn't available right now.`
  String get harmonyErrorForbidden {
    return Intl.message(
      'Weekly feedback isn\'t available right now.',
      name: 'harmonyErrorForbidden',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong.`
  String get harmonyErrorUnknown {
    return Intl.message(
      'Something went wrong.',
      name: 'harmonyErrorUnknown',
      desc: '',
      args: [],
    );
  }

  /// `House shoutouts`
  String get todayGratitudeHouseCta {
    return Intl.message(
      'House shoutouts',
      name: 'todayGratitudeHouseCta',
      desc: '',
      args: [],
    );
  }

  /// `My shoutouts`
  String get todayGratitudePersonalCta {
    return Intl.message(
      'My shoutouts',
      name: 'todayGratitudePersonalCta',
      desc: '',
      args: [],
    );
  }

  /// `House`
  String get gratitudeWallHouseTab {
    return Intl.message(
      'House',
      name: 'gratitudeWallHouseTab',
      desc: '',
      args: [],
    );
  }

  /// `Mine`
  String get gratitudeWallPersonalTab {
    return Intl.message(
      'Mine',
      name: 'gratitudeWallPersonalTab',
      desc: '',
      args: [],
    );
  }

  /// `My Shoutouts`
  String get gratitudeWallPersonalTitle {
    return Intl.message(
      'My Shoutouts',
      name: 'gratitudeWallPersonalTitle',
      desc: '',
      args: [],
    );
  }

  /// `A private place for quick thanks.`
  String get gratitudeWallPersonalSummary {
    return Intl.message(
      'A private place for quick thanks.',
      name: 'gratitudeWallPersonalSummary',
      desc: '',
      args: [],
    );
  }

  /// `Shoutouts`
  String get gratitudeWallStatsMentions {
    return Intl.message(
      'Shoutouts',
      name: 'gratitudeWallStatsMentions',
      desc: '',
      args: [],
    );
  }

  /// `People`
  String get gratitudeWallStatsPeople {
    return Intl.message(
      'People',
      name: 'gratitudeWallStatsPeople',
      desc: '',
      args: [],
    );
  }

  /// `Homes`
  String get gratitudeWallStatsHomes {
    return Intl.message(
      'Homes',
      name: 'gratitudeWallStatsHomes',
      desc: '',
      args: [],
    );
  }

  /// `Type @ to mention someone`
  String get mentionFieldHint {
    return Intl.message(
      'Type @ to mention someone',
      name: 'mentionFieldHint',
      desc: '',
      args: [],
    );
  }

  /// `No shoutouts yet`
  String get gratitudeWallEmptyTitle {
    return Intl.message(
      'No shoutouts yet',
      name: 'gratitudeWallEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add a shoutout from this week.`
  String get gratitudeWallEmptySubtitle {
    return Intl.message(
      'Add a shoutout from this week.',
      name: 'gratitudeWallEmptySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load shoutouts right now.`
  String get gratitudeWallErrorGeneric {
    return Intl.message(
      'Couldn\'t load shoutouts right now.',
      name: 'gratitudeWallErrorGeneric',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get gratitudeWallRetry {
    return Intl.message(
      'Try again',
      name: 'gratitudeWallRetry',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get gratitudeWallShareCta {
    return Intl.message(
      'Share',
      name: 'gratitudeWallShareCta',
      desc: '',
      args: [],
    );
  }

  /// `House shoutouts`
  String get gratitudeWallShareTitle {
    return Intl.message(
      'House shoutouts',
      name: 'gratitudeWallShareTitle',
      desc: '',
      args: [],
    );
  }

  /// `A few shoutouts from our Kinly home. Download the app: {link}`
  String gratitudeWallShareMessage(String link) {
    return Intl.message(
      'A few shoutouts from our Kinly home. Download the app: $link',
      name: 'gratitudeWallShareMessage',
      desc: '',
      args: [link],
    );
  }

  /// `Couldn't share right now.`
  String get gratitudeWallShareError {
    return Intl.message(
      'Couldn\'t share right now.',
      name: 'gratitudeWallShareError',
      desc: '',
      args: [],
    );
  }

  /// `Made with {appName} - Together feels lighter`
  String gratitudeWallFooter(String appName) {
    return Intl.message(
      'Made with $appName - Together feels lighter',
      name: 'gratitudeWallFooter',
      desc: '',
      args: [appName],
    );
  }

  /// `{weeks, plural, =0{This week} one{# week ago} other{# weeks ago}}`
  String gratitudeWallWeeksAgo(int weeks) {
    return Intl.plural(
      weeks,
      zero: 'This week',
      one: '# week ago',
      other: '# weeks ago',
      name: 'gratitudeWallWeeksAgo',
      desc: '',
      args: [weeks],
    );
  }

  /// `Has Kinly helped your home run more smoothly?`
  String get npsTitle {
    return Intl.message(
      'Has Kinly helped your home run more smoothly?',
      name: 'npsTitle',
      desc: '',
      args: [],
    );
  }

  /// `0 means not at all. 10 means it made a real difference.`
  String get npsDescription {
    return Intl.message(
      '0 means not at all. 10 means it made a real difference.',
      name: 'npsDescription',
      desc: '',
      args: [],
    );
  }

  /// `0 Not at all`
  String get npsScaleLowLabel {
    return Intl.message(
      '0 Not at all',
      name: 'npsScaleLowLabel',
      desc: '',
      args: [],
    );
  }

  /// `10 Made a real difference`
  String get npsScaleHighLabel {
    return Intl.message(
      '10 Made a real difference',
      name: 'npsScaleHighLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose a score to continue.`
  String get npsCannotSkip {
    return Intl.message(
      'Choose a score to continue.',
      name: 'npsCannotSkip',
      desc: '',
      args: [],
    );
  }

  /// `You don't need to share feedback right now.`
  String get npsSubmitErrorNotRequired {
    return Intl.message(
      'You don\'t need to share feedback right now.',
      name: 'npsSubmitErrorNotRequired',
      desc: '',
      args: [],
    );
  }

  /// `Choose a number between 0 and 10.`
  String get npsSubmitErrorInvalidScore {
    return Intl.message(
      'Choose a number between 0 and 10.',
      name: 'npsSubmitErrorInvalidScore',
      desc: '',
      args: [],
    );
  }

  /// `Feedback isn't available right now.`
  String get npsSubmitErrorForbidden {
    return Intl.message(
      'Feedback isn\'t available right now.',
      name: 'npsSubmitErrorForbidden',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't send your feedback.`
  String get npsSubmitErrorGeneric {
    return Intl.message(
      'Couldn\'t send your feedback.',
      name: 'npsSubmitErrorGeneric',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't open the next step.`
  String get npsLaunchError {
    return Intl.message(
      'Couldn\'t open the next step.',
      name: 'npsLaunchError',
      desc: '',
      args: [],
    );
  }

  /// `How could Kinly better support your home?`
  String get npsEmailSubject {
    return Intl.message(
      'How could Kinly better support your home?',
      name: 'npsEmailSubject',
      desc: '',
      args: [],
    );
  }

  /// `Set your vibe`
  String get preferencePromptTitle {
    return Intl.message(
      'Set your vibe',
      name: 'preferencePromptTitle',
      desc: '',
      args: [],
    );
  }

  /// `Help your home understand what works for you.`
  String get preferencePromptSubtitle {
    return Intl.message(
      'Help your home understand what works for you.',
      name: 'preferencePromptSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get preferencePromptCta {
    return Intl.message(
      'Start',
      name: 'preferencePromptCta',
      desc: '',
      args: [],
    );
  }

  /// `Your vibe`
  String get preferenceOnboardingTitle {
    return Intl.message(
      'Your vibe',
      name: 'preferenceOnboardingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get preferenceOnboardingBack {
    return Intl.message(
      'Back',
      name: 'preferenceOnboardingBack',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get preferenceOnboardingSubmit {
    return Intl.message(
      'Save',
      name: 'preferenceOnboardingSubmit',
      desc: '',
      args: [],
    );
  }

  /// `{current}/{total}`
  String preferenceOnboardingProgress(int current, int total) {
    return Intl.message(
      '$current/$total',
      name: 'preferenceOnboardingProgress',
      desc: 'Progress for preference onboarding',
      args: [current, total],
    );
  }

  /// `Your preferences`
  String get preferenceReportTitle {
    return Intl.message(
      'Your preferences',
      name: 'preferenceReportTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get preferenceReportEditCta {
    return Intl.message(
      'Edit',
      name: 'preferenceReportEditCta',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get preferenceReportDoneCta {
    return Intl.message(
      'Done',
      name: 'preferenceReportDoneCta',
      desc: '',
      args: [],
    );
  }

  /// `Edit preferences`
  String get preferenceReportEditTitle {
    return Intl.message(
      'Edit preferences',
      name: 'preferenceReportEditTitle',
      desc: '',
      args: [],
    );
  }

  /// `View preferences`
  String get preferenceReportViewTitle {
    return Intl.message(
      'View preferences',
      name: 'preferenceReportViewTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit this section.`
  String get preferenceReportEditSectionPrompt {
    return Intl.message(
      'Edit this section.',
      name: 'preferenceReportEditSectionPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Write what feels right`
  String get preferenceReportEditSectionHint {
    return Intl.message(
      'Write what feels right',
      name: 'preferenceReportEditSectionHint',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get preferenceReportEditSectionDone {
    return Intl.message(
      'Done',
      name: 'preferenceReportEditSectionDone',
      desc: '',
      args: [],
    );
  }

  /// `Preferences not ready`
  String get preferenceReportEmptyTitle {
    return Intl.message(
      'Preferences not ready',
      name: 'preferenceReportEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Complete your preferences to generate your report.`
  String get preferenceReportEmptyBody {
    return Intl.message(
      'Complete your preferences to generate your report.',
      name: 'preferenceReportEmptyBody',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load report`
  String get preferenceReportErrorTitle {
    return Intl.message(
      'Couldn\'t load report',
      name: 'preferenceReportErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please try again.`
  String get preferenceReportErrorBody {
    return Intl.message(
      'Please try again.',
      name: 'preferenceReportErrorBody',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't save that update.`
  String get preferenceReportEditError {
    return Intl.message(
      'Couldn\'t save that update.',
      name: 'preferenceReportEditError',
      desc: '',
      args: [],
    );
  }

  /// `This shows what feels comfortable for them.`
  String get preferenceReportReadOnlyNote {
    return Intl.message(
      'This shows what feels comfortable for them.',
      name: 'preferenceReportReadOnlyNote',
      desc: '',
      args: [],
    );
  }

  /// `Noise level?`
  String get preferenceScenarioEnvironmentNoiseQuestion {
    return Intl.message(
      'Noise level?',
      name: 'preferenceScenarioEnvironmentNoiseQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Quiet please`
  String get preferenceScenarioEnvironmentNoiseOption1 {
    return Intl.message(
      'Quiet please',
      name: 'preferenceScenarioEnvironmentNoiseOption1',
      desc: '',
      args: [],
    );
  }

  /// `Normal noise`
  String get preferenceScenarioEnvironmentNoiseOption2 {
    return Intl.message(
      'Normal noise',
      name: 'preferenceScenarioEnvironmentNoiseOption2',
      desc: '',
      args: [],
    );
  }

  /// `Lively is fine`
  String get preferenceScenarioEnvironmentNoiseOption3 {
    return Intl.message(
      'Lively is fine',
      name: 'preferenceScenarioEnvironmentNoiseOption3',
      desc: '',
      args: [],
    );
  }

  /// `Lighting?`
  String get preferenceScenarioEnvironmentLightQuestion {
    return Intl.message(
      'Lighting?',
      name: 'preferenceScenarioEnvironmentLightQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Soft`
  String get preferenceScenarioEnvironmentLightOption1 {
    return Intl.message(
      'Soft',
      name: 'preferenceScenarioEnvironmentLightOption1',
      desc: '',
      args: [],
    );
  }

  /// `Balanced`
  String get preferenceScenarioEnvironmentLightOption2 {
    return Intl.message(
      'Balanced',
      name: 'preferenceScenarioEnvironmentLightOption2',
      desc: '',
      args: [],
    );
  }

  /// `Bright`
  String get preferenceScenarioEnvironmentLightOption3 {
    return Intl.message(
      'Bright',
      name: 'preferenceScenarioEnvironmentLightOption3',
      desc: '',
      args: [],
    );
  }

  /// `Strong smells?`
  String get preferenceScenarioEnvironmentScentQuestion {
    return Intl.message(
      'Strong smells?',
      name: 'preferenceScenarioEnvironmentScentQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Sensitive`
  String get preferenceScenarioEnvironmentScentOption1 {
    return Intl.message(
      'Sensitive',
      name: 'preferenceScenarioEnvironmentScentOption1',
      desc: '',
      args: [],
    );
  }

  /// `Neutral`
  String get preferenceScenarioEnvironmentScentOption2 {
    return Intl.message(
      'Neutral',
      name: 'preferenceScenarioEnvironmentScentOption2',
      desc: '',
      args: [],
    );
  }

  /// `Doesn't bother me`
  String get preferenceScenarioEnvironmentScentOption3 {
    return Intl.message(
      'Doesn\'t bother me',
      name: 'preferenceScenarioEnvironmentScentOption3',
      desc: '',
      args: [],
    );
  }

  /// `Evenings?`
  String get preferenceScenarioScheduleQuietHoursQuestion {
    return Intl.message(
      'Evenings?',
      name: 'preferenceScenarioScheduleQuietHoursQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Quiet nights`
  String get preferenceScenarioScheduleQuietHoursOption1 {
    return Intl.message(
      'Quiet nights',
      name: 'preferenceScenarioScheduleQuietHoursOption1',
      desc: '',
      args: [],
    );
  }

  /// `Depends`
  String get preferenceScenarioScheduleQuietHoursOption2 {
    return Intl.message(
      'Depends',
      name: 'preferenceScenarioScheduleQuietHoursOption2',
      desc: '',
      args: [],
    );
  }

  /// `Active is fine`
  String get preferenceScenarioScheduleQuietHoursOption3 {
    return Intl.message(
      'Active is fine',
      name: 'preferenceScenarioScheduleQuietHoursOption3',
      desc: '',
      args: [],
    );
  }

  /// `Sleep style?`
  String get preferenceScenarioScheduleSleepTimingQuestion {
    return Intl.message(
      'Sleep style?',
      name: 'preferenceScenarioScheduleSleepTimingQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Early bird`
  String get preferenceScenarioScheduleSleepTimingOption1 {
    return Intl.message(
      'Early bird',
      name: 'preferenceScenarioScheduleSleepTimingOption1',
      desc: '',
      args: [],
    );
  }

  /// `In between`
  String get preferenceScenarioScheduleSleepTimingOption2 {
    return Intl.message(
      'In between',
      name: 'preferenceScenarioScheduleSleepTimingOption2',
      desc: '',
      args: [],
    );
  }

  /// `Night owl`
  String get preferenceScenarioScheduleSleepTimingOption3 {
    return Intl.message(
      'Night owl',
      name: 'preferenceScenarioScheduleSleepTimingOption3',
      desc: '',
      args: [],
    );
  }

  /// `Best way to reach you?`
  String get preferenceScenarioCommunicationChannelQuestion {
    return Intl.message(
      'Best way to reach you?',
      name: 'preferenceScenarioCommunicationChannelQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Text`
  String get preferenceScenarioCommunicationChannelOption1 {
    return Intl.message(
      'Text',
      name: 'preferenceScenarioCommunicationChannelOption1',
      desc: '',
      args: [],
    );
  }

  /// `In person`
  String get preferenceScenarioCommunicationChannelOption2 {
    return Intl.message(
      'In person',
      name: 'preferenceScenarioCommunicationChannelOption2',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get preferenceScenarioCommunicationChannelOption3 {
    return Intl.message(
      'Call',
      name: 'preferenceScenarioCommunicationChannelOption3',
      desc: '',
      args: [],
    );
  }

  /// `When something's wrong?`
  String get preferenceScenarioCommunicationDirectnessQuestion {
    return Intl.message(
      'When something\'s wrong?',
      name: 'preferenceScenarioCommunicationDirectnessQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Be gentle`
  String get preferenceScenarioCommunicationDirectnessOption1 {
    return Intl.message(
      'Be gentle',
      name: 'preferenceScenarioCommunicationDirectnessOption1',
      desc: '',
      args: [],
    );
  }

  /// `Depends`
  String get preferenceScenarioCommunicationDirectnessOption2 {
    return Intl.message(
      'Depends',
      name: 'preferenceScenarioCommunicationDirectnessOption2',
      desc: '',
      args: [],
    );
  }

  /// `Be direct`
  String get preferenceScenarioCommunicationDirectnessOption3 {
    return Intl.message(
      'Be direct',
      name: 'preferenceScenarioCommunicationDirectnessOption3',
      desc: '',
      args: [],
    );
  }

  /// `Shared space?`
  String get preferenceScenarioCleanlinessSharedSpaceQuestion {
    return Intl.message(
      'Shared space?',
      name: 'preferenceScenarioCleanlinessSharedSpaceQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Keep tidy`
  String get preferenceScenarioCleanlinessSharedSpaceOption1 {
    return Intl.message(
      'Keep tidy',
      name: 'preferenceScenarioCleanlinessSharedSpaceOption1',
      desc: '',
      args: [],
    );
  }

  /// `A little messy`
  String get preferenceScenarioCleanlinessSharedSpaceOption2 {
    return Intl.message(
      'A little messy',
      name: 'preferenceScenarioCleanlinessSharedSpaceOption2',
      desc: '',
      args: [],
    );
  }

  /// `Mess is fine`
  String get preferenceScenarioCleanlinessSharedSpaceOption3 {
    return Intl.message(
      'Mess is fine',
      name: 'preferenceScenarioCleanlinessSharedSpaceOption3',
      desc: '',
      args: [],
    );
  }

  /// `Entering your room?`
  String get preferenceScenarioPrivacyRoomEntryQuestion {
    return Intl.message(
      'Entering your room?',
      name: 'preferenceScenarioPrivacyRoomEntryQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Knock first`
  String get preferenceScenarioPrivacyRoomEntryOption1 {
    return Intl.message(
      'Knock first',
      name: 'preferenceScenarioPrivacyRoomEntryOption1',
      desc: '',
      args: [],
    );
  }

  /// `Usually knock`
  String get preferenceScenarioPrivacyRoomEntryOption2 {
    return Intl.message(
      'Usually knock',
      name: 'preferenceScenarioPrivacyRoomEntryOption2',
      desc: '',
      args: [],
    );
  }

  /// `Open door`
  String get preferenceScenarioPrivacyRoomEntryOption3 {
    return Intl.message(
      'Open door',
      name: 'preferenceScenarioPrivacyRoomEntryOption3',
      desc: '',
      args: [],
    );
  }

  /// `Messages at night?`
  String get preferenceScenarioPrivacyNotificationsQuestion {
    return Intl.message(
      'Messages at night?',
      name: 'preferenceScenarioPrivacyNotificationsQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Please don't`
  String get preferenceScenarioPrivacyNotificationsOption1 {
    return Intl.message(
      'Please don\'t',
      name: 'preferenceScenarioPrivacyNotificationsOption1',
      desc: '',
      args: [],
    );
  }

  /// `Important only`
  String get preferenceScenarioPrivacyNotificationsOption2 {
    return Intl.message(
      'Important only',
      name: 'preferenceScenarioPrivacyNotificationsOption2',
      desc: '',
      args: [],
    );
  }

  /// `Anytime`
  String get preferenceScenarioPrivacyNotificationsOption3 {
    return Intl.message(
      'Anytime',
      name: 'preferenceScenarioPrivacyNotificationsOption3',
      desc: '',
      args: [],
    );
  }

  /// `Guests?`
  String get preferenceScenarioSocialHostingQuestion {
    return Intl.message(
      'Guests?',
      name: 'preferenceScenarioSocialHostingQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Rare`
  String get preferenceScenarioSocialHostingOption1 {
    return Intl.message(
      'Rare',
      name: 'preferenceScenarioSocialHostingOption1',
      desc: '',
      args: [],
    );
  }

  /// `Sometimes`
  String get preferenceScenarioSocialHostingOption2 {
    return Intl.message(
      'Sometimes',
      name: 'preferenceScenarioSocialHostingOption2',
      desc: '',
      args: [],
    );
  }

  /// `Often`
  String get preferenceScenarioSocialHostingOption3 {
    return Intl.message(
      'Often',
      name: 'preferenceScenarioSocialHostingOption3',
      desc: '',
      args: [],
    );
  }

  /// `Home energy?`
  String get preferenceScenarioSocialTogethernessQuestion {
    return Intl.message(
      'Home energy?',
      name: 'preferenceScenarioSocialTogethernessQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Mostly solo`
  String get preferenceScenarioSocialTogethernessOption1 {
    return Intl.message(
      'Mostly solo',
      name: 'preferenceScenarioSocialTogethernessOption1',
      desc: '',
      args: [],
    );
  }

  /// `Mix of both`
  String get preferenceScenarioSocialTogethernessOption2 {
    return Intl.message(
      'Mix of both',
      name: 'preferenceScenarioSocialTogethernessOption2',
      desc: '',
      args: [],
    );
  }

  /// `Hang out a lot`
  String get preferenceScenarioSocialTogethernessOption3 {
    return Intl.message(
      'Hang out a lot',
      name: 'preferenceScenarioSocialTogethernessOption3',
      desc: '',
      args: [],
    );
  }

  /// `Daily life?`
  String get preferenceScenarioRoutinePlanningQuestion {
    return Intl.message(
      'Daily life?',
      name: 'preferenceScenarioRoutinePlanningQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Structured`
  String get preferenceScenarioRoutinePlanningOption1 {
    return Intl.message(
      'Structured',
      name: 'preferenceScenarioRoutinePlanningOption1',
      desc: '',
      args: [],
    );
  }

  /// `Some structure`
  String get preferenceScenarioRoutinePlanningOption2 {
    return Intl.message(
      'Some structure',
      name: 'preferenceScenarioRoutinePlanningOption2',
      desc: '',
      args: [],
    );
  }

  /// `Go with the flow`
  String get preferenceScenarioRoutinePlanningOption3 {
    return Intl.message(
      'Go with the flow',
      name: 'preferenceScenarioRoutinePlanningOption3',
      desc: '',
      args: [],
    );
  }

  /// `If something's off?`
  String get preferenceScenarioConflictResolutionQuestion {
    return Intl.message(
      'If something\'s off?',
      name: 'preferenceScenarioConflictResolutionQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Cool off first`
  String get preferenceScenarioConflictResolutionOption1 {
    return Intl.message(
      'Cool off first',
      name: 'preferenceScenarioConflictResolutionOption1',
      desc: '',
      args: [],
    );
  }

  /// `Check in later`
  String get preferenceScenarioConflictResolutionOption2 {
    return Intl.message(
      'Check in later',
      name: 'preferenceScenarioConflictResolutionOption2',
      desc: '',
      args: [],
    );
  }

  /// `Talk early`
  String get preferenceScenarioConflictResolutionOption3 {
    return Intl.message(
      'Talk early',
      name: 'preferenceScenarioConflictResolutionOption3',
      desc: '',
      args: [],
    );
  }

  /// `Create house norms`
  String get houseNormPromptTitle {
    return Intl.message(
      'Create house norms',
      name: 'houseNormPromptTitle',
      desc: '',
      args: [],
    );
  }

  /// `Turn your answers into a shared guide.`
  String get houseNormPromptSubtitle {
    return Intl.message(
      'Turn your answers into a shared guide.',
      name: 'houseNormPromptSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Generate`
  String get houseNormPromptCta {
    return Intl.message(
      'Generate',
      name: 'houseNormPromptCta',
      desc: '',
      args: [],
    );
  }

  /// `House vibe`
  String get houseNormOnboardingTitle {
    return Intl.message(
      'House vibe',
      name: 'houseNormOnboardingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get houseNormOnboardingBack {
    return Intl.message(
      'Back',
      name: 'houseNormOnboardingBack',
      desc: '',
      args: [],
    );
  }

  /// `Generate`
  String get houseNormOnboardingSubmit {
    return Intl.message(
      'Generate',
      name: 'houseNormOnboardingSubmit',
      desc: '',
      args: [],
    );
  }

  /// `{current}/{total}`
  String houseNormOnboardingProgress(int current, int total) {
    return Intl.message(
      '$current/$total',
      name: 'houseNormOnboardingProgress',
      desc: 'Progress for house norms onboarding',
      args: [current, total],
    );
  }

  /// `Couldn't generate house norms right now.`
  String get houseNormGenerationFailed {
    return Intl.message(
      'Couldn\'t generate house norms right now.',
      name: 'houseNormGenerationFailed',
      desc: '',
      args: [],
    );
  }

  /// `House norms`
  String get houseNormReportTitle {
    return Intl.message(
      'House norms',
      name: 'houseNormReportTitle',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get houseNormDoneCta {
    return Intl.message('Done', name: 'houseNormDoneCta', desc: '', args: []);
  }

  /// `Edit house norms`
  String get houseNormEditTitle {
    return Intl.message(
      'Edit house norms',
      name: 'houseNormEditTitle',
      desc: '',
      args: [],
    );
  }

  /// `View house norms`
  String get houseNormViewTitle {
    return Intl.message(
      'View house norms',
      name: 'houseNormViewTitle',
      desc: '',
      args: [],
    );
  }

  /// `House norms not ready`
  String get houseNormReportEmptyTitle {
    return Intl.message(
      'House norms not ready',
      name: 'houseNormReportEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Generate house norms to see them.`
  String get houseNormReportEmptyBody {
    return Intl.message(
      'Generate house norms to see them.',
      name: 'houseNormReportEmptyBody',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load house norms`
  String get houseNormReportErrorTitle {
    return Intl.message(
      'Couldn\'t load house norms',
      name: 'houseNormReportErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please try again.`
  String get houseNormReportErrorBody {
    return Intl.message(
      'Please try again.',
      name: 'houseNormReportErrorBody',
      desc: '',
      args: [],
    );
  }

  /// `Publish to web`
  String get houseNormPublishCta {
    return Intl.message(
      'Publish to web',
      name: 'houseNormPublishCta',
      desc: '',
      args: [],
    );
  }

  /// `Republish`
  String get houseNormRepublishCta {
    return Intl.message(
      'Republish',
      name: 'houseNormRepublishCta',
      desc: '',
      args: [],
    );
  }

  /// `Copy URL`
  String get houseNormCopyUrlCta {
    return Intl.message(
      'Copy URL',
      name: 'houseNormCopyUrlCta',
      desc: '',
      args: [],
    );
  }

  /// `Open URL`
  String get houseNormOpenUrlCta {
    return Intl.message(
      'Open URL',
      name: 'houseNormOpenUrlCta',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't open that URL.`
  String get houseNormOpenUrlError {
    return Intl.message(
      'Couldn\'t open that URL.',
      name: 'houseNormOpenUrlError',
      desc: '',
      args: [],
    );
  }

  /// `Share URL`
  String get houseNormShareUrlCta {
    return Intl.message(
      'Share URL',
      name: 'houseNormShareUrlCta',
      desc: '',
      args: [],
    );
  }

  /// `House norms URL copied.`
  String get houseNormUrlCopied {
    return Intl.message(
      'House norms URL copied.',
      name: 'houseNormUrlCopied',
      desc: '',
      args: [],
    );
  }

  /// `Our house norms`
  String get houseNormShareSubject {
    return Intl.message(
      'Our house norms',
      name: 'houseNormShareSubject',
      desc: '',
      args: [],
    );
  }

  /// `House norms`
  String get houseNormSummaryTitle {
    return Intl.message(
      'House norms',
      name: 'houseNormSummaryTitle',
      desc: '',
      args: [],
    );
  }

  /// `A guide, not a rulebook.`
  String get houseNormSummarySubtitle {
    return Intl.message(
      'A guide, not a rulebook.',
      name: 'houseNormSummarySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Summary`
  String get houseNormSummaryFramingLabel {
    return Intl.message(
      'Summary',
      name: 'houseNormSummaryFramingLabel',
      desc: '',
      args: [],
    );
  }

  /// `Rhythm and quiet`
  String get houseNormSectionRhythmQuietTitle {
    return Intl.message(
      'Rhythm and quiet',
      name: 'houseNormSectionRhythmQuietTitle',
      desc: '',
      args: [],
    );
  }

  /// `Shared spaces`
  String get houseNormSectionSharedSpacesTitle {
    return Intl.message(
      'Shared spaces',
      name: 'houseNormSectionSharedSpacesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Guests and social flow`
  String get houseNormSectionGuestsSocialTitle {
    return Intl.message(
      'Guests and social flow',
      name: 'houseNormSectionGuestsSocialTitle',
      desc: '',
      args: [],
    );
  }

  /// `Responsibility flow`
  String get houseNormSectionResponsibilityFlowTitle {
    return Intl.message(
      'Responsibility flow',
      name: 'houseNormSectionResponsibilityFlowTitle',
      desc: '',
      args: [],
    );
  }

  /// `Repair style`
  String get houseNormSectionRepairStyleTitle {
    return Intl.message(
      'Repair style',
      name: 'houseNormSectionRepairStyleTitle',
      desc: '',
      args: [],
    );
  }

  /// `Home identity`
  String get houseNormSectionHomeIdentityTitle {
    return Intl.message(
      'Home identity',
      name: 'houseNormSectionHomeIdentityTitle',
      desc: '',
      args: [],
    );
  }

  /// `Section`
  String get houseNormSectionFallbackTitle {
    return Intl.message(
      'Section',
      name: 'houseNormSectionFallbackTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit this section`
  String get houseNormSectionEditLabel {
    return Intl.message(
      'Edit this section',
      name: 'houseNormSectionEditLabel',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get houseNormSectionSaveCta {
    return Intl.message(
      'Save',
      name: 'houseNormSectionSaveCta',
      desc: '',
      args: [],
    );
  }

  /// `Add text before saving.`
  String get houseNormSectionEmptyError {
    return Intl.message(
      'Add text before saving.',
      name: 'houseNormSectionEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `Section updated.`
  String get houseNormSectionSaveSuccess {
    return Intl.message(
      'Section updated.',
      name: 'houseNormSectionSaveSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't save that update.`
  String get houseNormSectionSaveFailed {
    return Intl.message(
      'Couldn\'t save that update.',
      name: 'houseNormSectionSaveFailed',
      desc: '',
      args: [],
    );
  }

  /// `House norms`
  String get hubHouseNormsTitle {
    return Intl.message(
      'House norms',
      name: 'hubHouseNormsTitle',
      desc: '',
      args: [],
    );
  }

  /// `A guide for how this home works.`
  String get hubHouseNormsSubtitle {
    return Intl.message(
      'A guide for how this home works.',
      name: 'hubHouseNormsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `This home is:`
  String get houseNormScenarioPropertyContextQuestion {
    return Intl.message(
      'This home is:',
      name: 'houseNormScenarioPropertyContextQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Owned`
  String get houseNormScenarioPropertyContextOption1 {
    return Intl.message(
      'Owned',
      name: 'houseNormScenarioPropertyContextOption1',
      desc: '',
      args: [],
    );
  }

  /// `Whole rental`
  String get houseNormScenarioPropertyContextOption2 {
    return Intl.message(
      'Whole rental',
      name: 'houseNormScenarioPropertyContextOption2',
      desc: '',
      args: [],
    );
  }

  /// `Room rental`
  String get houseNormScenarioPropertyContextOption3 {
    return Intl.message(
      'Room rental',
      name: 'houseNormScenarioPropertyContextOption3',
      desc: '',
      args: [],
    );
  }

  /// `Who's living here?`
  String get houseNormScenarioRelationshipModelQuestion {
    return Intl.message(
      'Who\'s living here?',
      name: 'houseNormScenarioRelationshipModelQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Housemates`
  String get houseNormScenarioRelationshipModelOption1 {
    return Intl.message(
      'Housemates',
      name: 'houseNormScenarioRelationshipModelOption1',
      desc: '',
      args: [],
    );
  }

  /// `Family`
  String get houseNormScenarioRelationshipModelOption2 {
    return Intl.message(
      'Family',
      name: 'houseNormScenarioRelationshipModelOption2',
      desc: '',
      args: [],
    );
  }

  /// `Mixed`
  String get houseNormScenarioRelationshipModelOption3 {
    return Intl.message(
      'Mixed',
      name: 'houseNormScenarioRelationshipModelOption3',
      desc: '',
      args: [],
    );
  }

  /// `At night?`
  String get houseNormScenarioRhythmQuestion {
    return Intl.message(
      'At night?',
      name: 'houseNormScenarioRhythmQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Wind down`
  String get houseNormScenarioRhythmOption1 {
    return Intl.message(
      'Wind down',
      name: 'houseNormScenarioRhythmOption1',
      desc: '',
      args: [],
    );
  }

  /// `Depends`
  String get houseNormScenarioRhythmOption2 {
    return Intl.message(
      'Depends',
      name: 'houseNormScenarioRhythmOption2',
      desc: '',
      args: [],
    );
  }

  /// `People do their thing`
  String get houseNormScenarioRhythmOption3 {
    return Intl.message(
      'People do their thing',
      name: 'houseNormScenarioRhythmOption3',
      desc: '',
      args: [],
    );
  }

  /// `Kitchen at night?`
  String get houseNormScenarioSharedSpacesQuestion {
    return Intl.message(
      'Kitchen at night?',
      name: 'houseNormScenarioSharedSpacesQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Clean`
  String get houseNormScenarioSharedSpacesOption1 {
    return Intl.message(
      'Clean',
      name: 'houseNormScenarioSharedSpacesOption1',
      desc: '',
      args: [],
    );
  }

  /// `Lived-in`
  String get houseNormScenarioSharedSpacesOption2 {
    return Intl.message(
      'Lived-in',
      name: 'houseNormScenarioSharedSpacesOption2',
      desc: '',
      args: [],
    );
  }

  /// `Messy is fine`
  String get houseNormScenarioSharedSpacesOption3 {
    return Intl.message(
      'Messy is fine',
      name: 'houseNormScenarioSharedSpacesOption3',
      desc: '',
      args: [],
    );
  }

  /// `Bringing guests?`
  String get houseNormScenarioGuestsQuestion {
    return Intl.message(
      'Bringing guests?',
      name: 'houseNormScenarioGuestsQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Ask first`
  String get houseNormScenarioGuestsOption1 {
    return Intl.message(
      'Ask first',
      name: 'houseNormScenarioGuestsOption1',
      desc: '',
      args: [],
    );
  }

  /// `Give a heads-up`
  String get houseNormScenarioGuestsOption2 {
    return Intl.message(
      'Give a heads-up',
      name: 'houseNormScenarioGuestsOption2',
      desc: '',
      args: [],
    );
  }

  /// `Totally normal`
  String get houseNormScenarioGuestsOption3 {
    return Intl.message(
      'Totally normal',
      name: 'houseNormScenarioGuestsOption3',
      desc: '',
      args: [],
    );
  }

  /// `Small home tasks?`
  String get houseNormScenarioResponsibilityQuestion {
    return Intl.message(
      'Small home tasks?',
      name: 'houseNormScenarioResponsibilityQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Clear agreements`
  String get houseNormScenarioResponsibilityOption1 {
    return Intl.message(
      'Clear agreements',
      name: 'houseNormScenarioResponsibilityOption1',
      desc: '',
      args: [],
    );
  }

  /// `Whoever notices`
  String get houseNormScenarioResponsibilityOption2 {
    return Intl.message(
      'Whoever notices',
      name: 'houseNormScenarioResponsibilityOption2',
      desc: '',
      args: [],
    );
  }

  /// `Everyone handles their own`
  String get houseNormScenarioResponsibilityOption3 {
    return Intl.message(
      'Everyone handles their own',
      name: 'houseNormScenarioResponsibilityOption3',
      desc: '',
      args: [],
    );
  }

  /// `Tension?`
  String get houseNormScenarioRepairQuestion {
    return Intl.message(
      'Tension?',
      name: 'houseNormScenarioRepairQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Talk early`
  String get houseNormScenarioRepairOption1 {
    return Intl.message(
      'Talk early',
      name: 'houseNormScenarioRepairOption1',
      desc: '',
      args: [],
    );
  }

  /// `Pick the moment`
  String get houseNormScenarioRepairOption2 {
    return Intl.message(
      'Pick the moment',
      name: 'houseNormScenarioRepairOption2',
      desc: '',
      args: [],
    );
  }

  /// `Let small things pass`
  String get houseNormScenarioRepairOption3 {
    return Intl.message(
      'Let small things pass',
      name: 'houseNormScenarioRepairOption3',
      desc: '',
      args: [],
    );
  }

  /// `Best description?`
  String get houseNormScenarioHomeIdentityQuestion {
    return Intl.message(
      'Best description?',
      name: 'houseNormScenarioHomeIdentityQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Calm home`
  String get houseNormScenarioHomeIdentityOption1 {
    return Intl.message(
      'Calm home',
      name: 'houseNormScenarioHomeIdentityOption1',
      desc: '',
      args: [],
    );
  }

  /// `Balanced home`
  String get houseNormScenarioHomeIdentityOption2 {
    return Intl.message(
      'Balanced home',
      name: 'houseNormScenarioHomeIdentityOption2',
      desc: '',
      args: [],
    );
  }

  /// `Social home`
  String get houseNormScenarioHomeIdentityOption3 {
    return Intl.message(
      'Social home',
      name: 'houseNormScenarioHomeIdentityOption3',
      desc: '',
      args: [],
    );
  }

  /// `Got it.`
  String get reflectiveAcknowledgementTitle {
    return Intl.message(
      'Got it.',
      name: 'reflectiveAcknowledgementTitle',
      desc: '',
      args: [],
    );
  }

  /// `Reflecting what you shared.`
  String get reflectivePersonalPrimary {
    return Intl.message(
      'Reflecting what you shared.',
      name: 'reflectivePersonalPrimary',
      desc: '',
      args: [],
    );
  }

  /// `So others understand what feels comfortable to you.`
  String get reflectivePersonalSecondary {
    return Intl.message(
      'So others understand what feels comfortable to you.',
      name: 'reflectivePersonalSecondary',
      desc: '',
      args: [],
    );
  }

  /// `Putting your home's expectations into words.`
  String get reflectiveHousePrimary {
    return Intl.message(
      'Putting your home\'s expectations into words.',
      name: 'reflectiveHousePrimary',
      desc: '',
      args: [],
    );
  }

  /// `So expectations are clear.`
  String get reflectiveHouseSecondary {
    return Intl.message(
      'So expectations are clear.',
      name: 'reflectiveHouseSecondary',
      desc: '',
      args: [],
    );
  }

  /// `Reflecting what this home shared.`
  String get reflectiveHouseNormsPrimary {
    return Intl.message(
      'Reflecting what this home shared.',
      name: 'reflectiveHouseNormsPrimary',
      desc: '',
      args: [],
    );
  }

  /// `A shared guide, not a rulebook.`
  String get reflectiveHouseNormsSecondary {
    return Intl.message(
      'A shared guide, not a rulebook.',
      name: 'reflectiveHouseNormsSecondary',
      desc: '',
      args: [],
    );
  }

  /// `Putting this together with care.`
  String get reflectiveGenericPrimary {
    return Intl.message(
      'Putting this together with care.',
      name: 'reflectiveGenericPrimary',
      desc: '',
      args: [],
    );
  }

  /// `A short pause before we show it.`
  String get reflectiveGenericSecondary {
    return Intl.message(
      'A short pause before we show it.',
      name: 'reflectiveGenericSecondary',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't finish your preference reflection. Try again soon.`
  String get preferenceReportGenerationMissing {
    return Intl.message(
      'Couldn\'t finish your preference reflection. Try again soon.',
      name: 'preferenceReportGenerationMissing',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't finish your preference reflection. Go back and try again.`
  String get preferenceReportGenerationFailed {
    return Intl.message(
      'Couldn\'t finish your preference reflection. Go back and try again.',
      name: 'preferenceReportGenerationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Your profile`
  String get personalProfileTitle {
    return Intl.message(
      'Your profile',
      name: 'personalProfileTitle',
      desc: '',
      args: [],
    );
  }

  /// `Personal preferences`
  String get personalProfilePreferences {
    return Intl.message(
      'Personal preferences',
      name: 'personalProfilePreferences',
      desc: '',
      args: [],
    );
  }

  /// `Personal mentions`
  String get personalProfileMentions {
    return Intl.message(
      'Personal mentions',
      name: 'personalProfileMentions',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load your personal profile.`
  String get personalProfileLoadError {
    return Intl.message(
      'Couldn\'t load your personal profile.',
      name: 'personalProfileLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Personal mentions`
  String get personalMentionsTitle {
    return Intl.message(
      'Personal mentions',
      name: 'personalMentionsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Weekly home pulse`
  String get housePulseCardHeader {
    return Intl.message(
      'Weekly home pulse',
      name: 'housePulseCardHeader',
      desc: '',
      args: [],
    );
  }

  /// `Share pulse`
  String get housePulseShareCta {
    return Intl.message(
      'Share pulse',
      name: 'housePulseShareCta',
      desc: '',
      args: [],
    );
  }

  /// `Sharing our Kinly home pulse`
  String get housePulseShareTitle {
    return Intl.message(
      'Sharing our Kinly home pulse',
      name: 'housePulseShareTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sharing our Kinly home pulse. Download the app: {link}`
  String housePulseShareMessage(String link) {
    return Intl.message(
      'Sharing our Kinly home pulse. Download the app: $link',
      name: 'housePulseShareMessage',
      desc: '',
      args: [link],
    );
  }

  /// `Updated {date}`
  String housePulseUpdatedOn(String date) {
    return Intl.message(
      'Updated $date',
      name: 'housePulseUpdatedOn',
      desc: '',
      args: [date],
    );
  }

  /// `Still forming`
  String get pulseFormingTitle {
    return Intl.message(
      'Still forming',
      name: 'pulseFormingTitle',
      desc: '',
      args: [],
    );
  }

  /// `A few more check-ins will give a clearer picture.`
  String get pulseFormingSummary {
    return Intl.message(
      'A few more check-ins will give a clearer picture.',
      name: 'pulseFormingSummary',
      desc: '',
      args: [],
    );
  }

  /// `Running smoothly`
  String get pulseSunnyCalmTitle {
    return Intl.message(
      'Running smoothly',
      name: 'pulseSunnyCalmTitle',
      desc: '',
      args: [],
    );
  }

  /// `Things felt smooth this week.`
  String get pulseSunnyCalmSummary {
    return Intl.message(
      'Things felt smooth this week.',
      name: 'pulseSunnyCalmSummary',
      desc: '',
      args: [],
    );
  }

  /// `Mostly smooth`
  String get pulseSunnyBumpyTitle {
    return Intl.message(
      'Mostly smooth',
      name: 'pulseSunnyBumpyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Mostly smooth, with a few bumps.`
  String get pulseSunnyBumpySummary {
    return Intl.message(
      'Mostly smooth, with a few bumps.',
      name: 'pulseSunnyBumpySummary',
      desc: '',
      args: [],
    );
  }

  /// `Okay overall`
  String get pulsePartlySupportedTitle {
    return Intl.message(
      'Okay overall',
      name: 'pulsePartlySupportedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Mostly steady, with some room to improve.`
  String get pulsePartlySupportedSummary {
    return Intl.message(
      'Mostly steady, with some room to improve.',
      name: 'pulsePartlySupportedSummary',
      desc: '',
      args: [],
    );
  }

  /// `Mixed`
  String get pulseCloudySteadyTitle {
    return Intl.message(
      'Mixed',
      name: 'pulseCloudySteadyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Some things worked. Some didn't.`
  String get pulseCloudySteadySummary {
    return Intl.message(
      'Some things worked. Some didn\'t.',
      name: 'pulseCloudySteadySummary',
      desc: '',
      args: [],
    );
  }

  /// `Needs attention`
  String get pulseCloudyTenseTitle {
    return Intl.message(
      'Needs attention',
      name: 'pulseCloudyTenseTitle',
      desc: '',
      args: [],
    );
  }

  /// `Some tension came up this week.`
  String get pulseCloudyTenseSummary {
    return Intl.message(
      'Some tension came up this week.',
      name: 'pulseCloudyTenseSummary',
      desc: '',
      args: [],
    );
  }

  /// `Reset recommended`
  String get pulseRainySupportedTitle {
    return Intl.message(
      'Reset recommended',
      name: 'pulseRainySupportedTitle',
      desc: '',
      args: [],
    );
  }

  /// `It may be time for a small reset.`
  String get pulseRainySupportedSummary {
    return Intl.message(
      'It may be time for a small reset.',
      name: 'pulseRainySupportedSummary',
      desc: '',
      args: [],
    );
  }

  /// `Reset needed`
  String get pulseRainyUnsupportedTitle {
    return Intl.message(
      'Reset needed',
      name: 'pulseRainyUnsupportedTitle',
      desc: '',
      args: [],
    );
  }

  /// `There's noticeable friction right now.`
  String get pulseRainyUnsupportedSummary {
    return Intl.message(
      'There\'s noticeable friction right now.',
      name: 'pulseRainyUnsupportedSummary',
      desc: '',
      args: [],
    );
  }

  /// `Tension high`
  String get pulseThunderstormTitle {
    return Intl.message(
      'Tension high',
      name: 'pulseThunderstormTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tension is high. Reset soon.`
  String get pulseThunderstormSummary {
    return Intl.message(
      'Tension is high. Reset soon.',
      name: 'pulseThunderstormSummary',
      desc: '',
      args: [],
    );
  }

  /// `Send calmly with Kinly`
  String get weeklyRewriteCta {
    return Intl.message(
      'Send calmly with Kinly',
      name: 'weeklyRewriteCta',
      desc: '',
      args: [],
    );
  }

  /// `Add a short note before sending this mention.`
  String get harmonyErrorCommentRequiredForMention {
    return Intl.message(
      'Add a short note before sending this mention.',
      name: 'harmonyErrorCommentRequiredForMention',
      desc: '',
      args: [],
    );
  }

  /// `Choose one person for this note.`
  String get harmonyErrorSingleMentionRequired {
    return Intl.message(
      'Choose one person for this note.',
      name: 'harmonyErrorSingleMentionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Add a short note before posting this shoutout.`
  String get harmonyErrorCommentRequiredForPublicWall {
    return Intl.message(
      'Add a short note before posting this shoutout.',
      name: 'harmonyErrorCommentRequiredForPublicWall',
      desc: '',
      args: [],
    );
  }

  /// `Add a bit more detail.`
  String get harmonyErrorComplaintTooShort {
    return Intl.message(
      'Add a bit more detail.',
      name: 'harmonyErrorComplaintTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Write a short sentence so it's clear.`
  String get harmonyErrorComplaintTooBrief {
    return Intl.message(
      'Write a short sentence so it\'s clear.',
      name: 'harmonyErrorComplaintTooBrief',
      desc: '',
      args: [],
    );
  }

  /// `Add a clear sentence.`
  String get harmonyErrorComplaintNeedsSentence {
    return Intl.message(
      'Add a clear sentence.',
      name: 'harmonyErrorComplaintNeedsSentence',
      desc: '',
      args: [],
    );
  }

  /// `Demo Access`
  String get demoAccess {
    return Intl.message(
      'Demo Access',
      name: 'demoAccess',
      desc: 'Title for the demo access screen used by app store reviewers',
      args: [],
    );
  }

  /// `Demo access: {current} of 7 taps`
  String demoAccessTapHint(int current) {
    return Intl.message(
      'Demo access: $current of 7 taps',
      name: 'demoAccessTapHint',
      desc: 'Progress indicator shown when tapping logo to reveal demo access',
      args: [current],
    );
  }

  /// `Email`
  String get demoAccessEmail {
    return Intl.message(
      'Email',
      name: 'demoAccessEmail',
      desc: 'Label for email input on demo access screen',
      args: [],
    );
  }

  /// `Password`
  String get demoAccessPassword {
    return Intl.message(
      'Password',
      name: 'demoAccessPassword',
      desc: 'Label for password input on demo access screen',
      args: [],
    );
  }

  /// `Sign in`
  String get demoAccessSubmit {
    return Intl.message(
      'Sign in',
      name: 'demoAccessSubmit',
      desc: 'Submit button label on demo access screen',
      args: [],
    );
  }

  /// `Couldn't sign in. Check your credentials.`
  String get demoAccessError {
    return Intl.message(
      'Couldn\'t sign in. Check your credentials.',
      name: 'demoAccessError',
      desc: 'Error message shown when demo login does not succeed',
      args: [],
    );
  }

  /// `Upgrade to Premium`
  String get planFreeLabel {
    return Intl.message(
      'Upgrade to Premium',
      name: 'planFreeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Premium`
  String get planPremiumLabel {
    return Intl.message(
      'Premium',
      name: 'planPremiumLabel',
      desc: '',
      args: [],
    );
  }

  /// `You're on Premium`
  String get planPremiumActiveTitle {
    return Intl.message(
      'You\'re on Premium',
      name: 'planPremiumActiveTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enjoy unlimited access to all features.`
  String get planPremiumActiveBody {
    return Intl.message(
      'Enjoy unlimited access to all features.',
      name: 'planPremiumActiveBody',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `House directory`
  String get houseDirectoryTitle {
    return Intl.message(
      'House directory',
      name: 'houseDirectoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load House directory.`
  String get houseDirectoryLoadError {
    return Intl.message(
      'Couldn\'t load House directory.',
      name: 'houseDirectoryLoadError',
      desc: '',
      args: [],
    );
  }

  /// `House directory`
  String get hubHouseDirectoryTitle {
    return Intl.message(
      'House directory',
      name: 'hubHouseDirectoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Wifi, services, notes, and renewal reminders.`
  String get hubHouseDirectorySubtitle {
    return Intl.message(
      'Wifi, services, notes, and renewal reminders.',
      name: 'hubHouseDirectorySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Shared home details live here.`
  String get houseDirectoryEmptyTitle {
    return Intl.message(
      'Shared home details live here.',
      name: 'houseDirectoryEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Save wifi, rent, services, and house notes here.`
  String get houseDirectoryEmptyBody {
    return Intl.message(
      'Save wifi, rent, services, and house notes here.',
      name: 'houseDirectoryEmptyBody',
      desc: '',
      args: [],
    );
  }

  /// `Wifi`
  String get houseDirectoryWifiTitle {
    return Intl.message(
      'Wifi',
      name: 'houseDirectoryWifiTitle',
      desc: '',
      args: [],
    );
  }

  /// `Rent`
  String get houseDirectoryRentTitle {
    return Intl.message(
      'Rent',
      name: 'houseDirectoryRentTitle',
      desc: '',
      args: [],
    );
  }

  /// `Services`
  String get houseDirectoryServicesTitle {
    return Intl.message(
      'Services',
      name: 'houseDirectoryServicesTitle',
      desc: '',
      args: [],
    );
  }

  /// `House notes`
  String get houseDirectoryNotesTitle {
    return Intl.message(
      'House notes',
      name: 'houseDirectoryNotesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tutorials`
  String get houseDirectoryTutorialsTitle {
    return Intl.message(
      'Tutorials',
      name: 'houseDirectoryTutorialsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Search home details`
  String get houseDirectorySearchLabel {
    return Intl.message(
      'Search home details',
      name: 'houseDirectorySearchLabel',
      desc: '',
      args: [],
    );
  }

  /// `Find services or notes`
  String get houseDirectorySearchHint {
    return Intl.message(
      'Find services or notes',
      name: 'houseDirectorySearchHint',
      desc: '',
      args: [],
    );
  }

  /// `Searching all house details`
  String get houseDirectorySearchingAll {
    return Intl.message(
      'Searching all house details',
      name: 'houseDirectorySearchingAll',
      desc: '',
      args: [],
    );
  }

  /// `No services, notes, or tutorials match that search.`
  String get houseDirectorySearchAllEmpty {
    return Intl.message(
      'No services, notes, or tutorials match that search.',
      name: 'houseDirectorySearchAllEmpty',
      desc: '',
      args: [],
    );
  }

  /// `No services match that search.`
  String get houseDirectoryServicesSearchEmpty {
    return Intl.message(
      'No services match that search.',
      name: 'houseDirectoryServicesSearchEmpty',
      desc: '',
      args: [],
    );
  }

  /// `No notes match that search.`
  String get houseDirectoryNotesSearchEmpty {
    return Intl.message(
      'No notes match that search.',
      name: 'houseDirectoryNotesSearchEmpty',
      desc: '',
      args: [],
    );
  }

  /// `No tutorials match that search.`
  String get houseDirectoryTutorialsSearchEmpty {
    return Intl.message(
      'No tutorials match that search.',
      name: 'houseDirectoryTutorialsSearchEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Add wifi`
  String get houseDirectoryAddWifi {
    return Intl.message(
      'Add wifi',
      name: 'houseDirectoryAddWifi',
      desc: '',
      args: [],
    );
  }

  /// `Edit wifi`
  String get houseDirectoryEditWifi {
    return Intl.message(
      'Edit wifi',
      name: 'houseDirectoryEditWifi',
      desc: '',
      args: [],
    );
  }

  /// `Add service`
  String get houseDirectoryAddService {
    return Intl.message(
      'Add service',
      name: 'houseDirectoryAddService',
      desc: '',
      args: [],
    );
  }

  /// `Edit service`
  String get houseDirectoryEditService {
    return Intl.message(
      'Edit service',
      name: 'houseDirectoryEditService',
      desc: '',
      args: [],
    );
  }

  /// `Add note`
  String get houseDirectoryAddNote {
    return Intl.message(
      'Add note',
      name: 'houseDirectoryAddNote',
      desc: '',
      args: [],
    );
  }

  /// `Add tutorial`
  String get houseDirectoryAddTutorial {
    return Intl.message(
      'Add tutorial',
      name: 'houseDirectoryAddTutorial',
      desc: '',
      args: [],
    );
  }

  /// `Edit note`
  String get houseDirectoryEditNote {
    return Intl.message(
      'Edit note',
      name: 'houseDirectoryEditNote',
      desc: '',
      args: [],
    );
  }

  /// `Edit tutorial`
  String get houseDirectoryEditTutorial {
    return Intl.message(
      'Edit tutorial',
      name: 'houseDirectoryEditTutorial',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get houseDirectorySave {
    return Intl.message('Save', name: 'houseDirectorySave', desc: '', args: []);
  }

  /// `Edit`
  String get houseDirectoryEdit {
    return Intl.message('Edit', name: 'houseDirectoryEdit', desc: '', args: []);
  }

  /// `Archive`
  String get houseDirectoryDelete {
    return Intl.message(
      'Archive',
      name: 'houseDirectoryDelete',
      desc: '',
      args: [],
    );
  }

  /// `Add your home wifi so everyone can find it here.`
  String get houseDirectoryWifiOwnerEmpty {
    return Intl.message(
      'Add your home wifi so everyone can find it here.',
      name: 'houseDirectoryWifiOwnerEmpty',
      desc: '',
      args: [],
    );
  }

  /// `No wifi details have been added yet.`
  String get houseDirectoryWifiMemberEmpty {
    return Intl.message(
      'No wifi details have been added yet.',
      name: 'houseDirectoryWifiMemberEmpty',
      desc: '',
      args: [],
    );
  }

  /// `No services added yet.`
  String get houseDirectoryServicesEmpty {
    return Intl.message(
      'No services added yet.',
      name: 'houseDirectoryServicesEmpty',
      desc: '',
      args: [],
    );
  }

  /// `No notes added yet.`
  String get houseDirectoryNotesEmpty {
    return Intl.message(
      'No notes added yet.',
      name: 'houseDirectoryNotesEmpty',
      desc: '',
      args: [],
    );
  }

  /// `No tutorials added yet.`
  String get houseDirectoryTutorialsEmpty {
    return Intl.message(
      'No tutorials added yet.',
      name: 'houseDirectoryTutorialsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get houseDirectoryServiceOther {
    return Intl.message(
      'Other',
      name: 'houseDirectoryServiceOther',
      desc: '',
      args: [],
    );
  }

  /// `{start} to {end}`
  String houseDirectoryTermRange(String start, String end) {
    return Intl.message(
      '$start to $end',
      name: 'houseDirectoryTermRange',
      desc: '',
      args: [start, end],
    );
  }

  /// `Unknown`
  String get houseDirectoryDateUnknown {
    return Intl.message(
      'Unknown',
      name: 'houseDirectoryDateUnknown',
      desc: '',
      args: [],
    );
  }

  /// `Open link`
  String get houseDirectoryOpenLink {
    return Intl.message(
      'Open link',
      name: 'houseDirectoryOpenLink',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't open that link.`
  String get houseDirectoryOpenLinkError {
    return Intl.message(
      'Couldn\'t open that link.',
      name: 'houseDirectoryOpenLinkError',
      desc: '',
      args: [],
    );
  }

  /// `Term`
  String get houseDirectoryTermLabel {
    return Intl.message(
      'Term',
      name: 'houseDirectoryTermLabel',
      desc: '',
      args: [],
    );
  }

  /// `SSID`
  String get houseDirectorySsidLabel {
    return Intl.message(
      'SSID',
      name: 'houseDirectorySsidLabel',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get houseDirectoryPasswordLabel {
    return Intl.message(
      'Password',
      name: 'houseDirectoryPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Leave blank to save as an open network.`
  String get houseDirectoryPasswordHelper {
    return Intl.message(
      'Leave blank to save as an open network.',
      name: 'houseDirectoryPasswordHelper',
      desc: '',
      args: [],
    );
  }

  /// `Service type`
  String get houseDirectoryServiceTypeLabel {
    return Intl.message(
      'Service type',
      name: 'houseDirectoryServiceTypeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Custom label`
  String get houseDirectoryCustomLabel {
    return Intl.message(
      'Custom label',
      name: 'houseDirectoryCustomLabel',
      desc: '',
      args: [],
    );
  }

  /// `Use a clear name like cleaner, parking, or storage`
  String get houseDirectoryCustomLabelHint {
    return Intl.message(
      'Use a clear name like cleaner, parking, or storage',
      name: 'houseDirectoryCustomLabelHint',
      desc: '',
      args: [],
    );
  }

  /// `Provider name`
  String get houseDirectoryProviderLabel {
    return Intl.message(
      'Provider name',
      name: 'houseDirectoryProviderLabel',
      desc: '',
      args: [],
    );
  }

  /// `Who runs this service, like your power company`
  String get houseDirectoryProviderHint {
    return Intl.message(
      'Who runs this service, like your power company',
      name: 'houseDirectoryProviderHint',
      desc: '',
      args: [],
    );
  }

  /// `Account reference`
  String get houseDirectoryAccountReferenceLabel {
    return Intl.message(
      'Account reference',
      name: 'houseDirectoryAccountReferenceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add the account number or customer ID`
  String get houseDirectoryAccountReferenceHint {
    return Intl.message(
      'Add the account number or customer ID',
      name: 'houseDirectoryAccountReferenceHint',
      desc: '',
      args: [],
    );
  }

  /// `Provider link`
  String get houseDirectoryLinkLabel {
    return Intl.message(
      'Provider link',
      name: 'houseDirectoryLinkLabel',
      desc: '',
      args: [],
    );
  }

  /// `Paste the login, portal, or payment link for this service`
  String get houseDirectoryProviderLinkHint {
    return Intl.message(
      'Paste the login, portal, or payment link for this service',
      name: 'houseDirectoryProviderLinkHint',
      desc: '',
      args: [],
    );
  }

  /// `Start date`
  String get houseDirectoryStartDate {
    return Intl.message(
      'Start date',
      name: 'houseDirectoryStartDate',
      desc: '',
      args: [],
    );
  }

  /// `End date`
  String get houseDirectoryEndDate {
    return Intl.message(
      'End date',
      name: 'houseDirectoryEndDate',
      desc: '',
      args: [],
    );
  }

  /// `Reminder offset`
  String get houseDirectoryReminderOffset {
    return Intl.message(
      'Reminder offset',
      name: 'houseDirectoryReminderOffset',
      desc: '',
      args: [],
    );
  }

  /// `Offset unit`
  String get houseDirectoryReminderOffsetUnit {
    return Intl.message(
      'Offset unit',
      name: 'houseDirectoryReminderOffsetUnit',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get houseDirectoryNotes {
    return Intl.message(
      'Notes',
      name: 'houseDirectoryNotes',
      desc: '',
      args: [],
    );
  }

  /// `Add helpful details, like billing dates or contact steps`
  String get houseDirectoryNotesHint {
    return Intl.message(
      'Add helpful details, like billing dates or contact steps',
      name: 'houseDirectoryNotesHint',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get houseDirectoryTitleLabel {
    return Intl.message(
      'Title',
      name: 'houseDirectoryTitleLabel',
      desc: '',
      args: [],
    );
  }

  /// `Name the note so everyone knows what it covers`
  String get houseDirectoryNoteTitleHint {
    return Intl.message(
      'Name the note so everyone knows what it covers',
      name: 'houseDirectoryNoteTitleHint',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get houseDirectoryNoteDetailsLabel {
    return Intl.message(
      'Details',
      name: 'houseDirectoryNoteDetailsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add clear details for the home`
  String get houseDirectoryNoteDetailsHint {
    return Intl.message(
      'Add clear details for the home',
      name: 'houseDirectoryNoteDetailsHint',
      desc: '',
      args: [],
    );
  }

  /// `Photo`
  String get houseDirectoryNotePhotoLabel {
    return Intl.message(
      'Photo',
      name: 'houseDirectoryNotePhotoLabel',
      desc: '',
      args: [],
    );
  }

  /// `Replace photo`
  String get houseDirectoryNotePhotoReplaceLabel {
    return Intl.message(
      'Replace photo',
      name: 'houseDirectoryNotePhotoReplaceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add a photo for this note`
  String get houseDirectoryNotePhotoPlaceholder {
    return Intl.message(
      'Add a photo for this note',
      name: 'houseDirectoryNotePhotoPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't upload that photo.`
  String get houseDirectoryNotePhotoUploadError {
    return Intl.message(
      'Couldn\'t upload that photo.',
      name: 'houseDirectoryNotePhotoUploadError',
      desc: '',
      args: [],
    );
  }

  /// `Photo`
  String get houseDirectoryPhotoViewerTitle {
    return Intl.message(
      'Photo',
      name: 'houseDirectoryPhotoViewerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Reference URL`
  String get houseDirectoryNoteUrlLabel {
    return Intl.message(
      'Reference URL',
      name: 'houseDirectoryNoteUrlLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid http or https URL.`
  String get houseDirectoryNoteUrlHint {
    return Intl.message(
      'Enter a valid http or https URL.',
      name: 'houseDirectoryNoteUrlHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter a provider name.`
  String get houseDirectoryValidationProvider {
    return Intl.message(
      'Enter a provider name.',
      name: 'houseDirectoryValidationProvider',
      desc: '',
      args: [],
    );
  }

  /// `Enter a custom label.`
  String get houseDirectoryValidationCustomLabel {
    return Intl.message(
      'Enter a custom label.',
      name: 'houseDirectoryValidationCustomLabel',
      desc: '',
      args: [],
    );
  }

  /// `Rent needs both start and end dates.`
  String get houseDirectoryValidationRentDates {
    return Intl.message(
      'Rent needs both start and end dates.',
      name: 'houseDirectoryValidationRentDates',
      desc: '',
      args: [],
    );
  }

  /// `Pick an end date after the start date.`
  String get houseDirectoryValidationDateRange {
    return Intl.message(
      'Pick an end date after the start date.',
      name: 'houseDirectoryValidationDateRange',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid reminder offset.`
  String get houseDirectoryValidationReminderOffset {
    return Intl.message(
      'Enter a valid reminder offset.',
      name: 'houseDirectoryValidationReminderOffset',
      desc: '',
      args: [],
    );
  }

  /// `Enter a title.`
  String get houseDirectoryValidationNoteFields {
    return Intl.message(
      'Enter a title.',
      name: 'houseDirectoryValidationNoteFields',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid http or https URL.`
  String get houseDirectoryValidationUrl {
    return Intl.message(
      'Enter a valid http or https URL.',
      name: 'houseDirectoryValidationUrl',
      desc: '',
      args: [],
    );
  }

  /// `Archive`
  String get houseDirectoryArchiveConfirm {
    return Intl.message(
      'Archive',
      name: 'houseDirectoryArchiveConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Archive this note?`
  String get houseDirectoryArchiveNoteTitle {
    return Intl.message(
      'Archive this note?',
      name: 'houseDirectoryArchiveNoteTitle',
      desc: '',
      args: [],
    );
  }

  /// `This removes it from your House directory view.`
  String get houseDirectoryArchiveNoteBody {
    return Intl.message(
      'This removes it from your House directory view.',
      name: 'houseDirectoryArchiveNoteBody',
      desc: '',
      args: [],
    );
  }

  /// `Archive this service?`
  String get houseDirectoryArchiveServiceTitle {
    return Intl.message(
      'Archive this service?',
      name: 'houseDirectoryArchiveServiceTitle',
      desc: '',
      args: [],
    );
  }

  /// `This removes it from your House directory view.`
  String get houseDirectoryArchiveServiceBody {
    return Intl.message(
      'This removes it from your House directory view.',
      name: 'houseDirectoryArchiveServiceBody',
      desc: '',
      args: [],
    );
  }

  /// `Wifi details saved.`
  String get houseDirectoryWifiSaved {
    return Intl.message(
      'Wifi details saved.',
      name: 'houseDirectoryWifiSaved',
      desc: '',
      args: [],
    );
  }

  /// `Service saved.`
  String get houseDirectoryServiceSaved {
    return Intl.message(
      'Service saved.',
      name: 'houseDirectoryServiceSaved',
      desc: '',
      args: [],
    );
  }

  /// `Service archived.`
  String get houseDirectoryServiceArchived {
    return Intl.message(
      'Service archived.',
      name: 'houseDirectoryServiceArchived',
      desc: '',
      args: [],
    );
  }

  /// `Note saved.`
  String get houseDirectoryNoteSaved {
    return Intl.message(
      'Note saved.',
      name: 'houseDirectoryNoteSaved',
      desc: '',
      args: [],
    );
  }

  /// `Note archived.`
  String get houseDirectoryNoteArchived {
    return Intl.message(
      'Note archived.',
      name: 'houseDirectoryNoteArchived',
      desc: '',
      args: [],
    );
  }

  /// `Reminder acknowledged.`
  String get houseDirectoryReminderAcknowledged {
    return Intl.message(
      'Reminder acknowledged.',
      name: 'houseDirectoryReminderAcknowledged',
      desc: '',
      args: [],
    );
  }

  /// `Reminder dismissed.`
  String get houseDirectoryReminderDismissed {
    return Intl.message(
      'Reminder dismissed.',
      name: 'houseDirectoryReminderDismissed',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't save those changes.`
  String get houseDirectoryActionFailed {
    return Intl.message(
      'Couldn\'t save those changes.',
      name: 'houseDirectoryActionFailed',
      desc: '',
      args: [],
    );
  }

  /// `Renewal reminders`
  String get todayHouseDirectoryRemindersTitle {
    return Intl.message(
      'Renewal reminders',
      name: 'todayHouseDirectoryRemindersTitle',
      desc: '',
      args: [],
    );
  }

  /// `Reminder for {date}`
  String todayHouseDirectoryReminderDue(String date) {
    return Intl.message(
      'Reminder for $date',
      name: 'todayHouseDirectoryReminderDue',
      desc: '',
      args: [date],
    );
  }

  /// `Open directory`
  String get todayHouseDirectoryOpenCta {
    return Intl.message(
      'Open directory',
      name: 'todayHouseDirectoryOpenCta',
      desc: '',
      args: [],
    );
  }

  /// `Acknowledge`
  String get todayHouseDirectoryAcknowledgeCta {
    return Intl.message(
      'Acknowledge',
      name: 'todayHouseDirectoryAcknowledgeCta',
      desc: '',
      args: [],
    );
  }

  /// `Dismiss`
  String get todayHouseDirectoryDismissCta {
    return Intl.message(
      'Dismiss',
      name: 'todayHouseDirectoryDismissCta',
      desc: '',
      args: [],
    );
  }

  /// `Personal directory`
  String get personalProfilePersonalDirectory {
    return Intl.message(
      'Personal directory',
      name: 'personalProfilePersonalDirectory',
      desc: '',
      args: [],
    );
  }

  /// `Personal directory`
  String get personalDirectoryTitle {
    return Intl.message(
      'Personal directory',
      name: 'personalDirectoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Member`
  String get personalDirectoryFallbackName {
    return Intl.message(
      'Member',
      name: 'personalDirectoryFallbackName',
      desc: '',
      args: [],
    );
  }

  /// `Search notes`
  String get personalDirectorySearchLabel {
    return Intl.message(
      'Search notes',
      name: 'personalDirectorySearchLabel',
      desc: '',
      args: [],
    );
  }

  /// `Search notes`
  String get personalDirectorySearchHint {
    return Intl.message(
      'Search notes',
      name: 'personalDirectorySearchHint',
      desc: '',
      args: [],
    );
  }

  /// `Bank account`
  String get personalDirectoryBankTitle {
    return Intl.message(
      'Bank account',
      name: 'personalDirectoryBankTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add bank`
  String get personalDirectoryAddBank {
    return Intl.message(
      'Add bank',
      name: 'personalDirectoryAddBank',
      desc: '',
      args: [],
    );
  }

  /// `Edit bank`
  String get personalDirectoryEditBank {
    return Intl.message(
      'Edit bank',
      name: 'personalDirectoryEditBank',
      desc: '',
      args: [],
    );
  }

  /// `Account holder name`
  String get personalDirectoryAccountHolderLabel {
    return Intl.message(
      'Account holder name',
      name: 'personalDirectoryAccountHolderLabel',
      desc: '',
      args: [],
    );
  }

  /// `Account number`
  String get personalDirectoryAccountNumberLabel {
    return Intl.message(
      'Account number',
      name: 'personalDirectoryAccountNumberLabel',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get personalDirectorySave {
    return Intl.message(
      'Save',
      name: 'personalDirectorySave',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get personalDirectoryNotesTitle {
    return Intl.message(
      'Notes',
      name: 'personalDirectoryNotesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add note`
  String get personalDirectoryAddNote {
    return Intl.message(
      'Add note',
      name: 'personalDirectoryAddNote',
      desc: '',
      args: [],
    );
  }

  /// `Edit note`
  String get personalDirectoryEditNote {
    return Intl.message(
      'Edit note',
      name: 'personalDirectoryEditNote',
      desc: '',
      args: [],
    );
  }

  /// `Add emergency contacts, allergies, or other notes.`
  String get personalDirectoryNotesEmptySelf {
    return Intl.message(
      'Add emergency contacts, allergies, or other notes.',
      name: 'personalDirectoryNotesEmptySelf',
      desc: '',
      args: [],
    );
  }

  /// `No notes added yet.`
  String get personalDirectoryNotesEmptyOther {
    return Intl.message(
      'No notes added yet.',
      name: 'personalDirectoryNotesEmptyOther',
      desc: '',
      args: [],
    );
  }

  /// `No notes match that search.`
  String get personalDirectoryNotesSearchEmpty {
    return Intl.message(
      'No notes match that search.',
      name: 'personalDirectoryNotesSearchEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Emergency contact`
  String get personalDirectoryEmergencyContactTitle {
    return Intl.message(
      'Emergency contact',
      name: 'personalDirectoryEmergencyContactTitle',
      desc: '',
      args: [],
    );
  }

  /// `Allergy`
  String get personalDirectoryAllergyTitle {
    return Intl.message(
      'Allergy',
      name: 'personalDirectoryAllergyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get personalDirectoryOtherTitle {
    return Intl.message(
      'Other',
      name: 'personalDirectoryOtherTitle',
      desc: '',
      args: [],
    );
  }

  /// `Note type`
  String get personalDirectoryNoteTypeLabel {
    return Intl.message(
      'Note type',
      name: 'personalDirectoryNoteTypeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add one person to call fast.`
  String get personalDirectoryEmergencyContactHelp {
    return Intl.message(
      'Add one person to call fast.',
      name: 'personalDirectoryEmergencyContactHelp',
      desc: '',
      args: [],
    );
  }

  /// `Add an allergy so housemates know what to avoid.`
  String get personalDirectoryAllergyTypeHelp {
    return Intl.message(
      'Add an allergy so housemates know what to avoid.',
      name: 'personalDirectoryAllergyTypeHelp',
      desc: '',
      args: [],
    );
  }

  /// `Add another note that helps your housemates live with you.`
  String get personalDirectoryOtherTypeHelp {
    return Intl.message(
      'Add another note that helps your housemates live with you.',
      name: 'personalDirectoryOtherTypeHelp',
      desc: '',
      args: [],
    );
  }

  /// `Contact name`
  String get personalDirectoryContactNameLabel {
    return Intl.message(
      'Contact name',
      name: 'personalDirectoryContactNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Who can a housemate contact in an emergency?`
  String get personalDirectoryContactNameHelp {
    return Intl.message(
      'Who can a housemate contact in an emergency?',
      name: 'personalDirectoryContactNameHelp',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get personalDirectoryPhoneNumberLabel {
    return Intl.message(
      'Phone number',
      name: 'personalDirectoryPhoneNumberLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add the best number to call or text for this person.`
  String get personalDirectoryPhoneNumberHelp {
    return Intl.message(
      'Add the best number to call or text for this person.',
      name: 'personalDirectoryPhoneNumberHelp',
      desc: '',
      args: [],
    );
  }

  /// `Allergy`
  String get personalDirectoryAllergyLabel {
    return Intl.message(
      'Allergy',
      name: 'personalDirectoryAllergyLabel',
      desc: '',
      args: [],
    );
  }

  /// `Name the allergy, like peanuts.`
  String get personalDirectoryAllergyHelp {
    return Intl.message(
      'Name the allergy, like peanuts.',
      name: 'personalDirectoryAllergyHelp',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get personalDirectoryNoteTitleLabel {
    return Intl.message(
      'Title',
      name: 'personalDirectoryNoteTitleLabel',
      desc: '',
      args: [],
    );
  }

  /// `Give this note a short title so housemates know what it is about.`
  String get personalDirectoryNoteTitleHelp {
    return Intl.message(
      'Give this note a short title so housemates know what it is about.',
      name: 'personalDirectoryNoteTitleHelp',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get personalDirectoryDetailsLabel {
    return Intl.message(
      'Details',
      name: 'personalDirectoryDetailsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add details that could help fast.`
  String get personalDirectoryEmergencyDetailsHelp {
    return Intl.message(
      'Add details that could help fast.',
      name: 'personalDirectoryEmergencyDetailsHelp',
      desc: '',
      args: [],
    );
  }

  /// `Add extra details your housemates can use.`
  String get personalDirectoryOtherDetailsHelp {
    return Intl.message(
      'Add extra details your housemates can use.',
      name: 'personalDirectoryOtherDetailsHelp',
      desc: '',
      args: [],
    );
  }

  /// `Check the bank details and try again.`
  String get personalDirectoryBankValidation {
    return Intl.message(
      'Check the bank details and try again.',
      name: 'personalDirectoryBankValidation',
      desc: '',
      args: [],
    );
  }

  /// `Check this note and try again.`
  String get personalDirectoryNoteValidation {
    return Intl.message(
      'Check this note and try again.',
      name: 'personalDirectoryNoteValidation',
      desc: '',
      args: [],
    );
  }

  /// `Archive this note?`
  String get personalDirectoryArchiveNoteTitle {
    return Intl.message(
      'Archive this note?',
      name: 'personalDirectoryArchiveNoteTitle',
      desc: '',
      args: [],
    );
  }

  /// `This removes it from your Personal directory view.`
  String get personalDirectoryArchiveNoteBody {
    return Intl.message(
      'This removes it from your Personal directory view.',
      name: 'personalDirectoryArchiveNoteBody',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load your personal directory.`
  String get personalDirectoryLoadError {
    return Intl.message(
      'Couldn\'t load your personal directory.',
      name: 'personalDirectoryLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Bank details saved.`
  String get personalDirectoryBankSaved {
    return Intl.message(
      'Bank details saved.',
      name: 'personalDirectoryBankSaved',
      desc: '',
      args: [],
    );
  }

  /// `Note saved.`
  String get personalDirectoryNoteSaved {
    return Intl.message(
      'Note saved.',
      name: 'personalDirectoryNoteSaved',
      desc: '',
      args: [],
    );
  }

  /// `Note archived.`
  String get personalDirectoryNoteArchived {
    return Intl.message(
      'Note archived.',
      name: 'personalDirectoryNoteArchived',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't save those changes.`
  String get personalDirectoryActionFailed {
    return Intl.message(
      'Couldn\'t save those changes.',
      name: 'personalDirectoryActionFailed',
      desc: '',
      args: [],
    );
  }

  /// `Members`
  String get houseDirectoryMembersTitle {
    return Intl.message(
      'Members',
      name: 'houseDirectoryMembersTitle',
      desc: '',
      args: [],
    );
  }

  /// `Payment details`
  String get shareOwedPaymentDetailsTitle {
    return Intl.message(
      'Payment details',
      name: 'shareOwedPaymentDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Account holder`
  String get shareOwedAccountHolderLabel {
    return Intl.message(
      'Account holder',
      name: 'shareOwedAccountHolderLabel',
      desc: '',
      args: [],
    );
  }

  /// `Account number`
  String get shareOwedAccountNumberLabel {
    return Intl.message(
      'Account number',
      name: 'shareOwedAccountNumberLabel',
      desc: '',
      args: [],
    );
  }

  /// `Reference`
  String get shareOwedReferenceLabel {
    return Intl.message(
      'Reference',
      name: 'shareOwedReferenceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get shareOwedCopyCta {
    return Intl.message('Copy', name: 'shareOwedCopyCta', desc: '', args: []);
  }

  /// `Bank details aren't here yet for {name}. Check with them directly.`
  String shareOwedBankMissing(String name) {
    return Intl.message(
      'Bank details aren\'t here yet for $name. Check with them directly.',
      name: 'shareOwedBankMissing',
      desc: '',
      args: [name],
    );
  }

  /// `Add your bank details`
  String get todayBankAccountPromptTitle {
    return Intl.message(
      'Add your bank details',
      name: 'todayBankAccountPromptTitle',
      desc: '',
      args: [],
    );
  }

  /// `Make it easier for housemates to pay you.`
  String get todayBankAccountPromptSubtitle {
    return Intl.message(
      'Make it easier for housemates to pay you.',
      name: 'todayBankAccountPromptSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Add bank details`
  String get todayBankAccountPromptCta {
    return Intl.message(
      'Add bank details',
      name: 'todayBankAccountPromptCta',
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
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'my'),
      Locale.fromSubtags(languageCode: 'zh'),
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
