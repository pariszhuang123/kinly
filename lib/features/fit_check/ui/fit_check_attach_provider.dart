import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/ports/fit_check_repository.dart';
import 'package:kinly/features/fit_check/bloc/fit_check_attach_cubit.dart';
import 'fit_check_attach_screen.dart';

class FitCheckAttachProvider extends StatelessWidget {
  const FitCheckAttachProvider({
    super.key,
    required this.repository,
    required this.draftId,
    this.homeId,
  });

  final FitCheckRepository repository;
  final String draftId;
  final String? homeId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => FitCheckAttachCubit(repository: repository, draftId: draftId),
      child: FitCheckAttachScreen(draftId: draftId, homeId: homeId),
    );
  }
}
