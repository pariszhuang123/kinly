import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/core/ui/toggles/kinly_checkbox.dart';
import 'package:kinly/generated/l10n.dart';

import 'bloc/profile_shared_unit_join_bloc.dart';

class ProfileSharedUnitJoinScreen extends StatelessWidget {
  const ProfileSharedUnitJoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return KinlyScaffold(
      appBar: KinlyAppBar(title: Text(s.profileSharedUnitJoinScreenTitle)),
      body: SafeArea(
        child:
            BlocConsumer<ProfileSharedUnitJoinBloc, ProfileSharedUnitJoinState>(
              listenWhen:
                  (previous, current) =>
                      previous.status != current.status ||
                      previous.errorMessage != current.errorMessage,
              listener: (context, state) {
                if (state.status == ProfileSharedUnitJoinStatus.success) {
                  context.pop(true);
                  return;
                }
                if (state.status == ProfileSharedUnitJoinStatus.failure &&
                    state.errorMessage != null &&
                    state.units.isNotEmpty) {
                  KinlySnackBar.showError(context, state.errorMessage!);
                }
              },
              builder: (context, state) {
                if (state.isLoading && state.units.isEmpty) {
                  return const Center(child: KinlyLoader(size: 32));
                }
                if (state.status == ProfileSharedUnitJoinStatus.failure &&
                    state.units.isEmpty) {
                  return _JoinSharedUnitError(
                    onRetry:
                        () => context.read<ProfileSharedUnitJoinBloc>().add(
                          const ProfileSharedUnitJoinStarted(),
                        ),
                  );
                }

                return Padding(
                  padding: EdgeInsetsDirectional.all(spacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        s.profileSharedUnitJoinScreenSubtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: spacing.lg),
                      if (state.units.isEmpty)
                        Text(
                          s.profileSharedUnitJoinEmpty,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.separated(
                            itemCount: state.units.length,
                            separatorBuilder:
                                (_, __) => SizedBox(height: spacing.sm),
                            itemBuilder: (context, index) {
                              final unit = state.units[index];
                              final isSelected =
                                  state.selectedUnitId == unit.unitId;
                              return KinlyTapTarget(
                                onTap:
                                    () => context
                                        .read<ProfileSharedUnitJoinBloc>()
                                        .add(
                                          ProfileSharedUnitJoinSelected(
                                            unit.unitId,
                                          ),
                                        ),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: EdgeInsetsDirectional.all(spacing.md),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: theme.colorScheme.surfaceContainerHighest,
                                  ),
                                  child: Row(
                                    children: [
                                      KinlyCheckbox(
                                        value: isSelected,
                                        onChanged:
                                            (_) => context
                                                .read<ProfileSharedUnitJoinBloc>()
                                                .add(
                                                  ProfileSharedUnitJoinSelected(
                                                    unit.unitId,
                                                  ),
                                                ),
                                      ),
                                      SizedBox(width: spacing.sm),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              unit.name,
                                              style: theme.textTheme.titleSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      SizedBox(height: spacing.md),
                      KinlyFilledButton.text(
                        onPressed:
                            state.canSubmit
                                ? () => context
                                    .read<ProfileSharedUnitJoinBloc>()
                                    .add(const ProfileSharedUnitJoinSubmitted())
                                : null,
                        label: s.profileSharedUnitJoinSubmit,
                        fullWidth: true,
                      ),
                    ],
                  ),
                );
              },
            ),
      ),
    );
  }
}

class _JoinSharedUnitError extends StatelessWidget {
  const _JoinSharedUnitError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              s.profileSharedUnitLoadError,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.md),
            KinlyOutlinedButton.text(
              onPressed: onRetry,
              label: s.shareCreateRetry,
            ),
          ],
        ),
      ),
    );
  }
}
