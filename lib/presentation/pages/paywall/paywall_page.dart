import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/premium/premium_cubit.dart';
import '../../bloc/premium/premium_state.dart';

class PaywallPage extends StatelessWidget {
  const PaywallPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FeedPlan Premium'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<PremiumCubit, PremiumState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Icon(
                  Icons.auto_stories,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Unlock Premium',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _FeatureRow(
                  icon: Icons.unsubscribe,
                  title: 'Unlimited carousels',
                  subtitle: 'Create as many carousels as you want',
                ),
                const SizedBox(height: 12),
                _FeatureRow(
                  icon: Icons.crop_original,
                  title: 'All aspect ratios',
                  subtitle: '1:1, 4:5, 9:16, 16:9 and more',
                ),
                const SizedBox(height: 12),
                _FeatureRow(
                  icon: Icons.water_drop,
                  title: 'Export without watermark',
                  subtitle: 'Clean, professional exports',
                ),
                const SizedBox(height: 12),
                _FeatureRow(
                  icon: Icons.cloud_done,
                  title: 'Priority support',
                  subtitle: 'Get help when you need it',
                ),
                const SizedBox(height: 32),
                if (state.packages.isNotEmpty)
                  ...state.packages.map(
                    (package) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => context
                              .read<PremiumCubit>()
                              .purchasePackage(package),
                          child: Text(
                            '${package.storeProduct.title} - ${package.storeProduct.priceString}',
                          ),
                        ),
                      ),
                    ),
                  ),
                if (state.packages.isEmpty)
                  Text(
                    'No products available yet.\nConfigure them in App Store Connect / Google Play Console.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () =>
                      context.read<PremiumCubit>().restorePurchases(),
                  child: const Text('Restore purchases'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.onPrimaryContainer,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
