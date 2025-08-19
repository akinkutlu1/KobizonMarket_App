import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'controllers/cart_controller.dart';
import 'controllers/product_controller.dart';
import 'controllers/navigation_controller.dart';
import 'controllers/location_controller.dart';
import 'controllers/order_controller.dart';
import 'controllers/user_data_controller.dart';
import 'services/auth_service.dart';
import 'services/support_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Firebase'i başlat
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase başarıyla başlatıldı');
  } catch (e) {
    print('Firebase başlatılırken hata: $e');
  }
  
  // Controllers'ları başlat
  Get.put(CartController());
  Get.put(ProductController());
  Get.put(NavigationController());
  Get.put(LocationController());
  Get.put(OrderController());
  Get.put(UserDataController());
  Get.put(AuthService());
  Get.put(SupportService());
  
  runApp(const GroceriesApp());
}

class GroceriesApp extends StatelessWidget {
  const GroceriesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kobizon Market',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF53B175),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
