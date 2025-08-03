import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';

class ProductCard extends GetView<CartController> {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });
  
  ProductController get productController => Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
                         child: Container(
               width: double.infinity,
               decoration: BoxDecoration(
                 borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                 color: const Color(0xFFF8F9FA),
               ),
               child: Stack(
                 children: [
                   Center(
                     child: Icon(
                       _getProductIcon(product.name),
                       size: 60,
                       color: const Color(0xFF53B175),
                     ),
                   ),
                   Positioned(
                     top: 8,
                     right: 8,
                     child: Obx(() => GestureDetector(
                       onTap: () {
                         final productId = int.tryParse(product.id);
                         if (productId != null) {
                           productController.toggleFavorite(productId);
                         }
                       },
                       child: Container(
                         padding: const EdgeInsets.all(4),
                         decoration: BoxDecoration(
                           color: Colors.white.withOpacity(0.9),
                           borderRadius: BorderRadius.circular(12),
                         ),
                         child: Icon(
                           productController.isFavorite(int.tryParse(product.id) ?? 0)
                               ? Icons.favorite
                               : Icons.favorite_border,
                           color: productController.isFavorite(int.tryParse(product.id) ?? 0)
                               ? Colors.red
                               : Colors.grey,
                           size: 20,
                         ),
                       ),
                     )),
                   ),
                 ],
               ),
             ),
          ),
          
          // Product Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 1),
                  
                  // Rating
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 12,
                        color: Colors.amber[600],
                      ),
                      const SizedBox(width: 1),
                      Text(
                        '${product.rating}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 1),
                      Text(
                        '(${product.reviewCount})',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Price and Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                                         Text(
                               '₺${product.price.toStringAsFixed(2)}',
                               style: const TextStyle(
                                 fontSize: 15,
                                 fontWeight: FontWeight.bold,
                                 color: Color(0xFF53B175),
                               ),
                             ),
                             Text(
                               '/ ${product.unit}',
                               style: const TextStyle(
                                 fontSize: 9,
                                 color: Colors.grey,
                               ),
                             ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.addItem(product);
                          Get.snackbar(
                            'Başarılı!',
                            '${product.name} sepete eklendi',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(0xFF53B175),
                            colorText: Colors.white,
                            duration: const Duration(seconds: 2),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF53B175),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getProductIcon(String productName) {
    final name = productName.toLowerCase();
    if (name.contains('banana')) return Icons.eco;
    if (name.contains('apple')) return Icons.apple;
    if (name.contains('milk')) return Icons.local_drink;
    if (name.contains('bread')) return Icons.flatware;
    if (name.contains('egg')) return Icons.egg;
    if (name.contains('tomato')) return Icons.eco;
    if (name.contains('chicken')) return Icons.restaurant;
    if (name.contains('rice')) return Icons.grain;
    return Icons.shopping_bag;
  }
} 