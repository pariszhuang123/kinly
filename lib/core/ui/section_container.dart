import 'package:flutter/material.dart';
import '../theme/kinly_sections.dart';
import '../theme/spacing.dart';

class SectionContainer extends StatelessWidget {
  final String title;
  final SectionColors colors;
  final Widget child;
  final Widget? trailing; // optional chip / badge / icon
  final EdgeInsetsGeometry? padding;

  const SectionContainer({
    super.key,
    required this.title,
    required this.colors,
    required this.child,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<Spacing>();
    final effectivePadding =
        padding ??
        EdgeInsets.fromLTRB(
          spacing?.lg ?? 16,
          spacing?.lg ?? 16,
          spacing?.lg ?? 16,
          spacing?.md ?? 12,
        );

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row (title + optional trailing)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.icon,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          SizedBox(height: spacing?.md ?? 12),
          child,
        ],
      ),
    );
  }
}
