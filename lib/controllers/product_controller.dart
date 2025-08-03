import 'package:get/get.dart';
import '../models/product.dart';
import '../models/sample_data.dart';

class ProductController extends GetxController {
  final RxList<Product> _products = <Product>[].obs;
  final RxString _selectedCategory = 'All'.obs;
  final RxString _searchQuery = ''.obs;

  List<Product> get products => _products;
  String get selectedCategory => _selectedCategory.value;
  String get searchQuery => _searchQuery.value;

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

  void toggleFavorite(String productId) {
    final index = _products.indexWhere((product) => product.id == productId);
    if (index != -1) {
      final product = _products[index];
      final updatedProduct = product.copyWith(isFavorite: !product.isFavorite);
      _products[index] = updatedProduct;
    }
  }
} 