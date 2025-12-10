// ENUMS
enum CoffeeCategory { coffee, nonCoffee, seasonal, pastry }
enum CoffeeSize { small, medium, large }
enum CoffeeTemp { hot, iced }
enum CoffeeTopping { none, boba, cheese, chocoChips }
enum CoffeeSugar { zero, less, normal } // NEW

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

String getSugarName(CoffeeSugar sugar) { // NEW
  switch (sugar) {
    case CoffeeSugar.zero:
      return '0%';
    case CoffeeSugar.less:
      return '50%';
    case CoffeeSugar.normal:
      return '100%';
  }
}


// MODEL COFFEE PROFESIONAL
class Coffee {
  final String id;
  final String name;
  final String description;
  final double price; // Harga dasar (asumsi untuk ukuran Medium)
  final String imageUrl;
  final CoffeeCategory category;
  
  // New Fields
  final double rating;
  final int reviews;
  final bool isBestSeller;
  final int calories;

  Coffee({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.category = CoffeeCategory.coffee,
    this.rating = 4.5,
    this.reviews = 0,
    this.isBestSeller = false,
    this.calories = 0,
  });
}

// DUMMY DATA LENGKAP (ASSETS LOKAL - FIXED)
List<Coffee> dummyCoffees = [
  // --- KOPI ---
  Coffee(
    id: 'c1',
    name: 'Classic Latte',
    description: 'Espresso full-bodied dipadukan dengan susu steamed lembut dan lapisan foam tipis.',
    price: 30000,
    imageUrl: 'assets/images/c1.jpg',
    category: CoffeeCategory.coffee,
    rating: 4.8,
    reviews: 120,
    isBestSeller: true,
    calories: 190,
  ),
  Coffee(
    id: 'c2',
    name: 'Caramel Macchiato',
    description: 'Simfoni rasa espresso, vanilla, dan saus karamel premium yang manis dan legit.',
    price: 42000,
    imageUrl: 'assets/images/c2.jpg',
    category: CoffeeCategory.coffee,
    rating: 4.9,
    reviews: 215,
    isBestSeller: true,
    calories: 250,
  ),
  Coffee(
    id: 'c3',
    name: 'Iced Americano',
    description: 'Kesegaran murni double shot espresso yang dituangkan di atas es batu kristal.',
    price: 25000,
    imageUrl: 'assets/images/c3.jpg',
    category: CoffeeCategory.coffee,
    rating: 4.6,
    reviews: 85,
    calories: 15,
  ),
  Coffee(
    id: 'c4',
    name: 'Cappuccino',
    description: 'Keseimbangan sempurna antara espresso, steamed milk, dan foam tebal yang creamy.',
    price: 32000,
    imageUrl: 'assets/images/c4.jpg',
    category: CoffeeCategory.coffee,
    rating: 4.7,
    reviews: 98,
    calories: 120,
  ),
  Coffee(
    id: 'c5',
    name: 'Kopi Gula Aren',
    description: 'Kearifan lokal kopi susu dengan gula aren asli yang legit dan aromatik.',
    price: 28000,
    imageUrl: 'assets/images/c5.jpg',
    category: CoffeeCategory.coffee,
    rating: 4.9,
    reviews: 350,
    isBestSeller: true,
    calories: 210,
  ),

  // --- NON KOPI ---
  Coffee(
    id: 'nc1',
    name: 'Signature Chocolate',
    description: 'Cokelat Belgia premium yang dilelehkan dengan susu segar. Kaya dan mewah.',
    price: 38000,
    imageUrl: 'assets/images/nc1.jpg',
    category: CoffeeCategory.nonCoffee,
    rating: 4.8,
    reviews: 145,
    isBestSeller: true,
    calories: 320,
  ),
  Coffee(
    id: 'nc2',
    name: 'Matcha Latte',
    description: 'Teh hijau Matcha Uji Jepang asli, diaduk dengan susu hangat. Zen dalam cangkir.',
    price: 38000,
    imageUrl: 'assets/images/nc2.jpg',
    category: CoffeeCategory.nonCoffee,
    rating: 4.7,
    reviews: 110,
    calories: 180,
  ),
  Coffee(
    id: 'nc3',
    name: 'Taro Latte',
    description: 'Rasa unik talas ungu yang manis lembut, favorit milenial.',
    price: 35000,
    imageUrl: 'assets/images/nc3.jpg',
    category: CoffeeCategory.nonCoffee,
    rating: 4.5,
    reviews: 60,
    calories: 220,
  ),
  Coffee(
    id: 'nc4',
    name: 'Red Velvet Latte',
    description: 'Minuman berwarna merah menggoda dengan rasa cocoa dan buttermilk.',
    price: 36000,
    imageUrl: 'assets/images/nc4.jpg',
    category: CoffeeCategory.nonCoffee,
    rating: 4.6,
    reviews: 75,
    calories: 240,
  ),

  // --- SEASONAL ---
  Coffee(
    id: 's1',
    name: 'Holiday Spice Latte',
    description: 'Edisi terbatas! Campuran rempah kayu manis, cengkeh, dan espresso.',
    price: 45000,
    imageUrl: 'assets/images/s1.jpg',
    category: CoffeeCategory.seasonal,
    rating: 4.8,
    reviews: 40,
    calories: 280,
  ),
  Coffee(
    id: 's2',
    name: 'Summer Berry Cooler',
    description: 'Sparkling soda dengan potongan buah berry asli. Sangat menyegarkan!',
    price: 40000,
    imageUrl: 'assets/images/s2.jpg',
    category: CoffeeCategory.seasonal,
    rating: 4.7,
    reviews: 55,
    calories: 140,
  ),
  Coffee(
    id: 's3',
    name: 'Avocado Coffee',
    description: 'Jus alpukat mentega kental disiram espresso shot. Creamy dan bold.',
    price: 48000,
    imageUrl: 'assets/images/s3.jpg',
    category: CoffeeCategory.seasonal,
    rating: 4.9,
    reviews: 80,
    isBestSeller: true,
    calories: 350,
  ),

  // --- PASTRY ---
  Coffee(
    id: 'p1',
    name: 'Butter Croissant',
    description: 'Croissant klasik Prancis dengan lapisan layer mentega yang renyah dan gurih.',
    price: 25000,
    imageUrl: 'assets/images/p1.jpg',
    category: CoffeeCategory.pastry,
    rating: 4.8,
    reviews: 130,
    isBestSeller: true,
    calories: 260,
  ),
  Coffee(
    id: 'p2',
    name: 'New York Cheesecake',
    description: 'Cheesecake panggang padat namun lembut dengan crust biskuit.',
    price: 45000,
    imageUrl: 'assets/images/p2.jpg',
    category: CoffeeCategory.pastry,
    rating: 4.9,
    reviews: 90,
    calories: 400,
  ),
  Coffee(
    id: 'p3',
    name: 'Chocolate Glazed Donut',
    description: 'Donat ragi empuk dicelup dalam ganache cokelat pekat.',
    price: 18000,
    imageUrl: 'assets/images/p3.jpg',
    category: CoffeeCategory.pastry,
    rating: 4.5,
    reviews: 65,
    calories: 290,
  ),
  Coffee(
    id: 'p4',
    name: 'Blueberry Muffin',
    description: 'Muffin vanila moist penuh dengan ledakan buah blueberry segar.',
    price: 28000,
    imageUrl: 'assets/images/p4.jpg',
    category: CoffeeCategory.pastry,
    rating: 4.6,
    reviews: 45,
    calories: 340,
  ),
  Coffee(
    id: 'p5',
    name: 'Beef Sausage Roll',
    description: 'Sosis sapi premium dibalut puff pastry renyah.',
    price: 32000,
    imageUrl: 'assets/images/p5.jpg',
    category: CoffeeCategory.pastry,
    rating: 4.7,
    reviews: 70,
    calories: 310,
  ),
];
