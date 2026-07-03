import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/carousel_model.dart';
import '../../bloc/carousel_editor/carousel_editor_bloc.dart';
import '../../bloc/carousel_editor/carousel_editor_event.dart';
import '../../bloc/carousel_editor/carousel_editor_state.dart';
import '../../bloc/carousel_list/carousel_list_bloc.dart' as list_bloc;
import '../../bloc/carousel_list/carousel_list_event.dart' as list_events;

class CarouselViewerPage extends StatefulWidget {
  const CarouselViewerPage({super.key, required this.carouselId});

  final String carouselId;

  @override
  State<CarouselViewerPage> createState() => _CarouselViewerPageState();
}

class _CarouselViewerPageState extends State<CarouselViewerPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context
        .read<CarouselEditorBloc>()
        .add(LoadCarousel(widget.carouselId));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Carousel'),
        actions: [
          BlocBuilder<CarouselEditorBloc, CarouselEditorState>(
            builder: (context, state) {
              if (state is CarouselEditorLoaded) {
                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    context.push('/carousel-editor/${state.carousel.id}');
                  },
                );
              }
              return const SizedBox.shrink();
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
            if (carousel.pages.isEmpty) {
              return _emptyState(context, carousel.id);
            }

            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: carousel.pages.length,
                          onPageChanged: (index) {
                            setState(() => _currentPage = index);
                          },
                          itemBuilder: (context, index) {
                            final page = carousel.pages[index];
                            final hasNextPage =
                                index < carousel.pages.length - 1;
                            final nextPage =
                                hasNextPage ? carousel.pages[index + 1] : null;
                            return _ViewerPage(
                              page: page,
                              nextPage: nextPage,
                              hasNextPage: hasNextPage,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                if (carousel.pages.length > 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: _PageIndicator(
                      currentPage: _currentPage,
                      totalPages: carousel.pages.length,
                    ),
                  ),
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
          Icon(
            Icons.auto_stories,
            size: 72,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant
                .withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          const Text('No pages in this carousel'),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {
                  context.read<CarouselEditorBloc>().add(DeleteCarousel());
                  context.read<list_bloc.CarouselListBloc>().add(list_events.DeleteCarousel(carouselId));
                  context.pop();
                },
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.currentPage,
    required this.totalPages,
  });

  final int currentPage;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 8 : 6,
          height: isActive ? 8 : 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        );
      }),
    );
  }
}

class _ViewerPage extends StatelessWidget {
  const _ViewerPage({
    required this.page,
    this.nextPage,
    required this.hasNextPage,
  });

  final PageModel page;
  final PageModel? nextPage;
  final bool hasNextPage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasWidth = constraints.maxWidth;
        final canvasHeight = constraints.maxHeight;

        return Stack(
          children: [
            Container(color: Theme.of(context).colorScheme.surfaceContainerHighest),
            ...page.items.map((item) => _ViewerItem(
                  item: item,
                  canvasWidth: canvasWidth,
                  canvasHeight: canvasHeight,
                )),
            if (hasNextPage)
              ..._spanningItems(nextPage, canvasWidth, canvasHeight),
          ],
        );
      },
    );
  }

  List<Widget> _spanningItems(
    PageModel? nextPage,
    double canvasWidth,
    double canvasHeight,
  ) {
    if (nextPage == null) return [];
    return nextPage.items
        .where((item) => item.spanToNextPage)
        .map((item) => Positioned(
              left: item.positionX * canvasWidth,
              top: 0,
              child: ClipRect(
                clipper: _TopHalfClipper(),
                child: Image.file(
                  File(item.filePath),
                  width: item.width * canvasWidth,
                  height: item.height * canvasHeight,
                  fit: BoxFit.cover,
                ),
              ),
            ))
        .toList();
  }
}

class _ViewerItem extends StatelessWidget {
  const _ViewerItem({
    required this.item,
    required this.canvasWidth,
    required this.canvasHeight,
  });

  final CanvasItemModel item;
  final double canvasWidth;
  final double canvasHeight;

  @override
  Widget build(BuildContext context) {
    final x = item.positionX * canvasWidth;
    final y = item.positionY * canvasHeight;
    final w = item.width * canvasWidth;
    final h = item.height * canvasHeight;

    return Positioned(
      left: x,
      top: y,
      child: SizedBox(
        width: w,
        height: h,
        child: Image.file(
          File(item.filePath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey.shade300,
            child: const Icon(Icons.broken_image),
          ),
        ),
      ),
    );
  }
}

class _TopHalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, size.height * 0.5, size.width, size.height * 0.5);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}
