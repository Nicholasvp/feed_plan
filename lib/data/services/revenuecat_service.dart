import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../core/env/env_config.dart';

class RevenueCatService {
  RevenueCatService._();

  static final RevenueCatService instance = RevenueCatService._();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      print('[RevenueCat] Already initialized');
      return;
    }

    print('[RevenueCat] Initializing...');
    print('[RevenueCat] API key set: ${EnvConfig.hasRevenueCatKeys}');
    if (EnvConfig.hasRevenueCatKeys) {
      print('[RevenueCat] API key: ${EnvConfig.revenueCatApiKey}');
    }

    if (!EnvConfig.hasRevenueCatKeys) {
      print('[RevenueCat] No API keys found - running in dev mode (premium unlocked)');
      _initialized = true;
      return;
    }

    await Purchases.setLogLevel(LogLevel.debug);
    print('[RevenueCat] Debug logging enabled');

    try {
      final configuration = PurchasesConfiguration(
        EnvConfig.revenueCatApiKey,
      );
      await Purchases.configure(configuration);
      _initialized = true;
      print('[RevenueCat] Configured successfully');
    } catch (e) {
      print('[RevenueCat] Configuration failed: $e');
    }
  }

  bool get isConfigured {
    final configured = _initialized && EnvConfig.hasRevenueCatKeys;
    print('[RevenueCat] isConfigured: $configured (initialized=$_initialized, hasKeys=${EnvConfig.hasRevenueCatKeys})');
    return configured;
  }

  Future<bool> get isPremium async {
    if (!isConfigured) {
      print('[RevenueCat] Not configured - returning premium=true (dev mode)');
      return true;
    }

    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final active = customerInfo.entitlements.active;
      print('[RevenueCat] Active entitlements: ${active.length}');
      for (final e in active.entries) {
        print('[RevenueCat]   Entitlement: ${e.key}');
      }
      return active.isNotEmpty;
    } catch (e) {
      print('[RevenueCat] Error checking premium: $e');
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
    print('[RevenueCat] presentPaywallIfNeeded called');
    print('[RevenueCat] isConfigured: $isConfigured');

    if (!isConfigured) {
      print('[RevenueCat] Not configured, returning notPresented');
      return PaywallResult.notPresented;
    }

    try {
      print('[RevenueCat] Calling RevenueCatUI.presentPaywallIfNeeded(pro)...');
      final result = await RevenueCatUI.presentPaywallIfNeeded(
        'pro',
        displayCloseButton: true,
      );
      print('[RevenueCat] Paywall result: $result');
      return result;
    } catch (e, stack) {
      print('[RevenueCat] Paywall error: $e');
      print('[RevenueCat] Stack: $stack');
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
