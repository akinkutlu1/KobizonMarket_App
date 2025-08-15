import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/sample_data.dart';

class CartController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final RxMap<String, CartItem> _items = <String, CartItem>{}.obs;

  Map<String, CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }

  @override
  void onInit() {
    super.onInit();
    // Kullanıcı oturum durumunu dinle
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _loadCartFromFirebase(user.uid);
      } else {
        _items.clear();
      }
    });
  }

  // Firebase'den sepet verilerini yükle
  Future<void> _loadCartFromFirebase(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).collection('cart').get();
      final Map<String, CartItem> loadedItems = {};
      
      for (var doc in doc.docs) {
        final data = doc.data();
        final productId = data['productId'];
        final quantity = data['quantity'] ?? 1;
        
        // SampleData'dan ürün bilgilerini al
        final product = SampleData.products.firstWhere(
          (product) => product.id == productId,
          orElse: () => Product(
            id: productId,
            name: 'Ürün Bulunamadı',
            description: '',
            price: 0.0,
            imageUrl: '',
            category: '',
            categoryId: 0,
          ),
        );
        
        loadedItems[productId] = CartItem(
          product: product,
          quantity: quantity,
        );
      }
      
      _items.assignAll(loadedItems);
      print('Sepet Firebase\'den yüklendi: ${_items.length} ürün');
    } catch (e) {
      print('Sepet yüklenirken hata: $e');
    }
  }

  // Firebase'e sepet verilerini kaydet
  Future<void> _saveCartToFirebase() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final batch = _firestore.batch();
      
      // Mevcut sepet verilerini temizle
      final existingDocs = await _firestore.collection('users').doc(user.uid).collection('cart').get();
      for (var doc in existingDocs.docs) {
        batch.delete(doc.reference);
      }
      
      // Yeni sepet verilerini ekle (sadece ID ve quantity)
      _items.forEach((productId, cartItem) {
        final docRef = _firestore.collection('users').doc(user.uid).collection('cart').doc(productId);
        batch.set(docRef, {
          'productId': productId,
          'quantity': cartItem.quantity,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
      
      await batch.commit();
      print('Sepet Firebase\'e kaydedildi');
    } catch (e) {
      print('Sepet kaydedilirken hata: $e');
    }
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(product: product),
      );
    }
    _saveCartToFirebase();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    _saveCartToFirebase();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    _saveCartToFirebase();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
    } else if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: quantity,
        ),
      );
      _saveCartToFirebase();
    }
  }

  void clear() {
    _items.clear();
    _saveCartToFirebase();
  }
} 