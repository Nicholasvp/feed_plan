import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/carousel_model.dart';
import '../../../bloc/carousel_editor/carousel_editor_bloc.dart';
import '../../../bloc/carousel_editor/carousel_editor_event.dart';

class PageThumbnailBar extends StatefulWidget {
  const PageThumbnailBar({
    super.key,
    required this.pages,
    required this.pageController,
    required this.carouselId,
  });

  final List<PageModel> pages;
  final PageController pageController;
  final String carouselId;

  @override
  State<PageThumbnailBar> createState() => _PageThumbnailBarState();
}

class _PageThumbnailBarState extends State<PageThumbnailBar> {
  int? _draggingIndex;
  int? _hoverIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.pages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final page = widget.pages[index];
          final firstItem = page.items.isNotEmpty ? page.items.first : null;
          final isHover = _hoverIndex == index && _draggingIndex != null && _draggingIndex != index;

          return LongPressDraggable<int>(
            delay: const Duration(milliseconds: 150),
            data: index,
            onDragStarted: () {
              setState(() => _draggingIndex = index);
            },
            onDragEnd: (_) {
              setState(() {
                _draggingIndex = null;
                _hoverIndex = null;
              });
            },
            feedback: Material(
              color: Colors.transparent,
              child: _buildThumbnail(
                context: context,
                page: page,
                firstItem: firstItem,
                index: index,
                isDragging: true,
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: _buildThumbnail(
                context: context,
                page: page,
                firstItem: firstItem,
                index: index,
                isDragging: false,
              ),
            ),
            child: DragTarget<int>(
              onWillAcceptWithDetails: (details) {
                setState(() => _hoverIndex = index);
                return details.data != index;
              },
              onLeave: (_) {
                setState(() => _hoverIndex = null);
              },
              onAcceptWithDetails: (details) {
                final oldIndex = details.data;
                final newIndex = index;
                setState(() {
                  _draggingIndex = null;
                  _hoverIndex = null;
                });
                context.read<CarouselEditorBloc>().add(ReorderPages(
                      oldIndex: oldIndex,
                      newIndex: newIndex,
                    ));
              },
              builder: (context, candidateData, rejectedData) {
                return GestureDetector(
                  onTap: () => widget.pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: _buildThumbnail(
                    context: context,
                    page: page,
                    firstItem: firstItem,
                    index: index,
                    isDragging: false,
                    isHover: isHover,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildThumbnail({
    required BuildContext context,
    required PageModel page,
    required CanvasItemModel? firstItem,
    required int index,
    required bool isDragging,
    bool isHover = false,
  }) {
    final theme = Theme.of(context);
    final borderColor = isHover
        ? theme.colorScheme.primary
        : theme.colorScheme.outlineVariant;

    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: borderColor,
              width: isHover ? 2 : 1,
            ),
          ),
          child: firstItem != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.file(
                    File(firstItem.filePath),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _emptyThumbnail(),
                  ),
                )
              : _emptyThumbnail(),
        ),
        Positioned(
          left: 2,
          bottom: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          right: -4,
          top: -4,
          child: GestureDetector(
            onTap: () {
              context
                  .read<CarouselEditorBloc>()
                  .add(RemovePage(page.id));
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _emptyThumbnail() {
    return const Icon(Icons.auto_stories, size: 20, color: Colors.grey);
  }
}
