import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/carousel_model.dart';
import '../../../bloc/carousel_editor/carousel_editor_bloc.dart';
import '../../../bloc/carousel_editor/carousel_editor_event.dart';

class CanvasPageView extends StatelessWidget {
  const CanvasPageView({
    super.key,
    required this.pages,
    required this.pageController,
    this.selectedItemId,
    this.onLockedItemTap,
  });

  final List<PageModel> pages;
  final PageController pageController;
  final String? selectedItemId;
  final void Function(String itemId)? onLockedItemTap;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return _PageCanvas(
          page: pages[index],
          pageIndex: index,
          allPages: pages,
          selectedItemId: selectedItemId,
          onLockedItemTap: onLockedItemTap,
        );
      },
    );
  }
}

class _PageCanvas extends StatelessWidget {
  const _PageCanvas({
    required this.page,
    required this.pageIndex,
    required this.allPages,
    this.selectedItemId,
    this.onLockedItemTap,
  });

  final PageModel page;
  final int pageIndex;
  final List<PageModel> allPages;
  final String? selectedItemId;
  final void Function(String itemId)? onLockedItemTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasWidth = constraints.maxWidth - 16;
        final canvasHeight = canvasWidth * 1.2;

        final renderedItems = <Widget>[];
        for (var pi = 0; pi < allPages.length; pi++) {
          for (final item in allPages[pi].items) {
            final visualLeft =
                (pi - pageIndex + item.positionX) * canvasWidth;
            final visualRight =
                visualLeft + item.width * canvasWidth;
            if (visualRight <= 0 || visualLeft >= canvasWidth) continue;

            if (item.isLocked) {
              renderedItems.add(_LockedCanvasItem(
                item: item,
                canvasWidth: canvasWidth,
                canvasHeight: canvasHeight,
                isSelected: item.id == selectedItemId,
                onTap: onLockedItemTap,
              ));
            } else {
              renderedItems.add(_DraggableCanvasItem(
                item: item,
                canvasWidth: canvasWidth,
                canvasHeight: canvasHeight,
                isSelected: item.id == selectedItemId,
                owningPageIndex: pi,
                currentPageIndex: pageIndex,
              ));
            }
          }
        }

        return Center(
          child: Container(
            width: canvasWidth,
            height: canvasHeight,
            margin: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRect(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(canvasWidth, canvasHeight),
                    painter: _GridPainter(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  ...renderedItems,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LockedCanvasItem extends StatelessWidget {
  const _LockedCanvasItem({
    required this.item,
    required this.canvasWidth,
    required this.canvasHeight,
    this.isSelected = false,
    this.onTap,
  });

  final CanvasItemModel item;
  final double canvasWidth;
  final double canvasHeight;
  final bool isSelected;
  final void Function(String itemId)? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemW = item.width * canvasWidth;
    final itemH = item.height * canvasHeight;
    final hasImage = item.filePath.isNotEmpty;

    return Positioned(
      left: item.positionX * canvasWidth,
      top: item.positionY * canvasHeight,
      child: GestureDetector(
        onTap: hasImage ? null : () => onTap?.call(item.id),
        child: Container(
          width: itemW,
          height: itemH,
          decoration: BoxDecoration(
            color: hasImage ? null : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            border: Border.all(
              color: hasImage
                  ? (isSelected ? theme.colorScheme.primary : Colors.transparent)
                  : theme.colorScheme.outlineVariant,
              width: hasImage ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: hasImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: [
                      Image.file(
                        File(item.filePath),
                        fit: BoxFit.cover,
                        width: itemW,
                        height: itemH,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.broken_image, size: 24),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Icon(
                          Icons.lock_outline,
                          size: 14,
                          color: Colors.white.withValues(alpha: 0.8),
                          shadows: const [Shadow(blurRadius: 2, color: Colors.black45)],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 28,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to add',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _DraggableCanvasItem extends StatefulWidget {
  const _DraggableCanvasItem({
    required this.item,
    required this.canvasWidth,
    required this.canvasHeight,
    this.isSelected = false,
    required this.owningPageIndex,
    required this.currentPageIndex,
  });

  final CanvasItemModel item;
  final double canvasWidth;
  final double canvasHeight;
  final bool isSelected;
  final int owningPageIndex;
  final int currentPageIndex;

  @override
  State<_DraggableCanvasItem> createState() => _DraggableCanvasItemState();
}

class _DraggableCanvasItemState extends State<_DraggableCanvasItem> {
  late double _x;
  late double _y;

  int get _pageOffset => widget.currentPageIndex - widget.owningPageIndex;

  @override
  void initState() {
    super.initState();
    _x = (widget.item.positionX - _pageOffset) * widget.canvasWidth;
    _y = widget.item.positionY * widget.canvasHeight;
  }

  @override
  void didUpdateWidget(_DraggableCanvasItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id ||
        oldWidget.item.positionX != widget.item.positionX ||
        oldWidget.item.positionY != widget.item.positionY ||
        oldWidget.owningPageIndex != widget.owningPageIndex ||
        oldWidget.currentPageIndex != widget.currentPageIndex) {
      _x = (widget.item.positionX - _pageOffset) * widget.canvasWidth;
      _y = widget.item.positionY * widget.canvasHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemW = widget.item.width * widget.canvasWidth;
    final itemH = widget.item.height * widget.canvasHeight;

    return Positioned(
      left: _x,
      top: _y,
      child: GestureDetector(
        onTap: () {
          context
              .read<CarouselEditorBloc>()
              .add(SelectItem(widget.item.id));
        },
        onPanUpdate: (details) {
          final newX = _x + details.delta.dx;
          final newY = _y + details.delta.dy;

          setState(() {
            _x = newX;
            _y = newY;
          });
          context.read<CarouselEditorBloc>().add(MoveItem(
                itemId: widget.item.id,
                positionX: _x / widget.canvasWidth + _pageOffset,
                positionY: _y / widget.canvasHeight,
              ));
        },
        child: Container(
          width: itemW,
          height: itemH,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.file(
              File(widget.item.filePath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image, size: 32),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    for (var x = 0.0; x < size.width; x += size.width / 3) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += size.height / 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
