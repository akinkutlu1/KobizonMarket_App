import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/product_card.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'favourite_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

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
      bottomNavigationBar: Obx(() {
        final navigationController = Get.find<NavigationController>();
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: navigationController.currentIndex,
          onTap: (index) {
            navigationController.changePage(index);
            switch (index) {
              case 0:
                Get.offAll(() => const HomeScreen());
                break;
              case 1:
                Get.offAll(() => const CategoriesScreen());
                break;
              case 2:
                Get.offAll(() => const FavouriteScreen());
                break;
              case 3:
                Get.offAll(() => const CartScreen());
                break;
              case 4:
                Get.offAll(() => const ProfileScreen());
                break;
            }
          },
          selectedItemColor: const Color(0xFF53B175),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Keşfet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favoriler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Sepet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Hesap',
            ),
          ],
        );
      }),
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