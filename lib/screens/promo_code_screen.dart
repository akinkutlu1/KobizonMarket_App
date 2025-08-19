import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class PromoCodeScreen extends StatefulWidget {
  const PromoCodeScreen({super.key});

  @override
  State<PromoCodeScreen> createState() => _PromoCodeScreenState();
}

class _PromoCodeScreenState extends State<PromoCodeScreen> {
  final TextEditingController _promoController = TextEditingController();
  final CartController _cartController = Get.find<CartController>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Promosyon Kodu',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Promo Code Input
            Container(
              padding: const EdgeInsets.all(20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Promosyon Kodunuz',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _promoController,
                    decoration: InputDecoration(
                      hintText: 'Kodunuzu buraya girin',
                      prefixIcon: const Icon(Icons.local_offer, color: Color(0xFF53B175)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF53B175), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _applyPromoCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF53B175),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Kodu Uygula',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Sepet Bilgileri
            Obx(() {
              if (_cartController.items.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.shopping_cart, color: Colors.blue[700]),
                          const SizedBox(width: 8),
                          Text(
                            'Sepet Bilgileri',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Sepet Toplamı:', style: TextStyle(fontSize: 16)),
                          Text(
                            '${_cartController.totalAmount.toStringAsFixed(2)} TL',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Kargo Ücreti:', style: TextStyle(fontSize: 16)),
                          Text(
                            '${_cartController.shippingCost.toStringAsFixed(2)} TL',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Toplam Tutar:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(
                            '${_cartController.totalAmountWithShipping.toStringAsFixed(2)} TL',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ],
                      ),
                      if (_cartController.isPromoCodeValid) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'İndirim (${_cartController.appliedPromoCode}):',
                              style: TextStyle(fontSize: 16, color: Colors.green[700]),
                            ),
                            Text(
                              '-${_cartController.discountAmount.toStringAsFixed(2)} TL',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[700]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Ödenecek Tutar:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(
                              '${_cartController.finalTotalAmount.toStringAsFixed(2)} TL',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF53B175)),
                            ),
                          ],
                        ),
                      ],
                      if (_cartController.totalAmountWithShipping < 100.0 && _cartController.totalAmountWithShipping > 0) ...[
                        const SizedBox(height: 8),
                        Text(
                          'KOBIZON100 kodu için minimum ${(100.0 - _cartController.totalAmountWithShipping).toStringAsFixed(2)} TL daha ürün ekleyin',
                          style: TextStyle(fontSize: 14, color: Colors.orange[700]),
                        ),
                      ],
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            
            const SizedBox(height: 24),
            
            // Special Offer Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B9D), Color(0xFF53B175)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.card_giftcard,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Özel İndirim',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '100 TL İndirim',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Kod: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF53B175),
                          ),
                        ),
                        Text(
                          'KOBIZON100',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF53B175),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '100 TL ve üzeri siparişlerde 100 TL indirim!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Her hesapta sadece bir kez kullanılabilir',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Applied Promo Code
            Obx(() {
              if (_cartController.isPromoCodeValid) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[700], size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Uygulanan Kod: ${_cartController.appliedPromoCode}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                            Text(
                              'İndirim: -${_cartController.finalTotalAmount.toStringAsFixed(2)} TL',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _cartController.removePromoCode();
                          Get.snackbar(
                            'Bilgi',
                            'Promosyon kodu kaldırıldı',
                            backgroundColor: Colors.blue,
                            colorText: Colors.white,
                          );
                        },
                        child: const Text('Kaldır'),
                      ),
                    ],
                  ),
                );
              } else if (_cartController.appliedPromoCode == 'USED') {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange[700], size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'KOBIZON100 Kodu Kullanıldı',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[700],
                              ),
                            ),
                            Text(
                              'Bu kodu daha önce kullandınız. Her hesapta sadece bir kez kullanılabilir.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            
            const SizedBox(height: 24),
            
            // Terms and Conditions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Şartlar ve Koşullar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• KOBIZON100 kodu her hesapta sadece bir kez kullanılabilir\n• Minimum sipariş tutarı 100 TL\'dir\n• İndirim tutarı 100 TL\'dir\n• Kodlar birleştirilemez\n• Geçerlilik süresi dolmuş kodlar kullanılamaz',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyPromoCode() async {
    final code = _promoController.text.trim();
    
    if (code.isEmpty) {
      Get.snackbar(
        'Hata',
        'Lütfen bir kod girin',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _cartController.applyPromoCode(code);
      
      if (success) {
        _promoController.clear();
        Get.snackbar(
          'Başarılı!',
          'KOBIZON100 kodu uygulandı. 100 TL indirim kazandınız!',
          backgroundColor: const Color(0xFF53B175),
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      } else {
        if (code.toUpperCase() == 'KOBIZON100') {
          if (_cartController.totalAmountWithShipping < 100.0) {
            Get.snackbar(
              'Hata',
              'KOBIZON100 kodu için minimum 100 TL sipariş tutarı gerekli (kargo dahil)',
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
          } else {
            Get.snackbar(
              'Hata',
              'Bu kodu zaten kullandınız',
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            'Hata',
            'Geçersiz promosyon kodu',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Kod uygulanırken bir hata oluştu: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }
}

