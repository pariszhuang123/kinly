class PreferenceOnboardingArgs {
  const PreferenceOnboardingArgs({
    this.initialResponses = const <String, int>{},
    this.entrySource,
  });

  final Map<String, int> initialResponses;
  final String? entrySource;
}
