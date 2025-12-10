// lib/screens/voucher_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/voucher.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';
import 'cart_screen.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voucher & Rewards'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyVouchers.length + 1, // Tambah 1 untuk Rewards
        itemBuilder: (ctx, i) {
          if (i == 0) {
            // Bagian Reward
            return _buildRewardSection(context, user, cart);
          }
          final voucher = dummyVouchers[i - 1];
          return _buildVoucherCard(context, voucher, cart);
        },
      ),
    );
  }

  Widget _buildRewardSection(BuildContext context, UserProvider user, CartProvider cart) {
    return GestureDetector(
      onTap: () {
        if (user.rewardPoints >= 500) {
          _showRedeemDialog(context, user, cart);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Poin belum cukup (Butuh 500 Poin)'), backgroundColor: Colors.red),
          );
        }
      },
      child: Card(
        elevation: 4,
        color: Colors.brown.shade700,
        margin: const EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Reward Saya', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                    child: const Text('Ketuk untuk Tukar', style: TextStyle(color: Colors.white, fontSize: 10)),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${user.rewardPoints} Poin', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  Icon(Icons.star, color: Colors.amber.shade300, size: 48),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Tukarkan 500 poin untuk Diskon Rp 25.000!', 
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w500)
              ),
              const SizedBox(height: 5),
              LinearProgressIndicator(
                value: (user.rewardPoints / 500).clamp(0.0, 1.0),
                backgroundColor: Colors.brown.shade900,
                color: Colors.amber,
                minHeight: 6,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRedeemDialog(BuildContext context, UserProvider user, CartProvider cart) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tukar Poin?'),
        content: const Text('Anda akan menukar 500 Poin untuk Voucher Diskon Rp 25.000.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              try {
                final voucher = user.redeemPointsForVoucher(cart: cart, pointsNeeded: 500, voucherValue: 25000);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Poin berhasil ditukar! Voucher otomatis terpasang.'), backgroundColor: Colors.green),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Tukar Sekarang'),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherCard(BuildContext context, Voucher voucher, CartProvider cart) {
    final theme = Theme.of(context);
    final isApplied = cart.currentVoucher?.code == voucher.code;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.confirmation_number_outlined, color: Colors.green.shade700, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(voucher.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(voucher.description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4)
                        ),
                        child: Text(voucher.code, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Exp: ${voucher.expiryDate.day}/${voucher.expiryDate.month}',
                        style: TextStyle(fontSize: 10, color: Colors.red.shade400),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isApplied)
              TextButton.icon(
                onPressed: () {
                  cart.removeVoucher();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voucher dilepas.')));
                },
                icon: const Icon(Icons.check, size: 16),
                label: const Text('Terpasang'),
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
              )
            else
              ElevatedButton(
                onPressed: () {
                  cart.applyVoucher(voucher);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${voucher.title} berhasil dipasang!'), 
                      backgroundColor: theme.colorScheme.primary,
                      action: SnackBarAction(label: 'LIHAT', textColor: Colors.white, onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                      }),
                    )
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Pakai'),
              ),
          ],
        ),
      ),
    );
  }
}
