// lib/screens/coffee_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  int _quantity = 1;

  void _addToCart(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final newItem = CartItem(
      coffee: widget.coffee,
      size: _selectedSize,
      temp: _selectedTemp,
      topping: _selectedTopping,
      quantity: _quantity,
    );

    cart.addItem(newItem);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_quantity}x ${widget.coffee.name} ditambahkan ke Keranjang.'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.brown.shade700,
      ),
    );
    Navigator.of(context).pop();
  }

  // Fungsi untuk menghitung harga item saat ini (untuk tampilan)
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coffee.name),
        actions: [
          IconButton(
            icon: Icon(
              favProvider.isFavorite(widget.coffee.id) ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              favProvider.toggleFavorite(widget.coffee.id);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: widget.coffee.id,
                    child: Image.network(
                      widget.coffee.imageUrl,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      cacheHeight: 300,
                      cacheWidth: 600,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                            height: 300,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.brown.shade300)));
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                          height: 300,
                          color: Colors.grey.shade200,
                          child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.local_cafe, size: 60, color: Colors.brown.shade400),
                                  const Text('Menu Foto', style: TextStyle(color: Colors.grey)),
                                ],
                              ))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.coffee.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(widget.coffee.description, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                        const Divider(height: 30),
                        
                        // Opsi Ukuran & Suhu
                        _buildOptionSection(
                          title: 'Pilih Ukuran & Suhu',
                          children: [
                            _buildChoiceChip<CoffeeSize>(
                                CoffeeSize.small, 'Small', _selectedSize, (val) => setState(() => _selectedSize = val)),
                            _buildChoiceChip<CoffeeSize>(
                                CoffeeSize.medium, 'Medium', _selectedSize, (val) => setState(() => _selectedSize = val)),
                            _buildChoiceChip<CoffeeSize>(
                                CoffeeSize.large, 'Large', _selectedSize, (val) => setState(() => _selectedSize = val)),
                            
                            const SizedBox(width: 10),

                            _buildChoiceChip<CoffeeTemp>(
                                CoffeeTemp.hot, 'Hot', _selectedTemp, (val) => setState(() => _selectedTemp = val)),
                            _buildChoiceChip<CoffeeTemp>(
                                CoffeeTemp.iced, 'Iced', _selectedTemp, (val) => setState(() => _selectedTemp = val)),
                          ],
                        ),

                        // Opsi Topping
                        _buildOptionSection(
                          title: 'Pilih Topping (Opsional)',
                          children: [
                            _buildChoiceChip<CoffeeTopping>(
                              CoffeeTopping.none, 'None', _selectedTopping, (val) => setState(() => _selectedTopping = val)),
                            _buildChoiceChip<CoffeeTopping>(
                              CoffeeTopping.boba, 'Boba', _selectedTopping, (val) => setState(() => _selectedTopping = val)),
                            _buildChoiceChip<CoffeeTopping>(
                              CoffeeTopping.cheese, 'Cheese', _selectedTopping, (val) => setState(() => _selectedTopping = val)),
                            _buildChoiceChip<CoffeeTopping>(
                              CoffeeTopping.chocoChips, 'Choco Chips', _selectedTopping, (val) => setState(() => _selectedTopping = val)),
                          ],
                        ),

                        const Divider(height: 30),

                        // Kuantitas
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Kuantitas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, size: 28),
                                  onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                                  color: Colors.brown.shade700,
                                ),
                                Text('$_quantity', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, size: 28),
                                  onPressed: () => setState(() => _quantity++),
                                  color: Colors.brown.shade700,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Tombol Tambah ke Keranjang (Fixed Footer)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rp ${currentPrice.toStringAsFixed(0)}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                ElevatedButton.icon(
                  onPressed: () => _addToCart(context),
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text('Tambah ke Keranjang', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: children,
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildChoiceChip<T>(T value, String label, T groupValue, Function(T) onSelected) {
    final isSelected = value == groupValue;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.green.shade100,
      backgroundColor: Colors.grey.shade100,
      labelStyle: TextStyle(
        color: isSelected ? Colors.green.shade800 : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? Colors.green.shade700 : Colors.grey.shade400,
      ),
      onSelected: (selected) {
        if (selected) {
          onSelected(value);
        }
      },
    );
  }
}