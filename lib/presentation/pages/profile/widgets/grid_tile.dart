import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../data/models/carousel_model.dart';

class PostGridTile extends StatelessWidget {
  const PostGridTile({
    super.key,
    required this.carousel,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
  });

  final CarouselModel carousel;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstPage =
        carousel.pages.isNotEmpty ? carousel.pages.first : null;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Colors.blue
                : theme.colorScheme.surface,
            width: isSelected ? 3 : 0.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: firstPage != null && firstPage.items.isNotEmpty
            ? _buildPagePreview(firstPage, theme)
            : _placeholder(theme),
      ),
    );
  }

  Widget _buildPagePreview(PageModel page, ThemeData theme) {
    final items = List<CanvasItemModel>.from(page.items)
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        return Stack(
          children: items.map((item) {
            return Positioned(
              left: item.positionX * size.width,
              top: item.positionY * size.height,
              width: item.width * size.width,
              height: item.height * size.height,
              child: Image.file(
                File(item.filePath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _placeholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.broken_image_outlined,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
      ),
    );
  }
}
