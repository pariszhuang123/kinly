import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/inputs/kinly_text_field.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_circle_avatar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/core/ui/toggles/kinly_checkbox.dart';
import 'package:kinly/generated/l10n.dart';

import 'bloc/profile_shared_unit_create_bloc.dart';

class ProfileSharedUnitCreateScreen extends StatefulWidget {
  const ProfileSharedUnitCreateScreen({super.key});

  @override
  State<ProfileSharedUnitCreateScreen> createState() =>
      _ProfileSharedUnitCreateScreenState();
}

class _ProfileSharedUnitCreateScreenState
    extends State<ProfileSharedUnitCreateScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return KinlyScaffold(
      appBar: KinlyAppBar(title: Text(s.profileSharedUnitCreateScreenTitle)),
      body: SafeArea(
        child: BlocConsumer<
          ProfileSharedUnitCreateBloc,
          ProfileSharedUnitCreateState
        >(
          listenWhen:
              (previous, current) =>
                  previous.status != current.status ||
                  previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            if (state.status == ProfileSharedUnitCreateStatus.success) {
              context.pop(true);
              return;
            }
            if (state.status == ProfileSharedUnitCreateStatus.failure &&
                state.errorMessage != null &&
                !state.hasBlockingLoadError) {
              KinlySnackBar.showError(context, state.errorMessage!);
              context.read<ProfileSharedUnitCreateBloc>().add(
                const ProfileSharedUnitCreateFeedbackCleared(),
              );
            }
          },
          builder: (context, state) {
            if (_nameController.text != state.name) {
              _nameController.value = TextEditingValue(
                text: state.name,
                selection: TextSelection.collapsed(offset: state.name.length),
              );
            }

            if (state.isLoading && state.candidates.isEmpty) {
              return const Center(child: KinlyLoader(size: 32));
            }

            if (state.hasBlockingLoadError) {
              return _CreateSharedUnitError(
                onRetry:
                    () => context.read<ProfileSharedUnitCreateBloc>().add(
                      const ProfileSharedUnitCreateStarted(),
                    ),
              );
            }

            return Padding(
              padding: EdgeInsetsDirectional.all(spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    s.profileSharedUnitCreateScreenSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: spacing.lg),
                  KinlyTextField(
                    controller: _nameController,
                    labelText: s.profileSharedUnitNameLabel,
                    hintText: s.profileSharedUnitNameHint,
                    onChanged:
                        (value) => context.read<ProfileSharedUnitCreateBloc>().add(
                          ProfileSharedUnitCreateNameChanged(value),
                        ),
                  ),
                  SizedBox(height: spacing.lg),
                  Text(
                    s.profileSharedUnitMembersLabel,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    s.profileSharedUnitMembersHelper,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: spacing.md),
                  if (state.candidates.isEmpty)
                    Text(
                      s.profileSharedUnitNoCandidates,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: state.candidates.length,
                        separatorBuilder:
                            (_, __) => SizedBox(height: spacing.sm),
                        itemBuilder: (context, index) {
                          final candidate = state.candidates[index];
                          final isSelected = state.selectedMembershipIds.contains(
                            candidate.membershipId,
                          );
                          return _CandidateTile(
                            label: candidate.displayName,
                            avatarUrl: candidate.avatarUrl,
                            isOwner: candidate.isOwner,
                            selected: isSelected,
                            onTap:
                                () => context
                                    .read<ProfileSharedUnitCreateBloc>()
                                    .add(
                                      ProfileSharedUnitCreateCandidateToggled(
                                        candidate.membershipId,
                                        !isSelected,
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
                            ? () => context.read<ProfileSharedUnitCreateBloc>().add(
                              const ProfileSharedUnitCreateSubmitted(),
                            )
                            : null,
                    label: s.profileSharedUnitCreateSubmit,
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

class _CandidateTile extends StatelessWidget {
  const _CandidateTile({
    required this.label,
    required this.avatarUrl,
    required this.isOwner,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String? avatarUrl;
  final bool isOwner;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;

    return KinlyTapTarget(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsetsDirectional.all(spacing.sm),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        child: Row(
          children: [
            KinlyCheckbox(value: selected, onChanged: (_) => onTap()),
            SizedBox(width: spacing.sm),
            KinlyCircleAvatar(
              avatarUrl: avatarUrl,
              isOwner: isOwner,
              radius: 20,
              fallbackInitial: label.isNotEmpty ? label[0] : null,
            ),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Text(label, style: theme.textTheme.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateSharedUnitError extends StatelessWidget {
  const _CreateSharedUnitError({required this.onRetry});

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
