import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final RxString currentLocation = 'İstanbul, Kadıköy'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLocationFromFirebase();
  }

  // Firebase'den konum bilgisini yükle
  Future<void> _loadLocationFromFirebase() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data();
          final savedLocation = data?['location'] as String?;
          if (savedLocation != null && savedLocation.isNotEmpty) {
            currentLocation.value = savedLocation;
            print('Konum Firebase\'den yüklendi: $savedLocation');
          }
        }
      } catch (e) {
        print('Konum yüklenirken hata: $e');
      }
    }
  }

  // Konumu güncelle ve Firebase'e kaydet
  Future<void> updateLocation(String newLocation) async {
    currentLocation.value = newLocation;
    
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'location': newLocation,
          'locationUpdatedAt': FieldValue.serverTimestamp(),
        });
        print('Konum Firebase\'e kaydedildi: $newLocation');
      } catch (e) {
        print('Konum kaydedilirken hata: $e');
        // Hata durumunda kullanıcıya bilgi ver
        Get.snackbar(
          'Hata',
          'Konum kaydedilirken bir sorun oluştu',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
} 