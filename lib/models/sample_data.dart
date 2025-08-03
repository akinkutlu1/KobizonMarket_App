import 'product.dart';

class SampleData {
  static List<Product> products = [
    Product(
      id: '1',
      name: 'Fresh Bananas',
      description: 'Organic yellow bananas, perfect for smoothies and snacks',
      price: 2.99,
      imageUrl: 'assets/images/banana.png',
      category: 'Fruits',
      rating: 4.5,
      reviewCount: 128,
      unit: 'kg',
    ),
    Product(
      id: '2',
      name: 'Organic Apples',
      description: 'Sweet and crisp organic red apples',
      price: 4.99,
      imageUrl: 'assets/images/apple.png',
      category: 'Fruits',
      rating: 4.3,
      reviewCount: 89,
      unit: 'kg',
    ),
    Product(
      id: '3',
      name: 'Fresh Milk',
      description: 'Farm fresh whole milk, rich in calcium',
      price: 3.49,
      imageUrl: 'assets/images/milk.png',
      category: 'Dairy',
      rating: 4.7,
      reviewCount: 256,
      unit: 'liter',
    ),
    Product(
      id: '4',
      name: 'Whole Grain Bread',
      description: 'Freshly baked whole grain bread',
      price: 2.99,
      imageUrl: 'assets/images/bread.png',
      category: 'Bakery',
      rating: 4.2,
      reviewCount: 67,
      unit: 'piece',
    ),
    Product(
      id: '5',
      name: 'Organic Eggs',
      description: 'Farm fresh organic eggs, 12 pieces',
      price: 5.99,
      imageUrl: 'assets/images/eggs.png',
      category: 'Dairy',
      rating: 4.6,
      reviewCount: 189,
      unit: 'dozen',
    ),
    Product(
      id: '6',
      name: 'Fresh Tomatoes',
      description: 'Ripe and juicy red tomatoes',
      price: 3.99,
      imageUrl: 'assets/images/tomato.png',
      category: 'Vegetables',
      rating: 4.4,
      reviewCount: 145,
      unit: 'kg',
    ),
    Product(
      id: '7',
      name: 'Chicken Breast',
      description: 'Fresh boneless chicken breast',
      price: 12.99,
      imageUrl: 'assets/images/chicken.png',
      category: 'Meat',
      rating: 4.8,
      reviewCount: 234,
      unit: 'kg',
    ),
    Product(
      id: '8',
      name: 'Brown Rice',
      description: 'Organic brown rice, rich in fiber',
      price: 6.99,
      imageUrl: 'assets/images/rice.png',
      category: 'Grains',
      rating: 4.1,
      reviewCount: 78,
      unit: 'kg',
    ),
  ];

  static List<String> categories = [
    'Fruits',
    'Vegetables',
    'Dairy',
    'Meat',
    'Bakery',
    'Grains',
    'Beverages',
    'Snacks',
  ];

  static List<Product> getProductsByCategory(String category) {
    return products.where((product) => product.category == category).toList();
  }

  static List<Product> getFeaturedProducts() {
    return products.where((product) => product.rating >= 4.5).toList();
  }
} 