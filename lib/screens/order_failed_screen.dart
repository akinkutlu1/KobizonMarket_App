import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'favourite_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class OrderFailedScreen extends StatelessWidget {
  const OrderFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Spacer to push content to center
              const Spacer(),
              
              // Error Image
              Container(
                width: 200,
                height: 200,
                child: Image.asset(
                  'assets/images/error.png',
                  fit: BoxFit.contain,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Error Title
              const Text(
                'Oops! Sipariş Başarısız',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Error Description
              const Text(
                'Bir şeyler yanlış gitti.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
              
              // Try Again Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Go back to checkout
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF53B175),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Tekrar Dene',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Back to Home Button
              GestureDetector(
                onTap: () {
                  // Go to home
                  Get.find<NavigationController>().changePage(0);
                  Get.offAll(() => const HomeScreen());
                },
                child: const Text(
                  'Ana sayfaya dön',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
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