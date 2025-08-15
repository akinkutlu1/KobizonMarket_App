import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String selectedMethod = 'credit_card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Ödeme Yöntemleri',
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ödeme Yönteminizi Seçin',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Payment Methods
            _buildPaymentMethod(
              id: 'credit_card',
              title: 'Kredi Kartı / Banka Kartı',
              subtitle: 'Visa, Mastercard, American Express',
              icon: Icons.credit_card,
              color: Colors.blue,
            ),
            
            const SizedBox(height: 12),
            
            _buildPaymentMethod(
              id: 'paypal',
              title: 'PayPal',
              subtitle: 'Güvenli online ödeme',
              icon: Icons.payment,
              color: Colors.indigo,
            ),
            
            const SizedBox(height: 12),
            
            _buildPaymentMethod(
              id: 'cash',
              title: 'Kapıda Ödeme',
              subtitle: 'Nakit veya kart ile teslimatta ödeme',
              icon: Icons.money,
              color: Colors.green,
            ),
            
            const SizedBox(height: 12),
            
            _buildPaymentMethod(
              id: 'bank_transfer',
              title: 'Banka Havalesi',
              subtitle: 'EFT/Havale ile ödeme',
              icon: Icons.account_balance,
              color: Colors.orange,
            ),
            
            const Spacer(),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Get.snackbar(
                    'Başarılı',
                    'Ödeme yöntemi kaydedildi',
                    backgroundColor: const Color(0xFF53B175),
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
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
                  'Kaydet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Security Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF53B175).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF53B175).withOpacity(0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.security,
                    color: Color(0xFF53B175),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tüm ödemeleriniz SSL şifreleme ile korunmaktadır.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF53B175),
                      ),
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

  Widget _buildPaymentMethod({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = selectedMethod == id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF53B175).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF53B175) : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xFF53B175) : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? const Color(0xFF53B175).withOpacity(0.8) : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF53B175),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
