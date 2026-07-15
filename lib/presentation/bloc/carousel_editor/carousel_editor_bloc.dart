import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/grid_layouts.dart';
import '../../../core/enums/media_type.dart';
import '../../../data/models/carousel_model.dart';
import '../../../data/repositories/carousel_repository_impl.dart';
import 'carousel_editor_event.dart';
import 'carousel_editor_state.dart';

class CarouselEditorBloc
    extends Bloc<CarouselEditorEvent, CarouselEditorState> {
  CarouselEditorBloc(this._repository)
      : super(const CarouselEditorInitial()) {
    on<LoadCarousel>(_onLoadCarousel);
    on<AddPage>(_onAddPage);
    on<RemovePage>(_onRemovePage);
    on<AddImageToPage>(_onAddImageToPage);
    on<MoveItem>(_onMoveItem);
    on<ResizeItem>(_onResizeItem);
    on<SelectItem>(_onSelectItem);
    on<MoveItemToPage>(_onMoveItemToPage);
    on<DeleteItem>(_onDeleteItem);
    on<DeleteCarousel>(_onDeleteCarousel);
    on<SaveCarousel>(_onSaveCarousel);
    on<ReorderPages>(_onReorderPages);
    on<ApplyGridLayout>(_onApplyGridLayout);
    on<ReplaceGridCellImage>(_onReplaceGridCellImage);
    on<ScaleItem>(_onScaleItem);
  }

  final CarouselRepositoryImpl _repository;

  Future<void> _onLoadCarousel(
    LoadCarousel event,
    Emitter<CarouselEditorState> emit,
  ) async {
    emit(const CarouselEditorLoading());
    try {
      final carousel = await _repository.getCarousel(event.carouselId);
      if (carousel != null) {
        emit(CarouselEditorLoaded(carousel: carousel));
      } else {
        emit(const CarouselEditorError('Carousel not found'));
      }
    } catch (e) {
      emit(CarouselEditorError(e.toString()));
    }
  }

  Future<void> _onAddPage(
    AddPage event,
    Emitter<CarouselEditorState> emit,
  ) async {
    if (state is CarouselEditorLoaded) {
      final loaded = state as CarouselEditorLoaded;
      final carousel = loaded.carousel;
      final now = DateTime.now();
      final page = PageModel(
        id: '',
        carouselId: carousel.id,
        orderIndex: carousel.pages.length,
        createdAt: now,
      );

      try {
        final saved = await _repository.createPage(page);
        emit(loaded.copyWith(
          carousel: carousel.copyWith(
            pages: [...carousel.pages, saved],
          ),
        ));
      } catch (e) {
        emit(CarouselEditorError(e.toString()));
      }
    }
  }

  Future<void> _onRemovePage(
    RemovePage event,
    Emitter<CarouselEditorState> emit,
  ) async {
    if (state is CarouselEditorLoaded) {
      final loaded = state as CarouselEditorLoaded;
      final carousel = loaded.carousel;

      try {
        await _repository.deletePage(event.pageId);
        emit(loaded.copyWith(
          carousel: carousel.copyWith(
            pages: carousel.pages.where((p) => p.id != event.pageId).toList(),
          ),
        ));
      } catch (e) {
        emit(CarouselEditorError(e.toString()));
      }
    }
  }

  Future<void> _onAddImageToPage(
    AddImageToPage event,
    Emitter<CarouselEditorState> emit,
  ) async {
    if (state is CarouselEditorLoaded) {
      final loaded = state as CarouselEditorLoaded;
      final carousel = loaded.carousel;
      final pageIdx =
          carousel.pages.indexWhere((p) => p.id == event.pageId);
      if (pageIdx == -1) return;

      final item = CanvasItemModel(
        id: '',
        pageId: event.pageId,
        filePath: event.filePath,
        mediaType: MediaType.image,
        positionX: 0.0,
        positionY: 0.0,
        width: 1.0,
        height: 1.0,
        rotation: 0.0,
        zIndex: carousel.pages[pageIdx].items.length,
        createdAt: DateTime.now(),
      );

      try {
        final saved = await _repository.addCanvasItem(item);
        final updatedPages = [...carousel.pages];
        final updatedItems = [...updatedPages[pageIdx].items, saved];
        updatedPages[pageIdx] =
            updatedPages[pageIdx].copyWith(items: updatedItems);
        emit(loaded.copyWith(carousel: carousel.copyWith(pages: updatedPages)));
      } catch (e) {
        emit(CarouselEditorError(e.toString()));
      }
    }
  }

  Future<void> _onMoveItem(
    MoveItem event,
    Emitter<CarouselEditorState> emit,
  ) async {
    if (state is CarouselEditorLoaded) {
      final loaded = state as CarouselEditorLoaded;
      final carousel = loaded.carousel;

      for (var pi = 0; pi < carousel.pages.length; pi++) {
        final page = carousel.pages[pi];
        final itemIdx = page.items.indexWhere((i) => i.id == event.itemId);
        if (itemIdx != -1) {
          final updated = page.items[itemIdx].copyWith(
            positionX: event.positionX,
            positionY: event.positionY,
          );
          final updatedPages = [...carousel.pages];
          final updatedItems = [...page.items];
          updatedItems[itemIdx] = updated;
          updatedPages[pi] = page.copyWith(items: updatedItems);
          emit(loaded.copyWith(
            carousel: carousel.copyWith(pages: updatedPages),
          ));
          return;
        }
      }
    }
  }

  Future<void> _onResizeItem(
    ResizeItem event,
    Emitter<CarouselEditorState> emit,
  ) async {
    if (state is CarouselEditorLoaded) {
      final loaded = state as CarouselEditorLoaded;
      final carousel = loaded.carousel;

      for (var pi = 0; pi < carousel.pages.length; pi++) {
        final page = carousel.pages[pi];
        final itemIdx = page.items.indexWhere((i) => i.id == event.itemId);
        if (itemIdx != -1) {
          final updated = page.items[itemIdx].copyWith(
            width: event.width,
            height: event.height,
          );
          final updatedPages = [...carousel.pages];
          final updatedItems = [...page.items];
          updatedItems[itemIdx] = updated;
          updatedPages[pi] = page.copyWith(items: updatedItems);
          emit(loaded.copyWith(
            carousel: carousel.copyWith(pages: updatedPages),
          ));
          return;
        }
      }
    }
  }

  void _onSelectItem(
    SelectItem event,
    Emitter<CarouselEditorState> emit,
  ) {
    if (state is CarouselEditorLoaded) {
      final loaded = state as CarouselEditorLoaded;
      emit(loaded.copyWith(
        selectedItemId: event.itemId,
        clearSelection: event.itemId == null,
      ));
    }
  }

  void _onMoveItemToPage(
    MoveItemToPage event,
    Emitter<CarouselEditorState> emit,
  ) {
    if (state is CarouselEditorLoaded) {
      final loaded = state as CarouselEditorLoaded;
      final carousel = loaded.carousel;

      // Find the item in its current page
      CanvasItemModel? movedItem;
      int? sourcePageIndex;

      for (var pi = 0; pi < carousel.pages.length; pi++) {
        final page = carousel.pages[pi];
        final itemIdx = page.items.indexWhere((i) => i.id == event.itemId);
        if (itemIdx != -1) {
          movedItem = page.items[itemIdx];
          sourcePageIndex = pi;
          break;
        }
      }

      if (movedItem == null || sourcePageIndex == null) return;

      // Find target page index
      final targetPageIndex =
          carousel.pages.indexWhere((p) => p.id == event.targetPageId);
      if (targetPageIndex == -1 || targetPageIndex == sourcePageIndex) return;

      final updatedPages = [...carousel.pages];

      // Remove from source page
      final sourceItems = [...updatedPages[sourcePageIndex].items];
      sourceItems.removeWhere((i) => i.id == event.itemId);
      updatedPages[sourcePageIndex] =
          updatedPages[sourcePageIndex].copyWith(items: sourceItems);

      // Add to target page with reset position
      final movedItemOnTarget = movedItem.copyWith(
        pageId: event.targetPageId,
        positionX: 0.0,
        positionY: 0.0,
        zIndex: updatedPages[targetPageIndex].items.length,
      );
      final targetItems = [...updatedPages[targetPageIndex].items, movedItemOnTarget];
      updatedPages[targetPageIndex] =
          updatedPages[targetPageIndex].copyWith(items: targetItems);

      emit(loaded.copyWith(
        carousel: carousel.copyWith(pages: updatedPages),
        clearSelection: true,
      ));
    }
  }

  void _onDeleteItem(
    DeleteItem event,
    Emitter<CarouselEditorState> emit,
  ) {
    if (state is CarouselEditorLoaded) {
      final loaded = state as CarouselEditorLoaded;
      final carousel = loaded.carousel;

      for (var pi = 0; pi < carousel.pages.length; pi++) {
        final page = carousel.pages[pi];
        final itemIdx = page.items.indexWhere((i) => i.id == event.itemId);
        if (itemIdx != -1) {
          final updatedPages = [...carousel.pages];
          final updatedItems = [...page.items];
          updatedItems.removeAt(itemIdx);
          updatedPages[pi] = page.copyWith(items: updatedItems);

          _repository.deleteCanvasItem(event.itemId);

          emit(loaded.copyWith(
            carousel: carousel.copyWith(pages: updatedPages),
            clearSelection: true,
          ));
          return;
        }
      }
    }
  }

  Future<void> _onDeleteCarousel(
    DeleteCarousel event,
    Emitter<CarouselEditorState> emit,
  ) async {
    if (state is CarouselEditorLoaded) {
      final loaded = state as CarouselEditorLoaded;
      try {
        await _repository.deleteCarousel(loaded.carousel.id);
        emit(const CarouselEditorInitial());
      } catch (e) {
        emit(CarouselEditorError(e.toString()));
      }
    }
  }

  void _onReorderPages(
    ReorderPages event,
    Emitter<CarouselEditorState> emit,
  ) {
    if (state is CarouselEditorLoaded) {
      final loaded = state as CarouselEditorLoaded;
      final pages = List<PageModel>.from(loaded.carousel.pages);

      if (event.oldIndex < 0 ||
          event.oldIndex >= pages.length ||
          event.newIndex < 0 ||
          event.newIndex >= pages.length) {
        return;
      }

      final movedPage = pages.removeAt(event.oldIndex);
      pages.insert(event.newIndex, movedPage);

      // Update orderIndex for all pages
      final updatedPages = pages
          .asMap()
          .entries
          .map((e) => e.value.copyWith(orderIndex: e.key))
          .toList();

      emit(loaded.copyWith(
        carousel: loaded.carousel.copyWith(pages: updatedPages),
      ));
    }
  }

  Future<void> _onApplyGridLayout(
    ApplyGridLayout event,
    Emitter<CarouselEditorState> emit,
  ) async {
    if (state is CarouselEditorLoaded) {
      final loaded = state as CarouselEditorLoaded;
      final carousel = loaded.carousel;
      final pageIdx =
          carousel.pages.indexWhere((p) => p.id == event.pageId);
      if (pageIdx == -1) return;

      final layout = GridLayout.fromId(event.layoutId);
      final now = DateTime.now();

      final items = <CanvasItemModel>[];
      for (var i = 0; i < layout.cells.length; i++) {
        final cell = layout.cells[i];
        items.add(CanvasItemModel(
          id: '',
          pageId: event.pageId,
          filePath: '',
          mediaType: MediaType.image,
          positionX: cell.positionX,
          positionY: cell.positionY,
          width: cell.width,
          height: cell.height,
          rotation: 0.0,
          zIndex: i,
          isLocked: true,
          cropRect: null,
          createdAt: now,
        ));
      }

      try {
        final savedItems = <CanvasItemModel>[];
        for (final item in items) {
          final saved = await _repository.addCanvasItem(item);
          savedItems.add(saved);
        }
        final updatedPages = [...carousel.pages];
        updatedPages[pageIdx] =
            updatedPages[pageIdx].copyWith(items: savedItems);
        emit(loaded.copyWith(
          carousel: carousel.copyWith(pages: updatedPages),
          clearSelection: true,
        ));
      } catch (e) {
        emit(CarouselEditorError(e.toString()));
      }
    }
  }

  Future<void> _onReplaceGridCellImage(
    ReplaceGridCellImage event,
    Emitter<CarouselEditorState> emit,
  ) async {
    if (state is CarouselEditorLoaded) {
      final loaded = state as CarouselEditorLoaded;
      final carousel = loaded.carousel;

      for (var pi = 0; pi < carousel.pages.length; pi++) {
        final page = carousel.pages[pi];
        final itemIdx = page.items.indexWhere((i) => i.id == event.itemId);
        if (itemIdx != -1) {
          final updated = page.items[itemIdx].copyWith(
            filePath: event.filePath,
          );
          final updatedPages = [...carousel.pages];
          final updatedItems = [...page.items];
          updatedItems[itemIdx] = updated;
          updatedPages[pi] = page.copyWith(items: updatedItems);
          emit(loaded.copyWith(
            carousel: carousel.copyWith(pages: updatedPages),
          ));
          return;
        }
      }
    }
  }

  void _onScaleItem(
    ScaleItem event,
    Emitter<CarouselEditorState> emit,
  ) {
    if (state is CarouselEditorLoaded) {
      final loaded = state as CarouselEditorLoaded;
      final carousel = loaded.carousel;

      for (var pi = 0; pi < carousel.pages.length; pi++) {
        final page = carousel.pages[pi];
        final itemIdx = page.items.indexWhere((i) => i.id == event.itemId);
        if (itemIdx != -1) {
          final item = page.items[itemIdx];
          final newWidth = (item.width * event.scaleFactor).clamp(0.1, 2.0);
          final newHeight = (item.height * event.scaleFactor).clamp(0.1, 2.0);
          final updated = item.copyWith(
            width: newWidth,
            height: newHeight,
          );
          final updatedPages = [...carousel.pages];
          final updatedItems = [...page.items];
          updatedItems[itemIdx] = updated;
          updatedPages[pi] = page.copyWith(items: updatedItems);
          emit(loaded.copyWith(
            carousel: carousel.copyWith(pages: updatedPages),
          ));
          return;
        }
      }
    }
  }

  Future<void> _onSaveCarousel(
    SaveCarousel event,
    Emitter<CarouselEditorState> emit,
  ) async {
    if (state is CarouselEditorLoaded) {
      final loaded = state as CarouselEditorLoaded;
      emit(CarouselEditorSaving(loaded.carousel));

      try {
        // If no pages, delete the carousel entirely
        if (loaded.carousel.pages.isEmpty) {
          await _repository.deleteCarousel(loaded.carousel.id);
          emit(CarouselEditorSaved(loaded.carousel));
          return;
        }

        // Save all canvas items positions
        for (final page in loaded.carousel.pages) {
          for (final item in page.items) {
            await _repository.updateCanvasItem(item);
          }
        }

        // Persist page order
        final pageIds = loaded.carousel.pages.map((p) => p.id).toList();
        await _repository.reorderPages(loaded.carousel.id, pageIds);

        emit(CarouselEditorSaved(loaded.carousel));
      } catch (e) {
        emit(CarouselEditorError(e.toString()));
      }
    }
  }
}
