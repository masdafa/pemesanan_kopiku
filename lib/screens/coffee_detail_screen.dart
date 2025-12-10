// lib/screens/coffee_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:cached_network_image/cached_network_image.dart'; // Hapus
import '../models/coffee.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class CoffeeDetailScreen extends StatefulWidget {
  final Coffee coffee;
  const CoffeeDetailScreen({super.key, required this.coffee});

  @override
  State<CoffeeDetailScreen> createState() => _CoffeeDetailScreenState();
}

class _CoffeeDetailScreenState extends State<CoffeeDetailScreen> {
  CoffeeSize _selectedSize = CoffeeSize.medium;
  CoffeeTemp _selectedTemp = CoffeeTemp.iced;
  CoffeeTopping _selectedTopping = CoffeeTopping.none;
  CoffeeSugar _selectedSugar = CoffeeSugar.normal; // NEW
  int _quantity = 1;

  void _addToCart(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final newItem = CartItem(
      coffee: widget.coffee,
      size: _selectedSize,
      temp: _selectedTemp,
      topping: _selectedTopping,
      sugar: _selectedSugar, // NEW
      quantity: _quantity,
    );

    cart.addItem(newItem);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_quantity}x ${widget.coffee.name} ditambahkan ke Keranjang.'),
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.of(context).pop();
  }

  double get currentPrice {
    double basePrice = widget.coffee.price;
    if (_selectedSize == CoffeeSize.large) {
      basePrice += 5000;
    } else if (_selectedSize == CoffeeSize.small) {
      basePrice -= 3000;
    }

    if (_selectedTopping != CoffeeTopping.none) {
      basePrice += 4000;
    }

    return basePrice * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);
    final theme = Theme.of(context);
    final isFav = favProvider.isFavorite(widget.coffee.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Hero(
              tag: widget.coffee.id,
              // Ganti ke Image.asset
              child: Image.asset(
                widget.coffee.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                ),
              ),
            ),
          ),
          
          // Back & Favorite Buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.black,
                    ),
                    onPressed: () {
                      favProvider.toggleFavorite(widget.coffee.id);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Content Scrollable Sheet
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.4 - 30,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 30, 24, 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.coffee.name,
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.coffee.rating} (${widget.coffee.reviews})',
                                      style: TextStyle(
                                        color: theme.colorScheme.onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          
                          if (widget.coffee.calories > 0)
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.orange.shade200),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.local_fire_department_outlined, size: 16, color: Colors.orange.shade800),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.coffee.calories} kkal', 
                                    style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold, fontSize: 12)
                                  ),
                                ],
                              ),
                            ),

                          Text(
                            widget.coffee.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                              height: 1.5,
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 24),

                          _buildSectionTitle(theme, 'Ukuran'),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildSizeOption(CoffeeSize.small, 'Small', Icons.coffee),
                              _buildSizeOption(CoffeeSize.medium, 'Medium', Icons.coffee),
                              _buildSizeOption(CoffeeSize.large, 'Large', Icons.coffee),
                            ],
                          ),

                          const SizedBox(height: 24),

                          _buildSectionTitle(theme, 'Suhu'),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildTempOption(CoffeeTemp.hot, 'Hot', Icons.local_fire_department)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildTempOption(CoffeeTemp.iced, 'Ice', Icons.ac_unit)),
                            ],
                          ),

                          const SizedBox(height: 24),
                          _buildSectionTitle(theme, 'Gula (Sugar Level)'), // NEW SECTION
                          const SizedBox(height: 12),
                          Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               _buildSugarOption(CoffeeSugar.zero, '0%'),
                               _buildSugarOption(CoffeeSugar.less, '50%'),
                               _buildSugarOption(CoffeeSugar.normal, '100%'),
                             ],
                          ),

                          const SizedBox(height: 24),
                          _buildSectionTitle(theme, 'Topping'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _buildToppingChip(CoffeeTopping.none, 'No Topping'),
                              _buildToppingChip(CoffeeTopping.boba, 'Boba (+4k)'),
                              _buildToppingChip(CoffeeTopping.cheese, 'Cheese (+4k)'),
                              _buildToppingChip(CoffeeTopping.chocoChips, 'Choco (+4k)'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                          iconSize: 20,
                        ),
                        Text('$_quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => _quantity++),
                          iconSize: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _addToCart(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Add - Rp ${currentPrice.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSizeOption(CoffeeSize size, String label, IconData icon) {
    final isSelected = _selectedSize == size;
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () => setState(() => _selectedSize = size),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.26,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? theme.colorScheme.primary : Colors.grey.shade400, size: size == CoffeeSize.large ? 32 : (size == CoffeeSize.medium ? 28 : 24)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? theme.colorScheme.primary : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTempOption(CoffeeTemp temp, String label, IconData icon) {
    final isSelected = _selectedTemp == temp;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => setState(() => _selectedTemp = temp),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? (temp == CoffeeTemp.hot ? Colors.orange.shade50 : Colors.blue.shade50) : Colors.white,
          border: Border.all(
            color: isSelected ? (temp == CoffeeTemp.hot ? Colors.orange : Colors.blue) : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? (temp == CoffeeTemp.hot ? Colors.orange : Colors.blue) : Colors.grey.shade400, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black87 : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSugarOption(CoffeeSugar sugar, String label) {
    final isSelected = _selectedSugar == sugar;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => setState(() => _selectedSugar = sugar),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.26,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? theme.colorScheme.primary : Colors.grey.shade600,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToppingChip(CoffeeTopping topping, String label) {
    final isSelected = _selectedTopping == topping;
    final theme = Theme.of(context);
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      showCheckmark: false,
      selectedColor: theme.colorScheme.primary,
      backgroundColor: Colors.grey.shade100,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.transparent),
      ),
      onSelected: (bool selected) {
        setState(() {
          _selectedTopping = topping;
        });
      },
    );
  }
}
