import 'package:flutter/material.dart';
import '../../theme/spacing.dart';
import '../kinly_circle_avatar.dart';
import '../kinly_motion_aware.dart';

class KinlyMemberAvatarChip extends StatelessWidget {
  const KinlyMemberAvatarChip({
    super.key,
    required this.displayName,
    required this.avatarUrl,
    this.isOwner = false,
    this.isSelected = false,
    this.onTap,
  });

  final String displayName;
  final String? avatarUrl;
  final bool isOwner;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final motionAware = KinlyMotionAware.of(context);
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final colorScheme = theme.colorScheme;

    final borderColor =
        isSelected
            ? colorScheme.primary
            : colorScheme.outlineVariant.withValues(alpha: 0.4);

    final bgColor =
        isSelected
            ? colorScheme.primary.withValues(alpha: 0.08)
            : Colors.transparent;

    return SizedBox(
      width: 110,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: Semantics(
              label: displayName,
              button: true,
              enabled: onTap != null,
              child: InkWell(
                borderRadius: BorderRadius.circular(48),
                onTap: onTap,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
                  child: AnimatedContainer(
                    duration: motionAware.effectiveDuration(
                      const Duration(milliseconds: 150),
                    ),
                    padding: EdgeInsets.all(spacing.xs),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(48),
                      border: Border.all(
                        color: borderColor,
                        width: isSelected ? 2 : 1,
                      ),
                      color: bgColor,
                    ),
                    child: KinlyCircleAvatar(
                      avatarUrl: avatarUrl,
                      radius: 34,
                      isOwner: isOwner,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(
            displayName,
            style: theme.textTheme.bodyMedium?.copyWith(
              color:
                  isSelected
                      ? colorScheme.onSurface
                      : colorScheme.onSurface.withValues(alpha: 0.9),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
