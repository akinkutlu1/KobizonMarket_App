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
  final RxList<Product> _mostClickedProducts = <Product>[].obs;

  List<Product> get products => _products;
  String get selectedCategory => _selectedCategory.value;
  String get searchQuery => _searchQuery.value;
  Set<String> get favouriteProductIds => _favouriteProductIds;
  
  RxList<Product> get favouriteProducts => _favouriteProducts;
  RxList<Product> get mostClickedProducts => _mostClickedProducts;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    loadMostClickedProducts();
    
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

  // En çok tıklanan ürünleri yükle
  Future<void> loadMostClickedProducts() async {
    try {
      final snapshot = await _firestore.collection('product_clicks').orderBy('clickCount', descending: true).limit(6).get();
      final List<Product> mostClicked = [];
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final productId = data['productId'] as String;
        
        // SampleData'dan ürünü bul
        final product = _products.firstWhere(
          (p) => p.id == productId,
          orElse: () => _products.first, // Eğer bulunamazsa ilk ürünü kullan
        );
        
        mostClicked.add(product);
      }
      
      // Eğer Firebase'de veri yoksa, varsayılan olarak ilk 6 ürünü göster
      if (mostClicked.isEmpty && _products.isNotEmpty) {
        mostClicked.addAll(_products.take(6));
      }
      
      _mostClickedProducts.assignAll(mostClicked);
      print('En çok tıklanan ürünler yüklendi: ${mostClicked.length} ürün');
    } catch (e) {
      print('En çok tıklanan ürünler yüklenirken hata: $e');
      // Hata durumunda varsayılan olarak ilk 6 ürünü göster
      if (_products.isNotEmpty) {
        _mostClickedProducts.assignAll(_products.take(6));
      }
    }
  }

  // Ürün tıklama sayısını artır
  Future<void> incrementProductClick(String productId) async {
    try {
      final docRef = _firestore.collection('product_clicks').doc(productId);
      
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        
        if (doc.exists) {
          final currentCount = doc.data()!['clickCount'] ?? 0;
          transaction.update(docRef, {'clickCount': currentCount + 1});
        } else {
          transaction.set(docRef, {
            'productId': productId,
            'clickCount': 1,
            'lastClicked': FieldValue.serverTimestamp(),
          });
        }
      });
      
      print('Ürün tıklama sayısı artırıldı: $productId');
      
      // Tıklama sonrası en çok tıklanan ürünleri yeniden yükle
      await loadMostClickedProducts();
    } catch (e) {
      print('Ürün tıklama sayısı artırılırken hata: $e');
    }
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
    List<Product> filteredProducts;
    if (query.isEmpty) {
      filteredProducts = List<Product>.from(SampleData.products);
    } else {
      filteredProducts = SampleData.products.where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase()) ||
        product.description.toLowerCase().contains(query.toLowerCase()) ||
        product.category.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }

    // Kategori filtresi
    if (categories.isNotEmpty) {
      String normalize(String input) {
        String s = input.toLowerCase();
        s = s.replaceAll(' ', '').replaceAll('&', '');
        s = s
          .replaceAll('ğ', 'g')
          .replaceAll('ü', 'u')
          .replaceAll('ş', 's')
          .replaceAll('ı', 'i')
          .replaceAll('ö', 'o')
          .replaceAll('ç', 'c')
          .replaceAll('â', 'a')
          .replaceAll('î', 'i')
          .replaceAll('û', 'u');
        return s;
      }

      final Set<String> normalized = categories.map(normalize).toSet();

      bool matchesSelectedCategories(Product product) {
        bool include = false;
        if (normalized.contains('meyvesebzeler')) {
          include = include || product.categoryId == 1 || product.categoryId == 2;
        }
        if (normalized.contains('yaglar')) {
          include = include || product.categoryId == 7;
        }
        if (normalized.contains('etbalik')) {
          include = include || product.categoryId == 4;
        }
        if (normalized.contains('unlumamuller')) {
          include = include || product.categoryId == 5;
        }
        if (normalized.contains('suturunleri')) {
          include = include || product.categoryId == 3;
        }
        if (normalized.contains('icecekler')) {
          include = include || product.categoryId == 8;
        }

        if (!include) {
          include = categories.any((category) =>
            product.category.toLowerCase().contains(category.toLowerCase()));
        }
        return include;
      }

      filteredProducts = filteredProducts.where(matchesSelectedCategories).toList();
    }

    // Marka filtresi kaldırıldı / şimdilik kullanılmıyor

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