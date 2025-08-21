import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/navigation_controller.dart';
import '../models/cart_item.dart';
import 'checkout_screen.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'favourite_screen.dart';
import 'profile_screen.dart';
import 'promo_code_screen.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepetim'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              controller.clear();
            },
          ),
        ],
      ),
      body: Obx(() => controller.items.isEmpty
          ? _buildEmptyCart()
          : _buildCartContent()),
      bottomNavigationBar: Obx(() {
        if (controller.items.isEmpty) {
          // Empty cart - show only navigation bar
          final navigationController = Get.find<NavigationController>();
          final cartCount = controller.itemCount;
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
                  // Cart - already here
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
        } else {
          // Cart has items - show checkout section with navigation
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCheckoutSection(),
              _buildNavigationBar(),
            ],
          );
        }
      }),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 60,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Sepetiniz boş',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sepetinize ürün ekleyin',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Get.find<NavigationController>().changePage(0);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF53B175),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Alışverişe Başla',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        Expanded(
          child: Obx(() => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final cartItem = controller.items.values.toList()[index];
              return _buildCartItem(cartItem);
            },
          )),
        ),
      ],
    );
  }

  Widget _buildCartItem(CartItem cartItem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          // Product Image
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFF8F9FA),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                cartItem.product.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      _getProductIcon(cartItem.product.name),
                      size: 35,
                      color: const Color(0xFF53B175),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₺${cartItem.product.price.toStringAsFixed(2)} / ${cartItem.product.unit}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '₺${cartItem.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF53B175),
                      ),
                    ),
                    const Spacer(),
                    // Quantity Controls
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              controller.removeSingleItem(cartItem.product.id);
                            },
                            icon: const Icon(Icons.remove, size: 20),
                            padding: const EdgeInsets.all(8),
                          ),
                          Text(
                            '${cartItem.quantity}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.addItem(cartItem.product);
                            },
                            icon: const Icon(Icons.add, size: 20),
                            padding: const EdgeInsets.all(8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sepet Toplamı
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sepet Toplamı:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '₺${controller.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            )),
            
            // Kargo Ücreti
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Kargo Ücreti:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '₺${controller.shippingCost.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            
            // Promosyon Kodu İndirimi
            Obx(() {
              if (controller.isPromoCodeValid) {
                return Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'İndirim (${controller.appliedPromoCode}):',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.green[700],
                          ),
                        ),
                        Text(
                          '-₺${controller.discountAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
            
            const SizedBox(height: 12),
            
            // Ödenecek Tutar
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ödenecek Tutar:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '₺${controller.finalTotalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF53B175),
                  ),
                ),
              ],
            )),
            
            // Promosyon Kodu Ekleme Butonu
            Obx(() {
              if (!controller.isPromoCodeValid) {
                return Column(
                  children: [
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Get.to(() => const PromoCodeScreen());
                        },
                        icon: const Icon(Icons.local_offer, color: Color(0xFF53B175)),
                        label: const Text(
                          'Promosyon Kodu Ekle',
                          style: TextStyle(
                            color: Color(0xFF53B175),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF53B175)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
            
            const SizedBox(height: 16),
            
            // Ödeme Butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.bottomSheet(
                    const CheckoutScreen(),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF53B175),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Ödeme Yap',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
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

  Widget _buildNavigationBar() {
    final navigationController = Get.find<NavigationController>();
    final cartCount = controller.itemCount;
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
            // Cart - already here
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
} 