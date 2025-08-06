import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterScreen extends StatefulWidget {
  final String searchQuery;
  final List<String> initialCategories;
  final List<String> initialBrands;
  
  const FilterScreen({
    super.key,
    required this.searchQuery,
    this.initialCategories = const [],
    this.initialBrands = const [],
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // Selected categories
  final Set<String> selectedCategories = <String>{};
  final Set<String> selectedBrands = <String>{};

  // Available categories
  final List<String> categories = [
    'Yumurtalar',
    'Erişte ve Makarna',
    'Cips ve Kraker',
    'Fast Food',
  ];

  // Available brands
  final List<String> brands = [
    'Individual Collection',
    'Cocola',
    'Ifad',
    'Kazi Farmas',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with previous selections
    selectedCategories.addAll(widget.initialCategories);
    selectedBrands.addAll(widget.initialBrands);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 28),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Filtreler',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Content
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categories Section
                    const Text(
                      'Kategoriler',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...categories.map((category) => _buildCheckboxTile(
                      title: category,
                      value: selectedCategories.contains(category),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedCategories.add(category);
                          } else {
                            selectedCategories.remove(category);
                          }
                        });
                      },
                    )),
                    
                    const SizedBox(height: 24),
                    
                    // Brands Section
                    const Text(
                      'Marka',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...brands.map((brand) => _buildCheckboxTile(
                      title: brand,
                      value: selectedBrands.contains(brand),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedBrands.add(brand);
                          } else {
                            selectedBrands.remove(brand);
                          }
                        });
                      },
                    )),
                  ],
                ),
              ),
            ),
          ),
          
          // Apply Filter Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Apply filters and go back to search screen
                  Get.back(result: {
                    'categories': selectedCategories.toList(),
                    'brands': selectedBrands.toList(),
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF53B175),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Filtre Uygula',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: value ? const Color(0xFF53B175) : Colors.transparent,
                border: Border.all(
                  color: value ? const Color(0xFF53B175) : Colors.grey.shade400,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: value
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: value ? const Color(0xFF53B175) : Colors.black87,
                  fontWeight: value ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 