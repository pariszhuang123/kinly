import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/core/auth/bloc/auth_bloc.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/features/fit_check/bloc/fit_check_claim_cubit.dart';
import 'package:kinly/generated/l10n.dart';

class FitCheckClaimScreen extends StatelessWidget {
  const FitCheckClaimScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocListener<FitCheckClaimCubit, FitCheckClaimState>(
      listenWhen: (previous, current) => current.status == FitCheckClaimStatus.ready,
      listener: (context, state) {
        final result = state.result;
        if (result == null) return;
        if (!result.homeAttachmentRequired) {
          context.goNamed(
            AppRouteNames.fitCheckInbox,
            pathParameters: {'draftId': result.draftId},
          );
          return;
        }
        if (result.ownerHomeCount > 0) {
          final homeId = context.read<AuthBloc>().state.membership?.homeId;
          context.goNamed(
            AppRouteNames.fitCheckAttach,
            pathParameters: {'draftId': result.draftId},
            queryParameters:
                homeId == null || homeId.isEmpty
                    ? <String, String>{}
                    : {'homeId': homeId},
          );
          return;
        }
        context.goNamed(
          AppRouteNames.start,
          queryParameters: {'fitCheckDraftId': result.draftId},
        );
      },
      child: BlocBuilder<FitCheckClaimCubit, FitCheckClaimState>(
        builder: (context, state) {
          return KinlyScaffold(
            appBar: KinlyAppBar(title: Text(s.fitCheckClaimTitle)),
            body: SafeArea(
              child: switch (state.status) {
                FitCheckClaimStatus.loading => _ClaimMessageBody(
                  body: s.fitCheckClaimLoadingBody,
                  showLoader: true,
                ),
                FitCheckClaimStatus.failure => _ClaimMessageBody(
                  body:
                      state.errorMessage == 'MISSING_CLAIM_TOKEN'
                          ? s.fitCheckClaimMissingToken
                          : state.errorMessage ?? s.fitCheckInboxErrorBody,
                ),
                FitCheckClaimStatus.ready => _ClaimMessageBody(
                  body: s.fitCheckClaimLoadingBody,
                  showLoader: true,
                ),
              },
            ),
          );
        },
      ),
    );
  }
}

class _ClaimMessageBody extends StatelessWidget {
  const _ClaimMessageBody({required this.body, this.showLoader = false});

  final String body;
  final bool showLoader;

  @override
  Widget build(BuildContext context) {
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>();
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.all(spacing?.lg ?? 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLoader) ...[
              const KinlyLoader(),
              SizedBox(height: spacing?.m ?? 12),
            ],
            Text(body, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
