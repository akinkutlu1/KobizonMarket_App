import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/location_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/category_card.dart';
import '../models/product.dart';
import 'location_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends GetView<ProductController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    final PageController _pageController = PageController();
    final RxInt _currentPage = 0.obs;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Logo and Location
                Column(
                  children: [
                    // Logo
                    Center(
                      child: Image.asset(
                        'assets/images/havuc.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Location
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const LocationScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                      const Text(
                        'Search Store',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
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

                // Exclusive Offer Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Exclusive Offer',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          color: Color(0xFF53B175),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Exclusive Products
                SizedBox(
                  height: 170,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildExclusiveProductCard(
                        imagePath: 'assets/images/muz.png',
                        title: 'Fresh Bananas',
                        subtitle: '7pcs, Priceg',
                        price: '\$4.99',
                      ),
                      const SizedBox(width: 16),
                      _buildExclusiveProductCard(
                        imagePath: 'assets/images/elma.png',
                        title: 'Fresh Apple',
                        subtitle: '1kg, Priceg',
                        price: '\$4.99',
                      ),
                      const SizedBox(width: 16),
                      _buildExclusiveProductCard(
                        imagePath: 'assets/images/zencefil.png',
                        title: 'Ginger & Mint',
                        subtitle: '250g, Priceg',
                        price: '\$3.99',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Best Selling Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Best Selling',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          color: Color(0xFF53B175),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Best Selling Products
                SizedBox(
                  height: 170,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildExclusiveProductCard(
                        imagePath: 'assets/images/biber1.png',
                        title: 'Bell Pepper',
                        subtitle: '1kg, Priceg',
                        price: '\$2.99',
                      ),
                      const SizedBox(width: 16),
                      _buildExclusiveProductCard(
                        imagePath: 'assets/images/zencefil.png',
                        title: 'Ginger & Mint',
                        subtitle: '500g, Priceg',
                        price: '\$5.99',
                      ),
                      const SizedBox(width: 16),
                      _buildExclusiveProductCard(
                        imagePath: 'assets/images/elma.png',
                        title: 'Fresh Apple',
                        subtitle: '1kg, Priceg',
                        price: '\$3.99',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExclusiveProductCard({
    required String imagePath,
    required String title,
    String? subtitle,
    required String price,
    String? size,
  }) {
    return GestureDetector(
      onTap: () {
        // Find product from SampleData
        final productController = Get.find<ProductController>();
        print('HomeScreen - Aranan ürün adı: $title');
        print('HomeScreen - Mevcut ürünler: ${productController.products.map((p) => p.name).toList()}');
        
        final product = productController.products.firstWhere(
          (p) => p.name == title,
          orElse: () {
            print('HomeScreen - Ürün bulunamadı, geçici ürün oluşturuluyor');
            return Product(
              id: 'temp_${title.hashCode}',
              name: title,
              description: subtitle ?? '',
              price: double.tryParse(price.replaceAll('\$', '')) ?? 0.0,
              imageUrl: imagePath,
              category: 'Exclusive',
              categoryId: 1, // Geçici ürün için varsayılan kategori ID
              unit: subtitle?.split(', ').last ?? 'piece',
            );
          },
        );
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
                        imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                    if (size != null)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            size,
                            style: const TextStyle(
                              fontSize: 8,
                              color: Colors.white,
                            ),
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
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 1),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          price,
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
                            final productController = Get.find<ProductController>();
                            
                            // Find the product from SampleData
                            final product = productController.products.firstWhere(
                              (p) => p.name == title,
                              orElse: () => Product(
                                id: 'temp_${title.hashCode}',
                                name: title,
                                description: subtitle ?? '',
                                price: double.tryParse(price.replaceAll('\$', '')) ?? 0.0,
                                imageUrl: imagePath,
                                category: 'Exclusive',
                                categoryId: 1, // Geçici ürün için varsayılan kategori ID
                                unit: subtitle?.split(', ').last ?? 'piece',
                              ),
                            );
                            
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