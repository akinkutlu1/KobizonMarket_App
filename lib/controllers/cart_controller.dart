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
  
  // Promosyon kodu desteği
  final RxString _appliedPromoCode = ''.obs;
  final RxDouble _discountAmount = 0.0.obs;
  final RxBool _isPromoCodeValid = false.obs;
  
  // Kargo ücreti
  final RxDouble _shippingCost = 15.0.obs; // Varsayılan kargo ücreti

  Map<String, CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }
  
  // Kargo ücreti dahil toplam tutar
  double get totalAmountWithShipping => totalAmount + _shippingCost.value;

  // İndirim sonrası toplam tutar (kargo dahil)
  double get finalTotalAmount => totalAmountWithShipping - _discountAmount.value;
  
  // Kargo ücreti
  double get shippingCost => _shippingCost.value;
  
  // Kargo ücreti ayarla
  void setShippingCost(double cost) {
    _shippingCost.value = cost;
    _validatePromoCode(); // Kargo ücreti değişince promosyon kodunu kontrol et
  }
  
  // Sipariş tutarına göre kargo ücretini hesapla
  void calculateShippingCost() {
    if (totalAmount >= 150.0) {
      // 150 TL üzeri siparişlerde ücretsiz kargo
      _shippingCost.value = 0.0;
    } else if (totalAmount >= 100.0) {
      // 100-150 TL arası siparişlerde 5 TL kargo
      _shippingCost.value = 5.0;
    } else {
      // 100 TL altı siparişlerde 15 TL kargo
      _shippingCost.value = 15.0;
    }
    _validatePromoCode(); // Kargo ücreti değişince promosyon kodunu kontrol et
  }

  // Uygulanan promosyon kodu
  String get appliedPromoCode => _appliedPromoCode.value;
  
  // İndirim tutarı
  double get discountAmount => _discountAmount.value;
  
  // Promosyon kodu geçerli mi
  bool get isPromoCodeValid => _isPromoCodeValid.value;

  // Promosyon kodu uygula
  Future<bool> applyPromoCode(String code) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      // Kodu büyük harfe çevir
      final upperCode = code.trim().toUpperCase();
      
      // KOBIZON100 kodu kontrolü
      if (upperCode == 'KOBIZON100') {
        // Kullanıcının bu kodu daha önce kullanıp kullanmadığını kontrol et
        final promoDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('used_promo_codes')
            .doc(upperCode)
            .get();
        
        if (promoDoc.exists) {
          print('KOBIZON100 kodu zaten kullanılmış');
          return false;
        }
        
        // Sepet tutarı 100 TL üzerinde mi kontrol et
        if (totalAmountWithShipping < 100.0) {
          print('Sepet tutarı 100 TL altında: ${totalAmountWithShipping}');
          return false;
        }
        
        // Kodu kullanıldı olarak işaretle
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('used_promo_codes')
            .doc(upperCode)
            .set({
          'code': upperCode,
          'discountAmount': 100.0,
          'usedAt': FieldValue.serverTimestamp(),
          'minOrderAmount': 100.0,
          'orderAmount': totalAmountWithShipping,
        });
        
        // İndirimi uygula
        _appliedPromoCode.value = upperCode;
        _discountAmount.value = 100.0;
        _isPromoCodeValid.value = true;
        
        print('KOBIZON100 kodu başarıyla uygulandı. İndirim: 100 TL');
        return true;
      }
      
      return false;
    } catch (e) {
      print('Promosyon kodu uygulanırken hata: $e');
      return false;
    }
  }

  // Promosyon kodunu kaldır
  void removePromoCode() {
    _appliedPromoCode.value = '';
    _discountAmount.value = 0.0;
    _isPromoCodeValid.value = false;
    print('Promosyon kodu kaldırıldı');
  }

  // Promosyon kodu bilgilerini yükle
  Future<void> _loadPromoCodeInfo() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Kullanıcının daha önce kullandığı promosyon kodlarını kontrol et
      final promoDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('used_promo_codes')
          .doc('KOBIZON100')
          .get();
      
      if (promoDoc.exists) {
        final data = promoDoc.data()!;
        print('KOBIZON100 kodu daha önce kullanılmış: ${data['usedAt']}');
        // Kodu kullanıldı olarak işaretle (UI'da gösterilmeyecek)
        _appliedPromoCode.value = 'USED';
        _discountAmount.value = 0.0;
        _isPromoCodeValid.value = false;
      } else {
        print('KOBIZON100 kodu henüz kullanılmamış');
        _appliedPromoCode.value = '';
        _discountAmount.value = 0.0;
        _isPromoCodeValid.value = false;
      }
    } catch (e) {
      print('Promosyon kodu bilgileri yüklenirken hata: $e');
      // Hata durumunda varsayılan olarak kullanılmamış kabul et
      _appliedPromoCode.value = '';
      _discountAmount.value = 0.0;
      _isPromoCodeValid.value = false;
    }
  }

  // Promosyon kodunun geçerliliğini kontrol et
  void _validatePromoCode() {
    if (_isPromoCodeValid.value && _appliedPromoCode.value.isNotEmpty) {
      // Eğer promosyon kodu uygulanmışsa ve sepet tutarı 100 TL altına düştüyse
      if (totalAmountWithShipping < 100.0) {
        print('Sepet tutarı 100 TL altına düştü, promosyon kodu geçersiz: ${totalAmountWithShipping}');
        // Promosyon kodunu geçersiz yap
        _appliedPromoCode.value = '';
        _discountAmount.value = 0.0;
        _isPromoCodeValid.value = false;
        
        // Firebase'den kodu kaldır (tekrar kullanılabilir hale getir)
        _removePromoCodeFromFirebase();
      }
    }
  }
  
  // Firebase'den promosyon kodunu kaldır
  Future<void> _removePromoCodeFromFirebase() async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('used_promo_codes')
          .doc(_appliedPromoCode.value)
          .delete();
      print('Promosyon kodu Firebase\'den kaldırıldı');
    } catch (e) {
      print('Promosyon kodu Firebase\'den kaldırılırken hata: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Kullanıcı oturum durumunu dinle
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _loadCartFromFirebase(user.uid);
        _loadPromoCodeInfo(); // Promosyon kod bilgilerini yükle
      } else {
        _items.clear();
        _appliedPromoCode.value = '';
        _discountAmount.value = 0.0;
        _isPromoCodeValid.value = false;
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
      calculateShippingCost(); // Kargo ücretini hesapla
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
    calculateShippingCost(); // Kargo ücretini hesapla
    _validatePromoCode(); // Promosyon kodunu kontrol et
  }

  void removeItem(String productId) {
    _items.remove(productId);
    _saveCartToFirebase();
    calculateShippingCost(); // Kargo ücretini hesapla
    _validatePromoCode(); // Promosyon kodunu kontrol et
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
    calculateShippingCost(); // Kargo ücretini hesapla
    _validatePromoCode(); // Promosyon kodunu kontrol et
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
      calculateShippingCost(); // Kargo ücretini hesapla
      _validatePromoCode(); // Promosyon kodunu kontrol et
    }
  }

  void clear() {
    _items.clear();
    _saveCartToFirebase();
  }

  // Sipariş tamamlandığında promosyon kodunu kaldır
  void clearAfterOrder() {
    _items.clear();
    // Promosyon kodu kalıcı olarak kullanıldı, bu yüzden kaldırmıyoruz
    // _appliedPromoCode.value = '';
    // _discountAmount.value = 0.0;
    // _isPromoCodeValid.value = false;
    _saveCartToFirebase();
    print('Sipariş tamamlandı, sepet temizlendi. Promosyon kodu kalıcı olarak kullanıldı.');
  }
} 