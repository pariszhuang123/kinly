import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatPackage {
  final String identifier;
  final String priceString;

  RevenueCatPackage({required this.identifier, required this.priceString});
}

abstract class RevenueCatService {
  Future<RevenueCatPackage?> fetchMonthlyPackage({String? placementId});
  Future<void> purchaseMonthly(RevenueCatPackage pkg);
  Future<void> restorePurchases();
  Future<CustomerInfo> getCustomerInfo();
  Future<Package?> fetchPackageByIdentifier(String identifier);
  Future<bool> isEntitlementActive(String entitlementId);
  Future<void> setSubscriberAttributes({
    required String appUserId,
    String? homeId,
    String? locale,
    String? email,
  });
}

class DefaultRevenueCatService implements RevenueCatService {
  @override
  Future<RevenueCatPackage?> fetchMonthlyPackage({String? placementId}) async {
    Offering? offering;
    if (placementId != null && placementId.isNotEmpty) {
      offering = await Purchases.getCurrentOfferingForPlacement(placementId);
    }
    offering ??= (await Purchases.getOfferings()).current;

    final monthly = offering?.monthly;
    if (monthly == null) return null;
    return RevenueCatPackage(
      identifier: monthly.identifier,
      priceString: monthly.storeProduct.priceString,
    );
  }

  @override
  Future<void> purchaseMonthly(RevenueCatPackage pkg) async {
    final package = await fetchPackageByIdentifier(pkg.identifier) ??
        (throw Exception('Monthly package not available'));
    await Purchases.purchasePackage(package);
  }

  @override
  Future<void> restorePurchases() => Purchases.restorePurchases();

  @override
  Future<CustomerInfo> getCustomerInfo() => Purchases.getCustomerInfo();

  @override
  Future<Package?> fetchPackageByIdentifier(String identifier) async {
    final offerings = await Purchases.getOfferings();
    for (final offering in offerings.all.values) {
      for (final package in offering.availablePackages) {
        if (package.identifier == identifier) return package;
      }
    }
    return null;
  }

  @override
  Future<bool> isEntitlementActive(String entitlementId) async {
    final info = await getCustomerInfo();
    return info.entitlements.active.containsKey(entitlementId);
  }

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
