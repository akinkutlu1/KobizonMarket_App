import 'package:get/get.dart';
import '../models/product.dart';
import '../models/sample_data.dart';

class ProductController extends GetxController {
  final RxList<Product> _products = <Product>[].obs;
  final RxString _selectedCategory = 'All'.obs;
  final RxString _searchQuery = ''.obs;
  final RxSet<int> _favouriteProductIds = <int>{}.obs;

  List<Product> get products => _products;
  String get selectedCategory => _selectedCategory.value;
  String get searchQuery => _searchQuery.value;
  Set<int> get favouriteProductIds => _favouriteProductIds;
  
  List<Product> get favouriteProducts {
    return SampleData.products.where((product) => 
      _favouriteProductIds.contains(int.tryParse(product.id))).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadProducts();
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

  List<Product> getFeaturedProducts() {
    return SampleData.getFeaturedProducts();
  }

  List<String> get categories => SampleData.categories;

  void toggleFavorite(int productId) {
    if (_favouriteProductIds.contains(productId)) {
      _favouriteProductIds.remove(productId);
    } else {
      _favouriteProductIds.add(productId);
    }
  }
  
  bool isFavorite(int productId) {
    return _favouriteProductIds.contains(productId);
  }
} 