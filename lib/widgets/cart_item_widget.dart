// lib/widgets/cart_item_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final String cartKey;
  final CartItem cartItem;

  const CartItemWidget({super.key, required this.cartKey, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return ChangeNotifierProvider.value(
      value: cartItem,
      child: Consumer<CartItem>(
        builder: (ctx, item, _) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.grey.withAlpha(26), spreadRadius: 1, blurRadius: 3)]),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    // Menggunakan Image.network
                    child: Image.network(
                      item.coffee.imageUrl,
                      width: 60, height: 60, fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(width: 60, height: 60, child: Center(child: CircularProgressIndicator(color: Colors.brown.shade300)));
                      },
                      errorBuilder: (context, error, stackTrace) => const SizedBox(width: 60, height: 60, child: Center(child: Icon(Icons.broken_image, size: 30, color: Colors.grey))),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.coffee.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.brown.shade800), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text('${item.sizeString.toUpperCase()} | Rp ${item.priceBySize.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                        const SizedBox(height: 4),
                        Text('Total: Rp ${item.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.green)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildQuantityButton(icon: Icons.remove, onTap: () { cart.removeSingleItem(cartKey); }, enabled: item.quantity > 1),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0), child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      _buildQuantityButton(icon: Icons.add, onTap: () { cart.incrementItemQuantity(cartKey); }, enabled: true),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildQuantityButton({required IconData icon, required VoidCallback onTap, required bool enabled}) {
    return InkWell(
      onTap: enabled ? onTap : null,
      customBorder: const CircleBorder(),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(border: Border.all(color: enabled ? Colors.brown.shade300 : Colors.grey.shade300), shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: enabled ? Colors.brown.shade700 : Colors.grey),
      ),
    );
  }
}