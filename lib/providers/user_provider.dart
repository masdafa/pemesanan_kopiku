import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart'; // Package untuk membuat ID unik
import '../models/voucher.dart';
import '../providers/cart_provider.dart';

class User {
  final String id;
  String name;
  String email;
  String phone;
  double walletBalance;
  int rewardPoints;

  User({
    required this.id,
    this.name = 'Administrator',
    this.email = 'admin@kopi.com',
    this.phone = '08123456789',
    this.walletBalance = 100000.0,
    this.rewardPoints = 500,
  });
}

class UserProvider with ChangeNotifier {
  final Uuid _uuid = Uuid();
  late User _currentUser;

  UserProvider() {
    _currentUser = User(id: _uuid.v4());
  }
  bool _isAdmin = true; // Status admin
  bool _isAuthenticated = true; // Status login

  User get currentUser => _currentUser;
  bool get isAdmin => _isAdmin;
  bool get isAuthenticated => _isAuthenticated;

  // Compatibility getters used by existing UI code
  String get username => _currentUser.name;
  double get walletBalance => _currentUser.walletBalance;
  int get rewardPoints => _currentUser.rewardPoints;

  Future<void> login(String email, String password) async {
    // Logika otentikasi sederhana
    if (email == 'admin@kopi.com' && password == 'admin123') {
      _isAuthenticated = true;
      _isAdmin = true;
      _currentUser = User(id: _uuid.v4(), name: 'Hai, Administrator!');
    } else if (email == 'user@kopi.com' && password == 'user123') {
      _isAuthenticated = true;
      _isAdmin = false;
      _currentUser = User(id: _uuid.v4(), name: 'Hai, Pelanggan Setia!');
    } else {
      // Gagal login
      throw Exception('Username atau password salah');
    }
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _isAdmin = false;
    _currentUser = User(id: _uuid.v4(), name: 'Hai, Tamu!');
    notifyListeners();
  }

  void updateProfile({String? name, String? email, String? phone, String? firstName, String? lastName}) {
    String? finalName = name;
    if ((firstName != null && firstName.isNotEmpty) || (lastName != null && lastName.isNotEmpty)) {
      finalName = '${firstName ?? ''}${(firstName != null && lastName != null && lastName.isNotEmpty) ? ' ' : ''}${lastName ?? ''}'.trim();
    }
    if (finalName != null && finalName.isNotEmpty) _currentUser.name = finalName;
    if (email != null) _currentUser.email = email;
    if (phone != null) _currentUser.phone = phone;
    notifyListeners();
  }

  void addPoints(int pts) {
    _currentUser.rewardPoints += pts;
    notifyListeners();
  }

  void deductFromWallet(double amt) {
    spendWallet(amt);
  }

  void updateWallet(double amount) {
    _currentUser.walletBalance += amount;
    notifyListeners();
  }

  bool spendWallet(double amount) {
    if (_currentUser.walletBalance >= amount) {
      _currentUser.walletBalance -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Redeem reward points for a voucher and apply it to the cart.
  /// Returns the Voucher if successful, otherwise throws an Exception.
  Voucher redeemPointsForVoucher({required CartProvider cart, int pointsNeeded = 100, double voucherValue = 25000}) {
    if (_currentUser.rewardPoints < pointsNeeded) {
      throw Exception('Poin tidak cukup');
    }
    _currentUser.rewardPoints -= pointsNeeded;

    final code = 'FREE${_uuid.v4().substring(0, 6).toUpperCase()}';
    final v = Voucher(
      id: _uuid.v4(),
      title: 'FREE Kopi',
      description: 'Voucher hadiah dari poin reward',
      discountValue: voucherValue,
      code: code,
      expiryDate: DateTime.now().add(const Duration(days: 7)),
      isPercentage: false,
    );

    cart.applyVoucher(v);
    notifyListeners();
    return v;
  }
}