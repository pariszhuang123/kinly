import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/share/ports/expenses_repository.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import '../../bloc/share_create_bloc/share_create_bloc.dart';
import 'share_create_screen.dart';

class ShareCreateProvider extends StatelessWidget {
  const ShareCreateProvider({
    super.key,
    required this.homeId,
    required this.expensesRepository,
    required this.homeRepository,
  });

  final String homeId;
  final ExpensesRepository expensesRepository;
  final HomeRepository homeRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ShareCreateBloc(
            homeId: homeId,
            expensesRepository: expensesRepository,
            homeRepository: homeRepository,
          )..add(const ShareCreateParticipantsRequested()),
      child: ShareCreateScreen(homeId: homeId),
    );
  }
}
