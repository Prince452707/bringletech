import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsByCategoryUseCase {
  final ProductRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  Future<List<ProductEntity>> call(String category) {
    return repository.getProductsByCategory(category);
  }
}
