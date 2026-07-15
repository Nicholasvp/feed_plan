import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/file_utils.dart';
import '../../../core/utils/logger.dart';
import '../../../data/services/revenuecat_service.dart';
import '../../bloc/carousel_list/carousel_list_bloc.dart';
import '../../bloc/carousel_list/carousel_list_event.dart';
import '../../bloc/carousel_list/carousel_list_state.dart';
import '../../bloc/premium/premium_cubit.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../bloc/profile/profile_event.dart';
import '../../bloc/profile/profile_state.dart';
import 'widgets/grid_tile.dart';
import 'widgets/profile_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Set<String> _selectedCarouselIds = {};

  bool get _hasSelection => _selectedCarouselIds.isNotEmpty;

  void _showDeleteDialog(BuildContext context) {
    final count = _selectedCarouselIds.length;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete $count post${count > 1 ? 's' : ''}'),
        content: Text(
            'Are you sure you want to delete $count post${count > 1 ? 's' : ''}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              for (final id in _selectedCarouselIds) {
                context.read<CarouselListBloc>().add(DeleteCarousel(id));
              }
              setState(() => _selectedCarouselIds.clear());
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileEmpty) {
          context.go('/profile-setup');
        }
      },
      builder: (context, profileState) {
        if (profileState is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (profileState is ProfileError) {
          return Scaffold(
            body: Center(child: Text(profileState.message)),
          );
        }

        if (profileState is! ProfileLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = profileState.profile;

        return Scaffold(
          appBar: AppBar(
            title: Text(_hasSelection
                ? '${_selectedCarouselIds.length} posts selected'
                : 'FeedPlan'),
            leading: _hasSelection
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() => _selectedCarouselIds.clear());
                    },
                  )
                : null,
            actions: [
              if (_hasSelection)
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () => _showDeleteDialog(context),
                ),
              if (!_hasSelection) ...[
                const _PremiumButton(),
                IconButton(
                  icon: const Icon(Icons.bug_report_outlined),
                  tooltip: 'Error Logs',
                  onPressed: () => context.push('/logs'),
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => context.push('/profile-setup'),
                ),
              ],
            ],
          ),
          body: Column(
            children: [
              ProfileHeader(profile: profile),
              const Divider(height: 1),
              Expanded(
                child: BlocBuilder<CarouselListBloc, CarouselListState>(
                  builder: (context, carouselState) {
                    if (carouselState is CarouselListInitial) {
                      context.read<CarouselListBloc>().add(
                            LoadCarousels(profile.id),
                          );
                    }

                    if (carouselState is CarouselListLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (carouselState is CarouselListError) {
                      return Center(child: Text(carouselState.message));
                    }

                    if (carouselState is CarouselListLoaded) {
                      final carousels = carouselState.carousels;

                      if (carousels.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.photo_library_outlined,
                                  size: 64,
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No posts yet',
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap + to create your first carousel',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<CarouselListBloc>()
                              .add(LoadCarousels(profile.id));
                        },
                        child: GridView.builder(
                          padding: const EdgeInsets.all(1),
                          itemCount: carousels.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 1,
                            crossAxisSpacing: 1,
                          ),
                          itemBuilder: (context, index) {
                            final carousel = carousels[index];
                            final isSelected =
                                _selectedCarouselIds.contains(carousel.id);
                            return PostGridTile(
                              carousel: carousel,
                              isSelected: isSelected,
                              onTap: () {
                                if (_hasSelection) {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedCarouselIds.remove(carousel.id);
                                    } else {
                                      _selectedCarouselIds.add(carousel.id);
                                    }
                                  });
                                } else {
                                  context.push('/carousel/${carousel.id}');
                                }
                              },
                              onLongPress: () {
                                setState(() {
                                  _selectedCarouselIds.add(carousel.id);
                                });
                              },
                            );
                          },
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.small(
                heroTag: 'photo',
                onPressed: () => _uploadSinglePhoto(context, profile.id),
                child: const Icon(Icons.add_photo_alternate_outlined),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                heroTag: 'carousel',
                onPressed: () => _createNewCarousel(context, profile.id),
                child: const Icon(Icons.auto_stories),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadSinglePhoto(
      BuildContext context, String profileId) async {
    final premiumState = context.read<PremiumCubit>().state;
    if (!premiumState.isPremium) {
      final carouselBloc = context.read<CarouselListBloc>();
      final currentState = carouselBloc.state;
      final count = currentState is CarouselListLoaded
          ? currentState.carousels.length
          : 0;
      if (count >= PremiumLimits.freeCarouselLimit) {
        if (context.mounted) {
          _showPremiumLimitDialog(context, 'posts');
        }
        return;
      }
    }

    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null || !context.mounted) return;

    try {
      final permanentPath = await FileUtils.copyToPermanentStorage(image.path);
      if (!context.mounted) return;

      final carouselBloc = context.read<CarouselListBloc>();
      final profileBloc = context.read<ProfileBloc>();

      carouselBloc.add(CreateSinglePhotoPost(
        profileId: profileId,
        filePath: permanentPath,
      ));
      profileBloc.add(const IncrementPostCount());

      await Future.delayed(const Duration(milliseconds: 500));
      carouselBloc.add(LoadCarousels(profileId));
    } catch (e, stackTrace) {
      Logger.logError('Failed to upload single photo', context: 'ProfilePage', stackTrace: stackTrace);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar imagem: $e')),
        );
      }
    }
  }

  Future<void> _createNewCarousel(
      BuildContext context, String profileId) async {
    final carouselBloc = context.read<CarouselListBloc>();
    final profileBloc = context.read<ProfileBloc>();
    final premiumState = context.read<PremiumCubit>().state;

    // Check free tier limit
    if (!premiumState.isPremium) {
      final currentState = carouselBloc.state;
      final count = currentState is CarouselListLoaded
          ? currentState.carousels.length
          : 0;
      if (count >= PremiumLimits.freeCarouselLimit) {
        if (context.mounted) {
          _showPremiumLimitDialog(context, 'carousels');
        }
        return;
      }
    }

    // Create empty carousel
    carouselBloc.add(CreateCarousel(profileId: profileId));

    // Wait for state to update with new carousel, then navigate
    await Future.delayed(const Duration(milliseconds: 300));

    final state = carouselBloc.state;
    if (state is CarouselListLoaded && state.carousels.isNotEmpty) {
      final newCarousel = state.carousels.last;
      profileBloc.add(const IncrementPostCount());
      if (context.mounted) {
        context.push('/carousel-editor/${newCarousel.id}');
      }
    }
  }

  void _showPremiumLimitDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.lock, size: 20),
            const SizedBox(width: 8),
            const Text('Premium feature'),
          ],
        ),
        content: Text(
          'You\'ve reached the free limit for $feature. '
          'Upgrade to Premium to unlock unlimited access.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.push('/paywall');
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }
}

class _PremiumButton extends StatefulWidget {
  const _PremiumButton();

  @override
  State<_PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<_PremiumButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withValues(
                  alpha: 0.4 * _glowAnimation.value,
                ),
                blurRadius: 12 * _glowAnimation.value,
                spreadRadius: 1 * _glowAnimation.value,
              ),
            ],
          ),
          child: Material(
            color: const Color(0xFF7C3AED),
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => context.push('/paywall'),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
