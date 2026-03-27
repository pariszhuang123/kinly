import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/ports/fit_check_repository.dart';
import 'package:kinly/features/fit_check/bloc/fit_check_claim_cubit.dart';
import 'fit_check_claim_screen.dart';

class FitCheckClaimProvider extends StatelessWidget {
  const FitCheckClaimProvider({
    super.key,
    required this.repository,
    required this.claimToken,
  });

  final FitCheckRepository repository;
  final String claimToken;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              FitCheckClaimCubit(
                repository: repository,
                claimToken: claimToken,
              )..load(),
      child: const FitCheckClaimScreen(),
    );
  }
}
