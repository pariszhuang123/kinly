import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/ports/fit_check_repository.dart';
import 'package:kinly/features/fit_check/bloc/fit_check_briefing_cubit.dart';
import 'fit_check_briefing_screen.dart';

class FitCheckBriefingProvider extends StatelessWidget {
  const FitCheckBriefingProvider({
    super.key,
    required this.repository,
    required this.submissionId,
    required this.locale,
  });

  final FitCheckRepository repository;
  final String submissionId;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              FitCheckBriefingCubit(
                repository: repository,
                submissionId: submissionId,
                locale: locale,
              )..load(),
      child: const FitCheckBriefingScreen(),
    );
  }
}
