import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

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

    final configuration = PurchasesConfiguration(EnvConfig.revenueCatApiKey);
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

  Future<PaywallResult> presentPaywallIfNeeded() async {
    if (!isConfigured) return PaywallResult.notPresented;

    try {
      return await RevenueCatUI.presentPaywallIfNeeded(
        'pro',
        displayCloseButton: true,
      );
    } catch (_) {
      return PaywallResult.error;
    }
  }
}

class PremiumLimits {
  PremiumLimits._();

  static const int freeCarouselLimit = 3;

  static const List<String> freeAspectRatios = ['1:1'];
  static const List<String> premiumAspectRatios = ['1:1', '4:5', '9:16', '16:9'];
}
