import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/enums/media_type.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';
import '../../domain/repositories/carousel_repository.dart';
import '../models/carousel_model.dart';

class CarouselRepositoryImpl implements CarouselRepository {
  CarouselRepositoryImpl({
    required Box carouselsBox,
    required Box pagesBox,
    required Box canvasItemsBox,
  })  : _carouselsBox = carouselsBox,
        _pagesBox = pagesBox,
        _canvasItemsBox = canvasItemsBox;

  final Box _carouselsBox;
  final Box _pagesBox;
  final Box _canvasItemsBox;
  final _uuid = const Uuid();

  Map<String, dynamic> _castMap(Map data) {
    return Map<String, dynamic>.from(data);
  }

  // --- Carousel ---

  @override
  Future<CarouselModel> createCarousel(CarouselModel carousel) async {
    try {
      final id = carousel.id.isEmpty ? _uuid.v4() : carousel.id;
      final now = DateTime.now();
      final entity = carousel.copyWith(id: id, createdAt: now, updatedAt: now);

      await _carouselsBox.put(id, {
        'id': entity.id,
        'profileId': entity.profileId,
        'order': entity.order,
        'aspectRatio': entity.aspectRatio,
        'createdAt': entity.createdAt.millisecondsSinceEpoch,
        'updatedAt': entity.updatedAt.millisecondsSinceEpoch,
        'pageIds': <String>[],
      });

      return entity;
    } catch (e) {
      throw DatabaseException('Failed to create carousel: $e');
    }
  }

