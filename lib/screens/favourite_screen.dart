import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';

class FavouriteScreen extends GetView<ProductController> {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorurite'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: GetBuilder<ProductController>(
        builder: (controller) {
          print('Favoriler sayfası güncellendi: ${controller.favouriteProductIds.length} ürün');
          print('Favori ürünler listesi: ${controller.favouriteProducts.length} ürün');
          print('Favori ürün isimleri: ${controller.favouriteProducts.map((p) => p.name).toList()}');
          
          return controller.favouriteProducts.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Henüz favori ürününüz yok',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Ürünlere kalp ikonuna tıklayarak\nfavorilerinize ekleyebilirsiniz',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Favourite Products List
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.favouriteProducts.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final product = controller.favouriteProducts[index];
                          return _buildFavouriteItem(product);
                        },
                      ),
                    ),
                    
                    // Add All To Cart Button
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _addAllToCart(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF53B175),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Add All To Cart',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildFavouriteItem(product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey[100],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                product.imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 16,
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.unit}, Price',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          // Price and Arrow
          Row(
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addAllToCart() {
    final cartController = Get.find<CartController>();
    final productController = Get.find<ProductController>();
    
    // Önce tüm favori ürünlerin ID'lerini bir listeye al
    final favouriteProductIds = List<String>.from(productController.favouriteProductIds);
    
    // Tüm favori ürünleri sepete ekle
    for (final product in productController.favouriteProducts) {
      cartController.addItem(product);
    }
    
    // Tüm favori ürünleri favorilerden kaldır (ID listesini kullan)
    for (final productId in favouriteProductIds) {
      productController.toggleFavorite(productId);
    }
    
    Get.snackbar(
      'Başarılı!',
      'Tüm favori ürünler sepete eklendi ve favorilerden kaldırıldı',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF53B175),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
} 