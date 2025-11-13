import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/locator.dart';
import '../../../../data/repositories/home_repository.dart';
import '../bloc/start_home_bloc.dart';
import 'start_home_screen.dart';

class StartHomeProvider extends StatelessWidget {
  const StartHomeProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StartHomeBloc(sl<HomeRepository>()),
      child: const StartHomeScreen(),
    );
  }
}
