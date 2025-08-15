import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/order_controller.dart';
import 'order_success_screen.dart';
import 'order_failed_screen.dart';
import 'payment_method_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPaymentMethod = 'MC';

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text(
                  'Ödeme',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(
                    Icons.close,
                    size: 28,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          
          // Checkout Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Delivery
                _buildCheckoutRow(
                  title: 'Teslimat',
                  subtitle: 'Yöntem Seç',
                  onTap: () {
                    // TODO: Implement delivery method selection
                  },
                ),
                
                const SizedBox(height: 16),
                
                                 // Payment
                 _buildCheckoutRow(
                   title: 'Ödeme',
                   subtitle: '',
                   onTap: () {
                     Get.bottomSheet(
                       PaymentMethodScreen(
                         onPaymentMethodSelected: (method) {
                           setState(() {
                             selectedPaymentMethod = method == 'Kredi Kartı' ? 'MC' : 'Diğer';
                           });
                         },
                       ),
                       isScrollControlled: true,
                       backgroundColor: Colors.transparent,
                     );
                   },
                   trailing: Container(
                     width: 40,
                     height: 25,
                     decoration: BoxDecoration(
                       color: selectedPaymentMethod == 'MC' ? Colors.orange : Colors.green,
                       borderRadius: BorderRadius.circular(4),
                     ),
                     child: Center(
                       child: Text(
                         selectedPaymentMethod,
                         style: const TextStyle(
                           color: Colors.white,
                           fontSize: 12,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ),
                   ),
                 ),
                
                const SizedBox(height: 16),
                
                // Promo Code
                _buildCheckoutRow(
                  title: 'Promosyon Kodu',
                  subtitle: 'İndirim Seç',
                  onTap: () {
                    // TODO: Implement promo code selection
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Total Cost
                _buildCheckoutRow(
                  title: 'Toplam Tutar',
                  subtitle: '₺${cartController.totalAmount.toStringAsFixed(2)}',
                  onTap: () {
                    // TODO: Show detailed breakdown
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Terms and Conditions
                const Text(
                  'Sipariş vererek şunları kabul etmiş olursunuz',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    // TODO: Show terms and conditions
                  },
                  child: const Text(
                    'Şartlar Ve Koşullar',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF53B175),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                                                           onPressed: () async {
                    // Check payment method and process order
                    if (selectedPaymentMethod == 'MC') {
                      try {
                        final orderController = Get.find<OrderController>();
                        final cartController = Get.find<CartController>();
                        
                        // Sipariş oluştur
                        await orderController.createOrder(
                          items: cartController.items.values.toList(),
                          totalAmount: cartController.totalAmount,
                          deliveryAddress: 'Teslimat Adresi', // TODO: Gerçek adres al
                          paymentMethod: 'Kredi Kartı',
                        );
                        
                        // Sepeti temizle
                        cartController.clear();
                        
                        // Başarı ekranına git
                        Get.back();
                        Get.offAll(() => const OrderSuccessScreen());
                      } catch (e) {
                        print('Sipariş oluşturulurken hata: $e');
                        Get.back();
                        Get.offAll(() => const OrderFailedScreen());
                      }
                    } else {
                      // Başarısız ekranına git
                      Get.back();
                      Get.offAll(() => const OrderFailedScreen());
                    }
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF53B175),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Sipariş Ver',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutRow({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              trailing,
              const SizedBox(width: 8),
            ],
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
} 