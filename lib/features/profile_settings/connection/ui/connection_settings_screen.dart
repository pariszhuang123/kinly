import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/kinly_list_tile.dart';
import '../../../../core/ui/settings/kinly_settings_card.dart';
import '../../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../../core/ui/kinly_time_picker.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/time/iana_timezone_resolver.dart';
import '../bloc/connection_settings_bloc.dart';
import '../../../../core/ui/kinly_scaffold.dart';
import '../../../../core/ui/kinly_app_bar.dart';
import '../../../../core/ui/kinly_theme_access.dart';
import '../../../../core/ui/kinly_icons.dart';
import '../../../../core/ui/kinly_switch.dart';
import '../../../../core/ui/kinly_divider.dart';
import '../../../../core/ui/kinly_time_types.dart';

class ConnectionSettingsScreen extends StatefulWidget {
  const ConnectionSettingsScreen({super.key});

  @override
  State<ConnectionSettingsScreen> createState() =>
      _ConnectionSettingsScreenState();
}

class _ConnectionSettingsScreenState extends State<ConnectionSettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    final ctx = context;
    final locale = Localizations.localeOf(ctx).toLanguageTag();
    final platform = KinlyThemeAccess.of(ctx).platform.name;
    final timezone = await sl<IanaTimezoneResolver>().resolve();
    String? deviceToken;
    try {
      deviceToken = await FirebaseMessaging.instance.getToken();
    } catch (_) {
      deviceToken = null;
    }
    if (!mounted || !ctx.mounted) return;
    ctx.read<ConnectionSettingsBloc>().add(
      ConnectionSettingsStarted(
        locale: locale,
        timezone: timezone,
        platform: platform,
        deviceToken: deviceToken,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>()!;
    final s = S.of(context);

    return KinlyScaffold(
      appBar: KinlyAppBar(title: Text(s.connectionSettingsTitle)),
      body: BlocConsumer<ConnectionSettingsBloc, ConnectionSettingsState>(
        listener: (context, state) async {
          final accent =
              KinlyThemeAccess.of(context).extension<KinlySections>()?.pulse.accent;
          if (state.action == ConnectionSettingsAction.showError) {
            KinlySnackBar.showError(
              context,
              state.actionMessage ?? s.connectionSettingsGenericError,
              accentColor: accent,
            );
            context.read<ConnectionSettingsBloc>().add(
              const ConnectionSettingsActionCleared(),
            );
            return;
          }

          if (state.action == ConnectionSettingsAction.openSystemSettings) {
            final bloc = context.read<ConnectionSettingsBloc>();
            KinlySnackBar.showInfo(
              context,
              s.connectionNotificationsPermissionBlocked,
              accentColor: accent,
            );
            await openAppSettings();
            if (!mounted || !context.mounted) return;
            bloc.add(const ConnectionSettingsPermissionRechecked());
            bloc.add(const ConnectionSettingsActionCleared());
          }

          if (state.action == ConnectionSettingsAction.permissionBlocked) {
            KinlySnackBar.showInfo(
              context,
              s.connectionNotificationsPermissionBlocked,
              accentColor: accent,
            );
            context.read<ConnectionSettingsBloc>().add(
              const ConnectionSettingsActionCleared(),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: KinlyLoader());
          }

          final timeText = _formatHour(
            context,
            state.preferredHour,
            state.preferredMinute,
          );

          return ListView(
            padding: EdgeInsetsDirectional.fromSTEB(
              spacing.lg,
              spacing.lg,
              spacing.lg,
              spacing.lg,
            ),
            children: [
              Text(
                s.connectionSettingsSubtitle,
                style: KinlyThemeAccess.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: spacing.md),
              KinlySettingsCard(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      spacing.l,
                      spacing.md,
                      spacing.l,
                      spacing.md,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.connectionNotificationsToggleTitle,
                                style: KinlyThemeAccess.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: spacing.xs),
                              Text(
                                state.wantsDaily
                                    ? s.connectionNotificationsToggleSubtitleOn
                                    : s.connectionNotificationsToggleSubtitleOff,
                                style: KinlyThemeAccess.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color:
                                      KinlyThemeAccess.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        KinlySwitch.adaptive(
                          value: state.wantsDaily,
                          onChanged:
                              state.isSavingToggle
                                  ? null
                                  : (enabled) {
                                    context.read<ConnectionSettingsBloc>().add(
                                      ConnectionSettingsToggleRequested(
                                        enabled: enabled,
                                      ),
                                    );
                                  },
                        ),
                      ],
                    ),
                  ),
                  if (!state.canEditTime &&
                      state.osPermission == 'blocked') ...[
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        spacing.l,
                        0,
                        spacing.l,
                        spacing.md,
                      ),
                      child: Text(
                        s.connectionNotificationsPermissionBlocked,
                        style: KinlyThemeAccess.of(context).textTheme.bodySmall?.copyWith(
                          color: KinlyThemeAccess.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                  if (state.canEditTime) ...[
                    const KinlyDivider(height: 0),
                    KinlyListTile(
                      contentPadding: EdgeInsetsDirectional.fromSTEB(
                        spacing.l,
                        spacing.md,
                        spacing.l,
                        spacing.md,
                      ),
                      title: s.connectionNotificationsTimeLabel,
                      subtitle: s.connectionNotificationsTimeSubtitle(
                        timeText,
                      ),
                      trailing:
                          state.isSavingTime
                              ? SizedBox(
                                width: 20,
                                height: 20,
                                child: KinlyLoader(
                                  size: 18,
                                  color: KinlyThemeAccess.of(context).colorScheme.primary,
                                ),
                              )
                                : Icon(KinlyIcons.chevronRight),
                      onTap:
                          state.isSavingTime
                              ? null
                              : () => _pickTime(
                                context,
                                state.preferredHour,
                                state.preferredMinute,
                              ),
                    ),
                  ],
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    int currentHour,
    int currentMinute,
  ) async {
    final bloc = context.read<ConnectionSettingsBloc>();
    final initialTime = TimeOfDay(
      hour: currentHour,
      minute: currentMinute,
    );
    final picked = await showKinlyTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (!context.mounted || picked == null) return;
    if (picked.hour == currentHour && picked.minute == currentMinute) return;
    bloc.add(
      ConnectionSettingsTimeChanged(
        hour: picked.hour,
        minute: picked.minute,
      ),
    );
  }

  String _formatHour(BuildContext context, int hour, int minute) {
    final time = TimeOfDay(hour: hour, minute: minute);
    final localizations = MaterialLocalizations.of(context);
    final mediaQuery = MediaQuery.of(context);
    return localizations.formatTimeOfDay(
      time,
      alwaysUse24HourFormat: mediaQuery.alwaysUse24HourFormat,
    );
  }
}




