import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../domain/entities/product_entity.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../controllers/product_controller.dart';
import 'add_edit_product_screen.dart';

class ProductDetailScreen extends GetView<ProductController> {
  final ProductEntity product;

  const ProductDetailScreen({super.key, required this.product});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product?'),
        content: const Text(
          'Are you sure you want to delete this product? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteProduct(product.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final currentProduct = controller.products.firstWhere(
          (p) => p.id == product.id,
          orElse: () => product,
        );

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: AppColors.background,
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => Get.to(
                    () => AddEditProductScreen(product: currentProduct),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AppColors.error),
                  onPressed: () => _confirmDelete(context),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'product_image_${currentProduct.id}',
                  child: CachedNetworkImage(
                    imageUrl: currentProduct.thumbnail,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withAlpha(26),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            currentProduct.category.toUpperCase(),
                            style: AppFonts.labelLarge.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              currentProduct.rating.toString(),
                              style: AppFonts.titleLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(currentProduct.title, style: AppFonts.displayLarge),
                    const SizedBox(height: 8),
                    Text(
                      currentProduct.brand,
                      style: AppFonts.titleLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (currentProduct.stock < 5)
                      Text(
                        'Only ${currentProduct.stock} left!',
                        style: AppFonts.bodyMedium.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Text(
                          '\$${currentProduct.price}',
                          style: AppFonts.displayLarge.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        if (currentProduct.discountPercentage > 0) ...[
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${currentProduct.discountPercentage}% OFF',
                              style: AppFonts.labelLarge.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text("Description", style: AppFonts.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      currentProduct.description,
                      style: AppFonts.bodyLarge.copyWith(height: 1.5),
                    ),

                    const SizedBox(height: 32),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 3,
                      children: [
                        _InfoItem("SKU", currentProduct.sku),
                        _InfoItem("Weight", "${currentProduct.weight}g"),
                        _InfoItem(
                          "Warranty",
                          currentProduct.warrantyInformation,
                        ),
                        _InfoItem(
                          "Shipping",
                          currentProduct.shippingInformation,
                        ),
                        _InfoItem(
                          "Availability",
                          currentProduct.availabilityStatus,
                        ),
                        _InfoItem("Return Policy", currentProduct.returnPolicy),
                      ],
                    ),

                    if (currentProduct.images.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      Text("Gallery", style: AppFonts.titleLarge),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: currentProduct.images.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: currentProduct.images[index],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ],

                    if (currentProduct.reviews.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      Text("Reviews", style: AppFonts.titleLarge),
                      const SizedBox(height: 16),
                      ...currentProduct.reviews.map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.shimmerBase),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      r.reviewerName,
                                      style: AppFonts.bodyLarge.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.star,
                                      size: 14,
                                      color: Colors.amber,
                                    ),
                                    Text(
                                      r.rating.toString(),
                                      style: AppFonts.bodyMedium,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(r.comment, style: AppFonts.bodyMedium),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 48),
                  ],
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  const _InfoItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: AppFonts.bodyLarge.copyWith(fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
