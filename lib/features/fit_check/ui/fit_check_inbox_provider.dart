import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/ports/fit_check_repository.dart';
import 'package:kinly/features/fit_check/bloc/fit_check_inbox_cubit.dart';
import 'fit_check_inbox_screen.dart';

class FitCheckInboxProvider extends StatelessWidget {
  const FitCheckInboxProvider({
    super.key,
    required this.repository,
    required this.draftId,
    required this.locale,
  });

  final FitCheckRepository repository;
  final String draftId;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              FitCheckInboxCubit(
                repository: repository,
                draftId: draftId,
                locale: locale,
              )..load(),
      child: const FitCheckInboxScreen(),
    );
  }
}
