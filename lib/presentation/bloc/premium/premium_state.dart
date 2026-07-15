import 'package:equatable/equatable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PremiumState extends Equatable {
  const PremiumState({
    this.isPremium = false,
    this.isLoading = true,
    this.packages = const [],
  });

  final bool isPremium;
  final bool isLoading;
  final List<Package> packages;

  PremiumState copyWith({
    bool? isPremium,
    bool? isLoading,
    List<Package>? packages,
  }) {
    return PremiumState(
      isPremium: isPremium ?? this.isPremium,
      isLoading: isLoading ?? this.isLoading,
      packages: packages ?? this.packages,
    );
  }

  @override
  List<Object?> get props => [isPremium, isLoading, packages];
}
