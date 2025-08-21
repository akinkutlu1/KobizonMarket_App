import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/location_controller.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/category_card.dart';
import '../models/product.dart';
import 'location_screen.dart';
import 'product_detail_screen.dart';
import 'search_screen.dart';
import 'categories_screen.dart';
import 'favourite_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'most_viewed_screen.dart';
import 'featured_products_screen.dart';
import 'chatbot_screen.dart';

class HomeScreen extends GetView<ProductController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sayfa açıldığında en çok tıklanan ürünleri yeniden yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadMostClickedProducts();
    });
    final TextEditingController _searchController = TextEditingController();
    final PageController _pageController = PageController();
    final RxInt _currentPage = 0.obs;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            controller.loadProducts();
            await controller.loadMostClickedProducts();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Logo, Location and Chatbot
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side - Logo and Location
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo
                          Row(
                            children: [
                              const SizedBox(width: 23),
                              Image.asset(
                                'assets/images/havuc.png',
                                width: 40,
                                height: 40,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          // Location
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const LocationScreen());
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.black87,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Obx(() => Text(
                                  Get.find<LocationController>().currentLocation.value,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Right side - Chatbot
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const ChatbotScreen());
                        },
                        child: Image.asset(
                          'assets/images/chatbot.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF4ECDC4),
                        width: 1,
                      ),
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
                              hintText: 'Mağazada ara',
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

                  const SizedBox(height: 20),

                  // Fresh Vegetables Banner with PageView
                  Container(
                    width: double.infinity,
                    height: 115,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: 3,
                      onPageChanged: (index) {
                        _currentPage.value = index;
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300, width: 1),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF53B175), Colors.white],
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/${index + 1}.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Page Indicators (Banner'ın altında)
                  Obx(() => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == _currentPage.value ? const Color(0xFF53B175) : Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )),
                    ),
                  )),

                  const SizedBox(height: 24),

                  // En Çok Görüntülenenler
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'En Çok Görüntülenenler',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const MostViewedScreen());
                        },
                        child: const Text(
                          'Tümünü Gör',
                          style: TextStyle(
                            color: Color(0xFF53B175),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Obx(() {
                    final mostClickedProducts = controller.mostClickedProducts;
                    if (mostClickedProducts.isEmpty) {
                      return const SizedBox(
                        height: 170,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    
                    return SizedBox(
                      height: 170,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mostClickedProducts.length,
                        itemBuilder: (context, index) {
                          final product = mostClickedProducts[index];
                          return Padding(
                            padding: EdgeInsets.only(right: index < mostClickedProducts.length - 1 ? 16 : 0),
                            child: _buildProductCard(product),
                          );
                        },
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Öne Çıkan Ürünler
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Öne Çıkan Ürünler',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const FeaturedProductsScreen());
                        },
                        child: const Text(
                          'Tümünü Gör',
                          style: TextStyle(
                            color: Color(0xFF53B175),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Öne Çıkan Ürünler
                  Obx(() {
                    final products = controller.products;
                    final featuredProducts = products.where((p) => p.rating >= 4.5).toList();
                    
                    // Random olarak 6 ürün seç
                    featuredProducts.shuffle();
                    final randomFeaturedProducts = featuredProducts.take(6).toList();
                    
                    if (randomFeaturedProducts.isEmpty) {
                      return const SizedBox(
                        height: 170,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    
                    return SizedBox(
                      height: 170,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: randomFeaturedProducts.length,
                        itemBuilder: (context, index) {
                          final product = randomFeaturedProducts[index];
                          return Padding(
                            padding: EdgeInsets.only(right: index < randomFeaturedProducts.length - 1 ? 16 : 0),
                            child: _buildProductCard(product),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        final navigationController = Get.find<NavigationController>();
        final cartController = Get.find<CartController>();
        final cartCount = cartController.itemCount;
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: navigationController.currentIndex,
          onTap: (index) {
            navigationController.changePage(index);
            switch (index) {
              case 0:
                // Home - already here
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
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Ana Sayfa',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Keşfet',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favoriler',
            ),
            BottomNavigationBarItem(
              icon: _buildCartIconWithBadge(cartCount),
              label: 'Sepet',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Hesap',
            ),
          ],
        );
      }),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        // Ürün tıklama sayısını artır
        controller.incrementProductClick(product.id);
        Get.to(() => ProductDetailScreen(product: product));
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          controller.toggleFavorite(product.id);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Obx(() => Icon(
                            controller.favouriteProductIds.contains(product.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 16,
                            color: controller.favouriteProductIds.contains(product.id)
                                ? Colors.red
                                : Colors.grey,
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${product.unit}, ${product.category}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₺${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF53B175),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Add to cart functionality
                            final cartController = Get.find<CartController>();
                            
                            cartController.addItem(product);
                            Get.snackbar(
                              'Başarılı!',
                              '${product.name} sepete eklendi',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: const Color(0xFF53B175),
                              colorText: Colors.white,
                              duration: const Duration(seconds: 1),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF53B175),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 12,
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
      ),
    );
  }


}

Widget _buildCartIconWithBadge(int count) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      const Icon(Icons.shopping_cart),
      if (count > 0)
        Positioned(
          right: -6,
          top: -4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 1),
            ),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
    ],
  );
}