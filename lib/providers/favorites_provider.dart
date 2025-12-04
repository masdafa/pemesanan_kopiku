import 'package:flutter/foundation.dart';
import '../models/coffee.dart';

class FavoritesProvider with ChangeNotifier {
  // Map<CoffeeId, Coffee>
  final Map<String, Coffee> _favorites = {};

  List<Coffee> get favorites => _favorites.values.toList();

  bool isFavorite(String coffeeId) {
    return _favorites.containsKey(coffeeId);
  }

  void toggleFavorite(String coffeeId) {
    final coffee = dummyCoffees.firstWhere((c) => c.id == coffeeId);

    if (_favorites.containsKey(coffeeId)) {
      _favorites.remove(coffeeId);
    } else {
      _favorites[coffeeId] = coffee;
    }
    notifyListeners();
  }
}