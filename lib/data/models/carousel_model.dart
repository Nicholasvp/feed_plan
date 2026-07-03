import 'package:equatable/equatable.dart';
import '../../core/enums/media_type.dart';
import '../../domain/entities/carousel.dart' as entity;

class CarouselModel extends Equatable {
  const CarouselModel({
    required this.id,
    required this.profileId,
    required this.order,
    required this.aspectRatio,
    required this.createdAt,
    required this.updatedAt,
    this.pages = const [],
  });

  final String id;
  final String profileId;
  final int order;
  final String aspectRatio;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<PageModel> pages;

  factory CarouselModel.fromEntity(entity.Carousel carousel,
      {List<PageModel> pages = const []}) {
    return CarouselModel(
      id: carousel.id,
      profileId: carousel.profileId,
      order: carousel.order,
      aspectRatio: carousel.aspectRatio,
      createdAt: carousel.createdAt,
      updatedAt: carousel.updatedAt,
      pages: pages,
    );
  }

  entity.Carousel toEntity() {
    return entity.Carousel(
      id: id,
      profileId: profileId,
      order: order,
      aspectRatio: aspectRatio,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  CarouselModel copyWith({
    String? id,
    String? profileId,
    int? order,
    String? aspectRatio,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<PageModel>? pages,
  }) {
    return CarouselModel(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      order: order ?? this.order,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pages: pages ?? this.pages,
    );
  }

  @override
  List<Object?> get props => [
        id,
        profileId,
        order,
        aspectRatio,
        createdAt,
        updatedAt,
        pages,
      ];
}

class PageModel extends Equatable {
  const PageModel({
    required this.id,
    required this.carouselId,
    required this.orderIndex,
    required this.createdAt,
    this.items = const [],
  });

  final String id;
  final String carouselId;
  final int orderIndex;
  final DateTime createdAt;
  final List<CanvasItemModel> items;

  factory PageModel.fromEntity(entity.Page page,
      {List<CanvasItemModel> items = const []}) {
    return PageModel(
      id: page.id,
      carouselId: page.carouselId,
      orderIndex: page.orderIndex,
      createdAt: page.createdAt,
      items: items,
    );
  }

  entity.Page toEntity() {
    return entity.Page(
      id: id,
      carouselId: carouselId,
      orderIndex: orderIndex,
      createdAt: createdAt,
    );
  }

  PageModel copyWith({
    String? id,
    String? carouselId,
    int? orderIndex,
    DateTime? createdAt,
    List<CanvasItemModel>? items,
  }) {
    return PageModel(
      id: id ?? this.id,
      carouselId: carouselId ?? this.carouselId,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [id, carouselId, orderIndex, createdAt, items];
}

class CanvasItemModel extends Equatable {
  const CanvasItemModel({
    required this.id,
    required this.pageId,
    required this.filePath,
    required this.mediaType,
    this.positionX = 0.0,
    this.positionY = 0.0,
    this.width = 1.0,
    this.height = 1.0,
    this.rotation = 0.0,
    this.zIndex = 0,
    this.spanToNextPage = false,
    this.isLocked = false,
    this.cropRect,
    required this.createdAt,
  });

  final String id;
  final String pageId;
  final String filePath;
  final MediaType mediaType;
  final double positionX;
  final double positionY;
  final double width;
  final double height;
  final double rotation;
  final int zIndex;
  final bool spanToNextPage;
  final bool isLocked;
  final String? cropRect;
  final DateTime createdAt;

  factory CanvasItemModel.fromEntity(entity.CanvasItem item) {
    return CanvasItemModel(
      id: item.id,
      pageId: item.pageId,
      filePath: item.filePath,
      mediaType: item.mediaType,
      positionX: item.positionX,
      positionY: item.positionY,
      width: item.width,
      height: item.height,
      rotation: item.rotation,
      zIndex: item.zIndex,
      spanToNextPage: item.spanToNextPage,
      isLocked: item.isLocked,
      cropRect: item.cropRect,
      createdAt: item.createdAt,
    );
  }

  entity.CanvasItem toEntity() {
    return entity.CanvasItem(
      id: id,
      pageId: pageId,
      filePath: filePath,
      mediaType: mediaType,
      positionX: positionX,
      positionY: positionY,
      width: width,
      height: height,
      rotation: rotation,
      zIndex: zIndex,
      spanToNextPage: spanToNextPage,
      isLocked: isLocked,
      cropRect: cropRect,
      createdAt: createdAt,
    );
  }

  CanvasItemModel copyWith({
    String? id,
    String? pageId,
    String? filePath,
    MediaType? mediaType,
    double? positionX,
    double? positionY,
    double? width,
    double? height,
    double? rotation,
    int? zIndex,
    bool? spanToNextPage,
    bool? isLocked,
    String? cropRect,
    DateTime? createdAt,
  }) {
    return CanvasItemModel(
      id: id ?? this.id,
      pageId: pageId ?? this.pageId,
      filePath: filePath ?? this.filePath,
      mediaType: mediaType ?? this.mediaType,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
      zIndex: zIndex ?? this.zIndex,
      spanToNextPage: spanToNextPage ?? this.spanToNextPage,
      isLocked: isLocked ?? this.isLocked,
      cropRect: cropRect ?? this.cropRect,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        pageId,
        filePath,
        mediaType,
        positionX,
        positionY,
        width,
        height,
        rotation,
        zIndex,
        spanToNextPage,
        isLocked,
        cropRect,
        createdAt,
      ];
}
