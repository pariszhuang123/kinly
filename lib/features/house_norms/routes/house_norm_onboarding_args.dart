class HouseNormOnboardingArgs {
  const HouseNormOnboardingArgs({
    this.initialResponses = const <String, int>{},
    this.entrySource,
    this.homeIdOverride,
  });

  final Map<String, int> initialResponses;
  final String? entrySource;
  final String? homeIdOverride;
}
