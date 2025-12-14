import 'package:flutter/material.dart';

import '../../../core/theme/spacing.dart';
import '../../../core/ui/scroll/kinly_scroll_fade.dart';
import 'harmony_screen.dart';

class HarmonyPage extends StatelessWidget {
  final String homeId;

  const HarmonyPage({super.key, required this.homeId});

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<Spacing>()!;

    return Scaffold(
      // No AppBar → gives full control of header layout
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// -------------------------------------------
              /// Body (Scrollable)
              /// -------------------------------------------
              Expanded(
                child: KinlyScrollFade(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: spacing.lg),
                    child: HarmonyScreen(homeId: homeId),
                  ),
                ),
              ),

              /// -------------------------------------------
              /// Footer
              /// -------------------------------------------
              SizedBox(height: spacing.lg),
              const HarmonySubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}
