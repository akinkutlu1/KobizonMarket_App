import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/product_card.dart';
import 'category_products_screen.dart';
import 'search_screen.dart';
import 'home_screen.dart';
import 'favourite_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class CategoriesScreen extends GetView<ProductController> {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Kategoriler',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Mağazada Ara',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            Get.to(() => SearchScreen(searchQuery: value.trim()));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Categories Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildCategoryCard(
                      title: 'Meyve sebzeler',
                      imagePath: 'assets/images/pngfuel6.png',
                      backgroundColor: const Color(0xFFF0F8F0),
                      onTap: () => _navigateToCategory(0, 'Taze Meyve & Sebze'), // 0 = Tüm meyve ve sebzeler
                    ),
                    _buildCategoryCard(
                      title: 'Yağlar',
                      imagePath: 'assets/images/pngfuel8.png',
                      backgroundColor: const Color(0xFFFFF8F0),
                      onTap: () => _navigateToCategory(7, 'Yemeklik Yağ & Sade Yağ'),
                    ),
                    _buildCategoryCard(
                      title: 'Et & Balık',
                      imagePath: 'assets/images/pngfuel9.png',
                      backgroundColor: const Color(0xFFFFF0F0),
                      onTap: () => _navigateToCategory(4, 'Et & Balık'),
                    ),
                    _buildCategoryCard(
                      title: 'Unlu Mamüller',
                      imagePath: 'assets/images/pngfuel7.png',
                      backgroundColor: const Color(0xFFF8F0FF),
                      onTap: () => _navigateToCategory(5, 'Fırın & Atıştırmalıklar'),
                    ),
                    _buildCategoryCard(
                      title: 'Süt Ürünleri',
                      imagePath: 'assets/images/pngfuel5.png',
                      backgroundColor: const Color(0xFFFFFEE0),
                      onTap: () => _navigateToCategory(3, 'Süt Ürünleri & Yumurta'),
                    ),
                    _buildCategoryCard(
                      title: 'İçecekler',
                      imagePath: 'assets/images/pngfuel4.png',
                      backgroundColor: const Color(0xFFF0F8FF),
                      onTap: () => _navigateToCategory(8, 'İçecekler'),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                // Categories - already here
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
    );
  }

  void _navigateToCategory(int categoryId, String categoryTitle) {
    Get.to(() => CategoryProductsScreen(
      categoryId: categoryId,
      categoryTitle: categoryTitle,
    ));
  }

  Widget _buildCategoryCard({
    required String title,
    required String imagePath,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Category Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            // Category Title
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


} 