// lib/features/today/ui/widgets/today_share_section_container.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/kinly_loader.dart';
import '../../bloc/today_bloc.dart';
import '../../domain/models.dart';
import 'today_share_section.dart';

class TodayShareSectionContainer extends StatelessWidget {
  const TodayShareSectionContainer({
    super.key,
    required this.onOwedTap,
    required this.onPaidToMeTap,
    required this.onDraftTap,
    required this.onSeeAllDraftsTap,
  });

  final void Function(TodayShareOwed) onOwedTap;
  final void Function(TodaySharePaidToMe) onPaidToMeTap;
  final void Function(TodayShareDraft) onDraftTap;
  final VoidCallback onSeeAllDraftsTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodayBloc, TodayState>(
      buildWhen:
          (previous, current) =>
              previous.shareOwed != current.shareOwed ||
              previous.sharePaidToMe != current.sharePaidToMe ||
              previous.shareDrafts != current.shareDrafts ||
              previous.shareErrorMessage != current.shareErrorMessage ||
              previous.isLoading != current.isLoading,
      builder: (context, state) {
        // Loading with no content yet → centered loader
        if (state.isLoading && !state.hasShareContent) {
          return const Center(child: KinlyLoader(size: 40));
        }

        // Normal state → delegate to presentational widget
        return TodayShareSection(
          owed: state.shareOwed,
          paidToMe: state.sharePaidToMe,
          drafts: state.shareDrafts,
          errorMessage: state.shareErrorMessage,
          onOwedTap: onOwedTap,
          onPaidToMeTap: onPaidToMeTap,
          onDraftTap: onDraftTap,
          onSeeAllDraftsTap: onSeeAllDraftsTap,
        );
      },
    );
  }
}



