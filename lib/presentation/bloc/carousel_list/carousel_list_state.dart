import 'package:equatable/equatable.dart';
import '../../../data/models/carousel_model.dart';

abstract class CarouselListState extends Equatable {
  const CarouselListState();
}

class CarouselListInitial extends CarouselListState {
  const CarouselListInitial();

  @override
  List<Object?> get props => [];
}

class CarouselListLoading extends CarouselListState {
  const CarouselListLoading();

  @override
  List<Object?> get props => [];
}

class CarouselListLoaded extends CarouselListState {
  const CarouselListLoaded(this.carousels);

  final List<CarouselModel> carousels;

  @override
  List<Object?> get props => [carousels];
}

class CarouselListError extends CarouselListState {
  const CarouselListError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
