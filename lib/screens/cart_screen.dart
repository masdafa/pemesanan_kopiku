// lib/screens/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:cached_network_image/cached_network_image.dart'; // Hapus
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import 'checkout_screen.dart';
import 'voucher_selection_screen.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final String coffeeId;

  const CartItemWidget({super.key, required this.cartItem, required this.coffeeId});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Dismissible(
      key: ValueKey(coffeeId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cart.removeItem(coffeeId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${cartItem.coffee.name} dihapus dari keranjang.'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      },
      background: Container(
        color: Colors.red.shade700,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              // Ganti ke Image.asset
              child: Image.asset(cartItem.coffee.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
            ),
            title: Text(cartItem.coffee.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
                '${cartItem.sizeString} | ${cartItem.tempString} | ${cartItem.toppingString}\nRp ${cartItem.adjustedPrice.toStringAsFixed(0)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.brown),
                  onPressed: () {
                    cart.removeSingleItem(coffeeId);
                  },
                ),
                Text('${cartItem.quantity}', style: const TextStyle(fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.brown),
                  onPressed: () {
                    cart.addItem(CartItem(
                      coffee: cartItem.coffee,
                      size: cartItem.size,
                      temp: cartItem.temp,
                      topping: cartItem.topping,
                      quantity: 1,
                    ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Keranjang (${cart.itemCount})')),
      body: Column(
        children: <Widget>[
          // List Item Keranjang
          Expanded(
            child: cart.itemCount == 0
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 10),
                        const Text('Keranjang masih kosong.', style: TextStyle(fontSize: 16, color: Colors.black54)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) => CartItemWidget(
                      cartItem: cart.items.values.toList()[i],
                      coffeeId: cart.items.keys.toList()[i],
                    ),
                  ),
          ),

          // Ringkasan Pembayaran & Tombol Checkout (Fixed Footer)
          if (cart.itemCount > 0)
            Card(
              margin: const EdgeInsets.all(10),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    // Voucher
                    ListTile(
                      leading: Icon(Icons.discount_outlined, color: Colors.brown.shade700),
                      title: Text(cart.currentVoucher != null ? cart.currentVoucher!.title : 'Gunakan Voucher'),
                      subtitle: cart.currentVoucher != null ? Text(cart.currentVoucher!.code, style: const TextStyle(color: Colors.green)) : null,
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const VoucherSelectionScreen()));
                      },
                    ),

                    // Detail Harga
                    const Divider(),
                    _buildSummaryRow('Subtotal Item', cart.subTotalAmount), 
                    if (cart.discountAmount > 0)
                      _buildSummaryRow('Diskon Voucher', -cart.discountAmount, isDiscount: true),
                    
                    const Divider(thickness: 2),
                    _buildSummaryRow('Total Pembayaran', cart.finalTotalAmount, isTotal: true),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CheckoutScreen()));
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('LANJUTKAN KE PEMBAYARAN'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, double amount, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: isTotal ? 18 : 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isTotal ? Colors.black : Colors.black54)),
          Text(
            '${isDiscount ? '-' : ''}Rp ${amount.abs().toStringAsFixed(0)}',
            style: TextStyle(
                fontSize: isTotal ? 18 : 14,
                fontWeight: isTotal ? FontWeight.bold : (isDiscount ? FontWeight.bold : FontWeight.normal),
                color: isTotal ? Colors.green.shade700 : (isDiscount ? Colors.red : Colors.black)),
          ),
        ],
      ),
    );
  }
}
