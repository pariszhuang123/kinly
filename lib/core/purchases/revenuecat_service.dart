import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatPackage {
  final String identifier;
  final String priceString;

  RevenueCatPackage({required this.identifier, required this.priceString});
}

abstract class RevenueCatService {
  Future<RevenueCatPackage?> fetchMonthlyPackage();
  Future<void> purchaseMonthly(RevenueCatPackage pkg);
  Future<void> restorePurchases();
  Future<void> setSubscriberAttributes({
    required String appUserId,
    String? homeId,
    String? locale,
    String? email,
  });
}

class DefaultRevenueCatService implements RevenueCatService {
  @override
  Future<RevenueCatPackage?> fetchMonthlyPackage() async {
    final offerings = await Purchases.getOfferings();
    final monthly = offerings.current?.monthly;
    if (monthly == null) return null;
    return RevenueCatPackage(
      identifier: monthly.identifier,
      priceString: monthly.storeProduct.priceString,
    );
  }

  @override
  Future<void> purchaseMonthly(RevenueCatPackage pkg) async {
    final offerings = await Purchases.getOfferings();
    final package = offerings.all.values
        .map((o) => o.monthly)
        .whereType<Package>()
        .firstWhere(
          (p) => p.identifier == pkg.identifier,
          orElse: () => offerings.current?.monthly ?? (throw Exception('Monthly package not available')),
        );
    // purchasePackage is deprecated in newer SDKs; ignore to keep compatibility with current version.
    // ignore: deprecated_member_use
    await Purchases.purchasePackage(package);
  }

  @override
  Future<void> restorePurchases() => Purchases.restorePurchases();

  @override
  Future<void> setSubscriberAttributes({
    required String appUserId,
    String? homeId,
    String? locale,
    String? email,
  }) async {
    await Purchases.setAttributes({
      'user_id': appUserId,
      if (homeId != null) 'home_id': homeId,
      if (locale != null) 'locale': locale,
      if (email != null) 'email': email,
    });
  }
}
