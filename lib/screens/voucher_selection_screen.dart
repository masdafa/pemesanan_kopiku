// lib/screens/voucher_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/voucher.dart';

class VoucherSelectionScreen extends StatelessWidget {
  const VoucherSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Voucher')),
      body: ListView.builder(
        itemCount: dummyVouchers.length,
        itemBuilder: (ctx, i) {
          final voucher = dummyVouchers[i];
          final isApplied = cart.currentVoucher?.code == voucher.code;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.local_activity, color: isApplied ? Colors.green.shade700 : Colors.brown.shade400),
              title: Text(voucher.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(voucher.description),
                  Text('Kode: ${voucher.code}', style: const TextStyle(color: Colors.black54)),
                  Text(
                    'Berlaku hingga: ${voucher.expiryDate.day}/${voucher.expiryDate.month}/${voucher.expiryDate.year}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              trailing: isApplied
                  ? TextButton(
                      onPressed: () {
                        cart.removeVoucher();
                        Navigator.of(context).pop();
                      },
                      child: const Text('BATAL', style: TextStyle(color: Colors.red)),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        cart.applyVoucher(voucher);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${voucher.title} berhasil diterapkan!'), backgroundColor: Colors.green.shade700),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('GUNAKAN'),
                    ),
              onTap: isApplied ? null : () {
                 cart.applyVoucher(voucher);
                 Navigator.of(context).pop();
              },
            ),
          );
        },
      ),
    );
  }
}