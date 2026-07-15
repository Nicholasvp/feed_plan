import 'package:flutter_bloc/flutter_bloc.dart';

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

  Future<void> purchasePackage(dynamic package) async {
    await _service.purchasePackage(package);
    await load();
  }

  Future<void> restorePurchases() async {
    await _service.restorePurchases();
    await load();
  }
}
