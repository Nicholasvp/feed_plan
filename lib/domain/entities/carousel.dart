import 'package:equatable/equatable.dart';
import '../../core/enums/media_type.dart';

class Carousel extends Equatable {
  const Carousel({
    required this.id,
    required this.profileId,
    required this.order,
    this.aspectRatio = '1:1',
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String profileId;
  final int order;
  final String aspectRatio;
  final DateTime createdAt;
  final DateTime updatedAt;

  Carousel copyWith({
    String? id,
    String? profileId,
    int? order,
    String? aspectRatio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Carousel(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      order: order ?? this.order,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
      ];
}

class Page extends Equatable {
  const Page({
    required this.id,
    required this.carouselId,
    required this.orderIndex,
    required this.createdAt,
  });

  final String id;
  final String carouselId;
  final int orderIndex;
  final DateTime createdAt;

  Page copyWith({
    String? id,
    String? carouselId,
    int? orderIndex,
    DateTime? createdAt,
  }) {
    return Page(
      id: id ?? this.id,
      carouselId: carouselId ?? this.carouselId,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, carouselId, orderIndex, createdAt];
}

class CanvasItem extends Equatable {
  const CanvasItem({
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
  final String? cropRect;
  final DateTime createdAt;

  CanvasItem copyWith({
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
    String? cropRect,
    DateTime? createdAt,
  }) {
    return CanvasItem(
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
        cropRect,
        createdAt,
      ];
}
