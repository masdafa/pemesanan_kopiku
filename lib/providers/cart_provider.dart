import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  // Map<UniqueCartKey, CartItem>
  final Map<String, CartItem> _items = {};
  final Uuid _uuid = Uuid();

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

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
      // Perlu notifyListeners pada CartItem yang dimodifikasi
      _items[existingKey]!.notifyListeners(); 
    } else {
      // Jika item baru, buat kunci unik dan tambahkan
      final newKey = _uuid.v4();
      _items[newKey] = newItem;
    }
    notifyListeners();
  }

  // Compatibility getters/methods used elsewhere in app
  double get subTotalAmount => totalAmount;

  double get discountAmount => 0.0; // No voucher calc yet

  // Simple voucher holder (optional)
  dynamic _currentVoucher;
  dynamic get currentVoucher => _currentVoucher;
  void applyVoucher(dynamic v) {
    _currentVoucher = v;
    notifyListeners();
  }

  void removeVoucher() {
    _currentVoucher = null;
    notifyListeners();
  }

  void clearCart() => clear();

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
  
  void clear() {
    _items.clear();
    notifyListeners();
  }
}