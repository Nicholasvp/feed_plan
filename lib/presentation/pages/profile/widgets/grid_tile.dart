import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../data/models/carousel_model.dart';

class PostGridTile extends StatelessWidget {
  const PostGridTile({
    super.key,
    required this.carousel,
    this.onTap,
  });

  final CarouselModel carousel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstPage =
        carousel.pages.isNotEmpty ? carousel.pages.first : null;
    final firstItem =
        firstPage?.items.isNotEmpty == true ? firstPage!.items.first : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.surface,
            width: 0.5,
          ),
        ),
        child: firstItem != null
            ? Image.file(
                File(firstItem.filePath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _placeholder(theme),
              )
            : _placeholder(theme),
      ),
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
