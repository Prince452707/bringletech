import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_by_category_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/manage_product_usecase.dart';
import '../../domain/usecases/search_products_usecase.dart';
import '../controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => ProductRepositoryImpl(apiClient: Get.find()));

    Get.lazyPut(() => GetProductsUseCase(Get.find<ProductRepositoryImpl>()));
    Get.lazyPut(() => SearchProductsUseCase(Get.find<ProductRepositoryImpl>()));
    Get.lazyPut(() => GetCategoriesUseCase(Get.find<ProductRepositoryImpl>()));
    Get.lazyPut(
      () => GetProductsByCategoryUseCase(Get.find<ProductRepositoryImpl>()),
    );
    Get.lazyPut(() => ManageProductUseCase(Get.find<ProductRepositoryImpl>()));

    Get.lazyPut(
      () => ProductController(
        getProductsUseCase: Get.find(),
        searchProductsUseCase: Get.find(),
        getCategoriesUseCase: Get.find(),
        getProductsByCategoryUseCase: Get.find(),
        manageProductUseCase: Get.find(),
      ),
    );
  }
}
