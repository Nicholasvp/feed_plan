import 'package:equatable/equatable.dart';

abstract class CarouselListEvent extends Equatable {
  const CarouselListEvent();
}

class LoadCarousels extends CarouselListEvent {
  const LoadCarousels(this.profileId);

  final String profileId;

  @override
  List<Object?> get props => [profileId];
}

class DeleteCarousel extends CarouselListEvent {
  const DeleteCarousel(this.carouselId);

  final String carouselId;

  @override
  List<Object?> get props => [carouselId];
}

class CreateCarousel extends CarouselListEvent {
  const CreateCarousel({
    required this.profileId,
    this.aspectRatio = '1:1',
  });

  final String profileId;
  final String aspectRatio;

  @override
  List<Object?> get props => [profileId, aspectRatio];
}

class CreateSinglePhotoPost extends CarouselListEvent {
  const CreateSinglePhotoPost({
    required this.profileId,
    required this.filePath,
  });

  final String profileId;
  final String filePath;

  @override
  List<Object?> get props => [profileId, filePath];
}
