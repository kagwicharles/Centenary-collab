import 'package:floor/floor.dart';
import 'package:rafiki/src/data/model.dart';

@dao
abstract class CarouselItemDao {
  @Query('SELECT * FROM Carousel')
  Future<List<Carousel>> getAllCarousels();

  @insert
  Future<void> insertCarousel(Carousel carousel);

  @Query('DELETE FROM Carousel')
  Future<void> clearTable();
}
