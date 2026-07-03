import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/file_utils.dart';
import '../../../core/utils/logger.dart';
import '../../bloc/carousel_list/carousel_list_bloc.dart';
import '../../bloc/carousel_list/carousel_list_event.dart';
import '../../bloc/carousel_list/carousel_list_state.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../bloc/profile/profile_event.dart';
import '../../bloc/profile/profile_state.dart';
import 'widgets/grid_tile.dart';
import 'widgets/profile_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
            title: const Text('FeedPlan'),
            actions: [
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
                            return PostGridTile(
                              carousel: carousel,
                              onTap: () => context.push(
                                '/carousel/${carousel.id}',
                              ),
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
}
