import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/locator.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import '../../../../../core/auth/bloc/auth_bloc.dart';
import '../bloc/start_home_bloc.dart';
import 'start_home_screen.dart';

class StartHomeProvider extends StatelessWidget {
  const StartHomeProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => StartHomeBloc(
        sl<HomeRepository>(),
        onProfileDeactivated: () =>
            ctx.read<AuthBloc>().add(const AuthProfileDeactivatedDetected()),
      ),
      child: const StartHomeScreen(),
    );
  }
}


