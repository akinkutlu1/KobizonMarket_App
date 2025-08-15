import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<SupportMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Sample messages
    _messages.addAll([
      SupportMessage(
        id: '1',
        message: 'Siparişim ne zaman gelecek?',
        isFromUser: true,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        status: 'answered',
      ),
      SupportMessage(
        id: '2',
        message: 'Merhaba! Siparişiniz 30-60 dakika içinde teslim edilecektir. Takip numaranız: #123456',
        isFromUser: false,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        status: 'answered',
      ),
      SupportMessage(
        id: '3',
        message: 'Promosyon kodumu kullanamıyorum',
        isFromUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        status: 'pending',
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Yardım & Destek',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageCard(message);
                    },
                  ),
          ),
          
          // Send Message Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Mesajınızı yazın...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Color(0xFF53B175), width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF53B175),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    onPressed: _isLoading ? null : _sendMessage,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.support_agent,
              size: 60,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Henüz mesajınız yok',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Destek ekibimizle iletişime geçin',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(SupportMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: message.isFromUser 
            ? CrossAxisAlignment.end 
            : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: message.isFromUser 
                  ? const Color(0xFF53B175) 
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomLeft: message.isFromUser ? const Radius.circular(16) : const Radius.circular(4),
                bottomRight: message.isFromUser ? const Radius.circular(4) : const Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.message,
                  style: TextStyle(
                    fontSize: 16,
                    color: message.isFromUser ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: message.isFromUser 
                            ? Colors.white.withOpacity(0.8) 
                            : Colors.grey,
                      ),
                    ),
                    if (message.isFromUser) ...[
                      const SizedBox(width: 8),
                      Icon(
                        message.status == 'answered' 
                            ? Icons.done_all 
                            : Icons.done,
                        size: 16,
                        color: message.status == 'answered' 
                            ? Colors.white 
                            : Colors.white.withOpacity(0.8),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate sending message
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(SupportMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: message,
          isFromUser: true,
          timestamp: DateTime.now(),
          status: 'pending',
        ));
        _messageController.clear();
        _isLoading = false;
      });

      // Simulate auto-reply
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _messages.add(SupportMessage(
            id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
            message: 'Mesajınız alındı. En kısa sürede size dönüş yapacağız.',
            isFromUser: false,
            timestamp: DateTime.now(),
            status: 'answered',
          ));
        });
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class SupportMessage {
  final String id;
  final String message;
  final bool isFromUser;
  final DateTime timestamp;
  final String status; // 'pending', 'answered'

  SupportMessage({
    required this.id,
    required this.message,
    required this.isFromUser,
    required this.timestamp,
    required this.status,
  });
}
