import 'package:dio/dio.dart';
import '../../core/error/api_exceptions.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient apiClient;

  ProductRepositoryImpl({required this.apiClient});

  @override
  Future<List<ProductEntity>> getProducts({
    int skip = 0,
    int limit = 10,
    String? sortBy,
    String? order,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {'skip': skip, 'limit': limit};

      if (sortBy != null) {
        queryParams['sortBy'] = sortBy;
        queryParams['order'] = order ?? 'asc';
      }

      final response = await apiClient.dio.get(
        '/products',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = response.data['products'];
        return productsJson.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to load products');
      }
    } on DioException catch (e) {
      throw NetworkException(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    try {
      final response = await apiClient.dio.get(
        '/products/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = response.data['products'];
        return productsJson.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to search products');
      }
    } on DioException catch (e) {
      throw NetworkException(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await apiClient.dio.get('/products/category-list');

      if (response.statusCode == 200) {
        return (response.data as List).map((e) => e.toString()).toList();
      } else {
        throw ServerException('Failed to load categories');
      }
    } on DioException catch (e) {
      throw NetworkException(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(String category) async {
    try {
      final response = await apiClient.dio.get('/products/category/$category');

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = response.data['products'];
        return productsJson.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to load category products');
      }
    } on DioException catch (e) {
      throw NetworkException(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

 
  Map<String, dynamic> _entityToJson(ProductEntity product) {
    return {
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'category': product.category,
      'brand': product.brand,
      'thumbnail': product.thumbnail,
     
    };
  }

  @override
  Future<ProductEntity> addProduct(ProductEntity product) async {
    try {
      final response = await apiClient.dio.post(
        '/products/add',
        data: _entityToJson(product),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProductModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to add product');
      }
    } on DioException catch (e) {
      throw NetworkException(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProductEntity> updateProduct(ProductEntity product) async {
    try {
      final response = await apiClient.dio.put(
        '/products/${product.id}',
        data: _entityToJson(product),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to update product');
      }
    } on DioException catch (e) {
      throw NetworkException(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProductEntity> deleteProduct(int id) async {
    try {
      final response = await apiClient.dio.delete('/products/$id');

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to delete product');
      }
    } on DioException catch (e) {
      throw NetworkException(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
