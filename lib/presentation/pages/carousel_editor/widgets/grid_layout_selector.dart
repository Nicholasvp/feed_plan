import 'package:flutter/material.dart';

import '../../../../core/constants/grid_layouts.dart';
import '../../../../l10n/generated/app_localizations.dart';

class GridLayoutSelector extends StatelessWidget {
  const GridLayoutSelector({super.key, required this.onSelected});

  final void Function(String layoutId) onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.chooseGridLayout,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: GridLayout.all.map((layout) {
              return _GridLayoutOption(
                layout: layout,
                onTap: () {
                  Navigator.of(context).pop();
                  onSelected(layout.id);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _GridLayoutOption extends StatelessWidget {
  const _GridLayoutOption({
    required this.layout,
    required this.onTap,
  });

  final GridLayout layout;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          children: [
            SizedBox(
              width: 74,
              height: 74,
              child: CustomPaint(
                painter: _LayoutPreviewPainter(
                  cells: layout.cells,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              layout.name,
              style: theme.textTheme.labelSmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _LayoutPreviewPainter extends CustomPainter {
  _LayoutPreviewPainter({
    required this.cells,
    required this.color,
  });

  final List<GridCell> cells;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (final cell in cells) {
      final rect = Rect.fromLTWH(
        cell.positionX * size.width,
        cell.positionY * size.height,
        cell.width * size.width,
        cell.height * size.height,
      );
      canvas.drawRect(rect, paint);
      canvas.drawRect(rect, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
