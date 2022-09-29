import 'package:floor/floor.dart';
import 'package:rafiki/src/data/model.dart';

@dao
abstract class ImageDataDao {
  @Query('SELECT * FROM ImageData WHERE imageCategory = :imageType')
  Future<List<ImageData>> getAllImages(String imageType);

  @insert
  Future<void> insertImage(ImageData imageData);

  @Query('DELETE FROM ImageData')
  Future<void> clearTable();
}
