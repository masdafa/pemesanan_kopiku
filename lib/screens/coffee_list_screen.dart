// lib/screens/coffee_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import '../models/coffee.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/notification_provider.dart';
import 'cart_screen.dart';
import 'coffee_detail_screen.dart';
import 'notification_screen.dart';

// --- WIDGET ITEM GRID ---
class CoffeeGridItem extends StatelessWidget {
  final Coffee coffee;
  const CoffeeGridItem({super.key, required this.coffee});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoffeeDetailScreen(coffee: coffee)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6F4E37).withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Bagian Gambar
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Hero(
                    tag: coffee.id,
                    child: Image.asset(
                      coffee.imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                          height: 150,
                          color: Colors.grey.shade100,
                          child: const Icon(Icons.coffee, size: 40, color: Colors.grey)),
                    ),
                  ),
                ),
                // Tombol Favorit
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: IconButton(
                      icon: Icon(
                        favProvider.isFavorite(coffee.id) ? Icons.favorite : Icons.favorite_border,
                        color: favProvider.isFavorite(coffee.id) ? Colors.red : Colors.grey.shade400,
                        size: 20,
                      ),
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        favProvider.toggleFavorite(coffee.id);
                      },
                    ),
                  ),
                ),
                // Rating Pill
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          coffee.rating.toString(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Bagian Info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coffee.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800, 
                      color: const Color(0xFF4E342E)
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_cafe_outlined, size: 12, color: theme.colorScheme.secondary),
                      const SizedBox(width: 4),
                      Text(
                        coffee.category.toString().split('.').last.toUpperCase(),
                        style: TextStyle(fontSize: 10, color: theme.colorScheme.secondary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp ${coffee.price.toStringAsFixed(0)}', 
                        style: TextStyle(
                          color: theme.colorScheme.primary, 
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        )
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [theme.colorScheme.secondary, Colors.orange.shade700],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- SCREEN UTAMA ---
class CoffeeListScreen extends StatefulWidget {
  const CoffeeListScreen({super.key});

  @override
  State<CoffeeListScreen> createState() => _CoffeeListScreenState();
}

class _CoffeeListScreenState extends State<CoffeeListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  bool _isDelivery = true;
  String _selectedLocation = "Kopi Kang Dafa - Serang";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (mounted) {
        setState(() {
          _searchText = _searchController.text;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Coffee> _getFilteredCoffees(CoffeeCategory category) {
    final all = dummyCoffees.where((c) => c.category == category).toList();
    if (_searchText.isEmpty) return all;
    return all.where((coffee) => coffee.name.toLowerCase().contains(_searchText.toLowerCase())).toList();
  }
  
  IconData _getCategoryIcon(CoffeeCategory category) {
    switch (category) {
      case CoffeeCategory.coffee: return Icons.coffee;
      case CoffeeCategory.nonCoffee: return Icons.local_drink;
      case CoffeeCategory.seasonal: return Icons.star_border; 
      case CoffeeCategory.pastry: return Icons.bakery_dining;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: CoffeeCategory.values.length,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopHeader(context),
                    _buildPromoBanner(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  Container(
                    color: theme.scaffoldBackgroundColor,
                    height: 60, // Set explicit height
                    child: TabBar(
                      isScrollable: true,
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF6F4E37),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF6F4E37), Color(0xFF8D6E63)]),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                      ),
                      dividerColor: Colors.transparent,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      tabs: CoffeeCategory.values.map((c) => Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_getCategoryIcon(c), size: 18),
                              const SizedBox(width: 8),
                              Text(getCategoryName(c), style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      )).toList(),
                    ),
                  ),
                ),
              ),
            ],
            body: TabBarView(
              children: CoffeeCategory.values.map((category) {
                final coffees = _getFilteredCoffees(category);
                if (coffees.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 80, color: Colors.brown.withOpacity(0.2)),
                          const SizedBox(height: 16),
                          Text('Menu tidak ditemukan', style: TextStyle(color: Colors.brown.shade300, fontSize: 16)),
                        ],
                      ),
                    );
                }
                return GridView.builder(
                  key: ValueKey(category), // Add key for stability
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 24,
                  ),
                  itemCount: coffees.length,
                  itemBuilder: (ctx, i) => CoffeeGridItem(coffee: coffees[i]),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    final user = Provider.of<UserProvider>(context); // Listen to changes now
    final theme = Theme.of(context);
    
    String displayName = "User";
    if (user.username.isNotEmpty) {
      displayName = user.username.split(' ')[0];
    }

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Halo, ', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      Text(displayName, style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // ADD LOYALTY POINTS HERE
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.stars, color: Colors.amber.shade700, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          '${user.rewardPoints} Pts', 
                          style: TextStyle(
                            color: Colors.amber.shade900, 
                            fontWeight: FontWeight.bold, 
                            fontSize: 14
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Consumer<CartProvider>( // Use Consumer for cart badge
                builder: (ctx, cart, child) => Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12)),
                      child: IconButton(
                        icon: Icon(Icons.shopping_bag_outlined, color: theme.colorScheme.secondary),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                      ),
                    ),
                    if (cart.itemCount > 0)
                      Positioned(right: 8, top: 8, child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: Text(cart.itemCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)))),
                  ],
                ),
              )
            ],
          ),
          
          const SizedBox(height: 24),
          
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Mau ngopi apa hari ini?', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF4E342E))),
          ),
          
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(50)),
            child: Row(
              children: [
                _buildToggleItem("Pickup", !_isDelivery),
                _buildToggleItem("Delivery", _isDelivery),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String title, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isDelivery = (title == "Delivery")),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : [],
          ),
          child: Center(
            child: Text(
              title, 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                color: isActive ? const Color(0xFF6F4E37) : Colors.grey
              )
            )
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.only(top: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _promoCard(
            const [Color(0xFF66BB6A), Color(0xFF2E7D32)], 
            "Buy 1 Get 1", 
            "Spesial Hari Ini", 
            Icons.local_offer
          ),
          _promoCard(
            const [Color(0xFFFFA726), Color(0xFFEF6C00)], 
            "Diskon 50%", 
            "Pengguna Baru", 
            Icons.person_add
          ),
          _promoCard(
            const [Color(0xFF8D6E63), Color(0xFF5D4037)], 
            "Free Delivery", 
            "Min. 50rb", 
            Icons.motorcycle
          ),
        ],
      ),
    );
  }

  Widget _promoCard(List<Color> colors, String title, String subtitle, IconData icon) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: colors[0].withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 6))],
      ),
      child: Stack(
        children: [
          Positioned(right: -20, bottom: -20, child: Icon(icon, size: 100, color: Colors.white.withOpacity(0.15))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                child: const Text("PROMO", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              ),
              const Spacer(),
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 26, height: 1.0)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this.child);

  final Widget child;

  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material( // Wrap with Material
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: shrinkOffset > 5 ? 2.0 : 0.0, // Add elevation on scroll
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return child != oldDelegate.child; // Rebuild only if child widget changes
  }
}
