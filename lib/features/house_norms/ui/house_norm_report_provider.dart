import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/house_norms/models.dart';
import 'package:kinly/contracts/house_norms/ports/house_norms_repository.dart';
import 'package:kinly/features/house_norms/bloc/house_norm_report_cubit.dart';
import 'house_norm_report_screen.dart';

class HouseNormReportProvider extends StatelessWidget {
  const HouseNormReportProvider({
    super.key,
    required this.homeId,
    required this.locale,
    required this.isOwner,
    required this.repository,
    this.showConfetti = false,
    this.initialDocument,
    this.showDoneCta = true,
    this.popOnDone = false,
  });

  final String homeId;
  final String locale;
  final bool isOwner;
  final HouseNormsRepository repository;
  final bool showConfetti;
  final HouseNormDocument? initialDocument;
  final bool showDoneCta;
  final bool popOnDone;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = HouseNormReportCubit(
          repository: repository,
          homeId: homeId,
          locale: locale,
          isOwner: isOwner,
          initialDocument: initialDocument,
        );
        if (initialDocument == null) {
          cubit.load();
        } else if (!isOwner) {
          cubit.recordView();
        }
        return cubit;
      },
      child: HouseNormReportScreen(
        isOwner: isOwner,
        showConfetti: showConfetti,
        showDoneCta: showDoneCta,
        popOnDone: popOnDone,
      ),
    );
  }
}
