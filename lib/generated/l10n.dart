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

  /// `What do you want to do next?`
  String get startReturningSubtitle {
    return Intl.message(
      'What do you want to do next?',
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

  /// `Join your Home`
  String get welcome_join {
    return Intl.message(
      'Join your Home',
      name: 'welcome_join',
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

  /// `Enter invite code Eg. ABC123`
  String get join_hint {
    return Intl.message(
      'Enter invite code Eg. ABC123',
      name: 'join_hint',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get join_submit {
    return Intl.message('Join', name: 'join_submit', desc: '', args: []);
  }

  /// `You're in. Welcome home.`
  String join_success(String code) {
    return Intl.message(
      'You\'re in. Welcome home.',
      name: 'join_success',
      desc: 'Snackbar message displayed when the user joins successfully',
      args: [code],
    );
  }

  /// `We couldn't join this home. Please try again.`
  String get join_failed_generic {
    return Intl.message(
      'We couldn\'t join this home. Please try again.',
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

  /// `Leave your current home to join a new one`
  String get join_error_already_in_other_home {
    return Intl.message(
      'Leave your current home to join a new one',
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

  /// `Keep your home running smoothly`
  String get paywallTitle {
    return Intl.message(
      'Keep your home running smoothly',
      name: 'paywallTitle',
      desc: '',
      args: [],
    );
  }

  /// `Costs less than 0.5% of your rent.`
  String get paywallSubtitle {
    return Intl.message(
      'Costs less than 0.5% of your rent.',
      name: 'paywallSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `One home plan, no hidden tiers.`
  String get paywallPriceCaption {
    return Intl.message(
      'One home plan, no hidden tiers.',
      name: 'paywallPriceCaption',
      desc: '',
      args: [],
    );
  }

  /// `{price} per month.`
  String paywallPricePerMonth(String price) {
    return Intl.message(
      '$price per month.',
      name: 'paywallPricePerMonth',
      desc: '',
      args: [price],
    );
  }

  /// `Pricing not available right now.`
  String get paywallPriceUnavailable {
    return Intl.message(
      'Pricing not available right now.',
      name: 'paywallPriceUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited home members`
  String get paywallBulletMembers {
    return Intl.message(
      'Unlimited home members',
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

  /// `Unlimited shared expense photos`
  String get paywallFeatureUnlimitedSharedExpensePhotos {
    return Intl.message(
      'Unlimited shared expense photos',
      name: 'paywallFeatureUnlimitedSharedExpensePhotos',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited shopping list photos`
  String get paywallBulletShoppingPhotos {
    return Intl.message(
      'Unlimited shopping list photos',
      name: 'paywallBulletShoppingPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited shared expenses`
  String get paywallBulletShares {
    return Intl.message(
      'Unlimited shared expenses',
      name: 'paywallBulletShares',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade to Kinly Premium`
  String get paywallPrimaryCta {
    return Intl.message(
      'Upgrade to Kinly Premium',
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

  /// `Purchase not completed - you can try again anytime.`
  String get paywallPurchaseFailed {
    return Intl.message(
      'Purchase not completed - you can try again anytime.',
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

  /// `Unable to load paywall.`
  String get paywallErrorTitle {
    return Intl.message(
      'Unable to load paywall.',
      name: 'paywallErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get paywallRetryLabel {
    return Intl.message('Retry', name: 'paywallRetryLabel', desc: '', args: []);
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

  /// `This home isnâ€™t accepting new members right now`
  String get join_blocked_title {
    return Intl.message(
      'This home isnâ€™t accepting new members right now',
      name: 'join_blocked_title',
      desc: '',
      args: [],
    );
  }

  /// `Weâ€™ve notified the home owner.`
  String get join_blocked_body {
    return Intl.message(
      'Weâ€™ve notified the home owner.',
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

  /// `{names} wants to join your home. Upgrade to support unlimited members.`
  String todayMemberCapSubtitle(String names) {
    return Intl.message(
      '$names wants to join your home. Upgrade to support unlimited members.',
      name: 'todayMemberCapSubtitle',
      desc: '',
      args: [names],
    );
  }

  /// `Your home is growing. Upgrade to welcome more people.`
  String get todayMemberCapSubtitleGeneric {
    return Intl.message(
      'Your home is growing. Upgrade to welcome more people.',
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

  /// `We could not complete {name}'s request.`
  String todayMemberCapResolutionFailed(String name) {
    return Intl.message(
      'We could not complete $name\'s request.',
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

  /// `{count, plural, one {{count} item to check} other {{count} items to check}}`
  String shoppingCardSubtitle(int count) {
    return Intl.plural(
      count,
      one: '$count item to check',
      other: '$count items to check',
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

  /// `Mark as completed`
  String get shoppingMarkCompleteCta {
    return Intl.message(
      'Mark as completed',
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

  /// `No shopping items to buy.`
  String get shoppingEmptyTitle {
    return Intl.message(
      'No shopping items to buy.',
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

  /// `Shopping item details`
  String get shoppingEditTitle {
    return Intl.message(
      'Shopping item details',
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

  /// `How many`
  String get shoppingAmountLabel {
    return Intl.message(
      'How many',
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

  /// `Anything helpful (brand, size, etc.)`
  String get shoppingContextHint {
    return Intl.message(
      'Anything helpful (brand, size, etc.)',
      name: 'shoppingContextHint',
      desc: '',
      args: [],
    );
  }

  /// `Add a photo`
  String get shoppingPhotoLabel {
    return Intl.message(
      'Add a photo',
      name: 'shoppingPhotoLabel',
      desc: '',
      args: [],
    );
  }

  /// `Help someone to know what to buy`
  String get shoppingPhotoReplaceLabel {
    return Intl.message(
      'Help someone to know what to buy',
      name: 'shoppingPhotoReplaceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add a photo to help with shopping`
  String get shoppingPhotoPlaceholder {
    return Intl.message(
      'Add a photo to help with shopping',
      name: 'shoppingPhotoPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Please enter an item name.`
  String get shoppingValidationName {
    return Intl.message(
      'Please enter an item name.',
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

  /// `This removes the item from your shared shopping list.`
  String get shoppingDeleteConfirmBody {
    return Intl.message(
      'This removes the item from your shared shopping list.',
      name: 'shoppingDeleteConfirmBody',
      desc: '',
      args: [],
    );
  }

  /// `Someone else already checked off this item.`
  String get shoppingErrorItemAlreadyCompletedByOther {
    return Intl.message(
      'Someone else already checked off this item.',
      name: 'shoppingErrorItemAlreadyCompletedByOther',
      desc: '',
      args: [],
    );
  }

  /// `Items bought`
  String get shoppingArchiveCta {
    return Intl.message(
      'Items bought',
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

  /// `Do you want to create a draft bill from these items?`
  String get shoppingArchiveSharePromptBody {
    return Intl.message(
      'Do you want to create a draft bill from these items?',
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

  /// `Items bought and removed from the list`
  String get shoppingArchiveItemsBought {
    return Intl.message(
      'Items bought and removed from the list',
      name: 'shoppingArchiveItemsBought',
      desc: '',
      args: [],
    );
  }

  /// `Draft bill created for items bought`
  String get shoppingArchiveDraftBillCreated {
    return Intl.message(
      'Draft bill created for items bought',
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

  /// `Connecting you to your homeâ€¦`
  String get membership_status_checking {
    return Intl.message(
      'Connecting you to your homeâ€¦',
      name: 'membership_status_checking',
      desc: '',
      args: [],
    );
  }

  /// `Your shared home starts here.`
  String get membership_status_none {
    return Intl.message(
      'Your shared home starts here.',
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

  /// `We couldn't refresh your home membership. Please try again.`
  String get authMembershipLoadFailed {
    return Intl.message(
      'We couldn\'t refresh your home membership. Please try again.',
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

  /// `Update needed`
  String get force_update_title {
    return Intl.message(
      'Update needed',
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

  /// `Couldn't load invite. Please try again.`
  String get hubInviteUnavailable {
    return Intl.message(
      'Couldn\'t load invite. Please try again.',
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

  /// `Welcome to our Kinly home! Enter this invite code: {code}\n\nDownload the Kinly app: {link}`
  String hubShareInviteBody(String code, String link) {
    return Intl.message(
      'Welcome to our Kinly home! Enter this invite code: $code\n\nDownload the Kinly app: $link',
      name: 'hubShareInviteBody',
      desc: '',
      args: [code, link],
    );
  }

  /// `Get the Kinly app`
  String get hubShareAppTitle {
    return Intl.message(
      'Get the Kinly app',
      name: 'hubShareAppTitle',
      desc: '',
      args: [],
    );
  }

  /// `Share Kinly so together feels lighter: {link}`
  String hubShareAppBody(String link) {
    return Intl.message(
      'Share Kinly so together feels lighter: $link',
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

  /// `Share Kinly so they can make shared living easier.`
  String get todayInviteFriendsSubtitle {
    return Intl.message(
      'Share Kinly so they can make shared living easier.',
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

  /// `Couldn't rotate invite. Try again.`
  String get hubRotateError {
    return Intl.message(
      'Couldn\'t rotate invite. Try again.',
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

  /// `Personal preferences`
  String get hubPreferencesTitle {
    return Intl.message(
      'Personal preferences',
      name: 'hubPreferencesTitle',
      desc: '',
      args: [],
    );
  }

  /// `How each person prefers shared living to work.`
  String get hubPreferencesSubtitle {
    return Intl.message(
      'How each person prefers shared living to work.',
      name: 'hubPreferencesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Home Vibe`
  String get homeVibeTitle {
    return Intl.message('Home Vibe', name: 'homeVibeTitle', desc: '', args: []);
  }

  /// `Based on {answered} of {total} members`
  String homeVibeCoverage(int answered, int total) {
    return Intl.message(
      'Based on $answered of $total members',
      name: 'homeVibeCoverage',
      desc: '',
      args: [answered, total],
    );
  }

  /// `House vibe`
  String get houseVibeShareTitle {
    return Intl.message(
      'House vibe',
      name: 'houseVibeShareTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sharing our Kinly house vibe. Download the app: {link}`
  String houseVibeShareMessage(String link) {
    return Intl.message(
      'Sharing our Kinly house vibe. Download the app: $link',
      name: 'houseVibeShareMessage',
      desc: '',
      args: [link],
    );
  }

  /// `Couldn't share right now. Please try again.`
  String get houseVibeShareError {
    return Intl.message(
      'Couldn\'t share right now. Please try again.',
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

  /// `Finish preferences to see your home vibe.`
  String get vibeInsufficientSummary {
    return Intl.message(
      'Finish preferences to see your home vibe.',
      name: 'vibeInsufficientSummary',
      desc: '',
      args: [],
    );
  }

  /// `A mixed home`
  String get vibeMixedTitle {
    return Intl.message(
      'A mixed home',
      name: 'vibeMixedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your home shows a mix of comfort styles, influenced by how different people like to live.`
  String get vibeMixedSummary {
    return Intl.message(
      'Your home shows a mix of comfort styles, influenced by how different people like to live.',
      name: 'vibeMixedSummary',
      desc: '',
      args: [],
    );
  }

  /// `A balanced home`
  String get vibeDefaultTitle {
    return Intl.message(
      'A balanced home',
      name: 'vibeDefaultTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your home feels easy to live in for everyone.`
  String get vibeDefaultSummary {
    return Intl.message(
      'Your home feels easy to live in for everyone.',
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

  /// `Your home feels calm, with gentle energy and softer rhythms.`
  String get vibeQuietCareSummary {
    return Intl.message(
      'Your home feels calm, with gentle energy and softer rhythms.',
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

  /// `Your home feels active, with people together.`
  String get vibeSocialSummary {
    return Intl.message(
      'Your home feels active, with people together.',
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

  /// `Your home feels warm and welcoming, with people often together.`
  String get vibeWarmSocialSummary {
    return Intl.message(
      'Your home feels warm and welcoming, with people often together.',
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

  /// `Your home feels cozy and calm when people spend time together.`
  String get vibeCozySocialSummary {
    return Intl.message(
      'Your home feels cozy and calm when people spend time together.',
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

  /// `Your home feels steady, with care shown through daily habits.`
  String get vibeSteadySummary {
    return Intl.message(
      'Your home feels steady, with care shown through daily habits.',
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

  /// `Your home works best with clear routines and shared plans.`
  String get vibeStructuredSummary {
    return Intl.message(
      'Your home works best with clear routines and shared plans.',
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

  /// `Your home feels relaxed and open to change day by day.`
  String get vibeEasygoingSummary {
    return Intl.message(
      'Your home feels relaxed and open to change day by day.',
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

  /// `Your home supports space and quiet.`
  String get vibeIndependentSummary {
    return Intl.message(
      'Your home supports space and quiet.',
      name: 'vibeIndependentSummary',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load Home Hub. Please try again.`
  String get hubError {
    return Intl.message(
      'Couldn\'t load Home Hub. Please try again.',
      name: 'hubError',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get hubRetry {
    return Intl.message('Retry', name: 'hubRetry', desc: '', args: []);
  }

  /// `All caught up today`
  String get todayEmptyCardTitle {
    return Intl.message(
      'All caught up today',
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

  /// `Enjoy the calm - Kinly will let you know when something needs your attention.`
  String get todayEmptyBody {
    return Intl.message(
      'Enjoy the calm - Kinly will let you know when something needs your attention.',
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

  /// `Good {partOfDay}, {name}`
  String greetingPartOfDay(String partOfDay, String name) {
    return Intl.message(
      'Good $partOfDay, $name',
      name: 'greetingPartOfDay',
      desc: '',
      args: [partOfDay, name],
    );
  }

  /// `Here’s what needs attention today.`
  String get todayFlowSubtitle {
    return Intl.message(
      'Here’s what needs attention today.',
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

  /// `Bill`
  String get todayShareSectionTitle {
    return Intl.message(
      'Bill',
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

  /// `Settled Amount`
  String get todaySharePaidSubtitle {
    return Intl.message(
      'Settled Amount',
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

  /// `We couldn't refresh Share right now.`
  String get todayShareError {
    return Intl.message(
      'We couldn\'t refresh Share right now.',
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

  /// `Gratitude Wall`
  String get todayGratitudeSectionTitle {
    return Intl.message(
      'Gratitude Wall',
      name: 'todayGratitudeSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `New gratitude posts are waiting for you.`
  String get todayGratitudeUnreadBody {
    return Intl.message(
      'New gratitude posts are waiting for you.',
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

  /// `Settled.`
  String get shareOwedDetailSuccess {
    return Intl.message(
      'Settled.',
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

  /// `Acknowledge Receipt`
  String get sharePaidDetailAcknowledge {
    return Intl.message(
      'Acknowledge Receipt',
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

  /// `We couldn't acknowledge receipting the bills.`
  String get sharePaidDetailAcknowledgeError {
    return Intl.message(
      'We couldn\'t acknowledge receipting the bills.',
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

  /// `We couldn't load that draft.`
  String get shareEditLoadError {
    return Intl.message(
      'We couldn\'t load that draft.',
      name: 'shareEditLoadError',
      desc: '',
      args: [],
    );
  }

  /// `This stays locked until someone takes this share.`
  String get shareEditNotAllowed {
    return Intl.message(
      'This stays locked until someone takes this share.',
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

  /// `Delete?`
  String get shareEditDeleteConfirmTitle {
    return Intl.message(
      'Delete?',
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

  /// `Couldn't delete. Try again.`
  String get shareEditDeleteError {
    return Intl.message(
      'Couldn\'t delete. Try again.',
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

  /// `Plan terminated.`
  String get shareEditTerminateSuccess {
    return Intl.message(
      'Plan terminated.',
      name: 'shareEditTerminateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Terminate plan`
  String get shareEditTerminatePlan {
    return Intl.message(
      'Terminate plan',
      name: 'shareEditTerminatePlan',
      desc: '',
      args: [],
    );
  }

  /// `Terminating...`
  String get shareEditTerminatePlanBusy {
    return Intl.message(
      'Terminating...',
      name: 'shareEditTerminatePlanBusy',
      desc: '',
      args: [],
    );
  }

  /// `Terminate recurring plan?`
  String get shareEditTerminatePlanTitle {
    return Intl.message(
      'Terminate recurring plan?',
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

  /// `Terminate plan`
  String get shareEditTerminatePlanConfirm {
    return Intl.message(
      'Terminate plan',
      name: 'shareEditTerminatePlanConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't terminate the plan. Try again.`
  String get shareEditTerminateError {
    return Intl.message(
      'Couldn\'t terminate the plan. Try again.',
      name: 'shareEditTerminateError',
      desc: '',
      args: [],
    );
  }

  /// `This bill is now a plan, and editing is off.`
  String get shareEditDisabledConverted {
    return Intl.message(
      'This bill is now a plan, and editing is off.',
      name: 'shareEditDisabledConverted',
      desc: '',
      args: [],
    );
  }

  /// `Recurring cycles are locked from edits here.`
  String get shareEditDisabledRecurringCycle {
    return Intl.message(
      'Recurring cycles are locked from edits here.',
      name: 'shareEditDisabledRecurringCycle',
      desc: '',
      args: [],
    );
  }

  /// `Active bills are locked from edits.`
  String get shareEditDisabledActive {
    return Intl.message(
      'Active bills are locked from edits.',
      name: 'shareEditDisabledActive',
      desc: '',
      args: [],
    );
  }

  /// `Editing this bill is unavailable right now.`
  String get shareEditDisabledGeneric {
    return Intl.message(
      'Editing this bill is unavailable right now.',
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

  /// `How do we want to split this?`
  String get shareCreateSplitLabel {
    return Intl.message(
      'How do we want to split this?',
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

  /// `You need at least two household members to share.`
  String get shareCreateParticipantsEmpty {
    return Intl.message(
      'You need at least two household members to share.',
      name: 'shareCreateParticipantsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Context`
  String get shareCreateNotesLabel {
    return Intl.message(
      'Context',
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

  /// `Enter each person's part. Make sure the total matches the amount above.`
  String get shareCreateCustomHelper {
    return Intl.message(
      'Enter each person\'s part. Make sure the total matches the amount above.',
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

  /// `Enter a valid amount greater than zero.`
  String get shareCreateValidationAmount {
    return Intl.message(
      'Enter a valid amount greater than zero.',
      name: 'shareCreateValidationAmount',
      desc: '',
      args: [],
    );
  }

  /// `Select at least one person to split the amount.`
  String get shareCreateValidationEqualParticipants {
    return Intl.message(
      'Select at least one person to split the amount.',
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

  /// `Make sure the custom split adds up to the amount above.`
  String get shareCreateValidationCustomSum {
    return Intl.message(
      'Make sure the custom split adds up to the amount above.',
      name: 'shareCreateValidationCustomSum',
      desc: '',
      args: [],
    );
  }

  /// `Custom split does not match. Total: {total}. Included: {included}. Difference: {difference}.`
  String shareCreateValidationCustomSumBreakdown(
    String total,
    String included,
    String difference,
  ) {
    return Intl.message(
      'Custom split does not match. Total: $total. Included: $included. Difference: $difference.',
      name: 'shareCreateValidationCustomSumBreakdown',
      desc: '',
      args: [total, included, difference],
    );
  }

  /// `You're the only person selected for this bill. Add at least one other person.`
  String get shareCreateValidationCustomSinglePayer {
    return Intl.message(
      'You\'re the only person selected for this bill. Add at least one other person.',
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

  /// `Pick how to split before setting a repeat.`
  String get shareCreateValidationRecurrenceSplit {
    return Intl.message(
      'Pick how to split before setting a repeat.',
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

  /// `Choose a date within the allowed range.`
  String get shareCreateValidationStartDateRange {
    return Intl.message(
      'Choose a date within the allowed range.',
      name: 'shareCreateValidationStartDateRange',
      desc: '',
      args: [],
    );
  }

  /// `Drafts canâ€™t repeat until you add a split.`
  String get shareCreateErrorRecurrenceDraft {
    return Intl.message(
      'Drafts canâ€™t repeat until you add a split.',
      name: 'shareCreateErrorRecurrenceDraft',
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

  /// `Couldn't create. Try again.`
  String get shareCreateErrorGeneric {
    return Intl.message(
      'Couldn\'t create. Try again.',
      name: 'shareCreateErrorGeneric',
      desc: '',
      args: [],
    );
  }

  /// `You're at the free limit of active bills. Upgrade for more space.`
  String get shareCreateErrorPaywallActiveCap {
    return Intl.message(
      'You\'re at the free limit of active bills. Upgrade for more space.',
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

  /// `Eg. Bin night, clean the fridge, water plants`
  String get flowChoreNameHint {
    return Intl.message(
      'Eg. Bin night, clean the fridge, water plants',
      name: 'flowChoreNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Name this task.`
  String get flowChoreValidationName {
    return Intl.message(
      'Name this task.',
      name: 'flowChoreValidationName',
      desc: '',
      args: [],
    );
  }

  /// `Who's handling this?`
  String get flowChoreAssigneeLabel {
    return Intl.message(
      'Who\'s handling this?',
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

  /// `When does this come up? `
  String get flowChoreStartLabel {
    return Intl.message(
      'When does this come up? ',
      name: 'flowChoreStartLabel',
      desc: '',
      args: [],
    );
  }

  /// `Pick a date up to a year from today.`
  String get flowChoreValidationDate {
    return Intl.message(
      'Pick a date up to a year from today.',
      name: 'flowChoreValidationDate',
      desc: '',
      args: [],
    );
  }

  /// `How often does this come up?`
  String get flowChoreRecurrenceLabel {
    return Intl.message(
      'How often does this come up?',
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

  /// `Why this matters`
  String get flowChoreNotesLabel {
    return Intl.message(
      'Why this matters',
      name: 'flowChoreNotesLabel',
      desc: '',
      args: [],
    );
  }

  /// `Anything that helps others do this easily`
  String get flowChoreNotesHint {
    return Intl.message(
      'Anything that helps others do this easily',
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

  /// `Add a link if there's a specific way to do it`
  String get flowChoreHowToHint {
    return Intl.message(
      'Add a link if there\'s a specific way to do it',
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

  /// `What good looks like`
  String get flowChorePhotoLabel {
    return Intl.message(
      'What good looks like',
      name: 'flowChorePhotoLabel',
      desc: '',
      args: [],
    );
  }

  /// `A photo can help everyone stay aligned`
  String get flowChorePhotoPlaceholder {
    return Intl.message(
      'A photo can help everyone stay aligned',
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

  /// `Create flow`
  String get flowChoreSubmitCreate {
    return Intl.message(
      'Create flow',
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

  /// `Delete this flow?`
  String get flowChoreDeleteDialogTitle {
    return Intl.message(
      'Delete this flow?',
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

  /// `Delete`
  String get flowChoreDeleteConfirm {
    return Intl.message(
      'Delete',
      name: 'flowChoreDeleteConfirm',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't load this task. Please try again.`
  String get flowChoreLoadError {
    return Intl.message(
      'We couldn\'t load this task. Please try again.',
      name: 'flowChoreLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get flowChoreRetry {
    return Intl.message('Retry', name: 'flowChoreRetry', desc: '', args: []);
  }

  /// `You're at the free limit for active flows. Upgrade for more space.`
  String get flowChoreErrorPaywallActiveCap {
    return Intl.message(
      'You\'re at the free limit for active flows. Upgrade for more space.',
      name: 'flowChoreErrorPaywallActiveCap',
      desc: '',
      args: [],
    );
  }

  /// `You're at the free limit for flow photos. Upgrade for more space.`
  String get flowChoreErrorPaywallMediaCap {
    return Intl.message(
      'You\'re at the free limit for flow photos. Upgrade for more space.',
      name: 'flowChoreErrorPaywallMediaCap',
      desc: '',
      args: [],
    );
  }

  /// `That member isn't part of this home right now.`
  String get flowChoreErrorAssigneeNotMember {
    return Intl.message(
      'That member isn\'t part of this home right now.',
      name: 'flowChoreErrorAssigneeNotMember',
      desc: '',
      args: [],
    );
  }

  /// `You don't have permission to change this flow.`
  String get flowChoreErrorForbidden {
    return Intl.message(
      'You don\'t have permission to change this flow.',
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

  /// `This flow is not available to update right now.`
  String get flowChoreErrorInvalidState {
    return Intl.message(
      'This flow is not available to update right now.',
      name: 'flowChoreErrorInvalidState',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't save this flow. Please try again.`
  String get flowChoreErrorGeneric {
    return Intl.message(
      'Couldn\'t save this flow. Please try again.',
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

  /// `No context provided.`
  String get flowChoreDetailNoNotes {
    return Intl.message(
      'No context provided.',
      name: 'flowChoreDetailNoNotes',
      desc: '',
      args: [],
    );
  }

  /// `No guide links provided.`
  String get flowChoreDetailNoHowTo {
    return Intl.message(
      'No guide links provided.',
      name: 'flowChoreDetailNoHowTo',
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

  /// `Couldn't complete this task. Please try again.`
  String get flowChoreDetailCompletionError {
    return Intl.message(
      'Couldn\'t complete this task. Please try again.',
      name: 'flowChoreDetailCompletionError',
      desc: '',
      args: [],
    );
  }

  /// `Helpful context`
  String get flowChoreDetailMoreInfoTitle {
    return Intl.message(
      'Helpful context',
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

  /// `Tasks to keep everyone aligned.`
  String get flowListEmptySubtitle {
    return Intl.message(
      'Tasks to keep everyone aligned.',
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

  /// `We couldn't load tasks. Pull to refresh.`
  String get flowListError {
    return Intl.message(
      'We couldn\'t load tasks. Pull to refresh.',
      name: 'flowListError',
      desc: '',
      args: [],
    );
  }

  /// `Update status and details to keep shared things clear.`
  String get exploreIntroSubtitle {
    return Intl.message(
      'Update status and details to keep shared things clear.',
      name: 'exploreIntroSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `See what needs doing and who's taking care of it.`
  String get exploreFlowSubtitle {
    return Intl.message(
      'See what needs doing and who\'s taking care of it.',
      name: 'exploreFlowSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `See every Bill you've created and track collections.`
  String get exploreShareSubtitle {
    return Intl.message(
      'See every Bill you\'ve created and track collections.',
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

  /// `View and manage your shared shopping items.`
  String get exploreShoppingSubtitle {
    return Intl.message(
      'View and manage your shared shopping items.',
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

  /// `Bills keep money clear, with no awkward reminders.`
  String get shareCreatedListEmptySubtitle {
    return Intl.message(
      'Bills keep money clear, with no awkward reminders.',
      name: 'shareCreatedListEmptySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't load your bills. Pull to refresh.`
  String get shareCreatedListError {
    return Intl.message(
      'We couldn\'t load your bills. Pull to refresh.',
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

  /// `Split it so everyone knows their part before publishing.`
  String get shareCreatedListDraftSubtitle {
    return Intl.message(
      'Split it so everyone knows their part before publishing.',
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

  /// `That username is taken. Try a different one.`
  String get profileIdentityUsernameTakenError {
    return Intl.message(
      'That username is taken. Try a different one.',
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

  /// `Leaving this home means stepping out of your shared Kinly space.`
  String get profileLeaveHomeSubtitle {
    return Intl.message(
      'Leaving this home means stepping out of your shared Kinly space.',
      name: 'profileLeaveHomeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Checking your home members...`
  String get profileLeaveEligibilityLoading {
    return Intl.message(
      'Checking your home members...',
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

  /// `You're the last member. Leaving will deactivate this home.`
  String get profileLeaveOwnerSoloMessage {
    return Intl.message(
      'You\'re the last member. Leaving will deactivate this home.',
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

  /// `Select who will become the new owner before you leave.`
  String get profileLeaveTransferSheetSubtitle {
    return Intl.message(
      'Select who will become the new owner before you leave.',
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

  /// `Choose who will lose access to this home.`
  String get profileKickMemberSubtitle {
    return Intl.message(
      'Choose who will lose access to this home.',
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

  /// `Select a member to remove. They'll lose access right away.`
  String get profileKickSheetSubtitle {
    return Intl.message(
      'Select a member to remove. They\'ll lose access right away.',
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

  /// `Ownership transferred. Finishing your leave...`
  String get profileLeaveTransferSuccessMessage {
    return Intl.message(
      'Ownership transferred. Finishing your leave...',
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

  /// `Connection settings`
  String get profileConnectionSettingsTitle {
    return Intl.message(
      'Connection settings',
      name: 'profileConnectionSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Manage notifications and reminders.`
  String get profileConnectionSettingsSubtitle {
    return Intl.message(
      'Manage notifications and reminders.',
      name: 'profileConnectionSettingsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Connection settings`
  String get connectionSettingsTitle {
    return Intl.message(
      'Connection settings',
      name: 'connectionSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Control daily reminders and notification timing.`
  String get connectionSettingsSubtitle {
    return Intl.message(
      'Control daily reminders and notification timing.',
      name: 'connectionSettingsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't update connection settings. Try again.`
  String get connectionSettingsGenericError {
    return Intl.message(
      'Couldn\'t update connection settings. Try again.',
      name: 'connectionSettingsGenericError',
      desc: '',
      args: [],
    );
  }

  /// `Daily notifications`
  String get connectionNotificationsToggleTitle {
    return Intl.message(
      'Daily notifications',
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

  /// `Turn on reminders about your home.`
  String get connectionNotificationsToggleSubtitleOff {
    return Intl.message(
      'Turn on reminders about your home.',
      name: 'connectionNotificationsToggleSubtitleOff',
      desc: '',
      args: [],
    );
  }

  /// `Turn on notifications in your phone settings to use this.`
  String get connectionNotificationsPermissionBlocked {
    return Intl.message(
      'Turn on notifications in your phone settings to use this.',
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

  /// `Your profile is deactivated. Please sign in with another email address.`
  String get profile_deactivated_message {
    return Intl.message(
      'Your profile is deactivated. Please sign in with another email address.',
      name: 'profile_deactivated_message',
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

  /// `This removes your account and signs you out. You won't be able to undo this.`
  String get profileConfirmDeleteMessage {
    return Intl.message(
      'This removes your account and signs you out. You won\'t be able to undo this.',
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

  /// `Leave Home`
  String get profileActionConfirm {
    return Intl.message(
      'Leave Home',
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

  /// `Anything to appreciate or adjust this week?`
  String get harmonyQuestion {
    return Intl.message(
      'Anything to appreciate or adjust this week?',
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

  /// `Type @ to provide feedback to 1 housemate.`
  String get harmonyFeedbackSingleHousemateHint {
    return Intl.message(
      'Type @ to provide feedback to 1 housemate.',
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

  /// `Submitting for this home is unavailable.`
  String get harmonyErrorForbidden {
    return Intl.message(
      'Submitting for this home is unavailable.',
      name: 'harmonyErrorForbidden',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong. Please try again.`
  String get harmonyErrorUnknown {
    return Intl.message(
      'Something went wrong. Please try again.',
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

  /// `A private place to save quick thanks.`
  String get gratitudeWallPersonalSummary {
    return Intl.message(
      'A private place to save quick thanks.',
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

  /// `Quick thanks live here.\n\nAdd one from this week.`
  String get gratitudeWallEmptySubtitle {
    return Intl.message(
      'Quick thanks live here.\n\nAdd one from this week.',
      name: 'gratitudeWallEmptySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load shoutouts right now.`
  String get gratitudeWallErrorGeneric {
    return Intl.message(
      'Unable to load shoutouts right now.',
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

  /// `Couldn't share right now. Please try again.`
  String get gratitudeWallShareError {
    return Intl.message(
      'Couldn\'t share right now. Please try again.',
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

  /// `0 means not at all. 10 means it's made a real difference.`
  String get npsDescription {
    return Intl.message(
      '0 means not at all. 10 means it\'s made a real difference.',
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

  /// `Please choose a score to continue.`
  String get npsCannotSkip {
    return Intl.message(
      'Please choose a score to continue.',
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

  /// `Please pick a number between 0 and 10.`
  String get npsSubmitErrorInvalidScore {
    return Intl.message(
      'Please pick a number between 0 and 10.',
      name: 'npsSubmitErrorInvalidScore',
      desc: '',
      args: [],
    );
  }

  /// `Feedback is unavailable right now.`
  String get npsSubmitErrorForbidden {
    return Intl.message(
      'Feedback is unavailable right now.',
      name: 'npsSubmitErrorForbidden',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't send your feedback. Please try again.`
  String get npsSubmitErrorGeneric {
    return Intl.message(
      'Couldn\'t send your feedback. Please try again.',
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

  /// `Share your preferences`
  String get preferencePromptTitle {
    return Intl.message(
      'Share your preferences',
      name: 'preferencePromptTitle',
      desc: '',
      args: [],
    );
  }

  /// `Set up your personal preferences so your home can learn how you like things.`
  String get preferencePromptSubtitle {
    return Intl.message(
      'Set up your personal preferences so your home can learn how you like things.',
      name: 'preferencePromptSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Start preferences`
  String get preferencePromptCta {
    return Intl.message(
      'Start preferences',
      name: 'preferencePromptCta',
      desc: '',
      args: [],
    );
  }

  /// `Personal preferences`
  String get preferenceOnboardingTitle {
    return Intl.message(
      'Personal preferences',
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

  /// `Save preferences`
  String get preferenceOnboardingSubmit {
    return Intl.message(
      'Save preferences',
      name: 'preferenceOnboardingSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Question {current} of {total}`
  String preferenceOnboardingProgress(int current, int total) {
    return Intl.message(
      'Question $current of $total',
      name: 'preferenceOnboardingProgress',
      desc: 'Progress for preference onboarding',
      args: [current, total],
    );
  }

  /// `Your preference report`
  String get preferenceReportTitle {
    return Intl.message(
      'Your preference report',
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

  /// `Adjust the wording for this section.`
  String get preferenceReportEditSectionPrompt {
    return Intl.message(
      'Adjust the wording for this section.',
      name: 'preferenceReportEditSectionPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Write what feels right for you`
  String get preferenceReportEditSectionHint {
    return Intl.message(
      'Write what feels right for you',
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

  /// `Preference report not ready`
  String get preferenceReportEmptyTitle {
    return Intl.message(
      'Preference report not ready',
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

  /// `Could not load report`
  String get preferenceReportErrorTitle {
    return Intl.message(
      'Could not load report',
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

  /// `We couldn't save that update.`
  String get preferenceReportEditError {
    return Intl.message(
      'We couldn\'t save that update.',
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

  /// `How comfortable are you with background noise in shared spaces?`
  String get preferenceScenarioEnvironmentNoiseQuestion {
    return Intl.message(
      'How comfortable are you with background noise in shared spaces?',
      name: 'preferenceScenarioEnvironmentNoiseQuestion',
      desc: '',
      args: [],
    );
  }

  /// `I'm most comfortable when things are generally quiet`
  String get preferenceScenarioEnvironmentNoiseOption1 {
    return Intl.message(
      'I\'m most comfortable when things are generally quiet',
      name: 'preferenceScenarioEnvironmentNoiseOption1',
      desc: '',
      args: [],
    );
  }

  /// `A moderate level of everyday noise feels fine`
  String get preferenceScenarioEnvironmentNoiseOption2 {
    return Intl.message(
      'A moderate level of everyday noise feels fine',
      name: 'preferenceScenarioEnvironmentNoiseOption2',
      desc: '',
      args: [],
    );
  }

  /// `Noise doesn't bother me much - lively spaces are okay`
  String get preferenceScenarioEnvironmentNoiseOption3 {
    return Intl.message(
      'Noise doesn\'t bother me much - lively spaces are okay',
      name: 'preferenceScenarioEnvironmentNoiseOption3',
      desc: '',
      args: [],
    );
  }

  /// `In shared areas, what lighting do you prefer?`
  String get preferenceScenarioEnvironmentLightQuestion {
    return Intl.message(
      'In shared areas, what lighting do you prefer?',
      name: 'preferenceScenarioEnvironmentLightQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Softer or dimmer lighting`
  String get preferenceScenarioEnvironmentLightOption1 {
    return Intl.message(
      'Softer or dimmer lighting',
      name: 'preferenceScenarioEnvironmentLightOption1',
      desc: '',
      args: [],
    );
  }

  /// `Balanced, natural lighting`
  String get preferenceScenarioEnvironmentLightOption2 {
    return Intl.message(
      'Balanced, natural lighting',
      name: 'preferenceScenarioEnvironmentLightOption2',
      desc: '',
      args: [],
    );
  }

  /// `Bright, well-lit spaces`
  String get preferenceScenarioEnvironmentLightOption3 {
    return Intl.message(
      'Bright, well-lit spaces',
      name: 'preferenceScenarioEnvironmentLightOption3',
      desc: '',
      args: [],
    );
  }

  /// `How comfortable are you with strong scents (candles, cooking, cleaners)?`
  String get preferenceScenarioEnvironmentScentQuestion {
    return Intl.message(
      'How comfortable are you with strong scents (candles, cooking, cleaners)?',
      name: 'preferenceScenarioEnvironmentScentQuestion',
      desc: '',
      args: [],
    );
  }

  /// `I'm quite sensitive to strong scents`
  String get preferenceScenarioEnvironmentScentOption1 {
    return Intl.message(
      'I\'m quite sensitive to strong scents',
      name: 'preferenceScenarioEnvironmentScentOption1',
      desc: '',
      args: [],
    );
  }

  /// `I'm mostly neutral`
  String get preferenceScenarioEnvironmentScentOption2 {
    return Intl.message(
      'I\'m mostly neutral',
      name: 'preferenceScenarioEnvironmentScentOption2',
      desc: '',
      args: [],
    );
  }

  /// `Strong scents don't really bother me`
  String get preferenceScenarioEnvironmentScentOption3 {
    return Intl.message(
      'Strong scents don\'t really bother me',
      name: 'preferenceScenarioEnvironmentScentOption3',
      desc: '',
      args: [],
    );
  }

  /// `In the evenings, what usually works best for you?`
  String get preferenceScenarioScheduleQuietHoursQuestion {
    return Intl.message(
      'In the evenings, what usually works best for you?',
      name: 'preferenceScenarioScheduleQuietHoursQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Evenings tend to be quieter for me`
  String get preferenceScenarioScheduleQuietHoursOption1 {
    return Intl.message(
      'Evenings tend to be quieter for me',
      name: 'preferenceScenarioScheduleQuietHoursOption1',
      desc: '',
      args: [],
    );
  }

  /// `It depends - some nights are quieter than others`
  String get preferenceScenarioScheduleQuietHoursOption2 {
    return Intl.message(
      'It depends - some nights are quieter than others',
      name: 'preferenceScenarioScheduleQuietHoursOption2',
      desc: '',
      args: [],
    );
  }

  /// `Nighttime activity doesn't usually bother me`
  String get preferenceScenarioScheduleQuietHoursOption3 {
    return Intl.message(
      'Nighttime activity doesn\'t usually bother me',
      name: 'preferenceScenarioScheduleQuietHoursOption3',
      desc: '',
      args: [],
    );
  }

  /// `Are you more of an early bird or a night owl?`
  String get preferenceScenarioScheduleSleepTimingQuestion {
    return Intl.message(
      'Are you more of an early bird or a night owl?',
      name: 'preferenceScenarioScheduleSleepTimingQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Earlier nights and mornings`
  String get preferenceScenarioScheduleSleepTimingOption1 {
    return Intl.message(
      'Earlier nights and mornings',
      name: 'preferenceScenarioScheduleSleepTimingOption1',
      desc: '',
      args: [],
    );
  }

  /// `Somewhere in the middle`
  String get preferenceScenarioScheduleSleepTimingOption2 {
    return Intl.message(
      'Somewhere in the middle',
      name: 'preferenceScenarioScheduleSleepTimingOption2',
      desc: '',
      args: [],
    );
  }

  /// `Later nights and mornings`
  String get preferenceScenarioScheduleSleepTimingOption3 {
    return Intl.message(
      'Later nights and mornings',
      name: 'preferenceScenarioScheduleSleepTimingOption3',
      desc: '',
      args: [],
    );
  }

  /// `When you need to coordinate at home, what works best for you?`
  String get preferenceScenarioCommunicationChannelQuestion {
    return Intl.message(
      'When you need to coordinate at home, what works best for you?',
      name: 'preferenceScenarioCommunicationChannelQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Messaging or text`
  String get preferenceScenarioCommunicationChannelOption1 {
    return Intl.message(
      'Messaging or text',
      name: 'preferenceScenarioCommunicationChannelOption1',
      desc: '',
      args: [],
    );
  }

  /// `Talking in person when it comes up`
  String get preferenceScenarioCommunicationChannelOption2 {
    return Intl.message(
      'Talking in person when it comes up',
      name: 'preferenceScenarioCommunicationChannelOption2',
      desc: '',
      args: [],
    );
  }

  /// `A quick call feels easiest`
  String get preferenceScenarioCommunicationChannelOption3 {
    return Intl.message(
      'A quick call feels easiest',
      name: 'preferenceScenarioCommunicationChannelOption3',
      desc: '',
      args: [],
    );
  }

  /// `When someone bring something up to you, how would you prefer to receive it?`
  String get preferenceScenarioCommunicationDirectnessQuestion {
    return Intl.message(
      'When someone bring something up to you, how would you prefer to receive it?',
      name: 'preferenceScenarioCommunicationDirectnessQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Gently, with context or easing in`
  String get preferenceScenarioCommunicationDirectnessOption1 {
    return Intl.message(
      'Gently, with context or easing in',
      name: 'preferenceScenarioCommunicationDirectnessOption1',
      desc: '',
      args: [],
    );
  }

  /// `A mix - it depends on the situation`
  String get preferenceScenarioCommunicationDirectnessOption2 {
    return Intl.message(
      'A mix - it depends on the situation',
      name: 'preferenceScenarioCommunicationDirectnessOption2',
      desc: '',
      args: [],
    );
  }

  /// `Directly and clearly`
  String get preferenceScenarioCommunicationDirectnessOption3 {
    return Intl.message(
      'Directly and clearly',
      name: 'preferenceScenarioCommunicationDirectnessOption3',
      desc: '',
      args: [],
    );
  }

  /// `In shared spaces, what level of tidiness works for you?`
  String get preferenceScenarioCleanlinessSharedSpaceQuestion {
    return Intl.message(
      'In shared spaces, what level of tidiness works for you?',
      name: 'preferenceScenarioCleanlinessSharedSpaceQuestion',
      desc: '',
      args: [],
    );
  }

  /// `I feel best when things are kept fairly tidy`
  String get preferenceScenarioCleanlinessSharedSpaceOption1 {
    return Intl.message(
      'I feel best when things are kept fairly tidy',
      name: 'preferenceScenarioCleanlinessSharedSpaceOption1',
      desc: '',
      args: [],
    );
  }

  /// `Some clutter is okay day-to-day`
  String get preferenceScenarioCleanlinessSharedSpaceOption2 {
    return Intl.message(
      'Some clutter is okay day-to-day',
      name: 'preferenceScenarioCleanlinessSharedSpaceOption2',
      desc: '',
      args: [],
    );
  }

  /// `I'm relaxed about mess in shared areas`
  String get preferenceScenarioCleanlinessSharedSpaceOption3 {
    return Intl.message(
      'I\'m relaxed about mess in shared areas',
      name: 'preferenceScenarioCleanlinessSharedSpaceOption3',
      desc: '',
      args: [],
    );
  }

  /// `Before entering someone's room, what feels right to you?`
  String get preferenceScenarioPrivacyRoomEntryQuestion {
    return Intl.message(
      'Before entering someone\'s room, what feels right to you?',
      name: 'preferenceScenarioPrivacyRoomEntryQuestion',
      desc: '',
      args: [],
    );
  }

  /// `I prefer people to ask or knock first`
  String get preferenceScenarioPrivacyRoomEntryOption1 {
    return Intl.message(
      'I prefer people to ask or knock first',
      name: 'preferenceScenarioPrivacyRoomEntryOption1',
      desc: '',
      args: [],
    );
  }

  /// `Asking is nice, but flexibility is okay`
  String get preferenceScenarioPrivacyRoomEntryOption2 {
    return Intl.message(
      'Asking is nice, but flexibility is okay',
      name: 'preferenceScenarioPrivacyRoomEntryOption2',
      desc: '',
      args: [],
    );
  }

  /// `I'm generally comfortable with open access`
  String get preferenceScenarioPrivacyRoomEntryOption3 {
    return Intl.message(
      'I\'m generally comfortable with open access',
      name: 'preferenceScenarioPrivacyRoomEntryOption3',
      desc: '',
      args: [],
    );
  }

  /// `How do you feel about messages at night?`
  String get preferenceScenarioPrivacyNotificationsQuestion {
    return Intl.message(
      'How do you feel about messages at night?',
      name: 'preferenceScenarioPrivacyNotificationsQuestion',
      desc: '',
      args: [],
    );
  }

  /// `I prefer not to be contacted after quiet hours`
  String get preferenceScenarioPrivacyNotificationsOption1 {
    return Intl.message(
      'I prefer not to be contacted after quiet hours',
      name: 'preferenceScenarioPrivacyNotificationsOption1',
      desc: '',
      args: [],
    );
  }

  /// `Limited or important messages are okay`
  String get preferenceScenarioPrivacyNotificationsOption2 {
    return Intl.message(
      'Limited or important messages are okay',
      name: 'preferenceScenarioPrivacyNotificationsOption2',
      desc: '',
      args: [],
    );
  }

  /// `I'm fine being contacted anytime`
  String get preferenceScenarioPrivacyNotificationsOption3 {
    return Intl.message(
      'I\'m fine being contacted anytime',
      name: 'preferenceScenarioPrivacyNotificationsOption3',
      desc: '',
      args: [],
    );
  }

  /// `How do you feel about guests coming over to the home?`
  String get preferenceScenarioSocialHostingQuestion {
    return Intl.message(
      'How do you feel about guests coming over to the home?',
      name: 'preferenceScenarioSocialHostingQuestion',
      desc: '',
      args: [],
    );
  }

  /// `I'm most comfortable with guests being rare`
  String get preferenceScenarioSocialHostingOption1 {
    return Intl.message(
      'I\'m most comfortable with guests being rare',
      name: 'preferenceScenarioSocialHostingOption1',
      desc: '',
      args: [],
    );
  }

  /// `Occasional guests feel fine`
  String get preferenceScenarioSocialHostingOption2 {
    return Intl.message(
      'Occasional guests feel fine',
      name: 'preferenceScenarioSocialHostingOption2',
      desc: '',
      args: [],
    );
  }

  /// `Frequent guests are okay with me`
  String get preferenceScenarioSocialHostingOption3 {
    return Intl.message(
      'Frequent guests are okay with me',
      name: 'preferenceScenarioSocialHostingOption3',
      desc: '',
      args: [],
    );
  }

  /// `At home, what balance works best for you?`
  String get preferenceScenarioSocialTogethernessQuestion {
    return Intl.message(
      'At home, what balance works best for you?',
      name: 'preferenceScenarioSocialTogethernessQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Mostly doing my own thing`
  String get preferenceScenarioSocialTogethernessOption1 {
    return Intl.message(
      'Mostly doing my own thing',
      name: 'preferenceScenarioSocialTogethernessOption1',
      desc: '',
      args: [],
    );
  }

  /// `A mix of shared time and solo time`
  String get preferenceScenarioSocialTogethernessOption2 {
    return Intl.message(
      'A mix of shared time and solo time',
      name: 'preferenceScenarioSocialTogethernessOption2',
      desc: '',
      args: [],
    );
  }

  /// `Spending time together often`
  String get preferenceScenarioSocialTogethernessOption3 {
    return Intl.message(
      'Spending time together often',
      name: 'preferenceScenarioSocialTogethernessOption3',
      desc: '',
      args: [],
    );
  }

  /// `When it comes to daily life at home, what feels most natural to you?`
  String get preferenceScenarioRoutinePlanningQuestion {
    return Intl.message(
      'When it comes to daily life at home, what feels most natural to you?',
      name: 'preferenceScenarioRoutinePlanningQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Having plans and structure helps me`
  String get preferenceScenarioRoutinePlanningOption1 {
    return Intl.message(
      'Having plans and structure helps me',
      name: 'preferenceScenarioRoutinePlanningOption1',
      desc: '',
      args: [],
    );
  }

  /// `A mix of planning and spontaneity`
  String get preferenceScenarioRoutinePlanningOption2 {
    return Intl.message(
      'A mix of planning and spontaneity',
      name: 'preferenceScenarioRoutinePlanningOption2',
      desc: '',
      args: [],
    );
  }

  /// `Going with the flow feels best`
  String get preferenceScenarioRoutinePlanningOption3 {
    return Intl.message(
      'Going with the flow feels best',
      name: 'preferenceScenarioRoutinePlanningOption3',
      desc: '',
      args: [],
    );
  }

  /// `If something needs addressing at home, what helps most?`
  String get preferenceScenarioConflictResolutionQuestion {
    return Intl.message(
      'If something needs addressing at home, what helps most?',
      name: 'preferenceScenarioConflictResolutionQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Taking time to cool off first`
  String get preferenceScenarioConflictResolutionOption1 {
    return Intl.message(
      'Taking time to cool off first',
      name: 'preferenceScenarioConflictResolutionOption1',
      desc: '',
      args: [],
    );
  }

  /// `Gently checking in at the right moment`
  String get preferenceScenarioConflictResolutionOption2 {
    return Intl.message(
      'Gently checking in at the right moment',
      name: 'preferenceScenarioConflictResolutionOption2',
      desc: '',
      args: [],
    );
  }

  /// `Talking it through sooner rather than later`
  String get preferenceScenarioConflictResolutionOption3 {
    return Intl.message(
      'Talking it through sooner rather than later',
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

  /// `Write a shared starting point for how your home tends to work.`
  String get houseNormPromptSubtitle {
    return Intl.message(
      'Write a shared starting point for how your home tends to work.',
      name: 'houseNormPromptSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Create house norms`
  String get houseNormPromptCta {
    return Intl.message(
      'Create house norms',
      name: 'houseNormPromptCta',
      desc: '',
      args: [],
    );
  }

  /// `House norms`
  String get houseNormOnboardingTitle {
    return Intl.message(
      'House norms',
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

  /// `Generate house norms`
  String get houseNormOnboardingSubmit {
    return Intl.message(
      'Generate house norms',
      name: 'houseNormOnboardingSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Question {current} of {total}`
  String houseNormOnboardingProgress(int current, int total) {
    return Intl.message(
      'Question $current of $total',
      name: 'houseNormOnboardingProgress',
      desc: 'Progress for house norms onboarding',
      args: [current, total],
    );
  }

  /// `We couldn't generate house norms right now. Please try again.`
  String get houseNormGenerationFailed {
    return Intl.message(
      'We couldn\'t generate house norms right now. Please try again.',
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

  /// `Generate house norms to see your shared starting point.`
  String get houseNormReportEmptyBody {
    return Intl.message(
      'Generate house norms to see your shared starting point.',
      name: 'houseNormReportEmptyBody',
      desc: '',
      args: [],
    );
  }

  /// `Could not load house norms`
  String get houseNormReportErrorTitle {
    return Intl.message(
      'Could not load house norms',
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

  /// `A shared starting point - not a rulebook.`
  String get houseNormSummarySubtitle {
    return Intl.message(
      'A shared starting point - not a rulebook.',
      name: 'houseNormSummarySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Summary framing`
  String get houseNormSummaryFramingLabel {
    return Intl.message(
      'Summary framing',
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

  /// `Adjust this section`
  String get houseNormSectionEditLabel {
    return Intl.message(
      'Adjust this section',
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

  /// `Please add text before saving.`
  String get houseNormSectionEmptyError {
    return Intl.message(
      'Please add text before saving.',
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

  /// `We couldn't save that update.`
  String get houseNormSectionSaveFailed {
    return Intl.message(
      'We couldn\'t save that update.',
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

  /// `A shared starting point for how this home tends to work.`
  String get hubHouseNormsSubtitle {
    return Intl.message(
      'A shared starting point for how this home tends to work.',
      name: 'hubHouseNormsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you renting or owning this house?`
  String get houseNormScenarioPropertyContextQuestion {
    return Intl.message(
      'Are you renting or owning this house?',
      name: 'houseNormScenarioPropertyContextQuestion',
      desc: '',
      args: [],
    );
  }

  /// `We own this home`
  String get houseNormScenarioPropertyContextOption1 {
    return Intl.message(
      'We own this home',
      name: 'houseNormScenarioPropertyContextOption1',
      desc: '',
      args: [],
    );
  }

  /// `We rent this whole home`
  String get houseNormScenarioPropertyContextOption2 {
    return Intl.message(
      'We rent this whole home',
      name: 'houseNormScenarioPropertyContextOption2',
      desc: '',
      args: [],
    );
  }

  /// `We rent rooms in a shared home`
  String get houseNormScenarioPropertyContextOption3 {
    return Intl.message(
      'We rent rooms in a shared home',
      name: 'houseNormScenarioPropertyContextOption3',
      desc: '',
      args: [],
    );
  }

  /// `Who's sharing this home together?`
  String get houseNormScenarioRelationshipModelQuestion {
    return Intl.message(
      'Who\'s sharing this home together?',
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

  /// `Family and housemates`
  String get houseNormScenarioRelationshipModelOption3 {
    return Intl.message(
      'Family and housemates',
      name: 'houseNormScenarioRelationshipModelOption3',
      desc: '',
      args: [],
    );
  }

  /// `It is nighttime, and someone is still active at home. What usually feels okay?`
  String get houseNormScenarioRhythmQuestion {
    return Intl.message(
      'It is nighttime, and someone is still active at home. What usually feels okay?',
      name: 'houseNormScenarioRhythmQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Things wind down so the home can rest`
  String get houseNormScenarioRhythmOption1 {
    return Intl.message(
      'Things wind down so the home can rest',
      name: 'houseNormScenarioRhythmOption1',
      desc: '',
      args: [],
    );
  }

  /// `It depends - some nights are quieter than others`
  String get houseNormScenarioRhythmOption2 {
    return Intl.message(
      'It depends - some nights are quieter than others',
      name: 'houseNormScenarioRhythmOption2',
      desc: '',
      args: [],
    );
  }

  /// `Everyone keeps doing their thing`
  String get houseNormScenarioRhythmOption3 {
    return Intl.message(
      'Everyone keeps doing their thing',
      name: 'houseNormScenarioRhythmOption3',
      desc: '',
      args: [],
    );
  }

  /// `You walk into the kitchen at the end of the day. What feels most comfortable?`
  String get houseNormScenarioSharedSpacesQuestion {
    return Intl.message(
      'You walk into the kitchen at the end of the day. What feels most comfortable?',
      name: 'houseNormScenarioSharedSpacesQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Mostly clear and ready to use`
  String get houseNormScenarioSharedSpacesOption1 {
    return Intl.message(
      'Mostly clear and ready to use',
      name: 'houseNormScenarioSharedSpacesOption1',
      desc: '',
      args: [],
    );
  }

  /// `Lived-in, but reset later`
  String get houseNormScenarioSharedSpacesOption2 {
    return Intl.message(
      'Lived-in, but reset later',
      name: 'houseNormScenarioSharedSpacesOption2',
      desc: '',
      args: [],
    );
  }

  /// `A bit messy is fine - it's a shared home`
  String get houseNormScenarioSharedSpacesOption3 {
    return Intl.message(
      'A bit messy is fine - it\'s a shared home',
      name: 'houseNormScenarioSharedSpacesOption3',
      desc: '',
      args: [],
    );
  }

  /// `A friend or partner wants to come over. What usually feels right?`
  String get houseNormScenarioGuestsQuestion {
    return Intl.message(
      'A friend or partner wants to come over. What usually feels right?',
      name: 'houseNormScenarioGuestsQuestion',
      desc: '',
      args: [],
    );
  }

  /// `It's planned and talked about first`
  String get houseNormScenarioGuestsOption1 {
    return Intl.message(
      'It\'s planned and talked about first',
      name: 'houseNormScenarioGuestsOption1',
      desc: '',
      args: [],
    );
  }

  /// `A heads-up is enough`
  String get houseNormScenarioGuestsOption2 {
    return Intl.message(
      'A heads-up is enough',
      name: 'houseNormScenarioGuestsOption2',
      desc: '',
      args: [],
    );
  }

  /// `That's part of daily life here`
  String get houseNormScenarioGuestsOption3 {
    return Intl.message(
      'That\'s part of daily life here',
      name: 'houseNormScenarioGuestsOption3',
      desc: '',
      args: [],
    );
  }

  /// `Something small needs doing around the house. What tends to happen?`
  String get houseNormScenarioResponsibilityQuestion {
    return Intl.message(
      'Something small needs doing around the house. What tends to happen?',
      name: 'houseNormScenarioResponsibilityQuestion',
      desc: '',
      args: [],
    );
  }

  /// `We usually have clear agreements`
  String get houseNormScenarioResponsibilityOption1 {
    return Intl.message(
      'We usually have clear agreements',
      name: 'houseNormScenarioResponsibilityOption1',
      desc: '',
      args: [],
    );
  }

  /// `Someone takes care of it when they notice`
  String get houseNormScenarioResponsibilityOption2 {
    return Intl.message(
      'Someone takes care of it when they notice',
      name: 'houseNormScenarioResponsibilityOption2',
      desc: '',
      args: [],
    );
  }

  /// `Everyone mostly looks after their own things`
  String get houseNormScenarioResponsibilityOption3 {
    return Intl.message(
      'Everyone mostly looks after their own things',
      name: 'houseNormScenarioResponsibilityOption3',
      desc: '',
      args: [],
    );
  }

  /// `Something feels a bit off between people. What helps most?`
  String get houseNormScenarioRepairQuestion {
    return Intl.message(
      'Something feels a bit off between people. What helps most?',
      name: 'houseNormScenarioRepairQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Talking it through sooner rather than later`
  String get houseNormScenarioRepairOption1 {
    return Intl.message(
      'Talking it through sooner rather than later',
      name: 'houseNormScenarioRepairOption1',
      desc: '',
      args: [],
    );
  }

  /// `Checking in gently when the moment feels right`
  String get houseNormScenarioRepairOption2 {
    return Intl.message(
      'Checking in gently when the moment feels right',
      name: 'houseNormScenarioRepairOption2',
      desc: '',
      args: [],
    );
  }

  /// `Letting small things pass unless they build up`
  String get houseNormScenarioRepairOption3 {
    return Intl.message(
      'Letting small things pass unless they build up',
      name: 'houseNormScenarioRepairOption3',
      desc: '',
      args: [],
    );
  }

  /// `On a good day, this home feels most like...`
  String get houseNormScenarioHomeIdentityQuestion {
    return Intl.message(
      'On a good day, this home feels most like...',
      name: 'houseNormScenarioHomeIdentityQuestion',
      desc: '',
      args: [],
    );
  }

  /// `A calm place to recharge`
  String get houseNormScenarioHomeIdentityOption1 {
    return Intl.message(
      'A calm place to recharge',
      name: 'houseNormScenarioHomeIdentityOption1',
      desc: '',
      args: [],
    );
  }

  /// `A balance of quiet time and togetherness`
  String get houseNormScenarioHomeIdentityOption2 {
    return Intl.message(
      'A balance of quiet time and togetherness',
      name: 'houseNormScenarioHomeIdentityOption2',
      desc: '',
      args: [],
    );
  }

  /// `A lively place where people come and go`
  String get houseNormScenarioHomeIdentityOption3 {
    return Intl.message(
      'A lively place where people come and go',
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

  /// `So others can understand what feels comfortable to you.`
  String get reflectivePersonalSecondary {
    return Intl.message(
      'So others can understand what feels comfortable to you.',
      name: 'reflectivePersonalSecondary',
      desc: '',
      args: [],
    );
  }

  /// `Putting the home's expectations into words.`
  String get reflectiveHousePrimary {
    return Intl.message(
      'Putting the home\'s expectations into words.',
      name: 'reflectiveHousePrimary',
      desc: '',
      args: [],
    );
  }

  /// `So everyone knows what to expect.`
  String get reflectiveHouseSecondary {
    return Intl.message(
      'So everyone knows what to expect.',
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

  /// `A shared reference, not a rulebook.`
  String get reflectiveHouseNormsSecondary {
    return Intl.message(
      'A shared reference, not a rulebook.',
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

  /// `A quiet moment before we show it.`
  String get reflectiveGenericSecondary {
    return Intl.message(
      'A quiet moment before we show it.',
      name: 'reflectiveGenericSecondary',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't finish your preference reflection. Please try again soon.`
  String get preferenceReportGenerationMissing {
    return Intl.message(
      'We couldn\'t finish your preference reflection. Please try again soon.',
      name: 'preferenceReportGenerationMissing',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't finish your preference reflection. Head back and try again.`
  String get preferenceReportGenerationFailed {
    return Intl.message(
      'We couldn\'t finish your preference reflection. Head back and try again.',
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

  /// `We couldn't load your personal profile right now. Please try again.`
  String get personalProfileLoadError {
    return Intl.message(
      'We couldn\'t load your personal profile right now. Please try again.',
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

  /// `Weekly house pulse`
  String get housePulseCardHeader {
    return Intl.message(
      'Weekly house pulse',
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

  /// `Sharing our Kinly house pulse`
  String get housePulseShareTitle {
    return Intl.message(
      'Sharing our Kinly house pulse',
      name: 'housePulseShareTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sharing our Kinly house pulse. Download the app: {link}`
  String housePulseShareMessage(String link) {
    return Intl.message(
      'Sharing our Kinly house pulse. Download the app: $link',
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

  /// `Mostly smooth, with a few small bumps.`
  String get pulseSunnyBumpySummary {
    return Intl.message(
      'Mostly smooth, with a few small bumps.',
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

  /// `Overall steady, with some areas to improve.`
  String get pulsePartlySupportedSummary {
    return Intl.message(
      'Overall steady, with some areas to improve.',
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

  /// `A mix of smooth moments and small friction.`
  String get pulseCloudySteadySummary {
    return Intl.message(
      'A mix of smooth moments and small friction.',
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

  /// `Some tension surfaced this week.`
  String get pulseCloudyTenseSummary {
    return Intl.message(
      'Some tension surfaced this week.',
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

  /// `Tension is high. A quick reset can help.`
  String get pulseThunderstormSummary {
    return Intl.message(
      'Tension is high. A quick reset can help.',
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

  /// `Add a short note to send this mention.`
  String get harmonyErrorCommentRequiredForMention {
    return Intl.message(
      'Add a short note to send this mention.',
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

  /// `Add a short note to post this shoutout.`
  String get harmonyErrorCommentRequiredForPublicWall {
    return Intl.message(
      'Add a short note to post this shoutout.',
      name: 'harmonyErrorCommentRequiredForPublicWall',
      desc: '',
      args: [],
    );
  }

  /// `Add a little more detail so it's clear.`
  String get harmonyErrorComplaintTooShort {
    return Intl.message(
      'Add a little more detail so it\'s clear.',
      name: 'harmonyErrorComplaintTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Write a short sentence so it's easier to understand.`
  String get harmonyErrorComplaintTooBrief {
    return Intl.message(
      'Write a short sentence so it\'s easier to understand.',
      name: 'harmonyErrorComplaintTooBrief',
      desc: '',
      args: [],
    );
  }

  /// `Add a clear sentence so it's easier to understand.`
  String get harmonyErrorComplaintNeedsSentence {
    return Intl.message(
      'Add a clear sentence so it\'s easier to understand.',
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

  /// `Could not sign in. Please check your credentials.`
  String get demoAccessError {
    return Intl.message(
      'Could not sign in. Please check your credentials.',
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
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
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
