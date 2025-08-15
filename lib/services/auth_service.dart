import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../screens/welcome_screen.dart';
import '../controllers/user_data_controller.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Kullanıcı durumu
  final Rx<User?> _user = Rx<User?>(null);
  User? get user => _user.value;
  
  // Kullanıcı bilgileri
  final Rx<Map<String, dynamic>?> _userData = Rx<Map<String, dynamic>?>(null);
  Map<String, dynamic>? get userData => _userData.value;
  
  // Telefon numarası doğrulama durumu
  final RxBool _isPhoneVerified = false.obs;
  bool get isPhoneVerified => _isPhoneVerified.value;
  
  // Doğrulama kodu gönderme durumu
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_auth.authStateChanges());
    _user.listen((User? user) {
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        _userData.value = null;
      }
    });
  }

  // Kullanıcı bilgilerini Firestore'dan yükle
  Future<void> _loadUserData(String userId) async {
    try {
      print('Kullanıcı bilgileri yükleniyor: $userId');
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data();
        print('Firestore verisi: $data');
        _userData.value = data;
      } else {
        print('Kullanıcı dokümanı bulunamadı');
      }
    } catch (e) {
      print('Kullanıcı bilgileri yüklenirken hata: $e');
    }
  }

  // Telefon numarasına doğrulama kodu gönder (Test Modu)
  Future<void> sendPhoneVerificationCode(String phoneNumber) async {
    try {
      _isLoading.value = true;
      
      // Test modu - SMS göndermiyoruz, sabit kod kullanıyoruz
      await Future.delayed(const Duration(seconds: 2)); // Simüle edilmiş gecikme
      
      // Test verification ID oluştur
      final testVerificationId = 'test_verification_id_${DateTime.now().millisecondsSinceEpoch}';
      Get.put(PhoneVerificationController()).verificationId = testVerificationId;
      
      _isLoading.value = false;
      
      Get.snackbar(
        'Test Modu',
        'Doğrulama kodu: 0000 (Test sürümü)',
        backgroundColor: const Color(0xFF53B175),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar(
        'Hata',
        'Bir hata oluştu: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Doğrulama kodunu kontrol et (Test Modu)
  Future<bool> verifyPhoneCode(String smsCode) async {
    try {
      _isLoading.value = true;
      
      // Test modu - sabit kod kontrolü
      await Future.delayed(const Duration(seconds: 1)); // Simüle edilmiş gecikme
      
      if (smsCode == '0000') {
        _isPhoneVerified.value = true;
        _isLoading.value = false;
        
        Get.snackbar(
          'Başarılı',
          'Doğrulama başarılı! (Test sürümü)',
          backgroundColor: const Color(0xFF53B175),
          colorText: Colors.white,
        );
        return true;
      } else {
        _isLoading.value = false;
        Get.snackbar(
          'Hata',
          'Doğrulama kodu hatalı. Test kodu: 0000',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar(
        'Hata',
        'Doğrulama kodu hatalı: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  // Kullanıcı bilgilerini güncelle
  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Önce e-posta ile Firebase'e kayıt ol
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Kullanıcı bilgilerini güncelle
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName('$firstName $lastName');
        
        // Kullanıcı bilgilerini Firestore'a kaydet
        final userData = {
          'firstName': firstName,
          'lastName': lastName,
          'username': username,
          'email': email,
          'phoneNumber': Get.find<PhoneInputController>().phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };
        
        print('Firestore\'a kaydedilecek veri: $userData');
        await _firestore.collection('users').doc(userCredential.user!.uid).set(userData);
        print('Firestore\'a kayıt tamamlandı');
        
        // Kullanıcı bilgilerini yükle
        await _loadUserData(userCredential.user!.uid);
        
        Get.snackbar(
          'Başarılı',
          'Hesap başarıyla oluşturuldu!',
          backgroundColor: const Color(0xFF53B175),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Hesap oluşturulurken hata oluştu: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // E-posta ile giriş yap
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      Get.snackbar(
        'Başarılı',
        'Giriş başarılı!',
        backgroundColor: const Color(0xFF53B175),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Giriş başarısız: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  // Çıkış yap
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _isPhoneVerified.value = false;
      Get.offAll(() => const WelcomeScreen());
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Çıkış yapılırken hata oluştu: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Kullanıcı durumunu kontrol et
  bool get isLoggedIn => _auth.currentUser != null;
}

// Doğrulama ID'sini saklamak için controller
class PhoneVerificationController extends GetxController {
  String verificationId = '';
}
