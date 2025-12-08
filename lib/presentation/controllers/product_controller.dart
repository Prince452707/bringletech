import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/error/error_handler.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_by_category_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/manage_product_usecase.dart';
import '../../domain/usecases/search_products_usecase.dart';

class ProductController extends GetxController {
  final GetProductsUseCase getProductsUseCase;
  final SearchProductsUseCase searchProductsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;
  final ManageProductUseCase manageProductUseCase;

  ProductController({
    required this.getProductsUseCase,
    required this.searchProductsUseCase,
    required this.getCategoriesUseCase,
    required this.getProductsByCategoryUseCase,
    required this.manageProductUseCase,
  });

  var products = <ProductEntity>[].obs;
  var categories = <String>[].obs;
  var selectedCategory = ''.obs;

  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var failure = Rxn<Failure>();
  var hasMore = true.obs;

  var sortBy = RxnString();
  var sortOrder = 'asc'.obs;

  int _currentSkip = 0;
  final int _limit = 10;
  Timer? _debounce;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProducts();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchCategories() async {
    try {
      final cats = await getCategoriesUseCase();
      categories.assignAll(['All', ...cats]);
      selectedCategory.value = 'All';
    } catch (e) {}
  }

  void selectCategory(String category) {
    if (selectedCategory.value == category) return;
    selectedCategory.value = category;

    searchController.clear();
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    fetchProducts(isRefresh: true);
  }

  void updateSort(String field, String order) {
    sortBy.value = field;
    sortOrder.value = order;
    fetchProducts(isRefresh: true);
  }

  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentSkip = 0;
      hasMore.value = true;
      failure.value = null;
      products.clear();
      isLoading.value = true;
    } else {
      if (!hasMore.value || isMoreLoading.value) return;
      isMoreLoading.value = true;
    }

    try {
      List<ProductEntity> newProducts;

      if (searchController.text.isNotEmpty) {
        return;
      }

      if (selectedCategory.value != 'All' &&
          selectedCategory.value.isNotEmpty) {
        newProducts = await getProductsByCategoryUseCase(
          selectedCategory.value,
        );
        hasMore.value = false;
      } else {
        newProducts = await getProductsUseCase(
          skip: _currentSkip,
          limit: _limit,
          sortBy: sortBy.value,
          order: sortOrder.value,
        );
      }

      if (newProducts.length < _limit && selectedCategory.value == 'All') {
        hasMore.value = false;
      }

      if (isRefresh) {
        products.assignAll(newProducts);
      } else {
        products.addAll(newProducts);
      }

      if (selectedCategory.value == 'All') {
        _currentSkip += _limit;
      }
    } catch (e) {
      failure.value = ErrorHandler.handle(e);
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        fetchProducts(isRefresh: true);
      } else {
        _performSearch(query);
      }
    });
  }

  Future<void> _performSearch(String query) async {
    isLoading.value = true;
    failure.value = null;
    products.clear();

    selectedCategory.value = 'All';
    try {
      final results = await searchProductsUseCase(query);
      products.assignAll(results);
      hasMore.value = false;
    } catch (e) {
      failure.value = ErrorHandler.handle(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addProduct(ProductEntity product) async {
    try {
      Get.loading();
      final newProduct = await manageProductUseCase.add(product);
      products.insert(0, newProduct);
      Get.back();
      Get.snackbar(
        'Success',
        'Product added successfully (Simulated)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        ErrorHandler.handle(e).message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<bool> updateProduct(ProductEntity product) async {
    try {
      Get.loading();
      final updated = await manageProductUseCase.update(product);
      final index = products.indexWhere((p) => p.id == updated.id);
      if (index != -1) {
        products[index] = updated;
        products.refresh();
      }
      Get.back();

      Get.snackbar(
        'Success',
        'Product updated successfully (Simulated)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        ErrorHandler.handle(e).message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      Get.loading();
      await manageProductUseCase.delete(id);
      products.removeWhere((p) => p.id == id);
      Get.back();

      Get.snackbar(
        'Success',
        'Product deleted successfully (Simulated)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.until((route) => route.isFirst);
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        ErrorHandler.handle(e).message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

extension GetLoading on GetInterface {
  void loading() {
    if (Get.isDialogOpen ?? false) return;
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }
}
