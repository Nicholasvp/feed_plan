import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../data/models/feed_item_model.dart';
import '../../../../data/models/carousel_model.dart';

class PostGridTile extends StatelessWidget {
  const PostGridTile({
    super.key,
    required this.item,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
  });

  final FeedItemModel item;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        child: item.isLocal
            ? _buildLocalPreview(theme)
            : _buildNetworkPreview(theme),
      ),
    );
  }

  Widget _buildLocalPreview(ThemeData theme) {
    final carousel = item.carousel;
    if (carousel == null) return _placeholder(theme);

    final firstPage =
        carousel.pages.isNotEmpty ? carousel.pages.first : null;

    if (firstPage == null || firstPage.items.isEmpty) {
      return _placeholder(theme);
    }

    return _buildPagePreview(firstPage, theme);
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

  Widget _buildNetworkPreview(ThemeData theme) {
    return Image.network(
      item.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.broken_image,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
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
