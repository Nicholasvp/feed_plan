import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';

import '../../data/models/carousel_model.dart';
import '../constants/app_constants.dart';
import '../constants/aspect_ratios.dart';
import '../enums/media_type.dart';
import 'logger.dart';

class ExportUtils {
  ExportUtils._();

  static const double _exportLongSide = 1080.0;

  static Size _exportSize(String aspectRatio) {
    final preset = AspectRatioPreset.fromValue(aspectRatio);
    final double w;
    final double h;
    if (preset.width >= preset.height) {
      w = _exportLongSide;
      h = _exportLongSide * preset.height / preset.width;
    } else {
      h = _exportLongSide;
      w = _exportLongSide * preset.width / preset.height;
    }
    return Size(w, h);
  }

  static Future<Uint8List> renderPageAsPng(
    PageModel page,
    double outputWidth,
    double outputHeight,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, outputWidth, outputHeight),
    );

    canvas.drawColor(Colors.white, BlendMode.src);

    final items = List<CanvasItemModel>.from(page.items)
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    for (final item in items) {
      if (item.mediaType != MediaType.image) continue;

      final file = File(item.filePath);
      if (!await file.exists()) continue;

      try {
        final bytes = await file.readAsBytes();
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        final image = frame.image;

        canvas.save();

        final itemX = item.positionX * outputWidth;
        final itemY = item.positionY * outputHeight;
        final itemW = item.width * outputWidth;
        final itemH = item.height * outputHeight;
        final centerX = itemX + itemW / 2;
        final centerY = itemY + itemH / 2;

        canvas.translate(centerX, centerY);
        if (item.rotation != 0) {
          canvas.rotate(item.rotation * math.pi / 180);
        }
        canvas.translate(-centerX, -centerY);

        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          Rect.fromLTWH(itemX, itemY, itemW, itemH),
          Paint()..filterQuality = FilterQuality.high,
        );

        canvas.restore();
      } catch (e) {
        Logger.logError(
          'Failed to render item ${item.id}: $e',
          context: 'ExportUtils',
        );
      }
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(
      outputWidth.toInt(),
      outputHeight.toInt(),
    );
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  static Future<int> exportCarouselToGallery({
    required List<PageModel> pages,
    required String aspectRatio,
    void Function(int completed, int total)? onProgress,
  }) async {
    int savedCount = 0;
    final size = _exportSize(aspectRatio);

    for (int i = 0; i < pages.length; i++) {
      onProgress?.call(i, pages.length);
      try {
        final pngBytes = await renderPageAsPng(
          pages[i],
          size.width,
          size.height,
        );
        final fileName =
            '${AppConstants.exportPrefix}${i.toString().padLeft(2, '0')}';
        await Gal.putImageBytes(pngBytes, name: fileName);
        savedCount++;
      } catch (e) {
        Logger.logError(
          'Failed to export page ${i + 1}: $e',
          context: 'ExportUtils',
        );
      }
    }
    onProgress?.call(pages.length, pages.length);
    return savedCount;
  }
}
