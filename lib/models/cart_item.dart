import 'package:flutter/foundation.dart';
import 'coffee.dart'; // Import model Coffee

class CartItem extends ChangeNotifier {
  final Coffee coffee;
  final CoffeeSize size;
  final CoffeeTemp temp;
  final CoffeeTopping topping;
  final CoffeeSugar sugar; // NEW
  int quantity;

  CartItem({
    required this.coffee,
    required this.size,
    required this.temp,
    this.topping = CoffeeTopping.none,
    this.sugar = CoffeeSugar.normal, // Default normal 100%
    required this.quantity,
  });

  // *** LOGIKA HARGA ***

  // Harga per item berdasarkan ukuran
  double get priceBySize {
    double basePrice = coffee.price;
    switch (size) {
      case CoffeeSize.small:
        return basePrice - 5000;
      case CoffeeSize.large:
        return basePrice + 5000;
      case CoffeeSize.medium:
        return basePrice;
    }
  }

  // Harga tambahan untuk topping
  double get toppingPrice {
    switch (topping) {
      case CoffeeTopping.boba:
        return 5000;
      case CoffeeTopping.cheese:
        return 7000;
      case CoffeeTopping.chocoChips:
        return 3000;
      case CoffeeTopping.none:
        return 0;
    }
  }

  // Harga akhir per satuan item (dengan topping)
  double get adjustedPrice {
    return priceBySize + toppingPrice;
  }

  // Total harga untuk item ini (Harga Satuan * Kuantitas)
  double get totalAmount {
    return adjustedPrice * quantity;
  }

  // *** GETTERS STRING ***
  String get sizeString => getSizeName(size);
  String get tempString => getTempName(temp);
  String get toppingString => getToppingName(topping);
  String get sugarString => getSugarName(sugar);


  // *** METHODS UNTUK MENGUBAH KUANTITAS ***

  void incrementQuantity() {
    quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
      notifyListeners();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'coffeeId': coffee.id,
      'name': coffee.name,
      'imageUrl': coffee.imageUrl,
      'size': size.toString().split('.').last,
      'temp': temp.toString().split('.').last,
      'topping': topping.toString().split('.').last,
      'sugar': sugar.toString().split('.').last,
      'quantity': quantity,
      'pricePerItem': adjustedPrice,
      'totalPrice': totalAmount,
    };
  }
}