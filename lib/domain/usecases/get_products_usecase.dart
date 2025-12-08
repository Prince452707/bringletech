import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<ProductEntity>> call({
    int skip = 0,
    int limit = 10,
    String? sortBy,
    String? order,
  }) {
    return repository.getProducts(
      skip: skip,
      limit: limit,
      sortBy: sortBy,
      order: order,
    );
  }
}
