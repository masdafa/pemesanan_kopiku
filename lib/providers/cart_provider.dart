import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/voucher.dart'; // Import Voucher model
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  // Map<UniqueCartKey, CartItem>
  final Map<String, CartItem> _items = {};
  final Uuid _uuid = Uuid();

  // Delivery options
  bool _isDelivery = false; // Default pickup
  String _deliveryAddress = '';
  double _deliveryFee = 0.0;

  bool get isDelivery => _isDelivery;
  String get deliveryAddress => _deliveryAddress;
  double get deliveryFee => _isDelivery ? _deliveryFee : 0.0; // Return 0 if not delivery

  void setDelivery(bool isDelivery) {
    _isDelivery = isDelivery;
    // Set default fee if delivery is active
    _deliveryFee = isDelivery ? 10000.0 : 0.0;
    notifyListeners();
  }

  void updateDeliveryAddress(String address) {
    _deliveryAddress = address;
    notifyListeners();
  }
  
  void updateDeliveryFee(double fee) {
    _deliveryFee = fee;
    notifyListeners();
  }

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  // Total amount before discount
  double get totalAmount => _items.values.fold(0.0, (sum, item) => sum + item.totalAmount);

  // Cari item yang sudah ada dengan kriteria yang sama
  String? _findExistingItemKey(CartItem newItem) {
    for (var entry in _items.entries) {
      final existingItem = entry.value;
      if (existingItem.coffee.id == newItem.coffee.id &&
          existingItem.size == newItem.size &&
          existingItem.temp == newItem.temp &&
          existingItem.topping == newItem.topping) {
        return entry.key;
      }
    }
    return null;
  }

  void addItem(CartItem newItem) {
    final existingKey = _findExistingItemKey(newItem);

    if (existingKey != null) {
      // Jika item sudah ada, tambah kuantitas
      _items[existingKey]!.quantity += newItem.quantity;
      _items[existingKey]!.notifyListeners(); 
    } else {
      // Jika item baru, buat kunci unik dan tambahkan
      final newKey = _uuid.v4();
      _items[newKey] = newItem;
    }
    notifyListeners();
  }

  // --- LOGIKA VOUCHER & DISKON ---
  Voucher? _currentVoucher;
  Voucher? get currentVoucher => _currentVoucher;

  void applyVoucher(Voucher v) {
    _currentVoucher = v;
    notifyListeners();
  }

  void removeVoucher() {
    _currentVoucher = null;
    notifyListeners();
  }

  double get subTotalAmount => totalAmount;

  double get discountAmount {
    if (_currentVoucher == null) return 0.0;
    
    // Validasi sederhana: Jika total 0, tidak ada diskon
    if (totalAmount <= 0) return 0.0;

    double discount = 0.0;
    if (_currentVoucher!.isPercentage) {
      discount = totalAmount * _currentVoucher!.discountValue;
      // Hardcoded cap logic based on description for "v1" (15% max 10k)
      // Idealnya ada field maxDiscount di model Voucher
      if (_currentVoucher!.code == 'DISKON15' && discount > 10000) {
        discount = 10000;
      }
    } else {
      discount = _currentVoucher!.discountValue;
    }

    // Diskon tidak boleh melebihi total
    if (discount > totalAmount) {
      return totalAmount;
    }
    return discount;
  }
  
  // Total yang harus dibayar (Item - Discount + Delivery)
  double get finalTotalAmount => (totalAmount - discountAmount) + deliveryFee;

  void removeSingleItem(String key) {
    if (!_items.containsKey(key)) return;
    final item = _items[key]!;
    if (item.quantity > 1) {
      item.decrementQuantity();
      notifyListeners();
    } else {
      removeItem(key);
    }
  }

  void incrementItemQuantity(String key) {
    if (!_items.containsKey(key)) return;
    _items[key]!.incrementQuantity();
    notifyListeners();
  }

  void removeItem(String key) {
    if (_items.containsKey(key)) {
      _items.remove(key);
      notifyListeners();
    }
  }
  
  void clearCart() => clear();

  void clear() {
    _items.clear();
    _currentVoucher = null; // Reset voucher saat cart kosong
    // Note: Kita mungkin tidak mereset delivery option agar user tidak perlu setting ulang
    notifyListeners();
  }
}
