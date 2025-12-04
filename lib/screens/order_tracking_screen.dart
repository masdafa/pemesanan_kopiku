// lib/screens/order_tracking_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../providers/cart_provider.dart';
import '../models/order.dart';
import 'main_tabs_screen.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  // Data Stepper (Status Order)
  final List<String> statusTitles = const [
    'Pesanan Diterima',
    'Sedang Diracik',
    'Siap Diambil/Dikirim',
    'Selesai',
  ];

  void _reorder(BuildContext context, Order order) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    // Simulasikan penambahan semua item kembali ke keranjang
    for (var item in order.items) {
      cartProvider.addItem(item); 
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua item pesanan ditambahkan kembali ke keranjang!'), 
        backgroundColor: Colors.brown
      )
    );
     // Kembali ke halaman utama (Menu)
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainTabsScreen()),
      (Route<dynamic> route) => false,
    );
  }


  @override
  Widget build(BuildContext context) {
    // Gunakan Consumer untuk mendengarkan perubahan status real-time
    return Consumer<OrderProvider>(
      builder: (ctx, orderProvider, child) {
        final order = orderProvider.findOrderById(orderId);

        if (order == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Pelacakan Pesanan')),
            body: const Center(child: Text('Pesanan tidak ditemukan.')),
          );
        }
        
        final currentStep = OrderStatus.values.indexOf(order.status);
        final isCompleted = order.status == OrderStatus.completed;

        return Scaffold(
          appBar: AppBar(
            title: Text(isCompleted ? 'Riwayat Pesanan #${order.id}' : 'Pelacakan Pesanan #${order.id}'),
            automaticallyImplyLeading: isCompleted, // Hanya tampilkan tombol back jika sudah selesai
            leading: isCompleted ? null : IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Info
                Text('Status: ${order.statusString}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isCompleted ? Colors.green.shade700 : Colors.blue.shade700)),
                Text('Total Bayar: Rp ${order.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16)),
                const Divider(height: 30),

                // Stepper (Tracking)
                if (!isCompleted) 
                  Theme(
                    data: Theme.of(context).copyWith(colorScheme: Theme.of(context).colorScheme.copyWith(primary: Colors.brown.shade700)),
                    child: Stepper(
                      physics: const NeverScrollableScrollPhysics(),
                      currentStep: currentStep,
                      controlsBuilder: (context, details) => const SizedBox.shrink(),
                      steps: List.generate(statusTitles.length, (index) {
                        return Step(
                          title: Text(statusTitles[index], style: TextStyle(fontWeight: FontWeight.bold, color: index <= currentStep ? Colors.brown.shade800 : Colors.grey)),
                          subtitle: Text(index == currentStep ? order.statusString : (index < currentStep ? 'Selesai' : 'Menunggu...')),
                          content: const SizedBox.shrink(), 
                          isActive: index <= currentStep,
                          state: index < currentStep ? StepState.complete : StepState.indexed,
                        );
                      }),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.check_circle, size: 80, color: Colors.green),
                          SizedBox(height: 10),
                          Text('Pesanan telah selesai diambil/dikirim.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 30),
                Text('Detail Item (${order.items.length})', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown.shade800)),
                const Divider(),
                
                // Detail Item List
                ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      Text('${item.quantity}x ', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Text('${item.coffee.name} (${item.sizeString}, ${item.tempString}, ${item.toppingString})')),
                      Text('Rp ${(item.adjustedPrice / item.quantity).toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                )),
                
                const Divider(),
                // Re-order Button (Fitur Re-order Cepat)
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _reorder(context, order),
                    icon: const Icon(Icons.repeat),
                    label: const Text('PESAN LAGI DENGAN KUSTOMISASI SAMA', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.brown.shade700,
                       foregroundColor: Colors.white,
                       padding: const EdgeInsets.all(15),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}