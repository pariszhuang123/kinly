import 'dart:ui' show Color;

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/homes/home_units_models.dart';
import 'package:kinly/contracts/profile_settings/profile_shared_unit_create_route_args.dart';
import 'package:kinly/contracts/profile_settings/profile_shared_unit_rename_route_args.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/dialogs/kinly_dialogs.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/generated/l10n.dart';

import 'bloc/profile_shared_unit_hub_bloc.dart';

class ProfileSharedUnitHubScreen extends StatelessWidget {
  const ProfileSharedUnitHubScreen({
    super.key,
    required this.homeId,
    required this.creatorMembershipId,
  });

  final String homeId;
  final String creatorMembershipId;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final strings = S.of(context);

    return KinlyScaffold(
      appBar: KinlyAppBar(title: Text(strings.profileSharedUnitSectionTitle)),
      body: SafeArea(
        child: BlocConsumer<ProfileSharedUnitHubBloc, ProfileSharedUnitHubState>(
          listenWhen: (previous, current) =>
              (previous.errorMessage != current.errorMessage &&
                  current.errorMessage != null) ||
              (previous.activeSharedUnit != null &&
                  current.activeSharedUnit == null &&
                  !current.isLoading),
          listener: (context, state) {
            if (!state.hasBlockingError && state.errorMessage != null) {
              KinlySnackBar.showError(context, state.errorMessage!);
              return;
            }
            KinlySnackBar.showSuccess(
              context,
              strings.profileSharedUnitLeaveSuccess,
            );
          },
          builder: (context, state) => _buildBody(
            context: context,
            state: state,
            spacing: spacing,
            strings: strings,
          ),
        ),
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required ProfileSharedUnitHubState state,
    required Spacing spacing,
    required S strings,
  }) {
    if (state.isLoading && state.homeUnitContext == null) {
      return const Center(child: KinlyLoader(size: 32));
    }
    if (state.hasBlockingError) {
      return _SharedUnitHubError(onRetry: () => _reload(context));
    }

    final content = _SharedUnitHubContent.fromState(
      state: state,
      creatorMembershipId: creatorMembershipId,
      strings: strings,
    );
    return Padding(
      padding: EdgeInsetsDirectional.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SharedUnitHubHeader(
            title: content.title,
            subtitle: content.subtitle,
          ),
          SizedBox(height: spacing.xl),
          ..._buildActions(
            context: context,
            state: state,
            spacing: spacing,
            strings: strings,
            content: content,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActions({
    required BuildContext context,
    required ProfileSharedUnitHubState state,
    required Spacing spacing,
    required S strings,
    required _SharedUnitHubContent content,
  }) {
    if (content.sharedUnit != null) {
      return _buildActiveSharedUnitActions(
        context: context,
        state: state,
        spacing: spacing,
        strings: strings,
        sharedUnit: content.sharedUnit!,
      );
    }
    return _buildEmptySharedUnitActions(
      context: context,
      spacing: spacing,
      strings: strings,
      content: content,
    );
  }

  List<Widget> _buildEmptySharedUnitActions({
    required BuildContext context,
    required Spacing spacing,
    required S strings,
    required _SharedUnitHubContent content,
  }) {
    final theme = KinlyThemeAccess.of(context);
    final widgets = <Widget>[
      if (content.canCreate)
        KinlyFilledButton.text(
          onPressed: () => _openCreateSharedUnit(context),
          label: strings.profileSharedUnitCreateCta,
          fullWidth: true,
        )
      else
        _SharedUnitHubSupportingText(
          text: strings.profileSharedUnitNoCandidates,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      SizedBox(height: content.canCreate ? spacing.sm : spacing.md),
      if (content.canJoin)
        KinlyOutlinedButton.text(
          onPressed: () => _openJoinSharedUnit(context),
          label: strings.profileSharedUnitJoinCta,
          fullWidth: true,
        )
      else
        _SharedUnitHubSupportingText(
          text: strings.profileSharedUnitJoinEmpty,
          color: theme.colorScheme.onSurfaceVariant,
        ),
    ];
    if (content.canJoin) {
      widgets.add(SizedBox(height: spacing.sm));
    }
    return widgets;
  }

  List<Widget> _buildActiveSharedUnitActions({
    required BuildContext context,
    required ProfileSharedUnitHubState state,
    required Spacing spacing,
    required S strings,
    required HomeUnitSummary sharedUnit,
  }) {
    return [
      KinlyOutlinedButton.text(
        onPressed: () => _openRenameSharedUnit(
          context,
          sharedUnit.unitId,
          sharedUnit.name,
        ),
        label: strings.profileSharedUnitRenameCta,
        fullWidth: true,
      ),
      SizedBox(height: spacing.sm),
      KinlyFilledButton.destructiveText(
        onPressed: state.isLeaving ? null : () => _leaveSharedUnit(context),
        label: strings.profileSharedUnitLeaveCta,
        fullWidth: true,
      ),
      if (state.isLeaving) ...[
        SizedBox(height: spacing.md),
        const Center(child: KinlyLoader(size: 24)),
      ],
    ];
  }

  void _reload(BuildContext context) {
    context.read<ProfileSharedUnitHubBloc>().add(
      const ProfileSharedUnitHubStarted(),
    );
  }

  Future<void> _openCreateSharedUnit(BuildContext context) async {
    final created = await context.pushNamed<bool>(
      AppRouteNames.profileSharedUnitCreate,
      extra: ProfileSharedUnitCreateRouteArgs(
        homeId: homeId,
        creatorMembershipId: creatorMembershipId,
      ),
    );
    if (created == true && context.mounted) {
      KinlySnackBar.showSuccess(
        context,
        S.of(context).profileSharedUnitCreateSuccess,
      );
      _reload(context);
    }
  }

  Future<void> _openJoinSharedUnit(BuildContext context) async {
    final joined = await context.pushNamed<bool>(
      AppRouteNames.profileSharedUnitJoin,
    );
    if (joined == true && context.mounted) {
      KinlySnackBar.showSuccess(
        context,
        S.of(context).profileSharedUnitJoinSuccess,
      );
      _reload(context);
    }
  }

  Future<void> _openRenameSharedUnit(
    BuildContext context,
    String unitId,
    String initialName,
  ) async {
    final renamed = await context.pushNamed<bool>(
      AppRouteNames.profileSharedUnitRename,
      extra: ProfileSharedUnitRenameRouteArgs(
        unitId: unitId,
        initialName: initialName,
      ),
    );
    if (renamed == true && context.mounted) {
      KinlySnackBar.showSuccess(
        context,
        S.of(context).profileSharedUnitRenameSuccess,
      );
      _reload(context);
    }
  }

  Future<void> _leaveSharedUnit(BuildContext context) async {
    final strings = S.of(context);
    final confirmed = await showKinlyConfirmDialog(
      context,
      title: strings.profileSharedUnitLeaveConfirmTitle,
      message: strings.profileSharedUnitLeaveConfirmMessage,
      confirmLabel: strings.profileSharedUnitLeaveCta,
      destructive: true,
    );
    if (!context.mounted || confirmed != true) {
      return;
    }
    context.read<ProfileSharedUnitHubBloc>().add(
      const ProfileSharedUnitHubLeaveRequested(),
    );
  }
}

class _SharedUnitHubHeader extends StatelessWidget {
  const _SharedUnitHubHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: spacing.xs),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SharedUnitHubSupportingText extends StatelessWidget {
  const _SharedUnitHubSupportingText({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    return Text(
      text,
      style: theme.textTheme.bodyMedium?.copyWith(color: color),
    );
  }
}

class _SharedUnitHubError extends StatelessWidget {
  const _SharedUnitHubError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final strings = S.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              strings.profileSharedUnitLoadError,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.md),
            KinlyOutlinedButton.text(
              onPressed: onRetry,
              label: strings.shareCreateRetry,
            ),
          ],
        ),
      ),
    );
  }
}

