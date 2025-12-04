// lib/screens/voucher_screen.dart

import 'package:flutter/material.dart';
import '../models/voucher.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voucher & Rewards'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: dummyVouchers.length + 1, // Tambah 1 untuk Rewards
        itemBuilder: (ctx, i) {
          if (i == 0) {
            // Bagian Reward
            return _buildRewardSection(context);
          }
          final voucher = dummyVouchers[i - 1];
          return _buildVoucherCard(voucher);
        },
      ),
    );
  }

  Widget _buildRewardSection(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.brown.shade700,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reward Saya', style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('850 Poin', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                Icon(Icons.star, color: Colors.amber.shade300, size: 40),
              ],
            ),
            const SizedBox(height: 10),
            Text('Tukarkan poin Anda untuk diskon menarik!', style: TextStyle(color: Colors.grey.shade300)),
          ],
        ),
      ),
    );
  }

  Widget _buildVoucherCard(Voucher voucher) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.discount, color: Colors.green.shade700, size: 30),
        title: Text(voucher.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(voucher.description),
            Text('Kode: ${voucher.code}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
            Text(
              'Kadaluarsa: ${voucher.expiryDate.day}/${voucher.expiryDate.month}/${voucher.expiryDate.year}',
              style: TextStyle(fontSize: 12, color: Colors.red.shade400),
            ),
          ],
        ),
        trailing: TextButton(
          onPressed: () {
            // Aksi simpan voucher
          },
          child: Text('Simpan', style: TextStyle(color: Colors.green.shade700)),
        ),
      ),
    );
  }
}