// lib/screens/order_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../models/order.dart';
import 'order_tracking_screen.dart';

class OrderHistoryList extends StatelessWidget {
  const OrderHistoryList({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Mendengarkan perubahan order provider (agar update saat tracking selesai)
    final orderProvider = Provider.of<OrderProvider>(context); 
    final history = orderProvider.orderHistory;

    if (history.isEmpty) {
       return const Center(child: Text('Belum ada riwayat pesanan.', style: TextStyle(color: Colors.black54)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: history.length,
      itemBuilder: (ctx, i) {
        final order = history[i];
        final isCompleted = order.status == OrderStatus.completed;
        
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(
              isCompleted ? Icons.check_circle : Icons.access_time_filled, 
              color: isCompleted ? Colors.green.shade600 : Colors.blue.shade400
            ),
            title: Text('Pesanan #${order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              '${order.items.length} item | ${order.orderDate.day}/${order.orderDate.month}', 
              style: const TextStyle(color: Colors.black54)
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Rp ${order.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                Text(order.statusString, style: TextStyle(fontSize: 12, color: isCompleted ? Colors.green.shade600 : Colors.blue.shade400)),
              ],
            ),
            onTap: () {
              // Navigasi ke Order Tracking
              Navigator.of(context).push(
                 MaterialPageRoute(builder: (context) => OrderTrackingScreen(orderId: order.id)),
              );
            },
          ),
        );
      },
    );
  }
}

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan'),
        centerTitle: true,
      ),
      body: const OrderHistoryList(),
    );
  }
}