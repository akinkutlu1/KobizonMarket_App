import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/location_controller.dart';
import 'home_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String selectedCity = 'İstanbul';
  String selectedDistrict = '';

  final List<String> cities = [
    'İstanbul',
    'İzmir',
    'Ankara',
    'Zonguldak',
  ];

  final Map<String, List<String>> districts = {
    'İstanbul': [
      'Kadıköy',
      'Beşiktaş',
      'Şişli',
      'Beyoğlu',
      'Fatih',
      'Üsküdar',
      'Maltepe',
      'Kartal',
      'Pendik',
      'Tuzla',
      'Sarıyer',
      'Bakırköy',
      'Bahçelievler',
      'Küçükçekmece',
      'Büyükçekmece',
      'Avcılar',
      'Esenyurt',
      'Başakşehir',
      'Sultangazi',
      'Gaziosmanpaşa',
      'Kağıthane',
      'Eyüp',
      'Bayrampaşa',
      'Esenler',
      'Bağcılar',
      'Güngören',
      'Zeytinburnu',
      'Sultanbeyli',
      'Çekmeköy',
      'Ümraniye',
      'Ataşehir',
      'Sancaktepe',
    ],
    'İzmir': [
      'Konak',
      'Karşıyaka',
      'Bornova',
      'Buca',
      'Çiğli',
      'Bayraklı',
      'Gaziemir',
      'Karabağlar',
      'Narlıdere',
      'Güzelbahçe',
      'Urla',
      'Seferihisar',
      'Menderes',
      'Torbalı',
      'Kemalpaşa',
      'Ödemiş',
      'Tire',
      'Bergama',
      'Dikili',
      'Aliağa',
      'Foça',
      'Çeşme',
      'Karaburun',
      'Kınık',
      'Beydağ',
      'Kiraz',
      'Ödemiş',
    ],
    'Ankara': [
      'Çankaya',
      'Keçiören',
      'Mamak',
      'Yenimahalle',
      'Etimesgut',
      'Sincan',
      'Altındağ',
      'Pursaklar',
      'Gölbaşı',
      'Polatlı',
      'Beypazarı',
      'Nallıhan',
      'Kızılcahamam',
      'Çamlıdere',
      'Ayaş',
      'Güdül',
      'Kazan',
      'Akyurt',
      'Kalecik',
      'Bala',
      'Elmadağ',
      'Haymana',
      'Şereflikoçhisar',
      'Evren',
      'Çubuk',
    ],
    'Zonguldak': [
      'Merkez',
      'Kozlu',
      'Kilimli',
      'Çaycuma',
      'Devrek',
      'Gökçebey',
      'Alaplı',
      'Ereğli',
      'Perşembe',
      'Ulus',
      'Bartın',
      'Amasra',
      'Kurucaşile',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              
              const SizedBox(height: 20),
              
              // Illustration
              Center(
                child: Container(
                  width: 224.68820190429688,
                  height: 170.69204711914062,
                  child: Image.asset(
                    'assets/images/illustration.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Title
              const Center(
                child: Text(
                  'Konumunuzu Seçin',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Description
              const Center(
                child: Text(
                  'Bölgenizde olup bitenlerden haberdar olmak için\nkonumunuzu açın',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Your City
              const Text(
                'Şehriniz',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCity,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    items: cities.map((String city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCity = newValue ?? selectedCity;
                        selectedDistrict = ''; // Şehir değişince ilçeyi sıfırla
                      });
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Your District
              const Text(
                'İlçeniz',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedDistrict.isEmpty ? null : selectedDistrict,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    hint: const Text(
                      'İlçenizi seçin',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    items: districts[selectedCity]?.map((String district) {
                      return DropdownMenuItem<String>(
                        value: district,
                        child: Text(district),
                      );
                    }).toList() ?? [],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDistrict = newValue ?? '';
                      });
                    },
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    // Konum bilgilerini kaydet ve ana sayfaya dön
                    final locationController = Get.find<LocationController>();
                    final newLocation = selectedDistrict.isNotEmpty 
                        ? '$selectedCity, $selectedDistrict'
                        : selectedCity;
                    
                    // Loading göster
                    Get.dialog(
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                      barrierDismissible: false,
                    );
                    
                    try {
                      await locationController.updateLocation(newLocation);
                      Get.back(); // Loading dialog'u kapat
                      
                      // Başarı mesajı göster
                      Get.snackbar(
                        'Başarılı',
                        'Konum bilgileriniz kaydedildi',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFF53B175),
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                      );
                      
                      // Ana sayfaya yönlendir
                      Get.offAll(() => const HomeScreen());
                    } catch (e) {
                      Get.back(); // Loading dialog'u kapat
                      Get.snackbar(
                        'Hata',
                        'Konum kaydedilirken bir sorun oluştu',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF53B175),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Kaydet',
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
    );
  }
} 