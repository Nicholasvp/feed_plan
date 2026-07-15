import 'package:equatable/equatable.dart';

import 'carousel_model.dart';
import 'instagram_post_model.dart';

class FeedItemModel extends Equatable {
  const FeedItemModel({
    required this.id,
    required this.imageUrl,
    required this.isLocal,
    required this.createdAt,
    this.carousel,
    this.post,
  });

  final String id;
  final String imageUrl;
  final bool isLocal;
  final DateTime createdAt;
  final CarouselModel? carousel;
  final InstagramPostModel? post;

  factory FeedItemModel.fromCarousel(CarouselModel carousel) {
    String imageUrl = '';
    if (carousel.pages.isNotEmpty) {
      final firstPage = carousel.pages.first;
      if (firstPage.items.isNotEmpty) {
        imageUrl = firstPage.items.first.filePath;
      }
    }

    return FeedItemModel(
      id: carousel.id,
      imageUrl: imageUrl,
      isLocal: true,
      createdAt: carousel.updatedAt,
      carousel: carousel,
    );
  }

  factory FeedItemModel.fromInstagramPost(InstagramPostModel post) {
    return FeedItemModel(
      id: post.id,
      imageUrl: post.displayUrl,
      isLocal: false,
      createdAt: post.timestamp ?? DateTime.now(),
      post: post,
    );
  }

  @override
  List<Object?> get props => [id, imageUrl, isLocal, createdAt];
}
