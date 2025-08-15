import 'cart_item.dart';

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final String status; // 'pending', 'confirmed', 'shipped', 'delivered', 'cancelled'
  final DateTime orderDate;
  final String? deliveryAddress;
  final String? paymentMethod;
  final String? orderNotes;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    this.deliveryAddress,
    this.paymentMethod,
    this.orderNotes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => {
        'productId': item.product.id,
        'quantity': item.quantity,
        'totalPrice': item.totalPrice,
      }).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'orderDate': orderDate.toIso8601String(),
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'orderNotes': orderNotes,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, List<CartItem> items) {
    return Order(
      id: map['id'],
      userId: map['userId'],
      items: items,
      totalAmount: map['totalAmount'].toDouble(),
      status: map['status'],
      orderDate: DateTime.parse(map['orderDate']),
      deliveryAddress: map['deliveryAddress'],
      paymentMethod: map['paymentMethod'],
      orderNotes: map['orderNotes'],
    );
  }
}
