import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/core/auth/bloc/auth_bloc.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/features/fit_check/bloc/fit_check_attach_cubit.dart';
import 'package:kinly/generated/l10n.dart';

class FitCheckAttachScreen extends StatelessWidget {
  const FitCheckAttachScreen({
    super.key,
    required this.draftId,
    this.homeId,
  });

  final String draftId;
  final String? homeId;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocListener<FitCheckAttachCubit, FitCheckAttachState>(
      listener: (context, state) {
        if (state.status == FitCheckAttachStatus.success) {
          KinlySnackBar.showSuccess(context, s.fitCheckAttachSuccess);
          context.goNamed(
            AppRouteNames.fitCheckInbox,
            pathParameters: {'draftId': draftId},
          );
        } else if (state.status == FitCheckAttachStatus.failure &&
            state.errorMessage != null) {
          KinlySnackBar.showError(context, state.errorMessage!);
        }
      },
      child: BlocBuilder<FitCheckAttachCubit, FitCheckAttachState>(
        builder: (context, state) {
          final resolvedHomeId =
              homeId?.trim().isNotEmpty == true
                  ? homeId!.trim()
                  : context.select(
                    (AuthBloc bloc) => bloc.state.membership?.homeId,
                  );
          final spacing = KinlyThemeAccess.of(context).extension<Spacing>();
          final isLoading = state.status == FitCheckAttachStatus.loading;
          return KinlyScaffold(
            appBar: KinlyAppBar(title: Text(s.fitCheckAttachTitle)),
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsetsDirectional.all(spacing?.lg ?? 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLoading) ...[
                        const KinlyLoader(),
                        SizedBox(height: spacing?.m ?? 12),
                      ],
                      Text(
                        resolvedHomeId == null || resolvedHomeId.isEmpty
                            ? s.fitCheckAttachNoHomeBody
                            : s.fitCheckAttachBody,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing?.lg ?? 16),
                      if (resolvedHomeId == null || resolvedHomeId.isEmpty)
                        KinlyFilledButton.text(
                          onPressed:
                              () => context.goNamed(
                                AppRouteNames.start,
                                queryParameters: {'fitCheckDraftId': draftId},
                              ),
                          label: s.fitCheckAttachCreateHomeCta,
                          fullWidth: true,
                        )
                      else
                        KinlyFilledButton.text(
                          onPressed:
                              isLoading
                                  ? null
                                  : () => context
                                      .read<FitCheckAttachCubit>()
                                      .attach(homeId: resolvedHomeId),
                          label: s.fitCheckAttachConfirmCta,
                          fullWidth: true,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
