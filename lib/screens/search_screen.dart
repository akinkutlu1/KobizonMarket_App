import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/product_card.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'cart_screen.dart';
import 'favourite_screen.dart';
import 'profile_screen.dart';
import 'filter_screen.dart';

class SearchScreen extends StatefulWidget {
  final String searchQuery;

  const SearchScreen({
    super.key,
    required this.searchQuery,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Filter state
  List<String> selectedCategories = [];
  List<String> selectedBrands = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arama'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Search Bar with Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Search Bar
                Expanded(
                  child: Container(
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
                           child: Text(
                             widget.searchQuery,
                             style: const TextStyle(
                               fontSize: 16,
                               color: Colors.black87,
                             ),
                           ),
                         ),
                        GestureDetector(
                          onTap: () {
                            // Clear search and go back
                            Get.back();
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Filter Button
                GestureDetector(
                  onTap: () async {
                    final result = await Get.to(() => FilterScreen(
                      searchQuery: widget.searchQuery,
                      initialCategories: selectedCategories,
                      initialBrands: selectedBrands,
                    ));
                    
                    if (result != null) {
                      selectedCategories = result['categories'] ?? [];
                      selectedBrands = result['brands'] ?? [];
                      // Trigger rebuild to show filtered results
                      setState(() {});
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF53B175),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.tune,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Search Results
          Expanded(
            child: Builder(
              builder: (context) {
                final productController = Get.find<ProductController>();
                final products = selectedCategories.isNotEmpty || selectedBrands.isNotEmpty
                    ? productController.searchProductsWithFilters(
                        widget.searchQuery, selectedCategories, selectedBrands)
                    : productController.searchProducts(widget.searchQuery);
                
                if (products.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Aradığınız ürün bulunamadı',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Farklı anahtar kelimeler deneyin',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '${products.length} ürün bulundu',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
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
    );
  }
} 