import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/locator.dart';
import '../../../../data/repositories/home_repository.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/widgets/auth_error_listener.dart';
import '../../../auth/widgets/auth_sign_out_button.dart';

class JoinHomeScreen extends StatelessWidget {
  const JoinHomeScreen({super.key, this.initialCode});

  final String? initialCode;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return AuthErrorListener(
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.join_title, style: theme.textTheme.titleLarge),
          actions: const [AuthSignOutButton()],
        ),
        body: BlocProvider(
          create: (_) => JoinCodeCubit(initialCode ?? ''),
          child: _JoinForm(initialCode: initialCode ?? ''),
        ),
      ),
    );
  }
}

class _JoinForm extends StatefulWidget {
  const _JoinForm({required this.initialCode});
  final String initialCode;

  @override
  State<_JoinForm> createState() => _JoinFormState();
}

class _JoinFormState extends State<_JoinForm> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialCode);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: s.join_hint),
            onChanged: context.read<JoinCodeCubit>().update,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final code = _controller.text.trim();
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
  JoinCodeCubit([String initial = '']) : super(initial.trim());
  void update(String code) => emit(code.trim());
}