class _SharedUnitHubContent {
  const _SharedUnitHubContent({
    required this.sharedUnit,
    required this.canCreate,
    required this.canJoin,
    required this.title,
    required this.subtitle,
  });

  factory _SharedUnitHubContent.fromState({
    required ProfileSharedUnitHubState state,
    required String creatorMembershipId,
    required S strings,
  }) {
    final sharedUnit = state.activeSharedUnit;
    final hasSharedUnit = sharedUnit != null;
    return _SharedUnitHubContent(
      sharedUnit: sharedUnit,
      canCreate:
          !hasSharedUnit &&
          creatorMembershipId.isNotEmpty &&
          state.createCandidates.isNotEmpty,
      canJoin: !hasSharedUnit && state.joinableUnits.isNotEmpty,
      title: _resolveTitle(sharedUnit, strings),
      subtitle:
          hasSharedUnit
              ? strings.profileSharedUnitActiveSubtitle
              : strings.profileSharedUnitSectionSubtitle,
    );
  }

  final HomeUnitSummary? sharedUnit;
  final bool canCreate;
  final bool canJoin;
  final String title;
  final String subtitle;

  static String _resolveTitle(
    HomeUnitSummary? sharedUnit,
    S strings,
  ) {
    if (sharedUnit == null) return strings.profileSharedUnitSectionTitle;
    final trimmedName = sharedUnit.name.trim();
    return trimmedName.isEmpty
        ? strings.profileSharedUnitActiveFallbackName
        : sharedUnit.name;
  }
}
