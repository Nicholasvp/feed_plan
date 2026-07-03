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
        final page = pages[index];
        final hasNextPage = index < pages.length - 1;
        final hasPrevPage = index > 0;
        final nextPage = hasNextPage ? pages[index + 1] : null;
        final prevPage = hasPrevPage ? pages[index - 1] : null;
        return _PageCanvas(
          page: page,
          pageIndex: index,
          totalPages: pages.length,
          nextPage: nextPage,
          prevPage: prevPage,
          hasNextPage: hasNextPage,
          hasPrevPage: hasPrevPage,
          selectedItemId: selectedItemId,
          onLockedItemTap: onLockedItemTap,
        );
      },
    );
  }
}

List<Widget> _spanningItems(
  PageModel? nextPage,
  double canvasWidth,
  double canvasHeight,
) {
  if (nextPage == null) return [];
  return nextPage.items
      .where((item) => item.spanToNextPage && !item.isLocked)
      .map((item) => _SpanOverlayItem(
            item: item,
            canvasWidth: canvasWidth,
            canvasHeight: canvasHeight,
          ))
      .toList();
}

class _PageCanvas extends StatelessWidget {
  const _PageCanvas({
    required this.page,
    required this.pageIndex,
    required this.totalPages,
    this.nextPage,
    this.prevPage,
    required this.hasNextPage,
    required this.hasPrevPage,
    this.selectedItemId,
    this.onLockedItemTap,
  });

  final PageModel page;
  final int pageIndex;
  final int totalPages;
  final PageModel? nextPage;
  final PageModel? prevPage;
  final bool hasNextPage;
  final bool hasPrevPage;
  final String? selectedItemId;
  final void Function(String itemId)? onLockedItemTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canvasWidth = MediaQuery.of(context).size.width - 32;
    final canvasHeight = canvasWidth * 1.2;

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
        clipBehavior: Clip.none,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(canvasWidth, canvasHeight),
              painter: _GridPainter(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            ...page.items.map((item) {
              if (item.isLocked) {
                return _LockedCanvasItem(
                  item: item,
                  canvasWidth: canvasWidth,
                  canvasHeight: canvasHeight,
                  isSelected: item.id == selectedItemId,
                  onTap: onLockedItemTap,
                );
              }
              return _DraggableCanvasItem(
                item: item,
                canvasWidth: canvasWidth,
                canvasHeight: canvasHeight,
                isSelected: item.id == selectedItemId,
                canMoveLeft: hasPrevPage,
                canMoveRight: hasNextPage,
                previousPageId: prevPage?.id,
                nextPageId: nextPage?.id,
              );
            }),
            ..._spanningItems(nextPage, canvasWidth, canvasHeight),
          ],
        ),
      ),
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
    this.canMoveLeft = false,
    this.canMoveRight = false,
    this.previousPageId,
    this.nextPageId,
  });

  final CanvasItemModel item;
  final double canvasWidth;
  final double canvasHeight;
  final bool isSelected;
  final bool canMoveLeft;
  final bool canMoveRight;
  final String? previousPageId;
  final String? nextPageId;

  @override
  State<_DraggableCanvasItem> createState() => _DraggableCanvasItemState();
}

class _DraggableCanvasItemState extends State<_DraggableCanvasItem> {
  late double _x;
  late double _y;
  bool _movedToPage = false;

  @override
  void initState() {
    super.initState();
    _x = widget.item.positionX * widget.canvasWidth;
    _y = widget.item.positionY * widget.canvasHeight;
  }

  @override
  void didUpdateWidget(_DraggableCanvasItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id ||
        oldWidget.item.positionX != widget.item.positionX ||
        oldWidget.item.positionY != widget.item.positionY) {
      _x = widget.item.positionX * widget.canvasWidth;
      _y = widget.item.positionY * widget.canvasHeight;
      _movedToPage = false;
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
        onPanStart: (_) {
          _movedToPage = false;
        },
        onPanUpdate: (details) {
          if (_movedToPage) return;

          final newX = _x + details.delta.dx;
          final newY = _y + details.delta.dy;

          // Drag past right edge → toggle span to next page
          if (newX > widget.canvasWidth - itemW * 0.7 &&
              widget.canMoveRight) {
            _movedToPage = true;
            context
                .read<CarouselEditorBloc>()
                .add(ToggleSpanNextPage(widget.item.id));
            return;
          }

          setState(() {
            _x = newX;
            _y = newY;
          });
          context.read<CarouselEditorBloc>().add(MoveItem(
                itemId: widget.item.id,
                positionX: _x / widget.canvasWidth,
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

class _SpanOverlayItem extends StatelessWidget {
  const _SpanOverlayItem({
    required this.item,
    required this.canvasWidth,
    required this.canvasHeight,
  });

  final CanvasItemModel item;
  final double canvasWidth;
  final double canvasHeight;

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
