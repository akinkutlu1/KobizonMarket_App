import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/sample_data.dart';

class OrderController extends GetxController {
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final RxList<Order> _orders = <Order>[].obs;

  List<Order> get orders => _orders;

  @override
  void onInit() {
    super.onInit();
    // Kullanıcı oturum durumunu dinle
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _loadOrdersFromFirebase(user.uid);
      } else {
        _orders.clear();
      }
    });
  }

  // Firebase'den siparişleri yükle
  Future<void> _loadOrdersFromFirebase(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .orderBy('orderDate', descending: true)
          .get();

      final List<Order> loadedOrders = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        
        // Sipariş öğelerini CartItem'lara dönüştür
        final List<CartItem> orderItems = [];
        for (var itemData in data['items']) {
          final productId = itemData['productId'];
          final quantity = itemData['quantity'];
          
          // SampleData'dan ürün bilgilerini al
          final product = SampleData.products.firstWhere(
            (product) => product.id == productId,
            orElse: () => throw Exception('Ürün bulunamadı: $productId'),
          );
          
          orderItems.add(CartItem(
            product: product,
            quantity: quantity,
          ));
        }

        final order = Order.fromMap(data, orderItems);
        loadedOrders.add(order);
      }

      _orders.assignAll(loadedOrders);
      print('Siparişler Firebase\'den yüklendi: ${_orders.length} sipariş');
    } catch (e) {
      print('Siparişler yüklenirken hata: $e');
    }
  }

  // Yeni sipariş oluştur
  Future<void> createOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String deliveryAddress,
    required String paymentMethod,
    String? orderNotes,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();
      
      final order = Order(
        id: orderId,
        userId: user.uid,
        items: items,
        totalAmount: totalAmount,
        status: 'pending',
        orderDate: DateTime.now(),
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
        orderNotes: orderNotes,
      );

      // Firebase'e siparişi kaydet
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .doc(orderId)
          .set(order.toMap());

      // Siparişleri yeniden yükle
      await _loadOrdersFromFirebase(user.uid);
      
      print('Sipariş oluşturuldu: $orderId');
    } catch (e) {
      print('Sipariş oluşturulurken hata: $e');
      rethrow;
    }
  }

  // Sipariş durumunu güncelle
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .doc(orderId)
          .update({'status': newStatus});

      // Siparişleri yeniden yükle
      await _loadOrdersFromFirebase(user.uid);
      
      print('Sipariş durumu güncellendi: $orderId -> $newStatus');
    } catch (e) {
      print('Sipariş durumu güncellenirken hata: $e');
    }
  }

  // Siparişi iptal et
  Future<void> cancelOrder(String orderId) async {
    await updateOrderStatus(orderId, 'cancelled');
  }

  // Sipariş detaylarını al
  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Siparişleri duruma göre filtrele
  List<Order> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }
}
