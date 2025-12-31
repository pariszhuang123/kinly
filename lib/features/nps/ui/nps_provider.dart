import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../harmony/harmony.dart';
import '../bloc/nps_cubit.dart';
import 'nps_screen.dart';

class NpsProvider extends StatelessWidget {
  final String homeId;
  final MoodRepository moodRepository;

  const NpsProvider({
    super.key,
    required this.homeId,
    required this.moodRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NpsCubit(homeId: homeId, moodRepository: moodRepository),
      child: const NpsScreen(),
    );
  }
}
