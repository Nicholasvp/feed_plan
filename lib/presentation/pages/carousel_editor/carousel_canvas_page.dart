import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/export_utils.dart';
import '../../../core/utils/file_utils.dart';
import '../../../core/utils/logger.dart';
import '../../../data/models/carousel_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../bloc/carousel_editor/carousel_editor_bloc.dart';
import '../../bloc/carousel_editor/carousel_editor_event.dart' as editor_events;
import '../../bloc/carousel_editor/carousel_editor_state.dart';
import '../../bloc/carousel_list/carousel_list_bloc.dart';
import '../../bloc/carousel_list/carousel_list_event.dart' as list_events;
import '../../bloc/profile/profile_bloc.dart';
import '../../bloc/profile/profile_state.dart';
import 'widgets/canvas_page_view.dart';
import 'widgets/grid_layout_selector.dart';
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
    _pageController = PageController(viewportFraction: 0.88);
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.carouselEditor),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.deleteCarousel,
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
                          onLockedItemTap: _onLockedItemTap,
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
    final l10n = AppLocalizations.of(context)!;
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
          Text(l10n.addPagesAndPhotos),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              context
                  .read<CarouselEditorBloc>()
                  .add(const editor_events.AddPage());
            },
            icon: const Icon(Icons.add),
            label: Text(l10n.addFirstPage),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, CarouselModel carousel) {
    final l10n = AppLocalizations.of(context)!;
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
              tooltip: l10n.addImageToCurrentPage,
              onPressed: () => _pickImage(context),
            ),
            IconButton(
              icon: const Icon(Icons.add_box_outlined),
              tooltip: l10n.addPage,
              onPressed: () {
                bloc.add(const editor_events.AddPage());
              },
            ),
            IconButton(
              icon: const Icon(Icons.grid_view),
              tooltip: l10n.applyGridLayout,
              onPressed: carousel.pages.isEmpty
                  ? null
                  : () => _showGridSelector(context, carousel),
            ),
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: l10n.exportPagesToGallery,
              onPressed: carousel.pages.isEmpty
                  ? null
                  : () => _exportCarousel(context, carousel),
            ),
            if (state is CarouselEditorLoaded &&
                state.selectedItemId != null) ...[
              IconButton(
                icon: const Icon(Icons.center_focus_strong),
                tooltip: l10n.centerImage,
                onPressed: () => _centerSelectedItem(context, state),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: l10n.deleteSelectedImage,
                onPressed: () {
                  bloc.add(editor_events.DeleteItem(state.selectedItemId!));
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _onLockedItemTap(String itemId) async {
    final bloc = context.read<CarouselEditorBloc>();
    final state = bloc.state;
    if (state is! CarouselEditorLoaded) return;

    CanvasItemModel? item;
    for (final page in state.carousel.pages) {
      for (final i in page.items) {
        if (i.id == itemId) {
          item = i;
          break;
        }
      }
      if (item != null) break;
    }
    if (item == null) return;

    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null || !context.mounted) return;

    try {
      final permanentPath = await FileUtils.copyToPermanentStorage(image.path);
      if (!context.mounted) return;
      bloc.add(editor_events.ReplaceGridCellImage(
        itemId: itemId,
        filePath: permanentPath,
      ));
    } catch (e) {
      Logger.logError('Failed to pick image for grid cell',
          context: 'CarouselCanvasPage');
    }
  }

  void _centerSelectedItem(
      BuildContext context, CarouselEditorLoaded state) {
    final selectedId = state.selectedItemId;
    if (selectedId == null) return;

    for (final page in state.carousel.pages) {
      for (final item in page.items) {
        if (item.id == selectedId) {
          final newX = (1.0 - item.width) / 2;
          final newY = (1.0 - item.height) / 2;
          context.read<CarouselEditorBloc>().add(editor_events.MoveItem(
                itemId: item.id,
                positionX: newX,
                positionY: newY,
              ));
          return;
        }
      }
    }
  }

  void _showGridSelector(BuildContext context, CarouselModel carousel) {
    if (carousel.pages.isEmpty) return;
    final currentPage = _currentPageIndex < carousel.pages.length
        ? carousel.pages[_currentPageIndex]
        : carousel.pages.first;

    showModalBottomSheet(
      context: context,
      builder: (ctx) => GridLayoutSelector(
        onSelected: (layoutId) {
          context.read<CarouselEditorBloc>().add(editor_events.ApplyGridLayout(
                pageId: currentPage.id,
                layoutId: layoutId,
              ));
        },
      ),
    );
  }

  Future<void> _exportCarousel(
      BuildContext context, CarouselModel carousel) async {
    if (carousel.pages.isEmpty) return;

    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.exportingPages),
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                l10n.savingPagesToGallery(carousel.pages.length),
              ),
            ),
          ],
        ),
      ),
    );

    try {
      final saved = await ExportUtils.exportCarouselToGallery(
        pages: carousel.pages,
        aspectRatio: carousel.aspectRatio,
      );

      if (!context.mounted) return;
      Navigator.of(context).pop();

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            saved == carousel.pages.length
                ? l10n.allPagesSaved
                : l10n.pagesSavedOf(saved, carousel.pages.length),
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.exportFailed(e.toString()))),
      );
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
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
            SnackBar(content: Text(l10n.pageCreatedTapAgain)),
          );
        }
      }
    } catch (e, stackTrace) {
      Logger.logError('Failed to pick image', context: 'CarouselCanvasPage', stackTrace: stackTrace);
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.errorAddingImage(e.toString()))),
        );
      }
    }
  }

  void _confirmDeleteCarousel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteCarouselConfirm),
        content: Text(l10n.actionCannotBeUndone),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
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
            child: Text(l10n.delete),
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
