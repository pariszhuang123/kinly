import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/di/locator.dart';
import '../../../../data/repositories/home_repository.dart';

class JoinHomeScreen extends StatelessWidget {
  const JoinHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.join_title, style: theme.textTheme.titleLarge),
      ),
      body: BlocProvider(
        create: (_) => JoinCodeCubit(),
        child: const _JoinForm(),
      ),
    );
  }
}

class _JoinForm extends StatelessWidget {
  const _JoinForm();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(labelText: s.join_hint),
            onChanged: context.read<JoinCodeCubit>().update,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final code = context.read<JoinCodeCubit>().state;
              final repo = sl<HomeRepository>();
              final messenger = ScaffoldMessenger.of(context);
              try {
                await repo.join(code);
                messenger.showSnackBar(
                  SnackBar(content: Text('Joined with code: $code')),
                );
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Join failed: $e')),
                );
              }
            },
            child: Text(s.join_submit),
          ),
        ],
      ),
    );
  }
}

class JoinCodeCubit extends Cubit<String> {
  JoinCodeCubit() : super('');
  void update(String code) => emit(code.trim());
}
