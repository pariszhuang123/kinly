import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';

class CreateHomeScreen extends StatelessWidget {
  const CreateHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.create_title, style: theme.textTheme.titleLarge)),
      body: Center(
        child: Text(
          s.create_title,
          style: theme.textTheme.titleLarge,
        ),
      ),
    );
  }
}
