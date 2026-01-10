// lib/features/flow/ui/widgets/flow_chore_extras_section.dart
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/spacing.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/theme/kinly_palette.dart';
import '../../../../../app/router/app_route_names.dart';
import '../../../../../core/ui/kinly_tap_target.dart';
import '../../../../../core/ui/kinly_icons.dart';
import 'flow_chore_expectation_photo_viewer.dart';
import '../../../../../core/ui/kinly_theme_access.dart';

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
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final colorScheme = theme.colorScheme;
    final linkColors =
        theme.extension<KinlyLinkColors>() ??
        KinlyLinkColors(link: colorScheme.primary, icon: colorScheme.primary);
    final s = S.of(context);

    final hasExpectationPhoto = expectationPhotoUrl?.trim().isNotEmpty == true;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(spacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: spacing.md),
          Text(
            s.flowChoreDetailMoreInfoTitle,
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: spacing.md),
          _FlowDetailSection(
            title: notesLabel,
            body: notesBody,
            linkColors: linkColors,
          ),
          SizedBox(height: spacing.md),
          _FlowDetailSection(
            title: howToLabel,
            body: howToBody,
            onTap: onHowToTap,
            linkColors: linkColors,
          ),
          if (hasExpectationPhoto) ...[
            SizedBox(height: spacing.md),
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
    required this.linkColors,
    this.onTap,
  });

  final String title;
  final String body;
  final VoidCallback? onTap;
  final KinlyLinkColors linkColors;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>();
    final isLink = onTap != null;

    final linkColor = isLink ? linkColors.link : null;

    final bodyText = Text(
      body,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: linkColor,
        decoration: isLink ? TextDecoration.underline : null,
        decorationColor: linkColor,
      ),
    );

    final bodyContent =
        isLink
            ? KinlyTapTarget(
              onTap: onTap,
              alignment: AlignmentDirectional.centerStart,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: bodyText),
                  const SizedBox(width: 8),
                  Icon(KinlyIcons.openInNew, size: 16, color: linkColors.icon),
                ],
              ),
            )
            : bodyText;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(spacing?.md ?? 16),
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
          SizedBox(height: spacing?.xs ?? 4),
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
    final theme = KinlyThemeAccess.of(context);
    final colorScheme = theme.colorScheme;
    final heroTag = 'flow-chore-photo-${photoUrl.hashCode}';

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
        KinlyTapTarget(
          onTap:
              () => context.pushNamed(
                AppRouteNames.flowChorePhoto,
                extra: FlowChorePhotoViewerArgs(
                  photoUrl: photoUrl,
                  heroTag: heroTag,
                  title: title,
                ),
              ),
          borderRadius: BorderRadius.circular(12),
          child: Hero(
            tag: heroTag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(photoUrl, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
