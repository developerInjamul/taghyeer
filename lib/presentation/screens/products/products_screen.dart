import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/product_model.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/products_controller.dart';
import '../../widgets/common/common_widgets.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Obx(
            () => controller.state.value == ListState.success
                ? Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${controller.products.length} items',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        switch (controller.state.value) {
          case ListState.loading:
          case ListState.initial:
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: 8,
              itemBuilder: (_, __) => const ProductShimmerItem(),
            );

          case ListState.error:
            return ErrorStateWidget(
              message: controller.errorMessage.value,
              onRetry: controller.retry,
            );

          case ListState.empty:
            return const EmptyStateWidget(
              message: 'No products available.',
              icon: Icons.inventory_2_outlined,
            );

          case ListState.success:
            return RefreshIndicator(
              onRefresh: controller.fetchProducts,
              color: AppTheme.primaryColor,
              child: ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.products.length +
                    (controller.isPaginationLoading.value ? 1 : 0) +
                    (!controller.hasMore.value &&
                            controller.products.isNotEmpty
                        ? 1
                        : 0),
                itemBuilder: (context, index) {
                  if (index == controller.products.length) {
                    if (controller.isPaginationLoading.value) {
                      return const PaginationLoader();
                    }
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          '✓ All products loaded',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    );
                  }
                  return _ProductTile(
                    product: controller.products[index],
                  );
                },
              ),
            );
        }
      }),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final ProductModel product;

  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: product),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.dividerTheme.color ?? Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: product.thumbnail,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                placeholder: (_, __) => const ShimmerCard(
                  height: 90,
                  width: 90,
                  borderRadius: 0,
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 90,
                  height: 90,
                  color: AppTheme.primaryColor.withOpacity(0.08),
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                ),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        StarRating(rating: product.rating, size: 13),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontSize: 15,
                          ),
                        ),
                        if (product.discountPercentage > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.successColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '-${product.discountPercentage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: AppTheme.successColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
