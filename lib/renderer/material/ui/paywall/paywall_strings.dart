class PaywallStrings {
  final String title;
  final String subtitle;
  final String bulletMembers;
  final String bulletFlows;
  final String? bulletFlowPhotos;
  final String bulletPhotos;
  final String bulletExpensePhotos;
  final String bulletShoppingPhotos;
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
    this.bulletFlowPhotos,
    required this.bulletPhotos,
    required this.bulletExpensePhotos,
    required this.bulletShoppingPhotos,
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

  PaywallStrings copyWith({
    String? title,
    String? subtitle,
    String? bulletMembers,
    String? bulletFlows,
    String? bulletFlowPhotos,
    String? bulletPhotos,
    String? bulletExpensePhotos,
    String? bulletShoppingPhotos,
    String? bulletShares,
    String? unlimitedLabel,
    String? priceCaption,
    String? emotionalBody,
    String? priceUnavailableLabel,
    String Function(String price)? priceFormatter,
    String? primaryCta,
    String? secondaryCta,
    String? purchaseFailed,
    String? purchaseSuccess,
    String? restoreCta,
    String? errorTitle,
    String? retryLabel,
  }) {
    return PaywallStrings(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      bulletMembers: bulletMembers ?? this.bulletMembers,
      bulletFlows: bulletFlows ?? this.bulletFlows,
      bulletFlowPhotos: bulletFlowPhotos ?? this.bulletFlowPhotos,
      bulletPhotos: bulletPhotos ?? this.bulletPhotos,
      bulletExpensePhotos: bulletExpensePhotos ?? this.bulletExpensePhotos,
      bulletShoppingPhotos: bulletShoppingPhotos ?? this.bulletShoppingPhotos,
      bulletShares: bulletShares ?? this.bulletShares,
      unlimitedLabel: unlimitedLabel ?? this.unlimitedLabel,
      priceCaption: priceCaption ?? this.priceCaption,
      emotionalBody: emotionalBody ?? this.emotionalBody,
      priceUnavailableLabel: priceUnavailableLabel ?? this.priceUnavailableLabel,
      priceFormatter: priceFormatter ?? this.priceFormatter,
      primaryCta: primaryCta ?? this.primaryCta,
      secondaryCta: secondaryCta ?? this.secondaryCta,
      purchaseFailed: purchaseFailed ?? this.purchaseFailed,
      purchaseSuccess: purchaseSuccess ?? this.purchaseSuccess,
      restoreCta: restoreCta ?? this.restoreCta,
      errorTitle: errorTitle ?? this.errorTitle,
      retryLabel: retryLabel ?? this.retryLabel,
    );
  }
}
