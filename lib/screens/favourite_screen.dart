import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';

class FavouriteScreen extends GetView<ProductController> {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoriler'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: Color(0xFF53B175),
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Favori Ürünleriniz',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Favourite Products
          Expanded(
            child: GetBuilder<ProductController>(
              builder: (controller) {
                print('Favoriler sayfası güncellendi: ${controller.favouriteProductIds.length} ürün'); // Debug için
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
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: controller.favouriteProducts.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: controller.favouriteProducts[index],
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
} 