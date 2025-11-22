// lib/features/flow/ui/widgets/flow_chore_extras_section.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/spacing.dart';
import '../../../../../generated/l10n.dart';

class FlowChoreExtrasSection extends StatelessWidget {
  const FlowChoreExtrasSection({
    super.key,
    required this.notesLabel,
    required this.notesBody,
    required this.howToLabel,
    required this.howToBody,
    this.expectationPhotoLabel,
    this.expectationPhotoUrl,
  });

  final String notesLabel;
  final String notesBody;
  final String howToLabel;
  final String howToBody;
  final String? expectationPhotoLabel;
  final String? expectationPhotoUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    final hasExpectationPhoto =
        expectationPhotoUrl != null && expectationPhotoUrl!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: theme.copyWith(
          dividerColor: Colors.transparent,
          listTileTheme: theme.listTileTheme.copyWith(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
        child: ExpansionTile(
          title: Text(
            // add a specific key later if you like
            s.flowChoreDetailMoreInfoTitle,
            style: theme.textTheme.titleMedium,
          ),
          childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, spacing?.md ?? 16),
          children: [
            _FlowDetailSection(title: notesLabel, body: notesBody),
            SizedBox(height: spacing?.md ?? 16),
            _FlowDetailSection(title: howToLabel, body: howToBody),
            if (hasExpectationPhoto) ...[
              SizedBox(height: spacing?.md ?? 16),
              _ExpectationPhotoSection(
                title:
                    expectationPhotoLabel ?? s.flowChoreExpectationPhotoLabel,
                photoUrl: expectationPhotoUrl!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FlowDetailSection extends StatelessWidget {
  const _FlowDetailSection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(body, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _ExpectationPhotoSection extends StatelessWidget {
  const _ExpectationPhotoSection({required this.title, required this.photoUrl});

  final String title;
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Image.network(photoUrl, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
