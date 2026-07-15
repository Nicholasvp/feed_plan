import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../bloc/premium/premium_cubit.dart';
import '../../bloc/premium/premium_state.dart';
import '../../widgets/premium_gate.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({super.key, required this.carouselId});

  final String carouselId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Export'),
        actions: [
          BlocBuilder<PremiumCubit, PremiumState>(
            builder: (context, state) {
              if (!state.isPremium) {
                return TextButton.icon(
                  onPressed: () => context.read<PremiumCubit>().presentPaywall(),
                  icon: const Icon(Icons.workspace_premium, size: 18),
                  label: const Text('Upgrade'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.download_done,
                size: 72,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Ready to export',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '${AppConstants.exportPrefix}01.jpg, ${AppConstants.exportPrefix}02.jpg...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              PremiumGate(
                locked: true,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Export feature coming soon!'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.save_alt),
                    label: const Text('Save to Gallery'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
