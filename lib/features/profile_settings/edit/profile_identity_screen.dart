import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/profile/enums/profile_error_code.dart';
import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/kinly_circle_avatar.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/ui/buttons/kinly_outlined_button.dart';
import '../../../core/ui/inputs/kinly_text_field.dart';
import '../../../core/profile/models.dart';
import '../../../generated/l10n.dart';
import '../../../core/ui/snackbars/kinly_snackbar.dart';
import 'bloc/profile_identity_bloc.dart';

class ProfileIdentityScreen extends StatefulWidget {
  const ProfileIdentityScreen({super.key});

  @override
  State<ProfileIdentityScreen> createState() => _ProfileIdentityScreenState();
}

class _ProfileIdentityScreenState extends State<ProfileIdentityScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<ProfileIdentityBloc>().state.username,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(s.profileIdentityTitle)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.all(spacing.lg),
          child: MultiBlocListener(
            listeners: [
              BlocListener<ProfileIdentityBloc, ProfileIdentityState>(
                listenWhen:
                    (previous, current) => previous.action != current.action,
                listener: (context, state) => _handleAction(context, state),
              ),
              BlocListener<ProfileIdentityBloc, ProfileIdentityState>(
                listenWhen:
                    (previous, current) =>
                        previous.username != current.username,
                listener: (context, state) {
                  if (_controller.text == state.username) return;
                  _controller.value = TextEditingValue(
                    text: state.username,
                    selection: TextSelection.collapsed(
                      offset: state.username.length,
                    ),
                  );
                },
              ),
            ],
            child: BlocBuilder<ProfileIdentityBloc, ProfileIdentityState>(
              builder: (context, state) {
                if (state.loadErrorMessage != null) {
                  return _ProfileIdentityError(
                    message: s.profileIdentityLoadError,
                    onRetry:
                        () => context.read<ProfileIdentityBloc>().add(
                          const ProfileIdentityStarted(),
                        ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ProfilePreview(
                              username: state.username,
                              avatarUrl: state.selectedAvatarUrl,
                            ),
                            SizedBox(height: spacing.lg),
                            Text(
                              s.profileIdentitySubtitle,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                            SizedBox(height: spacing.lg),
                            KinlyTextField(
                              controller: _controller,
                              labelText: s.profileIdentityUsernameLabel,
                              hintText: s.profileIdentityUsernameHint,
                              errorText: _mapUsernameError(state, s),
                              autocorrect: false,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9._]'),
                                ),
                                _LowercaseTextFormatter(),
                              ],
                              onChanged:
                                  (value) =>
                                      context.read<ProfileIdentityBloc>().add(
                                        ProfileIdentityUsernameChanged(value),
                                      ),
                            ),
                            SizedBox(height: spacing.xl),
                            Text(
                              s.profileIdentityAvatarSectionTitle,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: spacing.xs),
                            Text(
                              s.profileIdentityAvatarSectionDescription,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                            SizedBox(height: spacing.md),
                            if (state.isLoading)
                              const Center(child: KinlyLoader(size: 32))
                            else if (state.avatars.isEmpty)
                              Text(
                                s.profileIdentityAvatarEmpty,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              )
                            else
                              _AvatarGrid(
                                avatars: state.avatars,
                                selectedAvatarId: state.selectedAvatarId,
                                onSelected:
                                    (avatarId) =>
                                        context.read<ProfileIdentityBloc>().add(
                                          ProfileIdentityAvatarSelected(
                                            avatarId,
                                          ),
                                        ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: spacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          KinlyFilledButton.text(
                            fullWidth: true,
                            onPressed:
                                state.canSubmit
                                    ? () => context
                                        .read<ProfileIdentityBloc>()
                                        .add(const ProfileIdentitySubmitted())
                                    : null,
                            label: s.profileIdentitySaveButton,
                          ),
                          if (state.isSubmitting)
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: KinlyLoader(
                                size: 20,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, ProfileIdentityState state) {
    final s = S.of(context);
    switch (state.action) {
      case ProfileIdentityAction.success:
        if (state.updatedProfile != null) {
          context.pop(state.updatedProfile);
        } else {
          context.pop();
        }
        break;
      case ProfileIdentityAction.failure:
        final message = _resolveActionMessage(state, s);
        final accent =
            Theme.of(context).extension<KinlySections>()?.pulse.accent;
        KinlySnackBar.showError(context, message, accentColor: accent);
        break;
      case ProfileIdentityAction.none:
        break;
    }
  }

  String? _mapUsernameError(ProfileIdentityState state, S s) {
    return switch (state.usernameError) {
      ProfileIdentityValidationError.empty =>
        s.profileIdentityUsernameEmptyError,
      ProfileIdentityValidationError.invalidFormat =>
        s.profileIdentityUsernameFormatError,
      _ => null,
    };
  }

  String _resolveActionMessage(ProfileIdentityState state, S s) {
    if (state.actionError == ProfileErrorCode.usernameTaken) {
      return s.profileIdentityUsernameTakenError;
    }
    return state.actionMessage ?? s.profileGenericError;
  }
}

class _ProfilePreview extends StatelessWidget {
  const _ProfilePreview({required this.username, required this.avatarUrl});

  final String username;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);
    final display =
        username.isEmpty
            ? s.profileIdentityUsernamePreviewFallback
            : '@$username';
    return Column(
      children: [
        KinlyCircleAvatar(avatarUrl: avatarUrl, radius: 48),
        SizedBox(height: spacing.sm),
        Text(
          display,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _AvatarGrid extends StatelessWidget {
  const _AvatarGrid({
    required this.avatars,
    required this.selectedAvatarId,
    required this.onSelected,
  });

  final List<ProfileAvatar> avatars;
  final String? selectedAvatarId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<Spacing>()!;
    return Wrap(
      spacing: spacing.md,
      runSpacing: spacing.md,
      children: avatars
          .map<Widget>(
            (avatar) => _AvatarOption(
              avatar: avatar,
              isSelected: avatar.id == selectedAvatarId,
              onTap: () => onSelected(avatar.id),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _AvatarOption extends StatelessWidget {
  const _AvatarOption({
    required this.avatar,
    required this.isSelected,
    required this.onTap,
  });

  final ProfileAvatar avatar;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final borderColor =
        isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.outline.withValues(alpha: 0.5);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(56),
        child: Container(
          width: 72,
          height: 72,
          padding: EdgeInsetsDirectional.all(spacing.xs),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          ),
          child: KinlyCircleAvatar(avatarUrl: avatar.imageUrl, radius: 30),
        ),
      ),
    );
  }
}

class _ProfileIdentityError extends StatelessWidget {
  const _ProfileIdentityError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.md),
          KinlyOutlinedButton.text(
            onPressed: onRetry,
            label: s.profileIdentityRetry,
          ),
        ],
      ),
    );
  }
}

class _LowercaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
      composing: TextRange.empty,
    );
  }
}
