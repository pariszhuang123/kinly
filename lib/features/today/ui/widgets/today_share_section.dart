import 'package:flutter/material.dart';
import '../../../../core/ui/section_container.dart';
import '../../../../core/ui/section_list_card.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../domain/models.dart';

class TodayShareSection extends StatelessWidget {
  final List<TodayShareExpense> expenses;
  final void Function(TodayShareExpense) onExpenseTap;
  final VoidCallback onSeeAllTap;

  const TodayShareSection({
    super.key,
    required this.expenses,
    required this.onExpenseTap,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final sections = Theme.of(context).extension<KinlySections>()!;
    final spacing = Theme.of(context).extension<Spacing>();
    final visibleExpenses =
        expenses.length > 3 ? expenses.take(3).toList() : expenses;

    return SectionContainer(
      title: 'Share',
      colors: sections.share,
      child: Column(
        children: [
          ...visibleExpenses.map(
            (e) => SectionListCard(
              colors: sections.share,
              icon: Icons.savings_rounded,
              title: e.title,
              trailingText: '\$${e.amount.toStringAsFixed(2)}',
              badgeText: e.isUpcoming ? 'upcoming' : null,
              onTap: () => onExpenseTap(e),
            ),
          ),
          if (expenses.length > 3)
            Padding(
              padding: EdgeInsets.only(top: spacing?.sm ?? 8),
              child: Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: onSeeAllTap,
                  child: Text(
                    'See all expenses',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: sections.share.icon,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
