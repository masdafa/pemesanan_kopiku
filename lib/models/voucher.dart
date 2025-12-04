// lib/models/voucher.dart

class Voucher {
  final String id;
  final String title;
  final String description;
  final double discountValue; // Dalam Rupiah
  final String code;
  final DateTime expiryDate;
  final bool isPercentage;

  Voucher({
    required this.id,
    required this.title,
    required this.description,
    required this.discountValue,
    required this.code,
    required this.expiryDate,
    this.isPercentage = false,
  });
}

// Dummy Data
final List<Voucher> dummyVouchers = [
  Voucher(
    id: 'v1',
    title: 'DISKON 15%',
    description: 'Diskon 15% untuk semua minuman, Maks. Rp 10.000',
    discountValue: 0.15,
    code: 'DISKON15',
    expiryDate: DateTime.now().add(const Duration(days: 7)),
    isPercentage: true,
  ),
  Voucher(
    id: 'v2',
    title: 'FREE DELIVERY',
    description: 'Gratis biaya pengiriman untuk minimum pembelian Rp 50.000',
    discountValue: 10000,
    code: 'FREEDEL',
    expiryDate: DateTime.now().add(const Duration(days: 30)),
  ),
  Voucher(
    id: 'v3',
    title: 'DISKON Rp 20.000',
    description: 'Potongan harga Rp 20.000, Min. Transaksi Rp 80.000',
    discountValue: 20000,
    code: 'HEMAT20',
    expiryDate: DateTime.now().add(const Duration(days: 14)),
  ),
];