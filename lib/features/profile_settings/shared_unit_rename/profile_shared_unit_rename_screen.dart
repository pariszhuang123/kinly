import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/inputs/kinly_text_field.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/generated/l10n.dart';

import 'bloc/profile_shared_unit_rename_bloc.dart';

class ProfileSharedUnitRenameScreen extends StatefulWidget {
  const ProfileSharedUnitRenameScreen({super.key});

  @override
  State<ProfileSharedUnitRenameScreen> createState() =>
      _ProfileSharedUnitRenameScreenState();
}

class _ProfileSharedUnitRenameScreenState
    extends State<ProfileSharedUnitRenameScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: context.read<ProfileSharedUnitRenameBloc>().state.name,
    );
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
      appBar: KinlyAppBar(title: Text(s.profileSharedUnitRenameScreenTitle)),
      body: SafeArea(
        child:
            BlocConsumer<
              ProfileSharedUnitRenameBloc,
              ProfileSharedUnitRenameState
            >(
              listenWhen:
                  (previous, current) =>
                      previous.status != current.status ||
                      previous.errorMessage != current.errorMessage,
              listener: (context, state) {
                if (state.status == ProfileSharedUnitRenameStatus.success) {
                  context.pop(true);
                  return;
                }
                if (state.status == ProfileSharedUnitRenameStatus.failure &&
                    state.errorMessage != null) {
                  KinlySnackBar.showError(context, state.errorMessage!);
                }
              },
              builder: (context, state) {
                if (_nameController.text != state.name) {
                  _nameController.value = TextEditingValue(
                    text: state.name,
                    selection: TextSelection.collapsed(
                      offset: state.name.length,
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsetsDirectional.all(spacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      KinlyTextField(
                        controller: _nameController,
                        labelText: s.profileSharedUnitNameLabel,
                        hintText: s.profileSharedUnitNameHint,
                        onChanged:
                            (value) => context
                                .read<ProfileSharedUnitRenameBloc>()
                                .add(ProfileSharedUnitRenameNameChanged(value)),
                      ),
                      SizedBox(height: spacing.lg),
                      KinlyFilledButton.text(
                        onPressed:
                            state.canSubmit
                                ? () => context
                                    .read<ProfileSharedUnitRenameBloc>()
                                    .add(
                                      const ProfileSharedUnitRenameSubmitted(),
                                    )
                                : null,
                        label: s.profileSharedUnitRenameSubmit,
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
