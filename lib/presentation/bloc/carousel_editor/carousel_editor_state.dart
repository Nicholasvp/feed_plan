import 'package:equatable/equatable.dart';
import '../../../data/models/carousel_model.dart';

abstract class CarouselEditorState extends Equatable {
  const CarouselEditorState();
}

class CarouselEditorInitial extends CarouselEditorState {
  const CarouselEditorInitial();

  @override
  List<Object?> get props => [];
}

class CarouselEditorLoading extends CarouselEditorState {
  const CarouselEditorLoading();

  @override
  List<Object?> get props => [];
}

class CarouselEditorLoaded extends CarouselEditorState {
  const CarouselEditorLoaded({
    required this.carousel,
    this.selectedItemId,
  });

  final CarouselModel carousel;
  final String? selectedItemId;

  int get currentPageIndex => 0;

  PageModel? get currentPage =>
      carousel.pages.isNotEmpty ? carousel.pages.first : null;

  CarouselEditorLoaded copyWith({
    CarouselModel? carousel,
    String? selectedItemId,
    bool clearSelection = false,
  }) {
    return CarouselEditorLoaded(
      carousel: carousel ?? this.carousel,
      selectedItemId: clearSelection ? null : (selectedItemId ?? this.selectedItemId),
    );
  }

  @override
  List<Object?> get props => [carousel, selectedItemId];
}

class CarouselEditorSaving extends CarouselEditorState {
  const CarouselEditorSaving(this.carousel);

  final CarouselModel carousel;

  @override
  List<Object?> get props => [carousel];
}

class CarouselEditorSaved extends CarouselEditorState {
  const CarouselEditorSaved(this.carousel);

  final CarouselModel carousel;

  @override
  List<Object?> get props => [carousel];
}

class CarouselEditorError extends CarouselEditorState {
  const CarouselEditorError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
