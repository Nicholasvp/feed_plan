import 'package:equatable/equatable.dart';

abstract class CarouselEditorEvent extends Equatable {
  const CarouselEditorEvent();
}

class LoadCarousel extends CarouselEditorEvent {
  const LoadCarousel(this.carouselId);

  final String carouselId;

  @override
  List<Object?> get props => [carouselId];
}

class AddPage extends CarouselEditorEvent {
  const AddPage();

  @override
  List<Object?> get props => [];
}

class RemovePage extends CarouselEditorEvent {
  const RemovePage(this.pageId);

  final String pageId;

  @override
  List<Object?> get props => [pageId];
}

class AddImageToPage extends CarouselEditorEvent {
  const AddImageToPage({
    required this.pageId,
    required this.filePath,
  });

  final String pageId;
  final String filePath;

  @override
  List<Object?> get props => [pageId, filePath];
}

class MoveItem extends CarouselEditorEvent {
  const MoveItem({
    required this.itemId,
    required this.positionX,
    required this.positionY,
  });

  final String itemId;
  final double positionX;
  final double positionY;

  @override
  List<Object?> get props => [itemId, positionX, positionY];
}

class ResizeItem extends CarouselEditorEvent {
  const ResizeItem({
    required this.itemId,
    required this.width,
    required this.height,
  });

  final String itemId;
  final double width;
  final double height;

  @override
  List<Object?> get props => [itemId, width, height];
}

class ToggleSpanNextPage extends CarouselEditorEvent {
  const ToggleSpanNextPage(this.itemId);

  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class SelectItem extends CarouselEditorEvent {
  const SelectItem(this.itemId);

  final String? itemId;

  @override
  List<Object?> get props => [itemId];
}

class MoveItemToPage extends CarouselEditorEvent {
  const MoveItemToPage({
    required this.itemId,
    required this.targetPageId,
  });

  final String itemId;
  final String targetPageId;

  @override
  List<Object?> get props => [itemId, targetPageId];
}

class DeleteItem extends CarouselEditorEvent {
  const DeleteItem(this.itemId);

  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class DeleteCarousel extends CarouselEditorEvent {
  const DeleteCarousel();

  @override
  List<Object?> get props => [];
}

class SaveCarousel extends CarouselEditorEvent {
  const SaveCarousel();

  @override
  List<Object?> get props => [];
}

class ReorderPages extends CarouselEditorEvent {
  const ReorderPages({
    required this.oldIndex,
    required this.newIndex,
  });

  final int oldIndex;
  final int newIndex;

  @override
  List<Object?> get props => [oldIndex, newIndex];
}

class ApplyGridLayout extends CarouselEditorEvent {
  const ApplyGridLayout({
    required this.pageId,
    required this.layoutId,
  });

  final String pageId;
  final String layoutId;

  @override
  List<Object?> get props => [pageId, layoutId];
}

class ReplaceGridCellImage extends CarouselEditorEvent {
  const ReplaceGridCellImage({
    required this.itemId,
    required this.filePath,
  });

  final String itemId;
  final String filePath;

  @override
  List<Object?> get props => [itemId, filePath];
}
