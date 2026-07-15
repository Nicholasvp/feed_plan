import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../../data/services/revenuecat_service.dart';
import 'premium_state.dart';

class PremiumCubit extends Cubit<PremiumState> {
  PremiumCubit() : super(const PremiumState());

  final _service = RevenueCatService.instance;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));

    final isPremium = await _service.isPremium;
    final packages = await _service.getPackages();

    emit(state.copyWith(
      isPremium: isPremium,
      packages: packages,
      isLoading: false,
    ));
  }

  Future<void> presentPaywall() async {
    print('[PremiumCubit] presentPaywall() called');
    try {
      final result = await _service.presentPaywallIfNeeded();
      print('[PremiumCubit] Paywall result: $result');
      if (result == PaywallResult.purchased ||
          result == PaywallResult.restored) {
        print('[PremiumCubit] Purchase/restore detected, reloading state');
        await load();
      }
    } catch (e, stack) {
      print('[PremiumCubit] Error: $e');
      print('[PremiumCubit] Stack: $stack');
    }
  }
}
