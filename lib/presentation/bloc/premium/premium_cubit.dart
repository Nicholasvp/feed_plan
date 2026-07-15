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
    final result = await _service.presentPaywallIfNeeded();
    if (result == PaywallResult.purchased ||
        result == PaywallResult.restored) {
      await load();
    }
  }
}
