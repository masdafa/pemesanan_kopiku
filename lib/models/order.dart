// lib/models/order.dart

import 'cart_item.dart';

enum OrderStatus { received, preparing, readyForPickup, completed }

class Order {
  final String id;
  final DateTime orderDate;
  final List<CartItem> items;
  final double totalAmount;
  OrderStatus status;
  final String voucherUsed;

  Order({
    required this.id,
    required this.orderDate,
    required this.items,
    required this.totalAmount,
    this.status = OrderStatus.received,
    this.voucherUsed = '',
  });

  String get statusString {
    switch (status) {
      case OrderStatus.received:
        return 'Pesanan Diterima';
      case OrderStatus.preparing:
        return 'Sedang Diracik';
      case OrderStatus.readyForPickup:
        return 'Siap Diambil/Dikirim';
      case OrderStatus.completed:
        return 'Selesai';
    }
  }

  // Helper untuk mendapatkan status berikutnya
  OrderStatus get nextStatus {
    if (status == OrderStatus.received) return OrderStatus.preparing;
    if (status == OrderStatus.preparing) return OrderStatus.readyForPickup;
    if (status == OrderStatus.readyForPickup) return OrderStatus.completed;
    return OrderStatus.completed;
  }
}