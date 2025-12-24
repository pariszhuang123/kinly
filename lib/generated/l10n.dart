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

  /// `Bring more harmony to your home`
  String get paywallTitle {
    return Intl.message(
      'Bring more harmony to your home',
      name: 'paywallTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your home-level upgrade for less than 0.5% of your rent.`
  String get paywallSubtitle {
    return Intl.message(
      'Your home-level upgrade for less than 0.5% of your rent.',
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

  /// `Unlimited flows`
  String get paywallBulletFlows {
    return Intl.message(
      'Unlimited flows',
      name: 'paywallBulletFlows',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited flow photos`
  String get paywallBulletPhotos {
    return Intl.message(
      'Unlimited flow photos',
      name: 'paywallBulletPhotos',
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

  /// `Create a flow`
  String get quick_add_flow_subtitle {
    return Intl.message(
      'Create a flow',
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

  /// `Note a fairness entry`
  String get quick_add_fair_share_subtitle {
    return Intl.message(
      'Note a fairness entry',
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

  /// `Add Flow`
  String get todayAddSheetFlow {
    return Intl.message(
      'Add Flow',
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

  /// `Checking membership status...`
  String get membership_status_checking {
    return Intl.message(
      'Checking membership status...',
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

  /// `You’re already connected to a home.`
  String get membership_status_active {
    return Intl.message(
      'You’re already connected to a home.',
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

  /// `Home members`
  String get hubMembersTitle {
    return Intl.message(
      'Home members',
      name: 'hubMembersTitle',
      desc: '',
      args: [],
    );
  }

  /// `People currently active in this home.`
  String get hubMembersSubtitle {
    return Intl.message(
      'People currently active in this home.',
      name: 'hubMembersSubtitle',
      desc: '',
      args: [],
    );
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

  /// `Share Kinly so sharing feels lighter: {link}`
  String hubShareAppBody(String link) {
    return Intl.message(
      'Share Kinly so sharing feels lighter: $link',
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

  /// `Copy invite code`
  String get hubCopyCode {
    return Intl.message(
      'Copy invite code',
      name: 'hubCopyCode',
      desc: '',
      args: [],
    );
  }

  /// `Bring your home into Kinly`
  String get todayFlatmateInviteTitle {
    return Intl.message(
      'Bring your home into Kinly',
      name: 'todayFlatmateInviteTitle',
      desc: '',
      args: [],
    );
  }

  /// `Invite them so you can stay aligned and share the load.`
  String get todayFlatmateInviteSubtitle {
    return Intl.message(
      'Invite them so you can stay aligned and share the load.',
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

  /// `Share Kinly with a friend so they can bring more harmony to their home too.`
  String get todayInviteFriendsSubtitle {
    return Intl.message(
      'Share Kinly with a friend so they can bring more harmony to their home too.',
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

  /// `Gratitude Wall`
  String get hubCardGratitudeWallTitle {
    return Intl.message(
      'Gratitude Wall',
      name: 'hubCardGratitudeWallTitle',
      desc: '',
      args: [],
    );
  }

  /// `Read quick thank-yous and small moments of appreciation.`
  String get hubCardGratitudeWallSubtitle {
    return Intl.message(
      'Read quick thank-yous and small moments of appreciation.',
      name: 'hubCardGratitudeWallSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load Hub. Please try again.`
  String get hubError {
    return Intl.message(
      'Couldn\'t load Hub. Please try again.',
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

  /// `?`
  String get unknownInitial {
    return Intl.message('?', name: 'unknownInitial', desc: '', args: []);
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

  /// `upcoming`
  String get todayShareBadgeUpcoming {
    return Intl.message(
      'upcoming',
      name: 'todayShareBadgeUpcoming',
      desc: '',
      args: [],
    );
  }

  /// `See all bills`
  String get todayShareSeeAll {
    return Intl.message(
      'See all bills',
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

  /// `Nothing to see here yet.`
  String get todayShareEmptyState {
    return Intl.message(
      'Nothing to see here yet.',
      name: 'todayShareEmptyState',
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

  /// `Split based on the bill share.`
  String get todayShareDraftSubtitle {
    return Intl.message(
      'Split based on the bill share.',
      name: 'todayShareDraftSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Home Gratitude wall`
  String get todayGratitudeSectionTitle {
    return Intl.message(
      'Home Gratitude wall',
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

  /// `View wall`
  String get todayGratitudeOpenCta {
    return Intl.message(
      'View wall',
      name: 'todayGratitudeOpenCta',
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

  /// `Select the bill you just settled.`
  String get shareOwedDetailSubtitle {
    return Intl.message(
      'Select the bill you just settled.',
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

  /// `Select who to share with.`
  String get shareOwedDetailSelectionLabel {
    return Intl.message(
      'Select who to share with.',
      name: 'shareOwedDetailSelectionLabel',
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

  /// `Edit Share`
  String get shareEditTitle {
    return Intl.message(
      'Edit Share',
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

  /// `Couldn't delete. Try again.`
  String get shareEditDeleteError {
    return Intl.message(
      'Couldn\'t delete. Try again.',
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

  /// `Create`
  String get shareCreateTitle {
    return Intl.message('Create', name: 'shareCreateTitle', desc: '', args: []);
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

  /// `Who's sharing?`
  String get shareCreateParticipantsLabel {
    return Intl.message(
      'Who\'s sharing?',
      name: 'shareCreateParticipantsLabel',
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

  /// `Repeat`
  String get shareCreateRecurrenceLabel {
    return Intl.message(
      'Repeat',
      name: 'shareCreateRecurrenceLabel',
      desc: '',
      args: [],
    );
  }

  /// `One-time`
  String get shareCreateRecurrenceNone {
    return Intl.message(
      'One-time',
      name: 'shareCreateRecurrenceNone',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get shareCreateRecurrenceWeekly {
    return Intl.message(
      'Weekly',
      name: 'shareCreateRecurrenceWeekly',
      desc: '',
      args: [],
    );
  }

  /// `Every 2 weeks`
  String get shareCreateRecurrenceEvery2Weeks {
    return Intl.message(
      'Every 2 weeks',
      name: 'shareCreateRecurrenceEvery2Weeks',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get shareCreateRecurrenceMonthly {
    return Intl.message(
      'Monthly',
      name: 'shareCreateRecurrenceMonthly',
      desc: '',
      args: [],
    );
  }

  /// `Every 2 months`
  String get shareCreateRecurrenceEvery2Months {
    return Intl.message(
      'Every 2 months',
      name: 'shareCreateRecurrenceEvery2Months',
      desc: '',
      args: [],
    );
  }

  /// `Annual`
  String get shareCreateRecurrenceAnnual {
    return Intl.message(
      'Annual',
      name: 'shareCreateRecurrenceAnnual',
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

  /// `Choose how you want to share.`
  String get shareCreateValidationSplit {
    return Intl.message(
      'Choose how you want to share.',
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

  /// `Make sure the custom split adds up to the amount above.`
  String get shareCreateValidationCustomSum {
    return Intl.message(
      'Make sure the custom split adds up to the amount above.',
      name: 'shareCreateValidationCustomSum',
      desc: '',
      args: [],
    );
  }

  /// `Share the amount between at least two people when using a custom split.`
  String get shareCreateValidationCustomSinglePayer {
    return Intl.message(
      'Share the amount between at least two people when using a custom split.',
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

  /// `Drafts can’t repeat until you add a split.`
  String get shareCreateErrorRecurrenceDraft {
    return Intl.message(
      'Drafts can’t repeat until you add a split.',
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

  /// `Add Flow`
  String get flowChoreCreateTitle {
    return Intl.message(
      'Add Flow',
      name: 'flowChoreCreateTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit Flow`
  String get flowChoreEditTitle {
    return Intl.message(
      'Edit Flow',
      name: 'flowChoreEditTitle',
      desc: '',
      args: [],
    );
  }

  /// `What are we agreeing on?`
  String get flowChoreNameLabel {
    return Intl.message(
      'What are we agreeing on?',
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

  /// `Give the flow a name.`
  String get flowChoreValidationName {
    return Intl.message(
      'Give the flow a name.',
      name: 'flowChoreValidationName',
      desc: '',
      args: [],
    );
  }

  /// `Who’s taking this on?`
  String get flowChoreAssigneeLabel {
    return Intl.message(
      'Who’s taking this on?',
      name: 'flowChoreAssigneeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Open to anyone`
  String get flowChoreAssigneeUnassigned {
    return Intl.message(
      'Open to anyone',
      name: 'flowChoreAssigneeUnassigned',
      desc: '',
      args: [],
    );
  }

  /// `Choose someone, or leave it open for anyone.`
  String get flowChoreValidationAssignee {
    return Intl.message(
      'Choose someone, or leave it open for anyone.',
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

  /// `Why this matters`
  String get flowChoreNotesLabel {
    return Intl.message(
      'Why this matters',
      name: 'flowChoreNotesLabel',
      desc: '',
      args: [],
    );
  }

  /// `Anything that helps others understand the flow`
  String get flowChoreNotesHint {
    return Intl.message(
      'Anything that helps others understand the flow',
      name: 'flowChoreNotesHint',
      desc: '',
      args: [],
    );
  }

  /// `Guide link`
  String get flowChoreHowToLabel {
    return Intl.message(
      'Guide link',
      name: 'flowChoreHowToLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add a link to help someone to follow`
  String get flowChoreHowToHint {
    return Intl.message(
      'Add a link to help someone to follow',
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

  /// `What 'great' looks like`
  String get flowChorePhotoLabel {
    return Intl.message(
      'What \'great\' looks like',
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

  /// `Delete flow`
  String get flowChoreDeleteButton {
    return Intl.message(
      'Delete flow',
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

  /// `We couldn't load this flow. Please try again.`
  String get flowChoreLoadError {
    return Intl.message(
      'We couldn\'t load this flow. Please try again.',
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

  /// `You're at the free limit for expectation photos. Upgrade for more space.`
  String get flowChoreErrorPaywallMediaCap {
    return Intl.message(
      'You\'re at the free limit for expectation photos. Upgrade for more space.',
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

  /// `This flow isn't updateable right now.`
  String get flowChoreErrorInvalidState {
    return Intl.message(
      'This flow isn\'t updateable right now.',
      name: 'flowChoreErrorInvalidState',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't save the flow. Please try again.`
  String get flowChoreErrorGeneric {
    return Intl.message(
      'Couldn\'t save the flow. Please try again.',
      name: 'flowChoreErrorGeneric',
      desc: '',
      args: [],
    );
  }

  /// `Flow details`
  String get flowChoreDetailTitle {
    return Intl.message(
      'Flow details',
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

  /// `Flow created.`
  String get flowChoreCreateSuccess {
    return Intl.message(
      'Flow created.',
      name: 'flowChoreCreateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Flow updated.`
  String get flowChoreUpdateSuccess {
    return Intl.message(
      'Flow updated.',
      name: 'flowChoreUpdateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Flow completed.`
  String get flowChoreDetailCompletionSuccess {
    return Intl.message(
      'Flow completed.',
      name: 'flowChoreDetailCompletionSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't complete the flow. Please try again.`
  String get flowChoreDetailCompletionError {
    return Intl.message(
      'Couldn\'t complete the flow. Please try again.',
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

  /// `Create your first flow so everyone feels clear and aligned.`
  String get flowListEmptySubtitle {
    return Intl.message(
      'Create your first flow so everyone feels clear and aligned.',
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

  /// `Past date`
  String get flowListOverdueLabel {
    return Intl.message(
      'Past date',
      name: 'flowListOverdueLabel',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't load Flow. Pull to refresh.`
  String get flowListError {
    return Intl.message(
      'We couldn\'t load Flow. Pull to refresh.',
      name: 'flowListError',
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

  /// `Review every Flow and keep flows moving`
  String get exploreFlowSubtitle {
    return Intl.message(
      'Review every Flow and keep flows moving',
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

  /// `Create a Bill to see it listed here.`
  String get shareCreatedListEmptySubtitle {
    return Intl.message(
      'Create a Bill to see it listed here.',
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

  /// `Member removed`
  String get profileKickSuccessTitle {
    return Intl.message(
      'Member removed',
      name: 'profileKickSuccessTitle',
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

  /// `Back to settings`
  String get profileKickSuccessClose {
    return Intl.message(
      'Back to settings',
      name: 'profileKickSuccessClose',
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

  /// `You'll lose access to Flow, history, and invites.`
  String get profileConfirmLeaveMessage {
    return Intl.message(
      'You\'ll lose access to Flow, history, and invites.',
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

  /// `Cancel`
  String get profileActionCancel {
    return Intl.message(
      'Cancel',
      name: 'profileActionCancel',
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

  /// `Weekly house harmony`
  String get harmonyTitle {
    return Intl.message(
      'Weekly house harmony',
      name: 'harmonyTitle',
      desc: '',
      args: [],
    );
  }

  /// `How's your home feeling this week?`
  String get harmonyQuestion {
    return Intl.message(
      'How\'s your home feeling this week?',
      name: 'harmonyQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Pick the weather that best matches your vibe and leave an optional note.`
  String get harmonySubtext {
    return Intl.message(
      'Pick the weather that best matches your vibe and leave an optional note.',
      name: 'harmonySubtext',
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

  /// `Anything you’d like to share?`
  String get harmonyCommentLabel {
    return Intl.message(
      'Anything you’d like to share?',
      name: 'harmonyCommentLabel',
      desc: '',
      args: [],
    );
  }

  /// `What’s been contributing to this feeling at home?`
  String get harmonyCommentHint {
    return Intl.message(
      'What’s been contributing to this feeling at home?',
      name: 'harmonyCommentHint',
      desc: '',
      args: [],
    );
  }

  /// `Share this with the home`
  String get harmonyShareLabel {
    return Intl.message(
      'Share this with the home',
      name: 'harmonyShareLabel',
      desc: '',
      args: [],
    );
  }

  /// `Send feedback`
  String get harmonySubmitCta {
    return Intl.message(
      'Send feedback',
      name: 'harmonySubmitCta',
      desc: '',
      args: [],
    );
  }

  /// `Thanks! Your feedback was saved.`
  String get harmonySubmitSuccess {
    return Intl.message(
      'Thanks! Your feedback was saved.',
      name: 'harmonySubmitSuccess',
      desc: '',
      args: [],
    );
  }

  /// `You've already shared your mood for this week.`
  String get harmonyErrorAlreadySubmitted {
    return Intl.message(
      'You\'ve already shared your mood for this week.',
      name: 'harmonyErrorAlreadySubmitted',
      desc: '',
      args: [],
    );
  }

  /// `You are unable to submit feedback for this home.`
  String get harmonyErrorForbidden {
    return Intl.message(
      'You are unable to submit feedback for this home.',
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

  /// `Pick a mood before submitting.`
  String get harmonyErrorSelectMood {
    return Intl.message(
      'Pick a mood before submitting.',
      name: 'harmonyErrorSelectMood',
      desc: '',
      args: [],
    );
  }

  /// `Share this week's mood`
  String get harmonyEntryCta {
    return Intl.message(
      'Share this week\'s mood',
      name: 'harmonyEntryCta',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't open harmony feedback. Try again.`
  String get harmonyEntryError {
    return Intl.message(
      'Couldn\'t open harmony feedback. Try again.',
      name: 'harmonyEntryError',
      desc: '',
      args: [],
    );
  }

  /// `Gratitude wall`
  String get gratitudeWallTitle {
    return Intl.message(
      'Gratitude wall',
      name: 'gratitudeWallTitle',
      desc: '',
      args: [],
    );
  }

  /// `{time} today`
  String gratitudeWallTimestamp(String time) {
    return Intl.message(
      '$time today',
      name: 'gratitudeWallTimestamp',
      desc: '',
      args: [time],
    );
  }

  /// `No gratitude posts yet`
  String get gratitudeWallEmptyTitle {
    return Intl.message(
      'No gratitude posts yet',
      name: 'gratitudeWallEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Share a sunny moment to start filling the wall.`
  String get gratitudeWallEmptySubtitle {
    return Intl.message(
      'Share a sunny moment to start filling the wall.',
      name: 'gratitudeWallEmptySubtitle',
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

  /// `Share this wall`
  String get gratitudeWallShareCta {
    return Intl.message(
      'Share this wall',
      name: 'gratitudeWallShareCta',
      desc: '',
      args: [],
    );
  }

  /// `Gratitude wall`
  String get gratitudeWallShareTitle {
    return Intl.message(
      'Gratitude wall',
      name: 'gratitudeWallShareTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sharing a glimpse of our Kinly gratitude wall. Download the app: {link}`
  String gratitudeWallShareMessage(String link) {
    return Intl.message(
      'Sharing a glimpse of our Kinly gratitude wall. Download the app: $link',
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

  /// `Powered by`
  String get gratitudeWallPoweredBy {
    return Intl.message(
      'Powered by',
      name: 'gratitudeWallPoweredBy',
      desc: '',
      args: [],
    );
  }

  /// `Shared moments from your home.`
  String get gratitudeWallSubtitle {
    return Intl.message(
      'Shared moments from your home.',
      name: 'gratitudeWallSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Kinly helps your home share small moments of gratitude.`
  String get gratitudeWallKinlySubtitle {
    return Intl.message(
      'Kinly helps your home share small moments of gratitude.',
      name: 'gratitudeWallKinlySubtitle',
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

  /// `Gratitude wall {count, plural, one {(#)} other {(#)}}`
  String gratitudeWallTitleCount(int count) {
    return Intl.message(
      'Gratitude wall ${Intl.plural(count, one: '(#)', other: '(#)')}',
      name: 'gratitudeWallTitleCount',
      desc: '',
      args: [count],
    );
  }

  /// `How likely are you to recommend Kinly to a friend?`
  String get npsTitle {
    return Intl.message(
      'How likely are you to recommend Kinly to a friend?',
      name: 'npsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Net Promoter Score helps us learn how we're doing. Pick a number from 0 (not likely) to 10 (extremely likely).`
  String get npsDescription {
    return Intl.message(
      'Net Promoter Score helps us learn how we\'re doing. Pick a number from 0 (not likely) to 10 (extremely likely).',
      name: 'npsDescription',
      desc: '',
      args: [],
    );
  }

  /// `0 Not likely`
  String get npsScaleLowLabel {
    return Intl.message(
      '0 Not likely',
      name: 'npsScaleLowLabel',
      desc: '',
      args: [],
    );
  }

  /// `10 Extremely likely`
  String get npsScaleHighLabel {
    return Intl.message(
      '10 Extremely likely',
      name: 'npsScaleHighLabel',
      desc: '',
      args: [],
    );
  }

  /// `You need to pick a score to continue.`
  String get npsCannotSkip {
    return Intl.message(
      'You need to pick a score to continue.',
      name: 'npsCannotSkip',
      desc: '',
      args: [],
    );
  }

  /// `This feedback isn't needed right now.`
  String get npsSubmitErrorNotRequired {
    return Intl.message(
      'This feedback isn\'t needed right now.',
      name: 'npsSubmitErrorNotRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please pick a score between 0 and 10.`
  String get npsSubmitErrorInvalidScore {
    return Intl.message(
      'Please pick a score between 0 and 10.',
      name: 'npsSubmitErrorInvalidScore',
      desc: '',
      args: [],
    );
  }

  /// `You're not allowed to submit feedback right now.`
  String get npsSubmitErrorForbidden {
    return Intl.message(
      'You\'re not allowed to submit feedback right now.',
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

  /// `What can we improve?`
  String get npsEmailSubject {
    return Intl.message(
      'What can we improve?',
      name: 'npsEmailSubject',
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
