import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

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
                          // TODO: Implement payment method selection
                        },
                        trailing: Container(
                          width: 40,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: Text(
                              'MC',
                              style: TextStyle(
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
                          onPressed: () {
                            // TODO: Implement place order
                            Get.snackbar(
                              'Başarılı!',
                              'Siparişiniz alındı',
                              backgroundColor: const Color(0xFF53B175),
                              colorText: Colors.white,
                              duration: const Duration(seconds: 1),
                            );
                            Get.back();
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