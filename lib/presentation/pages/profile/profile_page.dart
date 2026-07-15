import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/file_utils.dart';
import '../../../core/utils/logger.dart';
import '../../../data/models/carousel_model.dart';
import '../../../data/models/feed_item_model.dart';
import '../../../data/models/instagram_post_model.dart';
import '../../../data/services/revenuecat_service.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../bloc/carousel_list/carousel_list_bloc.dart';
import '../../bloc/carousel_list/carousel_list_event.dart';
import '../../bloc/carousel_list/carousel_list_state.dart';
import '../../bloc/locale/locale_bloc.dart';
import '../../bloc/locale/locale_event.dart';
import '../../bloc/premium/premium_cubit.dart';
import '../../bloc/premium/premium_state.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../bloc/profile/profile_event.dart';
import '../../bloc/profile/profile_state.dart';
import '../../../data/services/instagram_cache_service.dart';
import 'widgets/grid_tile.dart';
import 'widgets/profile_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Set<String> _selectedItemIds = {};
  List<InstagramPostModel> _instagramPosts = [];

  bool get _hasSelection => _selectedItemIds.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadInstagramPosts();
  }

  Future<void> _loadInstagramPosts() async {
    final cacheService = InstagramCacheService.instance;
    final posts = await cacheService.getCachedPosts();
    if (mounted) {
      setState(() {
        _instagramPosts = posts;
      });
    }
  }

  List<FeedItemModel> _buildFeedItems(List<CarouselModel> carousels) {
    final items = <FeedItemModel>[];

    final sortedCarousels = List<CarouselModel>.from(carousels)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    for (final carousel in sortedCarousels) {
      items.add(FeedItemModel.fromCarousel(carousel));
    }

    final sortedPosts = List<InstagramPostModel>.from(_instagramPosts)
      ..sort((a, b) {
        final aTime = a.timestamp ?? DateTime.now();
        final bTime = b.timestamp ?? DateTime.now();
        return bTime.compareTo(aTime);
      });
    for (final post in sortedPosts) {
      items.add(FeedItemModel.fromInstagramPost(post));
    }

    return items;
  }

  void _showDeleteDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final count = _selectedItemIds.length;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteItemCount(count)),
        content: Text(l10n.deleteItemCountConfirm(count)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              for (final id in _selectedItemIds) {
                context.read<CarouselListBloc>().add(DeleteCarousel(id));
              }
              setState(() => _selectedItemIds.clear());
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = context.read<LocaleBloc>().state.locale;

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.language,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              title: Text(l10n.english),
              trailing: currentLocale.languageCode == 'en'
                  ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                context.read<LocaleBloc>().add(const ChangeLocale(Locale('en')));
                Navigator.of(ctx).pop();
              },
            ),
            ListTile(
              leading: const Text('🇧🇷', style: TextStyle(fontSize: 24)),
              title: Text(l10n.portuguese),
              trailing: currentLocale.languageCode == 'pt'
                  ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                context.read<LocaleBloc>().add(const ChangeLocale(Locale('pt')));
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

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
            centerTitle: false,
            title: Text(_hasSelection
                ? l10n.selectedCount(_selectedItemIds.length)
                : l10n.appTitle),
            leading: _hasSelection
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() => _selectedItemIds.clear());
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
                BlocBuilder<PremiumCubit, PremiumState>(
                  builder: (context, premiumState) {
                    if (premiumState.isPremium) {
                      return const SizedBox.shrink();
                    }
                    return const _PremiumButton();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.language),
                  tooltip: l10n.language,
                  onPressed: () => _showLanguagePicker(context),
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
              ProfileHeader(
                profile: profile,
                onPostsFetched: _loadInstagramPosts,
              ),
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
                      final feedItems = _buildFeedItems(carouselState.carousels);

                      if (feedItems.isEmpty) {
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
                                  l10n.noPostsYet,
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.tapToCreateCarousel,
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
                          await _loadInstagramPosts();
                        },
                        child: GridView.builder(
                          padding: const EdgeInsets.all(1),
                          itemCount: feedItems.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 1,
                            crossAxisSpacing: 1,
                          ),
                          itemBuilder: (context, index) {
                            final item = feedItems[index];
                            final isSelected =
                                _selectedItemIds.contains(item.id);
                            return PostGridTile(
                              item: item,
                              isSelected: isSelected,
                              onTap: () {
                                if (_hasSelection) {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedItemIds.remove(item.id);
                                    } else {
                                      _selectedItemIds.add(item.id);
                                    }
                                  });
                                } else if (item.isLocal &&
                                    item.carousel != null) {
                                  context.push(
                                      '/carousel/${item.carousel!.id}');
                                }
                              },
                              onLongPress: () {
                                setState(() {
                                  _selectedItemIds.add(item.id);
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
    final l10n = AppLocalizations.of(context)!;
    final premiumState = context.read<PremiumCubit>().state;
    if (!premiumState.isPremium) {
      final carouselBloc = context.read<CarouselListBloc>();
      final currentState = carouselBloc.state;
      final count = currentState is CarouselListLoaded
          ? currentState.carousels.length
          : 0;
      if (count >= PremiumLimits.freeCarouselLimit) {
        if (context.mounted) {
          _showPremiumLimitDialog(context, l10n.posts);
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
      Logger.logError('Failed to upload single photo',
          context: 'ProfilePage', stackTrace: stackTrace);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorSavingImage(e.toString()))),
        );
      }
    }
  }

  Future<void> _createNewCarousel(
      BuildContext context, String profileId) async {
    final l10n = AppLocalizations.of(context)!;
    final carouselBloc = context.read<CarouselListBloc>();
    final profileBloc = context.read<ProfileBloc>();
    final premiumState = context.read<PremiumCubit>().state;

    if (!premiumState.isPremium) {
      final currentState = carouselBloc.state;
      final count = currentState is CarouselListLoaded
          ? currentState.carousels.length
          : 0;
      if (count >= PremiumLimits.freeCarouselLimit) {
        if (context.mounted) {
          _showPremiumLimitDialog(context, l10n.posts);
        }
        return;
      }
    }

    carouselBloc.add(CreateCarousel(profileId: profileId));

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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.lock, size: 20),
            const SizedBox(width: 8),
            Text(l10n.premiumFeature),
          ],
        ),
        content: Text(l10n.premiumLimitReached(feature)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.notNow),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<PremiumCubit>().presentPaywall();
            },
            child: Text(l10n.upgrade),
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
    final l10n = AppLocalizations.of(context)!;
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
              onTap: () => context.read<PremiumCubit>().presentPaywall(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.workspace_premium, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      l10n.premium,
                      style: const TextStyle(
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
