import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enums/media_type.dart';
import '../../../data/models/carousel_model.dart';
import '../../../data/repositories/carousel_repository_impl.dart';
import 'carousel_list_event.dart';
import 'carousel_list_state.dart';

class CarouselListBloc extends Bloc<CarouselListEvent, CarouselListState> {
  CarouselListBloc(this._repository) : super(const CarouselListInitial()) {
    on<LoadCarousels>(_onLoadCarousels);
    on<DeleteCarousel>(_onDeleteCarousel);
    on<CreateCarousel>(_onCreateCarousel);
    on<CreateSinglePhotoPost>(_onCreateSinglePhotoPost);
  }

  final CarouselRepositoryImpl _repository;

  Future<void> _onLoadCarousels(
    LoadCarousels event,
    Emitter<CarouselListState> emit,
  ) async {
    emit(const CarouselListLoading());
    try {
      final carousels =
          await _repository.getCarouselsByProfile(event.profileId);
      emit(CarouselListLoaded(carousels));
    } catch (e) {
      emit(CarouselListError(e.toString()));
    }
  }

  Future<void> _onDeleteCarousel(
    DeleteCarousel event,
    Emitter<CarouselListState> emit,
  ) async {
    try {
      await _repository.deleteCarousel(event.carouselId);
      final current = state;
      if (current is CarouselListLoaded) {
        final updated =
            current.carousels.where((c) => c.id != event.carouselId).toList();
        emit(CarouselListLoaded(updated));
      }
    } catch (e) {
      emit(CarouselListError(e.toString()));
    }
  }

  Future<void> _onCreateCarousel(
    CreateCarousel event,
    Emitter<CarouselListState> emit,
  ) async {
    try {
      final now = DateTime.now();
      final currentState = state;
      final order = currentState is CarouselListLoaded
          ? currentState.carousels.length
          : 0;

      final carousel = await _repository.createCarousel(
        CarouselModel(
          id: '',
          profileId: event.profileId,
          order: order,
          aspectRatio: event.aspectRatio,
          createdAt: now,
          updatedAt: now,
        ),
      );

      // Create first page automatically
      final page = await _repository.createPage(
        PageModel(
          id: '',
          carouselId: carousel.id,
          orderIndex: 0,
          createdAt: now,
        ),
      );

      final carouselWithPages = CarouselModel(
        id: carousel.id,
        profileId: carousel.profileId,
        order: carousel.order,
        aspectRatio: carousel.aspectRatio,
        createdAt: carousel.createdAt,
        updatedAt: carousel.updatedAt,
        pages: [page],
      );

      if (currentState is CarouselListLoaded) {
        emit(CarouselListLoaded([...currentState.carousels, carouselWithPages]));
      } else {
        emit(CarouselListLoaded([carouselWithPages]));
      }
    } catch (e) {
      emit(CarouselListError(e.toString()));
    }
  }

  Future<void> _onCreateSinglePhotoPost(
    CreateSinglePhotoPost event,
    Emitter<CarouselListState> emit,
  ) async {
    try {
      final now = DateTime.now();
      final currentState = state;
      final order = currentState is CarouselListLoaded
          ? currentState.carousels.length
          : 0;

      final carousel = await _repository.createCarousel(
        CarouselModel(
          id: '',
          profileId: event.profileId,
          order: order,
          aspectRatio: '1:1',
          createdAt: now,
          updatedAt: now,
        ),
      );

      final page = await _repository.createPage(
        PageModel(
          id: '',
          carouselId: carousel.id,
          orderIndex: 0,
          createdAt: now,
        ),
      );

      await _repository.addCanvasItem(
        CanvasItemModel(
          id: '',
          pageId: page.id,
          filePath: event.filePath,
          mediaType: MediaType.image,
          positionX: 0.0,
          positionY: 0.0,
          width: 1.0,
          height: 1.0,
          rotation: 0.0,
          zIndex: 0,
          createdAt: now,
        ),
      );

      final carouselWithPages = await _repository.getCarousel(carousel.id);

      if (currentState is CarouselListLoaded && carouselWithPages != null) {
        emit(CarouselListLoaded([...currentState.carousels, carouselWithPages]));
      } else if (carouselWithPages != null) {
        emit(CarouselListLoaded([carouselWithPages]));
      }
    } catch (e) {
      emit(CarouselListError(e.toString()));
    }
  }
}
