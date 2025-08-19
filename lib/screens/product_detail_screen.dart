import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    final productController = Get.find<ProductController>();
    isFavorite = productController.isFavorite(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () {
                      // Share functionality
                      Get.snackbar(
                        'Paylaş',
                        'Ürün paylaşıldı',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFF53B175),
                        colorText: Colors.white,
                      );
                    },
                    icon: const Icon(Icons.share, color: Colors.black),
                  ),
                ],
              ),
            ),

            // Product Image Section
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Product Image
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            widget.product.imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                                         const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Product Info Section
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                                             // Product Title and Favorite
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   widget.product.name,
                                   style: const TextStyle(
                                     fontSize: 24,
                                     fontWeight: FontWeight.bold,
                                     color: Colors.black87,
                                     decoration: TextDecoration.underline,
                                   ),
                                 ),
                                 const SizedBox(height: 4),
                                 Text(
                                   '${widget.product.unit}, Price',
                                   style: const TextStyle(
                                     fontSize: 16,
                                     color: Colors.grey,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                           GestureDetector(
                             onTap: () {
                               print('ProductDetailScreen - Tıklanan ürün ID: ${widget.product.id}');
                               print('ProductDetailScreen - Ürün adı: ${widget.product.name}');
                               setState(() {
                                 isFavorite = !isFavorite;
                               });
                               final productController = Get.find<ProductController>();
                               productController.toggleFavorite(widget.product.id);
                               
                                                               Get.snackbar(
                                  isFavorite ? 'Favorilere Eklendi' : 'Favorilerden Çıkarıldı',
                                  isFavorite ? 'Ürün favorilere eklendi' : 'Ürün favorilerden çıkarıldı',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: const Color(0xFF53B175),
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 1),
                                );
                             },
                             child: Icon(
                               isFavorite ? Icons.favorite : Icons.favorite_border,
                               color: isFavorite ? Colors.red : Colors.grey,
                               size: 28,
                             ),
                           ),
                         ],
                       ),

                      const SizedBox(height: 16),

                      // Quantity Selector and Price
                      Row(
                        children: [
                          // Quantity Selector
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.remove, color: Colors.grey),
                                ),
                                Container(
                                  width: 40,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$quantity',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  icon: const Icon(Icons.add, color: Color(0xFF53B175)),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          // Price
                          Text(
                            '₺${(widget.product.price * quantity).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF53B175),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Product Detail Section
                      _buildExpandableSection(
                        title: 'Ürün Hakkında',
                        content: '%100 taze ve organik olup, sağlığınız için hiçbir sakınca teşkil etmez.',
                      ),

                      const SizedBox(height: 12),

                      // Nutritions Section
                      _buildExpandableSection(
                        title: 'Miktar',
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '1000gr',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Review Section
                      _buildExpandableSection(
                        title: 'Ürün Puanı',
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (index) => const Icon(
                            Icons.star,
                            color: Colors.red,
                            size: 16,
                          )),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Add To Basket Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            final cartController = Get.find<CartController>();
                            // Add multiple items based on quantity
                            for (int i = 0; i < quantity; i++) {
                              cartController.addItem(widget.product);
                            }
                            
                                                         Get.snackbar(
                               'Başarılı!',
                               '${widget.product.name} sepete eklendi',
                               snackPosition: SnackPosition.BOTTOM,
                               backgroundColor: const Color(0xFF53B175),
                               colorText: Colors.white,
                               duration: const Duration(seconds: 1),
                             );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF53B175),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Sepete Ekle',
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    String? content,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: trailing ?? const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        children: content != null ? [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
          ),
        ] : <Widget>[],
      ),
    );
  }
} 