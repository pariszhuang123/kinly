import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.today_title, style: theme.textTheme.titleLarge),
      ),
      body: Center(
        child: Text(s.today_title, style: theme.textTheme.titleLarge),
      ),
    );
  }
}
