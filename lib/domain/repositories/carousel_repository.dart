import '../../data/models/carousel_model.dart';

abstract class CarouselRepository {
  // Carousel
  Future<CarouselModel> createCarousel(CarouselModel carousel);
  Future<CarouselModel?> getCarousel(String id);
  Future<List<CarouselModel>> getCarouselsByProfile(String profileId);
  Future<CarouselModel> updateCarousel(CarouselModel carousel);
  Future<void> deleteCarousel(String id);

  // Pages
  Future<PageModel> createPage(PageModel page);
  Future<List<PageModel>> getPages(String carouselId);
  Future<void> deletePage(String id);
  Future<void> reorderPages(String carouselId, List<String> pageIds);

  // CanvasItems
  Future<CanvasItemModel> addCanvasItem(CanvasItemModel item);
  Future<List<CanvasItemModel>> getCanvasItems(String pageId);
  Future<CanvasItemModel> updateCanvasItem(CanvasItemModel item);
  Future<void> deleteCanvasItem(String id);
}
