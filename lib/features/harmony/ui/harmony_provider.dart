// lib/features/harmony/ui/harmony_provider.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../harmony.dart';
import '../../harmony/bloc/harmony_cubit.dart';
import '../../../contracts/homes/ports/home_repository.dart';

class HarmonyProvider extends StatelessWidget {
  final String homeId;
  final MoodRepository moodRepository;
  final HomeRepository homeRepository;
  final Widget child;

  const HarmonyProvider({
    super.key,
    required this.homeId,
    required this.moodRepository,
    required this.homeRepository,
    this.child = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => HarmonyCubit(
            homeId: homeId,
            moodRepository: moodRepository,
            homeRepository: homeRepository,
          )..loadMembers(),
      child: child,
    );
  }
}
