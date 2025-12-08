import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class ManageProductUseCase {
  final ProductRepository repository;

  ManageProductUseCase(this.repository);

  Future<ProductEntity> add(ProductEntity product) =>
      repository.addProduct(product);
  Future<ProductEntity> update(ProductEntity product) =>
      repository.updateProduct(product);
  Future<ProductEntity> delete(int id) => repository.deleteProduct(id);
}
