import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/file_utils.dart';
import '../../../core/utils/logger.dart';
import '../../bloc/carousel_editor/carousel_editor_bloc.dart';
import '../../bloc/carousel_editor/carousel_editor_event.dart' as editor_events;
import '../../bloc/carousel_editor/carousel_editor_state.dart';
import '../../bloc/carousel_list/carousel_list_bloc.dart';
import '../../bloc/carousel_list/carousel_list_event.dart' as list_events;
import '../../bloc/profile/profile_bloc.dart';
import '../../bloc/profile/profile_state.dart';
import 'widgets/canvas_page_view.dart';
import 'widgets/page_thumbnail_bar.dart';

class CarouselCanvasPage extends StatefulWidget {
  const CarouselCanvasPage({super.key, required this.carouselId});

  final String carouselId;

  @override
  State<CarouselCanvasPage> createState() => _CarouselCanvasPageState();
}

class _CarouselCanvasPageState extends State<CarouselCanvasPage> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
    context
        .read<CarouselEditorBloc>()
        .add(editor_events.LoadCarousel(widget.carouselId));
  }

  void _onPageChanged() {
    final newIndex = _pageController.page?.round() ?? 0;
    if (newIndex != _currentPageIndex) {
      setState(() => _currentPageIndex = newIndex);
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carousel Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete carousel',
            onPressed: () => _confirmDeleteCarousel(context),
          ),
          BlocBuilder<CarouselEditorBloc, CarouselEditorState>(
            builder: (context, state) {
              final isSaving = state is CarouselEditorSaving;
              return IconButton(
                icon: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check),
                onPressed: isSaving
                    ? null
                    : () {
                        context
                            .read<CarouselEditorBloc>()
                            .add(const editor_events.SaveCarousel());
                        _reloadAndPop(context);
                      },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CarouselEditorBloc, CarouselEditorState>(
        listener: (context, state) {
          if (state is CarouselEditorError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is CarouselEditorLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CarouselEditorLoaded) {
            final carousel = state.carousel;

            // Clamp page index if pages changed
            if (_currentPageIndex >= carousel.pages.length &&
                carousel.pages.isNotEmpty) {
              _currentPageIndex = carousel.pages.length - 1;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_pageController.hasClients) {
                  _pageController.jumpToPage(_currentPageIndex);
                }
              });
            }

            return Column(
              children: [
                Expanded(
                  child: carousel.pages.isEmpty
                      ? _emptyState(context, carousel.id)
                      : CanvasPageView(
                          pages: carousel.pages,
                          pageController: _pageController,
                          selectedItemId: state.selectedItemId,
                        ),
                ),
                if (carousel.pages.isNotEmpty)
                  PageThumbnailBar(
                    pages: carousel.pages,
                    pageController: _pageController,
                    carouselId: carousel.id,
                  ),
                _buildToolbar(context, carousel),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _emptyState(BuildContext context, String carouselId) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_stories,
              size: 72,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          const Text('Add pages and photos to build your carousel'),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              context
                  .read<CarouselEditorBloc>()
                  .add(const editor_events.AddPage());
            },
            icon: const Icon(Icons.add),
            label: const Text('Add First Page'),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, dynamic carousel) {
    final bloc = context.read<CarouselEditorBloc>();
    final state = bloc.state;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.add_photo_alternate_outlined),
              tooltip: 'Add image to current page',
              onPressed: () => _pickImage(context),
            ),
            IconButton(
              icon: const Icon(Icons.add_box_outlined),
              tooltip: 'Add page',
              onPressed: () {
                bloc.add(const editor_events.AddPage());
              },
            ),
            if (state is CarouselEditorLoaded &&
                state.selectedItemId != null)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete selected image',
                onPressed: () {
                  bloc.add(editor_events.DeleteItem(state.selectedItemId!));
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final bloc = context.read<CarouselEditorBloc>();
    final messenger = ScaffoldMessenger.of(context);
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null || !context.mounted) return;

    try {
      final permanentPath = await FileUtils.copyToPermanentStorage(image.path);
      if (!context.mounted) return;

      final state = bloc.state;
      if (state is CarouselEditorLoaded) {
        // Use the current page index instead of always the first page
        if (state.carousel.pages.isNotEmpty &&
            _currentPageIndex < state.carousel.pages.length) {
          final targetPageId = state.carousel.pages[_currentPageIndex].id;
          bloc.add(
            editor_events.AddImageToPage(
              pageId: targetPageId,
              filePath: permanentPath,
            ),
          );
        } else {
          bloc.add(const editor_events.AddPage());
          messenger.showSnackBar(
            const SnackBar(
                content: Text('Page created. Tap + again to add image.')),
          );
        }
      }
    } catch (e, stackTrace) {
      Logger.logError('Failed to pick image', context: 'CarouselCanvasPage', stackTrace: stackTrace);
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Erro ao adicionar imagem: $e')),
        );
      }
    }
  }

  void _confirmDeleteCarousel(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete carousel?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              final bloc = context.read<CarouselEditorBloc>();
              bloc.add(const editor_events.DeleteCarousel());
              bloc.stream
                  .firstWhere((s) => s is! CarouselEditorSaving)
                  .then((_) {
                if (context.mounted) _reloadAndPop(context);
              });
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _reloadAndPop(BuildContext context) {
    if (!context.mounted) return;
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileLoaded) {
      context
          .read<CarouselListBloc>()
          .add(list_events.LoadCarousels(profileState.profile.id));
    }
    context.go('/');
  }
}
