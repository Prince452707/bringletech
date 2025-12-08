import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';
import '../../core/error/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import 'product_detail_screen.dart';
import 'add_edit_product_screen.dart';

class ProductListScreen extends GetView<ProductController> {
  ProductListScreen({super.key});

  final ScrollController scrollController = ScrollController();

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.9) {
        controller.fetchProducts();
      }
    });
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("Default"),
            onTap: () {
              controller.updateSort('id', 'asc');
              Get.back();
            },
          ),
          ListTile(
            title: const Text("Price: Low to High"),
            onTap: () {
              controller.updateSort('price', 'asc');
              Get.back();
            },
          ),
          ListTile(
            title: const Text("Price: High to Low"),
            onTap: () {
              controller.updateSort('price', 'desc');
              Get.back();
            },
          ),
          ListTile(
            title: const Text("Name: A to Z"),
            onTap: () {
              controller.updateSort('title', 'asc');
              Get.back();
            },
          ),
          ListTile(
            title: const Text("Name: Z to A"),
            onTap: () {
              controller.updateSort('title', 'desc');
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _setupScrollListener();

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddEditProductScreen()),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Discover", style: AppFonts.displayLarge),
                      IconButton(
                        icon: const Icon(Icons.sort),
                        onPressed: () => _showSortOptions(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.searchController,
                    onChanged: controller.onSearchChanged,
                    decoration: InputDecoration(
                      hintText: "Search products...",
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: Obx(
                      () => ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.categories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final cat = controller.categories[index];
                          final isSelected =
                              cat == controller.selectedCategory.value;
                          return ChoiceChip(
                            label: Text(
                              cat.toUpperCase(),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.primary,
                            onSelected: (selected) =>
                                controller.selectCategory(cat),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.products.isEmpty) {
                  return _buildShimmerLoading();
                }

                if (controller.failure.value != null &&
                    controller.products.isEmpty) {
                  final failure = controller.failure.value!;
                  return Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              ErrorHandler.getIcon(failure),
                              size: 80,
                              color: AppColors.error.withAlpha(204),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              failure.title,
                              style: AppFonts.titleLarge.copyWith(
                                color: AppColors.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              failure.message,
                              style: AppFonts.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  controller.fetchProducts(isRefresh: true),
                              icon: const Icon(Icons.refresh),
                              label: const Text("Try Again"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                if (controller.products.isEmpty) {
                  return Center(
                    child: Text(
                      "No products found",
                      style: AppFonts.titleLarge,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async =>
                      await controller.fetchProducts(isRefresh: true),
                  child: GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount:
                        controller.products.length +
                        (controller.isMoreLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.products.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final product = controller.products[index];
                      return ProductCard(
                        product: product,
                        onTap: () =>
                            Get.to(() => ProductDetailScreen(product: product)),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.shimmerBase,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}
