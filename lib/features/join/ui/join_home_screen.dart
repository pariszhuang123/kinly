import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../generated/l10n.dart';

class JoinHomeScreen extends StatelessWidget {
  const JoinHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.join_title, style: theme.textTheme.titleLarge)),
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
            onPressed: () {
              final code = context.read<JoinCodeCubit>().state;
              // TODO: call homes.join(code) via repository
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Join with code: $code')),
              );
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
