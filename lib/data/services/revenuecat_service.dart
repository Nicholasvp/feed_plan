import 'package:purchases_flutter/purchases_flutter.dart';

import '../../core/env/env_config.dart';

class RevenueCatService {
  RevenueCatService._();

  static final RevenueCatService instance = RevenueCatService._();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    if (!EnvConfig.hasRevenueCatKeys) {
      _initialized = true;
      return;
    }

    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration;
    if (EnvConfig.revenueCatApiKeyIos.isNotEmpty &&
        EnvConfig.revenueCatApiKeyAndroid.isNotEmpty) {
      configuration = PurchasesConfiguration(
        EnvConfig.revenueCatApiKeyIos.isNotEmpty
            ? EnvConfig.revenueCatApiKeyIos
            : EnvConfig.revenueCatApiKeyAndroid,
      );
    } else {
      final apiKey = EnvConfig.revenueCatApiKeyIos.isNotEmpty
          ? EnvConfig.revenueCatApiKeyIos
          : EnvConfig.revenueCatApiKeyAndroid;
      configuration = PurchasesConfiguration(apiKey);
    }

    await Purchases.configure(configuration);
    _initialized = true;
  }

  bool get isConfigured => _initialized && EnvConfig.hasRevenueCatKeys;

  Future<bool> get isPremium async {
    if (!isConfigured) return true;

    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<List<Package>> getPackages() async {
    if (!isConfigured) return [];

    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current?.availablePackages ?? [];
    } catch (_) {
      return [];
    }
  }

  Future<void> purchasePackage(Package package) async {
    if (!isConfigured) return;

    try {
      await Purchases.purchasePackage(package);
    } catch (_) {}
  }

  Future<void> restorePurchases() async {
    if (!isConfigured) return;

    try {
      await Purchases.restorePurchases();
    } catch (_) {}
  }
}

class PremiumLimits {
  PremiumLimits._();

  static const int freeCarouselLimit = 3;

  static const List<String> freeAspectRatios = ['1:1'];
  static const List<String> premiumAspectRatios = ['1:1', '4:5', '9:16', '16:9'];
}
