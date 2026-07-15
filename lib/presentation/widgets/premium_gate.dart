import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/generated/app_localizations.dart';
import '../bloc/premium/premium_cubit.dart';
import '../bloc/premium/premium_state.dart';

class PremiumGate extends StatelessWidget {
  const PremiumGate({
    super.key,
    required this.child,
    this.locked = false,
  });

  final Widget child;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    if (!locked) return child;

    return BlocBuilder<PremiumCubit, PremiumState>(
      builder: (context, state) {
        if (state.isPremium) return child;

        final l10n = AppLocalizations.of(context)!;
        return Stack(
          children: [
            Opacity(
              opacity: 0.3,
              child: AbsorbPointer(child: child),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.read<PremiumCubit>().presentPaywall(),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            l10n.premium,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
