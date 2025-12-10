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
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _completeOrder(CartProvider cart, UserProvider user, OrderProvider order, BuildContext context) {
    if (cart.isDelivery && cart.deliveryAddress.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Harap masukkan alamat pengiriman.'), backgroundColor: Colors.red));
        return;
    }

    final double finalPrice = cart.finalTotalAmount;
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

    order.addOrder(cartItems, finalPrice, voucher);
    user.addPoints(50); 
    cart.clearCart(); 

    final String newOrderId = order.orderHistory.first.id;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => OrderTrackingScreen(orderId: newOrderId)),
      (Route<dynamic> route) => route.isFirst,
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
                  // --- TOGGLE PICKUP / DELIVERY ---
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        _buildToggleOption(cart, "Pickup", false),
                        _buildToggleOption(cart, "Delivery", true),
                      ],
                    ),
                  ),

                  // --- LOCATION / ADDRESS SECTION ---
                  const Text('Lokasi Pengambilan / Pengiriman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  
                  if (!cart.isDelivery)
                    // PICKUP INFO
                    Card(
                      elevation: 1,
                      child: ListTile(
                        leading: Icon(Icons.store, color: Colors.brown.shade700),
                        title: const Text('Kopi Kang Dafa'),
                        subtitle: const Text('Veteran No.87 Serang-Banten'),
                        trailing: const Icon(Icons.edit, size: 16),
                        onTap: () { /* Edit Store Location */ },
                      ),
                    )
                  else
                    // DELIVERY ADDRESS INPUT
                    Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Alamat Pengiriman', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                hintText: 'Masukkan alamat lengkap...',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.my_location, color: Colors.blue),
                                  onPressed: () {
                                    // Simulate getting location
                                    setState(() {
                                      _addressController.text = "Jl. Raya Serang No. 123, Banten (Lokasi Saya)";
                                      cart.updateDeliveryAddress(_addressController.text);
                                    });
                                  },
                                ),
                              ),
                              onChanged: (val) {
                                cart.updateDeliveryAddress(val);
                              },
                            ),
                            const SizedBox(height: 8),
                            if (cart.deliveryFee > 0)
                               Text('Biaya Ongkir: Rp ${cart.deliveryFee.toStringAsFixed(0)}', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                          ],
                        ),
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
                if (cart.discountAmount > 0)
                  _buildSummaryRow('Diskon Voucher', -cart.discountAmount, isDiscount: true),
                if (cart.isDelivery)
                   _buildSummaryRow('Ongkos Kirim', cart.deliveryFee),
                
                const Divider(thickness: 1.5, height: 20),
                _buildSummaryRow('Total Pembayaran', cart.finalTotalAmount, isTotal: true),
                const SizedBox(height: 15),
                
                ElevatedButton(
                  onPressed: () => _completeOrder(cart, user, order, context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('BAYAR SEKARANG - Rp ${cart.finalTotalAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(CartProvider cart, String label, bool isDeliveryOption) {
    final bool isSelected = (cart.isDelivery == isDeliveryOption);
    return Expanded(
      child: GestureDetector(
        onTap: () {
          cart.setDelivery(isDeliveryOption);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))] : [],
          ),
          child: Center(
            child: Text(
              label, 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                color: isSelected ? Colors.brown.shade700 : Colors.grey
              )
            ),
          ),
        ),
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
