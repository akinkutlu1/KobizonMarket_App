import 'package:cloud_firestore/cloud_firestore.dart';

class SupportTicket {
  final String id;
  final String userId;
  final String userEmail;
  final String userName;
  final String subject;
  final String message;
  final String status; // 'open', 'in_progress', 'resolved', 'closed'
  final String priority; // 'low', 'medium', 'high', 'urgent'
  final String category; // 'technical', 'billing', 'order', 'general'
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;
  final List<SupportMessage> messages;
  final String? assignedTo; // Admin ID
  final String? adminResponse;

  SupportTicket({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.subject,
    required this.message,
    this.status = 'open',
    this.priority = 'medium',
    this.category = 'general',
    required this.createdAt,
    this.updatedAt,
    this.resolvedAt,
    this.messages = const [],
    this.assignedTo,
    this.adminResponse,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userEmail': userEmail,
      'userName': userName,
      'subject': subject,
      'message': message,
      'status': status,
      'priority': priority,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
      'messages': messages.map((msg) => msg.toMap()).toList(),
      'assignedTo': assignedTo,
      'adminResponse': adminResponse,
    };
  }

  // Create from Firestore document
  factory SupportTicket.fromMap(Map<String, dynamic> map) {
    return SupportTicket(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userEmail: map['userEmail'] ?? '',
      userName: map['userName'] ?? '',
      subject: map['subject'] ?? '',
      message: map['message'] ?? '',
      status: map['status'] ?? 'open',
      priority: map['priority'] ?? 'medium',
      category: map['category'] ?? 'general',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,
      resolvedAt: map['resolvedAt'] != null ? (map['resolvedAt'] as Timestamp).toDate() : null,
      messages: List<SupportMessage>.from(
        (map['messages'] ?? []).map((msg) => SupportMessage.fromMap(msg)),
      ),
      assignedTo: map['assignedTo'],
      adminResponse: map['adminResponse'],
    );
  }

  // Create a copy with updated fields
  SupportTicket copyWith({
    String? id,
    String? userId,
    String? userEmail,
    String? userName,
    String? subject,
    String? message,
    String? status,
    String? priority,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
    List<SupportMessage>? messages,
    String? assignedTo,
    String? adminResponse,
  }) {
    return SupportTicket(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      messages: messages ?? this.messages,
      assignedTo: assignedTo ?? this.assignedTo,
      adminResponse: adminResponse ?? this.adminResponse,
    );
  }
}

class SupportMessage {
  final String id;
  final String message;
  final bool isFromUser;
  final DateTime timestamp;
  final String status; // 'pending', 'answered', 'read'

  SupportMessage({
    required this.id,
    required this.message,
    required this.isFromUser,
    required this.timestamp,
    this.status = 'pending',
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'isFromUser': isFromUser,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status,
    };
  }

  // Create from Firestore document
  factory SupportMessage.fromMap(Map<String, dynamic> map) {
    return SupportMessage(
      id: map['id'] ?? '',
      message: map['message'] ?? '',
      isFromUser: map['isFromUser'] ?? true,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      status: map['status'] ?? 'pending',
    );
  }
}
