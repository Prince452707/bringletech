import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts({
    int skip = 0,
    int limit = 10,
    String? sortBy,
    String? order,
  });

  Future<List<ProductEntity>> searchProducts(String query);

  Future<List<String>> getCategories();

  Future<List<ProductEntity>> getProductsByCategory(String category);

  Future<ProductEntity> addProduct(ProductEntity product);

  Future<ProductEntity> updateProduct(ProductEntity product);

  Future<ProductEntity> deleteProduct(int id);
}
