import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/support_ticket.dart';

class SupportService extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable lists for tickets
  final RxList<SupportTicket> _userTickets = <SupportTicket>[].obs;
  List<SupportTicket> get userTickets => _userTickets;

  // Loading states
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    // Firebase ve kullanıcı durumunu dinle
    _setupAuthListener();
  }

  // Firebase auth durumunu dinle
  void _setupAuthListener() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // Kullanıcı giriş yaptığında biletleri yükle
        print('Kullanıcı giriş yaptı: ${user.uid}');
        _loadUserTickets();
      } else {
        // Kullanıcı çıkış yaptığında biletleri temizle
        print('Kullanıcı çıkış yaptı');
        _userTickets.clear();
      }
    });
  }

  // Kullanıcı durumunu kontrol et ve biletleri yükle
  void _checkUserAndLoadTickets() {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      print('Mevcut kullanıcı bulundu: ${currentUser.uid}');
      _loadUserTickets();
    } else {
      print('Mevcut kullanıcı bulunamadı');
    }
  }

  // Kullanıcı giriş yaptığında çağrılacak metod
  void onUserLogin() {
    print('onUserLogin çağrıldı');
    _loadUserTickets();
  }

  // Load user's support tickets
  Future<void> _loadUserTickets() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('Kullanıcı bulunamadı, biletler yüklenmiyor');
        return;
      }

      print('Biletler yükleniyor... Kullanıcı ID: ${currentUser.uid}');
      _isLoading.value = true;
      
      // Firebase bağlantısını kontrol et ve gerekirse bekle
      int retryCount = 0;
      bool connected = false;
      
      while (retryCount < 3 && !connected) {
        try {
          await _firestore.collection('test').doc('test').get();
          connected = true;
          print('Firebase bağlantısı başarılı');
        } catch (e) {
          retryCount++;
          print('Firebase bağlantı denemesi $retryCount başarısız: $e');
          if (retryCount < 3) {
            await Future.delayed(Duration(seconds: retryCount * 2));
          }
        }
      }
      
      if (!connected) {
        print('Firebase bağlantısı kurulamadı, biletler yüklenmiyor');
        return;
      }
      
      print('Destek biletleri sorgulanıyor...');
      final querySnapshot = await _firestore
          .collection('support_tickets')
          .where('userId', isEqualTo: currentUser.uid)
          // .orderBy('createdAt', descending: true) // Index oluşturulana kadar geçici olarak kaldırıldı
          .get();

      print('${querySnapshot.docs.length} bilet bulundu');
      
      // Manuel olarak sıralama yap
      final tickets = querySnapshot.docs
          .map((doc) => SupportTicket.fromMap(doc.data()))
          .toList();
      
      // createdAt'e göre manuel sıralama
      tickets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      _userTickets.value = tickets;
      
      print('Biletler başarıyla yüklendi');
    } catch (e) {
      print('Destek biletleri yüklenirken hata: $e');
      // Uygulama başlangıcında hata mesajı gösterme
      if (_userTickets.isNotEmpty) {
        Get.snackbar(
          'Hata',
          'Destek biletleri yüklenirken hata oluştu',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }

  // Create a new support ticket
  Future<String?> createSupportTicket({
    required String subject,
    required String message,
    required String category,
    required String priority,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('Kullanıcı giriş yapmamış');
      }

      _isLoading.value = true;

      // Generate unique ticket ID
      final ticketId = _generateTicketId();
      
      // Get user data
      final userData = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      
      final userDataMap = userData.data() ?? {};
      final userName = '${userDataMap['firstName'] ?? ''} ${userDataMap['lastName'] ?? ''}'.trim();
      
      // Create support ticket
      final ticket = SupportTicket(
        id: ticketId,
        userId: currentUser.uid,
        userEmail: currentUser.email ?? '',
        userName: userName.isNotEmpty ? userName : 'Kullanıcı',
        subject: subject,
        message: message,
        category: category,
        priority: priority,
        createdAt: DateTime.now(),
        messages: [
          SupportMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            message: message,
            isFromUser: true,
            timestamp: DateTime.now(),
            status: 'pending',
          ),
        ],
      );

      // Save to Firestore
      await _firestore
          .collection('support_tickets')
          .doc(ticketId)
          .set(ticket.toMap());

      // Add to local list
      _userTickets.insert(0, ticket);
      
      print('Yeni bilet yerel listeye eklendi: $ticketId');

      Get.snackbar(
        'Başarılı',
        'Destek talebiniz oluşturuldu. Ticket ID: $ticketId',
        backgroundColor: const Color(0xFF53B175),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      return ticketId;
    } catch (e) {
      print('Destek bileti oluşturulurken hata: $e');
      Get.snackbar(
        'Hata',
        'Destek bileti oluşturulurken hata oluştu: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } finally {
      _isLoading.value = false;
    }
  }

  // Add a message to existing ticket
  Future<bool> addMessageToTicket({
    required String ticketId,
    required String message,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final newMessage = SupportMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: message,
        isFromUser: true,
        timestamp: DateTime.now(),
        status: 'pending',
      );

      // Update in Firestore
      await _firestore
          .collection('support_tickets')
          .doc(ticketId)
          .update({
        'messages': FieldValue.arrayUnion([newMessage.toMap()]),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      // Update local ticket
      final ticketIndex = _userTickets.indexWhere((t) => t.id == ticketId);
      if (ticketIndex != -1) {
        final updatedTicket = _userTickets[ticketIndex].copyWith(
          messages: [..._userTickets[ticketIndex].messages, newMessage],
          updatedAt: DateTime.now(),
        );
        _userTickets[ticketIndex] = updatedTicket;
      }

      return true;
    } catch (e) {
      print('Mesaj eklenirken hata: $e');
      return false;
    }
  }

  // Get ticket by ID
  Future<SupportTicket?> getTicketById(String ticketId) async {
    try {
      final doc = await _firestore
          .collection('support_tickets')
          .doc(ticketId)
          .get();
      
      if (doc.exists) {
        return SupportTicket.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Bilet getirilirken hata: $e');
      return null;
    }
  }

  // Refresh user tickets
  Future<void> refreshTickets() async {
    print('Biletler manuel olarak yenileniyor...');
    await _loadUserTickets();
  }

  // Generate unique ticket ID
  String _generateTicketId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'TKT-$timestamp-$random';
  }

  // Get status color
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  // Get priority color
  Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      case 'urgent':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Get status text in Turkish
  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return 'Açık';
      case 'in_progress':
        return 'İşlemde';
      case 'resolved':
        return 'Çözüldü';
      case 'closed':
        return 'Kapalı';
      default:
        return status;
    }
  }

  // Get priority text in Turkish
  String getPriorityText(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return 'Düşük';
      case 'medium':
        return 'Orta';
      case 'high':
        return 'Yüksek';
      case 'urgent':
        return 'Acil';
      default:
        return priority;
    }
  }

  // Get category text in Turkish
  String getCategoryText(String category) {
    switch (category.toLowerCase()) {
      case 'technical':
        return 'Teknik';
      case 'billing':
        return 'Faturalama';
      case 'order':
        return 'Sipariş';
      case 'general':
        return 'Genel';
      default:
        return category;
    }
  }
}
