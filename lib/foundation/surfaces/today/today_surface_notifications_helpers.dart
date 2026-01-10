part of 'today_surface.dart';

@visibleForTesting
Future<void> debugTriggerNotificationPromptImpl(
  BuildContext context, {
  VoidCallback? onPrompt,
}) => _maybePromptNotificationsImpl(context, onPrompt);

@visibleForTesting
Future<void> maybePromptNotificationsForTest(
  BuildContext context, {
  VoidCallback? onPrompt,
  NotificationPermissionService? permissionService,
  NotificationsRepository? notificationsRepository,
  DeviceTokenProvider? tokenProvider,
  IanaTimezoneResolver? timezoneResolver,
  Logger? logger,
}) => _maybePromptNotificationsImpl(
  context,
  onPrompt,
  permissionService: permissionService,
  notificationsRepository: notificationsRepository,
  tokenProvider: tokenProvider,
  timezoneResolver: timezoneResolver,
  logger: logger,
);

Future<void> _maybePromptNotificationsImpl(
  BuildContext context,
  VoidCallback? onPrompt, {
  NotificationPermissionService? permissionService,
  NotificationsRepository? notificationsRepository,
  DeviceTokenProvider? tokenProvider,
  IanaTimezoneResolver? timezoneResolver,
  Logger? logger,
}) async {
  if (!context.mounted) return;
  onPrompt?.call();
  final repo = notificationsRepository ?? sl<NotificationsRepository>();
  final resolvedPermissionService =
      permissionService ??
      (sl.isRegistered<NotificationPermissionService>()
          ? sl<NotificationPermissionService>()
          : NotificationPermissionService(notificationsRepository: repo));
  final resolvedTokenProvider =
      tokenProvider ??
      (sl.isRegistered<DeviceTokenProvider>()
          ? sl<DeviceTokenProvider>()
          : const FirebaseDeviceTokenProvider());
  final resolvedTimezoneResolver =
      timezoneResolver ?? sl<IanaTimezoneResolver>();
  final locale = Localizations.localeOf(context).toLanguageTag();
  final platformName = KinlyThemeAccess.of(context).platform.name;
  final timezone = await resolvedTimezoneResolver.resolve();
  final resolvedLogger =
      logger ??
      (sl.isRegistered<Logger>() ? sl<Logger>() : const DebugLogger());
  const notifTag = 'TodayNotifications';
  resolvedLogger.debug(
    'Using timezone=$timezone for notifications sync',
    tag: notifTag,
  );
  String? deviceToken;
  try {
    deviceToken = await resolvedTokenProvider.getToken();
  } catch (error, stackTrace) {
    resolvedLogger.warn(
      'Failed to read device token; continuing without it',
      tag: notifTag,
      error: error,
      stackTrace: stackTrace,
    );
  }
  if (!context.mounted) return;
  try {
    await resolvedPermissionService.requestAndSync(
      wantsDaily: true,
      preferredHour: 9,
      preferredMinute: 0,
      timezone: timezone,
      locale: locale,
      deviceToken: deviceToken,
      platform: platformName,
    );
  } on NotificationPermissionException catch (error, stackTrace) {
    resolvedLogger.warn(
      'Notification permission rejected or unavailable',
      tag: notifTag,
      error: error,
      stackTrace: stackTrace,
    );
  } catch (error, stackTrace) {
    resolvedLogger.warn(
      'Failed to request notification permissions',
      tag: notifTag,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
