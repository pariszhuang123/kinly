import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/core/auth/user_context.dart';
import 'package:kinly/core/auth/user_context_cubit.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/contracts/personal_directory/route_args.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/ui/kinly_bottom_sheet.dart';
import 'package:kinly/core/ui/enums/personal_profile_entry_source.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/theme/spacing.dart';

Future<void> showPersonalProfileSheet({
  required BuildContext context,
  required UserContextCubit userContextCubit,
  required PersonalProfileEntrySource entrySource,
}) async {
  final strings = S.of(context);
  final ctx = await userContextCubit.refresh();
  if (!context.mounted) return;
  if (ctx == null) {
    KinlySnackBar.showError(context, strings.personalProfileLoadError);
    return;
  }

  await KinlyBottomSheet.show(
    context: context,
    title: strings.personalProfileTitle,
    body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (ctx.hasPersonalDirectoryContent)
          _PersonalProfileActionTile(
            icon: KinlyIcons.menuBookOutlined,
            label: strings.personalProfilePersonalDirectory,
            onTap: () {
              Navigator.of(context).pop();
              GoRouter.of(context).pushNamed(
                AppRouteNames.personalDirectory,
                extra: PersonalDirectoryScreenRouteArgs(
                  target: PersonalDirectoryMemberSummary(
                    userId: ctx.userId,
                    username: (ctx.displayName ?? '').trim(),
                    avatarUrl: ctx.avatarUrl,
                    isHomeOwner: false,
                  ),
                  canEdit: true,
                ),
              );
            },
          ),
        _PersonalProfileActionTile(
          icon: KinlyIcons.tuneRounded,
          label: strings.personalProfilePreferences,
          onTap: () {
            Navigator.of(context).pop();
            _openPreferences(
              context: context,
              userContext: ctx,
              entrySource: entrySource,
            );
          },
        ),
        if (ctx.hasPersonalMentions)
          _PersonalProfileActionTile(
            icon: KinlyIcons.favoriteRounded,
            label: strings.personalProfileMentions,
            onTap: () {
              Navigator.of(context).pop();
              _openMentions(context, entrySource);
            },
          ),
      ],
    ),
  );
}

void _openPreferences({
  required BuildContext context,
  required UserContext userContext,
  required PersonalProfileEntrySource entrySource,
}) {
  final router = GoRouter.of(context);
  final extra = <String, Object?>{'entrySource': entrySource.wireValue};
  if (entrySource == PersonalProfileEntrySource.start) {
    extra['canEdit'] = false;
    extra['showDoneCta'] = false;
  }
  if (userContext.hasPreferenceReport) {
    router.pushNamed(AppRouteNames.preferenceReport, extra: extra);
  } else {
    router.pushNamed(AppRouteNames.preferenceOnboarding, extra: extra);
  }
}

void _openMentions(
  BuildContext context,
  PersonalProfileEntrySource entrySource,
) {
  final router = GoRouter.of(context);
  router.pushNamed(
    AppRouteNames.personalMentions,
    extra: {'entrySource': entrySource.wireValue},
  );
}

class _PersonalProfileActionTile extends StatelessWidget {
  const _PersonalProfileActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final textStyle = theme.textTheme.titleMedium;

    return Semantics(
      container: true,
      button: true,
      label: label,
      child: KinlyTapTarget(
        alignment: AlignmentDirectional.centerStart,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(vertical: spacing.xs),
          child: Row(
            children: [
              SizedBox(
                width: spacing.lg,
                height: spacing.lg,
                child: Center(child: Icon(icon, color: theme.colorScheme.onSurface)),
              ),
              SizedBox(width: spacing.m),
              Expanded(
                child: Text(
                  label,
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
