class PaywallStrings {
  final String title;
  final String subtitle;
  final String bulletMembers;
  final String bulletFlows;
  final String bulletPhotos;
  final String bulletShares;
  final String unlimitedLabel;
  final String? priceCaption;
  final String? emotionalBody;
  final String? priceUnavailableLabel;
  final String Function(String price)? priceFormatter;
  final String primaryCta;
  final String secondaryCta;
  final String purchaseFailed;
  final String purchaseSuccess;
  final String restoreCta;
  final String errorTitle;
  final String retryLabel;

  const PaywallStrings({
    required this.title,
    required this.subtitle,
    required this.bulletMembers,
    required this.bulletFlows,
    required this.bulletPhotos,
    required this.bulletShares,
    required this.unlimitedLabel,
    this.priceCaption,
    this.emotionalBody,
    this.priceUnavailableLabel,
    this.priceFormatter,
    required this.primaryCta,
    required this.secondaryCta,
    required this.purchaseFailed,
    required this.purchaseSuccess,
    required this.restoreCta,
    required this.errorTitle,
    required this.retryLabel,
  });
}
