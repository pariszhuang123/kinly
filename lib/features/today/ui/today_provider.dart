import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/chores_repository.dart';
import '../bloc/today_bloc.dart';
import 'today_screen.dart';

class TodayProvider extends StatelessWidget {
  final String homeId;
  final ChoresRepository choresRepository;

  const TodayProvider({
    super.key,
    required this.homeId,
    required this.choresRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodayBloc>(
      create:
          (_) => TodayBloc(choresRepository: choresRepository, homeId: homeId),
      child: const TodayScreen(),
    );
  }
}
