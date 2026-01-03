// lib/features/harmony/ui/harmony_provider.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../harmony.dart';
import '../../harmony/bloc/harmony_cubit.dart';

class HarmonyProvider extends StatelessWidget {
  final String homeId;
  final MoodRepository moodRepository;
  final Widget child;

  const HarmonyProvider({
    super.key,
    required this.homeId,
    required this.moodRepository,
    this.child = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => HarmonyCubit(homeId: homeId, moodRepository: moodRepository),
      child: child,
    );
  }
}


