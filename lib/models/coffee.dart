// ENUMS
enum CoffeeCategory { coffee, nonCoffee, seasonal, pastry }
enum CoffeeSize { small, medium, large }
enum CoffeeTemp { hot, iced }
enum CoffeeTopping { none, boba, cheese, chocoChips }

String getCategoryName(CoffeeCategory category) {
  switch (category) {
    case CoffeeCategory.coffee:
      return 'Kopi';
    case CoffeeCategory.nonCoffee:
      return 'Non Kopi';
    case CoffeeCategory.seasonal:
      return 'Spesial';
    case CoffeeCategory.pastry:
      return 'Pastry';
  }
}

String getSizeName(CoffeeSize size) {
  switch (size) {
    case CoffeeSize.small:
      return 'Small';
    case CoffeeSize.medium:
      return 'Medium';
    case CoffeeSize.large:
      return 'Large';
  }
}

String getTempName(CoffeeTemp temp) {
  switch (temp) {
    case CoffeeTemp.hot:
      return 'Panas';
    case CoffeeTemp.iced:
      return 'Dingin';
  }
}

String getToppingName(CoffeeTopping topping) {
  switch (topping) {
    case CoffeeTopping.none:
      return 'Tanpa Topping';
    case CoffeeTopping.boba:
      return 'Boba';
    case CoffeeTopping.cheese:
      return 'Cheese Cream';
    case CoffeeTopping.chocoChips:
      return 'Choco Chips';
  }
}


// MODEL COFFEE
class Coffee {
  final String id;
  final String name;
  final String description;
  final double price; // Harga dasar (asumsi untuk ukuran Medium)
  final String imageUrl;
  final CoffeeCategory category;

  Coffee({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.category = CoffeeCategory.coffee,
  });
}

// DUMMY DATA (Ini data statis yang akan digunakan)
List<Coffee> dummyCoffees = [
  Coffee(
    id: 'c1',
    name: 'Classic Latte',
    description: 'Espresso dengan susu steamed yang lembut.',
    price: 30000,
    imageUrl: 'https://images.unsplash.com/photo-1541167760496-1628856ab220?fit=crop&w=400&q=80',
    category: CoffeeCategory.coffee,
  ),
  Coffee(
    id: 'c2',
    name: 'Caramel Macchiato',
    description: 'Perpaduan espresso, susu, dan sirup karamel manis.',
    price: 42000,
    imageUrl: 'https://images.unsplash.com/photo-1582299878207-68b1a8d42d31?fit=crop&w=400&q=80',
    category: CoffeeCategory.coffee,
  ),
  Coffee(
    id: 'c3',
    name: 'Iced Americano',
    description: 'Sangat menyegarkan. Espresso yang dicampur air dan es.',
    price: 25000,
    imageUrl: 'https://images.unsplash.com/photo-1521406692052-a5e840d42187?fit=crop&w=400&q=80',
    category: CoffeeCategory.coffee,
  ),
  Coffee(
    id: 'nc1',
    name: 'Mocha Praline',
    description: 'Cokelat kaya rasa dengan sentuhan kacang praline.',
    price: 42000,
    imageUrl: 'https://images.unsplash.com/photo-1571408712613-cfd9d2011b9a?fit=crop&w=400&q=80',
    category: CoffeeCategory.nonCoffee,
  ),
  Coffee(
    id: 'nc2',
    name: 'Matcha Frappe',
    description: 'Minuman dingin kental dengan rasa otentik teh hijau Jepang.',
    price: 38000,
    imageUrl: 'https://images.unsplash.com/photo-1536762299388-9d48b11c97a7?fit=crop&w=400&q=80',
    category: CoffeeCategory.nonCoffee,
  ),
  Coffee(
    id: 's1',
    name: 'Holiday Spice Latte',
    description: 'Menu spesial musiman dengan campuran rempah hangat.',
    price: 45000,
    imageUrl: 'https://images.unsplash.com/photo-1546738549-906d9b93b2a2?fit=crop&w=400&q=80',
    category: CoffeeCategory.seasonal,
  ),
  Coffee(
    id: 's2',
    name: 'Summer Berry Cooler',
    description: 'Minuman dingin menyegarkan dengan campuran buah berry segar.',
    price: 40000,
    imageUrl: 'https://images.unsplash.com/photo-1552566085-f5b9d36e2f17?fit=crop&w=400&q=80',
    category: CoffeeCategory.seasonal,
  ),
  Coffee(
    id: 'p1',
    name: 'Croissant Mentega',
    description: 'Pastry renyah dengan lapisan mentega yang lezat.',
    price: 35000,
    imageUrl: 'https://images.unsplash.com/photo-1585518419759-c1f448bf21cc?fit=crop&w=400&q=80',
    category: CoffeeCategory.pastry,
  ),
  Coffee(
    id: 'p2',
    name: 'Cheese Cake',
    description: 'Kue keju yang lembut dan creamy dengan rasa nikmat.',
    price: 48000,
    imageUrl: 'https://images.unsplash.com/photo-1621394686414-8c26a9dac28c?fit=crop&w=400&q=80',
    category: CoffeeCategory.pastry,
  ),
  Coffee(
    id: 'p3',
    name: 'Chocolate Donut',
    description: 'Donat cokelat empuk dengan topping cokelat glossy.',
    price: 20000,
    imageUrl: 'https://images.unsplash.com/photo-1585621081563-430f63602d4b?fit=crop&w=400&q=80',
    category: CoffeeCategory.pastry,
  ),
  Coffee(
    id: 'p4',
    name: 'Blueberry Muffin',
    description: 'Muffin lembut dengan blueberry segar yang manis asam.',
    price: 32000,
    imageUrl: 'https://images.unsplash.com/photo-1598080785009-e1c4bc62d85d?fit=crop&w=400&q=80',
    category: CoffeeCategory.pastry,
  ),
];