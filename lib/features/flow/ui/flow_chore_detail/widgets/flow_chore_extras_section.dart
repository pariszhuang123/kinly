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
    this.onHowToTap,
    this.expectationPhotoLabel,
    this.expectationPhotoUrl,
  });

  final String notesLabel;
  final String notesBody;
  final String howToLabel;
  final String howToBody;
  final VoidCallback? onHowToTap;
  final String? expectationPhotoLabel;
  final String? expectationPhotoUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    final hasExpectationPhoto = expectationPhotoUrl?.trim().isNotEmpty == true;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing?.md ?? 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.flowChoreDetailMoreInfoTitle,
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: spacing?.md ?? 16),
          _FlowDetailSection(title: notesLabel, body: notesBody),
          SizedBox(height: spacing?.md ?? 16),
          _FlowDetailSection(
            title: howToLabel,
            body: howToBody,
            onTap: onHowToTap,
          ),
          if (hasExpectationPhoto) ...[
            SizedBox(height: spacing?.md ?? 16),
            _ExpectationPhotoSection(
              title: expectationPhotoLabel ?? s.flowChoreExpectationPhotoLabel,
              photoUrl: expectationPhotoUrl!,
            ),
          ],
        ],
      ),
    );
  }
}

class _FlowDetailSection extends StatelessWidget {
  const _FlowDetailSection({
    required this.title,
    required this.body,
    this.onTap,
  });

  final String title;
  final String body;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLink = onTap != null;
    final bodyText = Text(
      body,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: isLink ? colorScheme.primary : null,
        decoration: isLink ? TextDecoration.underline : null,
      ),
    );
    final bodyContent =
        isLink
            ? GestureDetector(
              onTap: onTap,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: bodyText),
                  const SizedBox(width: 8),
                  Icon(Icons.open_in_new, size: 16, color: colorScheme.primary),
                ],
              ),
            )
            : bodyText;
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
          bodyContent,
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
