import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import 'package:uuid/uuid.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];
  final Uuid _uuid = Uuid();

  List<Order> get orders => [..._orders].reversed.toList(); // Tampilkan yang terbaru duluan
  List<Order> get orderHistory => orders;

  void addOrder(List<CartItem> cartItems, double total, [String voucherCode = '']) {
    final newOrder = Order(
      id: _uuid.v4(),
      orderDate: DateTime.now(),
      items: cartItems.map((item) => item).toList(),
      totalAmount: total,
      voucherUsed: voucherCode,
    );
    _orders.add(newOrder);
    notifyListeners();

    // Simulasikan status update (misalnya, untuk Order Tracking)
    Future.delayed(const Duration(seconds: 10), () => updateOrderStatus(newOrder.id, newOrder.nextStatus));
    Future.delayed(const Duration(seconds: 20), () => updateOrderStatus(newOrder.id, OrderStatus.completed));
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final orderIndex = _orders.indexWhere((ord) => ord.id == orderId);
    if (orderIndex >= 0) {
      _orders[orderIndex].status = newStatus;
      notifyListeners();
    }
  }

  Order? findOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (e) {
      return null;
    }
  }
}