  @override
  Future<CarouselModel?> getCarousel(String id) async {
    try {
      final raw = _carouselsBox.get(id);
      if (raw == null) return null;
      final data = _castMap(raw);

      final pages = _getPagesForCarousel(id);

      return CarouselModel(
        id: data['id'] as String,
        profileId: data['profileId'] as String,
        order: data['order'] as int,
        aspectRatio: data['aspectRatio'] as String? ?? '1:1',
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int),
        updatedAt:
            DateTime.fromMillisecondsSinceEpoch(data['updatedAt'] as int),
        pages: pages,
      );
    } catch (e) {
      throw DatabaseException('Failed to get carousel: $e');
    }
  }

  @override
  Future<List<CarouselModel>> getCarouselsByProfile(String profileId) async {
    try {
      final carousels = <CarouselModel>[];
      for (final raw in _carouselsBox.values) {
        final data = _castMap(raw);
        if (data['profileId'] == profileId) {
          final id = data['id'] as String;
          final pages = _getPagesForCarousel(id);
          carousels.add(CarouselModel(
            id: id,
            profileId: profileId,
            order: data['order'] as int,
            aspectRatio: data['aspectRatio'] as String? ?? '1:1',
            createdAt:
                DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int),
            updatedAt:
                DateTime.fromMillisecondsSinceEpoch(data['updatedAt'] as int),
            pages: pages,
          ));
        }
      }
      carousels.sort((a, b) => a.order.compareTo(b.order));
      return carousels;
    } catch (e) {
      throw DatabaseException('Failed to get carousels: $e');
    }
  }

  @override
  Future<CarouselModel> updateCarousel(CarouselModel carousel) async {
    try {
      final now = DateTime.now();
      final updated = carousel.copyWith(updatedAt: now);
      final raw = _carouselsBox.get(updated.id);
      if (raw == null) {
        throw const DatabaseException('Carousel not found');
      }
      final data = _castMap(raw);

      data['order'] = updated.order;
      data['aspectRatio'] = updated.aspectRatio;
      data['updatedAt'] = updated.updatedAt.millisecondsSinceEpoch;

      await _carouselsBox.put(updated.id, data);
      return updated;
    } catch (e) {
      throw DatabaseException('Failed to update carousel: $e');
    }
  }

  @override
  Future<void> deleteCarousel(String id) async {
    try {
      final raw = _carouselsBox.get(id);
      if (raw == null) return;
      final data = _castMap(raw);

      final pageIds =
          (data['pageIds'] as List?)?.cast<String>() ?? <String>[];
      for (final pageId in pageIds) {
        await _deletePageData(pageId);
      }
      await _carouselsBox.delete(id);
    } catch (e) {
      throw DatabaseException('Failed to delete carousel: $e');
    }
  }

  // --- Pages ---

  @override
  Future<PageModel> createPage(PageModel page) async {
    try {
      final id = page.id.isEmpty ? _uuid.v4() : page.id;

      await _pagesBox.put(id, {
        'id': id,
        'carouselId': page.carouselId,
        'orderIndex': page.orderIndex,
        'createdAt': page.createdAt.millisecondsSinceEpoch,
        'itemIds': <String>[],
      });

      final raw = _carouselsBox.get(page.carouselId);
      if (raw != null) {
        final data = _castMap(raw);
        final pageIds =
            (data['pageIds'] as List?)?.cast<String>() ?? <String>[];
        pageIds.add(id);
        data['pageIds'] = pageIds;
        await _carouselsBox.put(page.carouselId, data);
      }

      return page.copyWith(id: id);
    } catch (e) {
      throw DatabaseException('Failed to create page: $e');
    }
  }

  @override
  Future<List<PageModel>> getPages(String carouselId) async {
    try {
      return _getPagesForCarousel(carouselId);
    } catch (e) {
      throw DatabaseException('Failed to get pages: $e');
    }
  }

  Future<void> _deletePageData(String pageId) async {
    final raw = _pagesBox.get(pageId);
    if (raw == null) return;
    final data = _castMap(raw);

    final itemIds =
        (data['itemIds'] as List?)?.cast<String>() ?? <String>[];
    for (final itemId in itemIds) {
      await _deleteCanvasItemData(itemId);
    }
    await _pagesBox.delete(pageId);
  }

  @override
  Future<void> deletePage(String id) async {
    try {
      final pageRaw = _pagesBox.get(id);
      if (pageRaw == null) return;
      final pageData = _castMap(pageRaw);

      final carouselId = pageData['carouselId'] as String;
      await _deletePageData(id);

      final carouselRaw = _carouselsBox.get(carouselId);
      if (carouselRaw != null) {
        final carouselData = _castMap(carouselRaw);
        final pageIds =
            (carouselData['pageIds'] as List?)?.cast<String>() ?? <String>[];
        pageIds.remove(id);
        carouselData['pageIds'] = pageIds;
        await _carouselsBox.put(carouselId, carouselData);
      }
    } catch (e) {
      throw DatabaseException('Failed to delete page: $e');
    }
  }

  @override
  Future<void> reorderPages(String carouselId, List<String> pageIds) async {
    try {
      for (var i = 0; i < pageIds.length; i++) {
        final raw = _pagesBox.get(pageIds[i]);
        if (raw != null) {
          final data = _castMap(raw);
          data['orderIndex'] = i;
          await _pagesBox.put(pageIds[i], data);
        }
      }
    } catch (e) {
      throw DatabaseException('Failed to reorder pages: $e');
    }
  }

  // --- Canvas Items ---

  @override
  Future<CanvasItemModel> addCanvasItem(CanvasItemModel item) async {
    try {
      final id = item.id.isEmpty ? _uuid.v4() : item.id;

      await _canvasItemsBox.put(id, {
        'id': id,
        'pageId': item.pageId,
        'filePath': item.filePath,
        'mediaType': item.mediaType.name,
        'positionX': item.positionX,
        'positionY': item.positionY,
        'width': item.width,
        'height': item.height,
        'rotation': item.rotation,
        'zIndex': item.zIndex,
        'spanToNextPage': item.spanToNextPage,
        'isLocked': item.isLocked,
        'cropRect': item.cropRect,
        'createdAt': item.createdAt.millisecondsSinceEpoch,
      });

      final raw = _pagesBox.get(item.pageId);
      if (raw != null) {
        final data = _castMap(raw);
        final itemIds =
            (data['itemIds'] as List?)?.cast<String>() ?? <String>[];
        itemIds.add(id);
        data['itemIds'] = itemIds;
        await _pagesBox.put(item.pageId, data);
      }

      return item.copyWith(id: id);
    } catch (e) {
      throw DatabaseException('Failed to add canvas item: $e');
    }
  }

  @override
  Future<List<CanvasItemModel>> getCanvasItems(String pageId) async {
    try {
      return _getCanvasItemsForPage(pageId);
    } catch (e) {
      throw DatabaseException('Failed to get canvas items: $e');
    }
  }

  @override
  Future<CanvasItemModel> updateCanvasItem(CanvasItemModel item) async {
    try {
      final raw = _canvasItemsBox.get(item.id);
      if (raw == null) {
        throw const DatabaseException('Canvas item not found');
      }
      final data = _castMap(raw);

      data['filePath'] = item.filePath;
      data['positionX'] = item.positionX;
      data['positionY'] = item.positionY;
      data['width'] = item.width;
      data['height'] = item.height;
      data['rotation'] = item.rotation;
      data['zIndex'] = item.zIndex;
      data['spanToNextPage'] = item.spanToNextPage;
      data['isLocked'] = item.isLocked;
      data['cropRect'] = item.cropRect;

      await _canvasItemsBox.put(item.id, data);
      return item;
    } catch (e) {
      throw DatabaseException('Failed to update canvas item: $e');
    }
  }

  Future<void> _deleteCanvasItemData(String id) async {
    final raw = _canvasItemsBox.get(id);
    if (raw != null) {
      final data = _castMap(raw);
      _deleteFile(data['filePath'] as String? ?? '');
    }
    await _canvasItemsBox.delete(id);
  }

  @override
  Future<void> deleteCanvasItem(String id) async {
    try {
      final raw = _canvasItemsBox.get(id);
      if (raw == null) return;

      final data = _castMap(raw);
      final pageId = data['pageId'] as String;
      await _deleteCanvasItemData(id);

      final pageRaw = _pagesBox.get(pageId);
      if (pageRaw != null) {
        final pageData = _castMap(pageRaw);
        final itemIds =
            (pageData['itemIds'] as List?)?.cast<String>() ?? <String>[];
        itemIds.remove(id);
        pageData['itemIds'] = itemIds;
        await _pagesBox.put(pageId, pageData);
      }
    } catch (e) {
      throw DatabaseException('Failed to delete canvas item: $e');
    }
  }

  // --- Helpers ---

  List<CanvasItemModel> _getCanvasItemsForPage(String pageId) {
    return _canvasItemsBox.values
        .where((item) => item['pageId'] == pageId)
        .map((raw) => _mapToCanvasItem(_castMap(raw)))
        .toList()
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));
  }

  List<PageModel> _getPagesForCarousel(String carouselId) {
    final raw = _carouselsBox.get(carouselId);
    if (raw == null) return <PageModel>[];
    final carouselData = _castMap(raw);

    final pageIds =
        (carouselData['pageIds'] as List?)?.cast<String>() ?? <String>[];
    return pageIds
        .map((pageId) {
          final pageRaw = _pagesBox.get(pageId);
          if (pageRaw == null) return null;
          final pageData = _castMap(pageRaw);
          final items = _getCanvasItemsForPage(pageId);
          return _mapToPage(pageData, items);
        })
        .whereType<PageModel>()
        .toList()
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  }

  CanvasItemModel _mapToCanvasItem(Map<String, dynamic> data) {
    return CanvasItemModel(
      id: data['id'] as String,
      pageId: data['pageId'] as String,
      filePath: data['filePath'] as String,
      mediaType:
          data['mediaType'] == 'video' ? MediaType.video : MediaType.image,
      positionX: (data['positionX'] as num).toDouble(),
      positionY: (data['positionY'] as num).toDouble(),
      width: (data['width'] as num).toDouble(),
      height: (data['height'] as num).toDouble(),
      rotation: (data['rotation'] as num?)?.toDouble() ?? 0.0,
      zIndex: data['zIndex'] as int? ?? 0,
      spanToNextPage: data['spanToNextPage'] as bool? ?? false,
      isLocked: data['isLocked'] as bool? ?? false,
      cropRect: data['cropRect'] as String?,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int),
    );
  }

  PageModel _mapToPage(
      Map<String, dynamic> data, List<CanvasItemModel> items) {
    return PageModel(
      id: data['id'] as String,
      carouselId: data['carouselId'] as String,
      orderIndex: data['orderIndex'] as int,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int),
      items: items,
    );
  }

  void _deleteFile(String path) {
    if (path.isEmpty) return;
    try {
      final file = File(path);
      if (file.existsSync()) {
        file.deleteSync();
        Logger.logInfo('Deleted file: $path', context: 'CarouselRepository');
      }
    } catch (e) {
      Logger.logError(
          'Failed to delete file: $path', context: 'CarouselRepository');
    }
  }
}
