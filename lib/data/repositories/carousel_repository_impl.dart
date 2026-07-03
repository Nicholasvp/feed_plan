import 'dart:io';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/enums/media_type.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';
import '../database/app_database.dart';
import '../models/carousel_model.dart';
import '../../domain/repositories/carousel_repository.dart';

class CarouselRepositoryImpl implements CarouselRepository {
  CarouselRepositoryImpl(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  @override
  Future<CarouselModel> createCarousel(CarouselModel carousel) async {
    try {
      final id = carousel.id.isEmpty ? _uuid.v4() : carousel.id;
      final now = DateTime.now();
      final entity = carousel.copyWith(id: id, createdAt: now, updatedAt: now);

      await _db.into(_db.carousels).insert(CarouselsCompanion(
            id: Value(entity.id),
            profileId: Value(entity.profileId),
            order: Value(entity.order),
            aspectRatio: Value(entity.aspectRatio),
            createdAt: Value(entity.createdAt),
            updatedAt: Value(entity.updatedAt),
          ));

      return entity;
    } catch (e) {
      throw DatabaseException('Failed to create carousel: $e');
    }
  }

  @override
  Future<CarouselModel?> getCarousel(String id) async {
    try {
      final row = await (_db.select(_db.carousels)
            ..where((c) => c.id.equals(id)))
          .getSingleOrNull();

      if (row == null) return null;

      final pages = await getPages(id);

      return CarouselModel(
        id: row.id,
        profileId: row.profileId,
        order: row.order,
        aspectRatio: row.aspectRatio,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        pages: pages,
      );
    } catch (e) {
      throw DatabaseException('Failed to get carousel: $e');
    }
  }

  @override
  Future<List<CarouselModel>> getCarouselsByProfile(String profileId) async {
    try {
      final rows = await (_db.select(_db.carousels)
            ..where((c) => c.profileId.equals(profileId))
            ..orderBy([(c) => OrderingTerm(expression: c.order)]))
          .get();

      final carousels = <CarouselModel>[];
      for (final row in rows) {
        final pages = await getPages(row.id);
        carousels.add(CarouselModel(
          id: row.id,
          profileId: row.profileId,
          order: row.order,
          aspectRatio: row.aspectRatio,
          createdAt: row.createdAt,
          updatedAt: row.updatedAt,
          pages: pages,
        ));
      }

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

      await (_db.update(_db.carousels)
            ..where((c) => c.id.equals(carousel.id)))
          .write(CarouselsCompanion(
            order: Value(updated.order),
            aspectRatio: Value(updated.aspectRatio),
            updatedAt: Value(updated.updatedAt),
          ));

      return updated;
    } catch (e) {
      throw DatabaseException('Failed to update carousel: $e');
    }
  }

  @override
  Future<void> deleteCarousel(String id) async {
    try {
      final pages = await (_db.select(_db.pages)
            ..where((p) => p.carouselId.equals(id)))
          .get();
      for (final page in pages) {
        final items = await (_db.select(_db.canvasItems)
              ..where((c) => c.pageId.equals(page.id)))
            .get();
        for (final item in items) {
          _deleteFile(item.filePath);
        }
      }
      await (_db.delete(_db.canvasItems)
            ..where((c) => c.pageId.isIn(pages.map((p) => p.id))))
          .go();
      await (_db.delete(_db.pages)..where((p) => p.carouselId.equals(id))).go();
      await (_db.delete(_db.carousels)..where((c) => c.id.equals(id))).go();
    } catch (e) {
      throw DatabaseException('Failed to delete carousel: $e');
    }
  }

  // --- Pages ---

  @override
  Future<PageModel> createPage(PageModel page) async {
    try {
      final id = page.id.isEmpty ? _uuid.v4() : page.id;

      await _db.into(_db.pages).insert(PagesCompanion(
            id: Value(id),
            carouselId: Value(page.carouselId),
            orderIndex: Value(page.orderIndex),
            createdAt: Value(page.createdAt),
          ));

      return page.copyWith(id: id);
    } catch (e) {
      throw DatabaseException('Failed to create page: $e');
    }
  }

  @override
  Future<List<PageModel>> getPages(String carouselId) async {
    try {
      final rows = await (_db.select(_db.pages)
            ..where((p) => p.carouselId.equals(carouselId))
            ..orderBy([(p) => OrderingTerm(expression: p.orderIndex)]))
          .get();

      final pages = <PageModel>[];
      for (final row in rows) {
        final items = await getCanvasItems(row.id);
        pages.add(PageModel(
          id: row.id,
          carouselId: row.carouselId,
          orderIndex: row.orderIndex,
          createdAt: row.createdAt,
          items: items,
        ));
      }

      return pages;
    } catch (e) {
      throw DatabaseException('Failed to get pages: $e');
    }
  }

  @override
  Future<void> deletePage(String id) async {
    try {
      final items = await (_db.select(_db.canvasItems)
            ..where((c) => c.pageId.equals(id)))
          .get();
      for (final item in items) {
        _deleteFile(item.filePath);
      }
      await (_db.delete(_db.canvasItems)..where((c) => c.pageId.equals(id))).go();
      await (_db.delete(_db.pages)..where((p) => p.id.equals(id))).go();
    } catch (e) {
      throw DatabaseException('Failed to delete page: $e');
    }
  }

  @override
  Future<void> reorderPages(String carouselId, List<String> pageIds) async {
    try {
      for (var i = 0; i < pageIds.length; i++) {
        await (_db.update(_db.pages)..where((p) => p.id.equals(pageIds[i])))
            .write(PagesCompanion(orderIndex: Value(i)));
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

      await _db.into(_db.canvasItems).insert(CanvasItemsCompanion(
            id: Value(id),
            pageId: Value(item.pageId),
            filePath: Value(item.filePath),
            mediaType: Value(item.mediaType.name),
            positionX: Value(item.positionX),
            positionY: Value(item.positionY),
            width: Value(item.width),
            height: Value(item.height),
            rotation: Value(item.rotation),
            zIndex: Value(item.zIndex),
            spanToNextPage: Value(item.spanToNextPage),
            cropRect: Value(item.cropRect),
            createdAt: Value(item.createdAt),
          ));

      return item.copyWith(id: id);
    } catch (e) {
      throw DatabaseException('Failed to add canvas item: $e');
    }
  }

  @override
  Future<List<CanvasItemModel>> getCanvasItems(String pageId) async {
    try {
      final rows = await (_db.select(_db.canvasItems)
            ..where((c) => c.pageId.equals(pageId))
            ..orderBy([(c) => OrderingTerm(expression: c.zIndex)]))
          .get();

      return rows
          .map((row) => CanvasItemModel(
                id: row.id,
                pageId: row.pageId,
                filePath: row.filePath,
                mediaType:
                    row.mediaType == 'video' ? MediaType.video : MediaType.image,
                positionX: row.positionX,
                positionY: row.positionY,
                width: row.width,
                height: row.height,
                rotation: row.rotation,
                zIndex: row.zIndex,
                spanToNextPage: row.spanToNextPage,
                cropRect: row.cropRect,
                createdAt: row.createdAt,
              ))
          .toList();
    } catch (e) {
      throw DatabaseException('Failed to get canvas items: $e');
    }
  }

  @override
  Future<CanvasItemModel> updateCanvasItem(CanvasItemModel item) async {
    try {
      await (_db.update(_db.canvasItems)
            ..where((c) => c.id.equals(item.id)))
          .write(CanvasItemsCompanion(
            positionX: Value(item.positionX),
            positionY: Value(item.positionY),
            width: Value(item.width),
            height: Value(item.height),
            rotation: Value(item.rotation),
            zIndex: Value(item.zIndex),
            spanToNextPage: Value(item.spanToNextPage),
            cropRect: Value(item.cropRect),
          ));

      return item;
    } catch (e) {
      throw DatabaseException('Failed to update canvas item: $e');
    }
  }

  @override
  Future<void> deleteCanvasItem(String id) async {
    try {
      final rows = await (_db.select(_db.canvasItems)
            ..where((c) => c.id.equals(id)))
          .get();
      if (rows.isNotEmpty) {
        _deleteFile(rows.first.filePath);
      }
      await (_db.delete(_db.canvasItems)..where((c) => c.id.equals(id))).go();
    } catch (e) {
      throw DatabaseException('Failed to delete canvas item: $e');
    }
  }

  void _deleteFile(String path) {
    try {
      final file = File(path);
      if (file.existsSync()) {
        file.deleteSync();
        Logger.logInfo('Deleted file: $path', context: 'CarouselRepository');
      }
    } catch (e) {
      Logger.logError('Failed to delete file: $path', context: 'CarouselRepository');
    }
  }
}
