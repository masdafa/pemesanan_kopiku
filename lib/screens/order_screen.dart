// lib/screens/order_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:cached_network_image/cached_network_image.dart'; // Hapus
import '../providers/order_provider.dart';
import '../models/order.dart';
import 'order_tracking_screen.dart';

class OrderHistoryList extends StatelessWidget {
  const OrderHistoryList({super.key});
  
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context); 
    final history = orderProvider.orderHistory;

    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 100, color: Colors.grey.shade300),
            const SizedBox(height: 20),
            Text('Belum Ada Riwayat Pesanan', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
            const SizedBox(height: 8),
            Text('Semua pesanan Anda akan muncul di sini.', style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (ctx, i) {
        final order = history[i];
        return _buildOrderItemCard(context, order);
      },
    );
  }

  Widget _buildOrderItemCard(BuildContext context, Order order) {
    final isCompleted = order.status == OrderStatus.completed;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => OrderTrackingScreen(orderId: order.id)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pesanan #${order.id.substring(0, 8)}', 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF4E342E))
                ),
                _buildStatusBadge(order.status),
              ],
            ),
            Text(
              '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}', 
              style: const TextStyle(color: Colors.grey, fontSize: 12)
            ),
            const Divider(height: 24),
            _buildItemsPreview(order),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Bayar', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(
                      'Rp ${order.totalAmount.toStringAsFixed(0)}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary, fontSize: 18),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                     Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => OrderTrackingScreen(orderId: order.id)),
                     );
                  },
                  icon: Icon(isCompleted ? Icons.receipt_long_outlined : Icons.track_changes, size: 16),
                  label: Text(isCompleted ? 'Lihat Detail' : 'Lacak'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    backgroundColor: isCompleted ? Colors.grey.shade600 : theme.colorScheme.secondary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color color;
    String text;
    switch (status) {
      case OrderStatus.received:
        color = Colors.orange;
        text = 'Diterima';
        break;
      case OrderStatus.preparing:
        color = Colors.blue;
        text = 'Dibuat';
        break;
      case OrderStatus.readyForPickup:
        color = Colors.purple;
        text = 'Siap Diambil';
        break;
      case OrderStatus.completed:
        color = Colors.green;
        text = 'Selesai';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildItemsPreview(Order order) {
    final itemsToShow = order.items.take(4).toList();
    return SizedBox(
      height: 45,
      child: Row(
        children: [
          ...itemsToShow.map((item) => Align(
            widthFactor: 0.7, // Membuat gambar saling tumpuk
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  item.coffee.imageUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, size: 20, color: Colors.grey),
                  ),
                ),
              ),
            ),
          )).toList(),
          if (order.items.length > 4)
            Align(
              widthFactor: 0.7,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade200,
                  child: Text('+${order.items.length - 4}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              order.items.map((e) => e.coffee.name).join(', '), 
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: const OrderHistoryList(),
    );
  }
}
