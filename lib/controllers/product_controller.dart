import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../models/sample_data.dart';

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final RxList<Product> _products = <Product>[].obs;
  final RxString _selectedCategory = 'All'.obs;
  final RxString _searchQuery = ''.obs;
  final RxSet<String> _favouriteProductIds = <String>{}.obs;
  final RxList<Product> _favouriteProducts = <Product>[].obs;

  List<Product> get products => _products;
  String get selectedCategory => _selectedCategory.value;
  String get searchQuery => _searchQuery.value;
  Set<String> get favouriteProductIds => _favouriteProductIds;
  
  RxList<Product> get favouriteProducts => _favouriteProducts;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    
    // Kullanıcı oturum durumunu dinle
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _loadFavoritesFromFirebase(user.uid);
      } else {
        _favouriteProductIds.clear();
        _favouriteProducts.clear();
      }
    });
  }

  // Firebase'den favori ürünleri yükle
  Future<void> _loadFavoritesFromFirebase(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).collection('favorites').get();
      final Set<String> loadedFavorites = {};
      
      for (var doc in doc.docs) {
        final data = doc.data();
        loadedFavorites.add(data['productId']);
      }
      
      _favouriteProductIds.assignAll(loadedFavorites);
      _updateFavouriteProducts();
      print('Favoriler Firebase\'den yüklendi: ${_favouriteProductIds.length} ürün');
    } catch (e) {
      print('Favoriler yüklenirken hata: $e');
    }
  }

  // Firebase'e favori ürünleri kaydet
  Future<void> _saveFavoritesToFirebase() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final batch = _firestore.batch();
      
      // Mevcut favori verilerini temizle
      final existingDocs = await _firestore.collection('users').doc(user.uid).collection('favorites').get();
      for (var doc in existingDocs.docs) {
        batch.delete(doc.reference);
      }
      
      // Yeni favori verilerini ekle (sadece ID)
      _favouriteProductIds.forEach((productId) {
        final docRef = _firestore.collection('users').doc(user.uid).collection('favorites').doc(productId);
        batch.set(docRef, {
          'productId': productId,
          'addedAt': FieldValue.serverTimestamp(),
        });
      });
      
      await batch.commit();
      print('Favoriler Firebase\'e kaydedildi');
    } catch (e) {
      print('Favoriler kaydedilirken hata: $e');
    }
  }

  void loadProducts() {
    _products.assignAll(SampleData.products);
  }

  void setSelectedCategory(String category) {
    _selectedCategory.value = category;
    filterProducts();
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
    filterProducts();
  }

  void filterProducts() {
    List<Product> filteredProducts = SampleData.products;

    // Kategori filtresi
    if (_selectedCategory.value != 'All') {
      filteredProducts = filteredProducts
          .where((product) => product.category == _selectedCategory.value)
          .toList();
    }

    // Arama filtresi
    if (_searchQuery.value.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((product) =>
              product.name.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
              product.description.toLowerCase().contains(_searchQuery.value.toLowerCase()))
          .toList();
    }

    _products.assignAll(filteredProducts);
  }

  List<Product> getProductsByCategory(String category) {
    return SampleData.getProductsByCategory(category);
  }

  List<Product> getProductsByCategoryId(int categoryId) {
    if (categoryId == 0) {
      // Taze Meyve & Sebze kategorisi için hem meyve (1) hem sebze (2) ürünlerini getir
      return SampleData.products.where((product) => 
        product.categoryId == 1 || product.categoryId == 2).toList();
    }
    return SampleData.getProductsByCategoryId(categoryId);
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return [];
    
    return SampleData.products.where((product) =>
      product.name.toLowerCase().contains(query.toLowerCase()) ||
      product.description.toLowerCase().contains(query.toLowerCase()) ||
      product.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  List<Product> searchProductsWithFilters(String query, List<String> categories, List<String> brands) {
    if (query.isEmpty) return [];
    
    List<Product> filteredProducts = SampleData.products.where((product) =>
      product.name.toLowerCase().contains(query.toLowerCase()) ||
      product.description.toLowerCase().contains(query.toLowerCase()) ||
      product.category.toLowerCase().contains(query.toLowerCase())
    ).toList();

    // Kategori filtresi
    if (categories.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        return categories.any((category) => 
          product.category.toLowerCase().contains(category.toLowerCase()));
      }).toList();
    }

    // Marka filtresi (şimdilik basit bir kontrol)
    if (brands.isNotEmpty) {
      // Marka bilgisi olmadığı için şimdilik tüm ürünleri geçiriyoruz
      // Gelecekte Product modeline brand field'ı eklenebilir
    }

    return filteredProducts;
  }

  List<Product> getFeaturedProducts() {
    return SampleData.getFeaturedProducts();
  }

  List<String> get categories => SampleData.categories;

  void toggleFavorite(String productId) {
    if (_favouriteProductIds.contains(productId)) {
      _favouriteProductIds.remove(productId);
    } else {
      _favouriteProductIds.add(productId);
    }
    _updateFavouriteProducts();
    _saveFavoritesToFirebase();
    update(); // UI'ı güncelle
    print('Favoriler güncellendi: ${_favouriteProductIds.length} ürün');
  }

  void _updateFavouriteProducts() {
    print('_updateFavouriteProducts çağrıldı');
    print('Favori ID\'ler: $_favouriteProductIds');
    
    final filteredProducts = SampleData.products.where((product) => 
      _favouriteProductIds.contains(product.id)).toList();
    
    print('Filtrelenmiş ürünler: ${filteredProducts.map((p) => p.name).toList()}');
    
    _favouriteProducts.assignAll(filteredProducts);
    
    print('_favouriteProducts güncellendi: ${_favouriteProducts.length} ürün');
    print('Favori ürün isimleri: ${_favouriteProducts.map((p) => p.name).toList()}');
  }
  
  bool isFavorite(String productId) {
    return _favouriteProductIds.contains(productId);
  }

  // Reactive getter for favorite status
  RxBool isFavoriteReactive(String productId) {
    return _favouriteProductIds.contains(productId).obs;
  }
} 