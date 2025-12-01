// lib/features/today/ui/widgets/today_section_tabs.dart

/// Shared tab type for Today sections that follow an
/// Active / Drafts pattern (Flow, Share, etc.).
enum TodaySectionTabType { active, drafts }

/// Helper for computing default / available tabs from
/// simple "has active / has drafts" booleans.
class TodaySectionTabs {
  const TodaySectionTabs._(); // no instances

  /// Returns the default tab to select, or null if there
  /// are no tabs at all.
  static TodaySectionTabType? defaultTab({
    required bool hasActive,
    required bool hasDrafts,
  }) {
    if (hasActive) return TodaySectionTabType.active;
    if (hasDrafts) return TodaySectionTabType.drafts;
    return null;
  }

  /// Returns the list of available tabs based on data.
  static List<TodaySectionTabType> available({
    required bool hasActive,
    required bool hasDrafts,
  }) {
    final tabs = <TodaySectionTabType>[];
    if (hasActive) tabs.add(TodaySectionTabType.active);
    if (hasDrafts) tabs.add(TodaySectionTabType.drafts);
    return tabs;
  }
}
