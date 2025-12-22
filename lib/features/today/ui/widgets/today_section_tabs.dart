// lib/features/today/ui/widgets/today_section_tabs.dart

/// Shared tab type for Today sections that follow an
/// Active / Drafts pattern (Flow, Share, etc.).
enum TodaySectionTabType { active, received, drafts }

/// Helper for computing default / available tabs from
/// simple "has active / has drafts" booleans.
class TodaySectionTabs {
  const TodaySectionTabs._(); // no instances

  /// Returns the default tab to select, or null if there
  /// are no tabs at all.
  static TodaySectionTabType? defaultTab({
    required bool hasActive,
    required bool hasReceived,
    required bool hasDrafts,
  }) {
    if (hasActive) return TodaySectionTabType.active;
    if (hasReceived) return TodaySectionTabType.received;
    if (hasDrafts) return TodaySectionTabType.drafts;
    return null;
  }

  /// Returns the list of available tabs based on data.
  static List<TodaySectionTabType> available({
    required bool hasActive,
    required bool hasReceived,
    required bool hasDrafts,
  }) {
    final tabs = <TodaySectionTabType>[];
    if (hasActive) tabs.add(TodaySectionTabType.active);
    if (hasReceived) tabs.add(TodaySectionTabType.received);
    if (hasDrafts) tabs.add(TodaySectionTabType.drafts);
    return tabs;
  }
}
