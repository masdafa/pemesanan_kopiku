// lib/screens/rewards_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/cart_provider.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  static const int pointsNeeded = 100;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final cart = Provider.of<CartProvider>(context, listen: false);

    final current = user.rewardPoints;
    final progress = ((current / pointsNeeded).clamp(0, 1)).toDouble();

    return Scaffold(
      appBar: AppBar(title: const Text('Rewards')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Poin Reward Anda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber.shade700, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$current Poin', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Kumpulkan $pointsNeeded poin untuk mendapatkan voucher gratis.'),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                color: Colors.green.shade700,
                backgroundColor: Colors.grey.shade200,
              ),

              const SizedBox(height: 16),
              Text('Progress: ${(progress * 100).toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),

              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hadiah Voucher', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Voucher Gratis: Potongan Rp 25.000 (Berlaku 7 hari)'),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: current >= pointsNeeded
                              ? () {
                                  try {
                                    final voucher = user.redeemPointsForVoucher(cart: cart, pointsNeeded: pointsNeeded, voucherValue: 25000);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Voucher ${voucher.code} berhasil ditambahkan ke keranjang')));
                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Poin tidak cukup')));
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, padding: const EdgeInsets.symmetric(vertical: 14)),
                          child: Text(current >= pointsNeeded ? 'Tukarkan Sekarang' : 'Kumpulkan lebih banyak poin'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text('Cara Mendapatkan Poin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('- Setiap pembelian mendapatkan poin\n- Menyelesaikan pesanan: +50 poin (contoh)\n- Promosi khusus dapat memberikan poin lebih banyak'),
            ],
          ),
        ),
      ),
    );
  }
}
