import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/product_card.dart';
import 'splash_screen.dart';

class CategoryProductsScreen extends GetView<ProductController> {
  final int categoryId;
  final String categoryTitle;

  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      bottomNavigationBar: GetBuilder<NavigationController>(
        builder: (controller) => BottomNavigationBar(
          currentIndex: controller.currentIndex,
          onTap: (index) {
            controller.changePage(index);
            switch (index) {
              case 0:
                Get.offAll(() => const MainScreen());
                break;
              case 1:
                Get.offAll(() => const MainScreen());
                break;
              case 2:
                Get.offAll(() => const MainScreen());
                break;
              case 3:
                Get.offAll(() => const MainScreen());
                break;
              case 4:
                Get.offAll(() => const MainScreen());
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF53B175),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: 'Market',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Keşfet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Sepet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favoriler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Hesap',
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (context) {
          final products = controller.getProductsByCategoryId(categoryId);
          
          if (products.isEmpty) {
            return const Center(
              child: Text(
                'Bu kategoride ürün bulunamadı',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          );
        },
      ),
    );
  }
} 