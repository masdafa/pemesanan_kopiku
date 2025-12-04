// lib/screens/checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';
import '../providers/order_provider.dart';
import 'order_tracking_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'wallet';

  void _completeOrder(CartProvider cart, UserProvider user, OrderProvider order, BuildContext context) {
    final double finalPrice = cart.totalAmount;
    final cartItems = cart.items.values.toList();
    final voucher = cart.currentVoucher?.code ?? '';

    if (_selectedPaymentMethod == 'wallet') {
      if (user.walletBalance < finalPrice) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Pembayaran Gagal: Saldo Dompet tidak cukup.'), backgroundColor: Colors.red));
        return;
      }
      user.deductFromWallet(finalPrice);
    } 

    // 1. Tambahkan Pesanan Baru ke Riwayat & Mulai Tracking
    order.addOrder(cartItems, finalPrice, voucher);
    
    // 2. Berikan Poin Reward
    user.addPoints(50); 
    
    // 3. Kosongkan Keranjang
    cart.clearCart(); 

    // 4. Navigasi ke Halaman Tracking
    final String newOrderId = order.orderHistory.first.id;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => OrderTrackingScreen(orderId: newOrderId)),
      (Route<dynamic> route) => route.isFirst, // Kembali ke main tabs screen
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pesanan #$newOrderId berhasil! Anda mendapatkan 50 Poin Reward.'),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final user = Provider.of<UserProvider>(context);
    final order = Provider.of<OrderProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lokasi
                  const Text('Lokasi Pengambilan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Card(
                    elevation: 1,
                    child: ListTile(
                      leading: Icon(Icons.location_on, color: Colors.brown.shade700),
                      title: const Text('Fore Coffee - Mall ABC'),
                      subtitle: const Text('Ambil sekarang (~15 menit)'),
                      trailing: const Icon(Icons.edit, size: 16),
                      onTap: () { /* Edit Lokasi */ },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Metode Pembayaran
                  const Text('Pilih Metode Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Card(
                    elevation: 1,
                    child: Column(
                      children: [
                        _buildPaymentTile('Dompet Fore', 'Saldo: Rp ${user.walletBalance.toStringAsFixed(0)}', 'wallet'),
                        const Divider(height: 0),
                        _buildPaymentTile('Kartu Kredit/Debit', 'Bayar dengan kartu', 'card'),
                        const Divider(height: 0),
                        _buildPaymentTile('QRIS/E-Wallet', 'Gopay, OVO, Dana, dll.', 'qris'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Detail Pesanan
                  const Text('Detail Pesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...cart.items.values.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${item.quantity}x ${item.coffee.name} (${item.sizeString})', style: const TextStyle(color: Colors.black87)),
                        Text('Rp ${item.adjustedPrice.toStringAsFixed(0)}', style: const TextStyle(color: Colors.black87)),
                      ],
                    ),
                  )),

                ],
              ),
            ),
          ),
          
          // Fixed Footer Total dan Bayar
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSummaryRow('Subtotal Item', cart.subTotalAmount),
                _buildSummaryRow('Diskon Voucher', -cart.discountAmount, isDiscount: true),
                const Divider(thickness: 1.5, height: 20),
                _buildSummaryRow('Total Pembayaran', cart.totalAmount, isTotal: true),
                const SizedBox(height: 15),
                
                ElevatedButton(
                  onPressed: () => _completeOrder(cart, user, order, context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('BAYAR SEKARANG - Rp ${cart.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTile(String title, String subtitle, String methodCode) {
    final selected = _selectedPaymentMethod == methodCode;
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      leading: Icon(
        methodCode == 'wallet' ? Icons.account_balance_wallet_outlined : (methodCode == 'card' ? Icons.credit_card : Icons.qr_code),
        color: selected ? Colors.green.shade700 : Colors.brown.shade400,
      ),
      trailing: selected ? Icon(Icons.check_circle, color: Colors.green.shade700) : null,
      onTap: () {
        setState(() {
          _selectedPaymentMethod = methodCode;
        });
      },
    );
  }

  Widget _buildSummaryRow(String title, double amount, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: isTotal ? 16 : 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isTotal ? Colors.black : Colors.black54)),
          Text(
            '${isDiscount ? '-' : ''}Rp ${amount.abs().toStringAsFixed(0)}',
            style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : (isDiscount ? FontWeight.bold : FontWeight.normal),
                color: isTotal ? Colors.green.shade700 : (isDiscount ? Colors.red : Colors.black)),
          ),
        ],
      ),
    );
  }
}