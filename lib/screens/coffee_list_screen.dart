// lib/screens/coffee_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/coffee.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/notification_provider.dart';
import 'cart_screen.dart';
import 'coffee_detail_screen.dart';
import 'notification_screen.dart';

class CoffeeGridItem extends StatelessWidget {
  final Coffee coffee;
  const CoffeeGridItem({super.key, required this.coffee});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoffeeDetailScreen(coffee: coffee)));
      },
      child: Card(
        elevation: 6,
        shadowColor: Colors.brown.withAlpha(100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Hero(
                tag: coffee.id,
                child: Image.network(
                  coffee.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  cacheHeight: 140,
                  cacheWidth: 300,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: 140,
                      child: Center(
                          child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.brown.shade300)),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                      height: 140,
                      color: Colors.grey.shade200,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_cafe, size: 40, color: Colors.brown.shade400),
                          const Text('Menu Foto', style: TextStyle(color: Colors.grey)),
                        ],
                      ))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coffee.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Rp ${coffee.price.toStringAsFixed(0)}', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(
                          favProvider.isFavorite(coffee.id) ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 24,
                        ),
                        onPressed: () {
                          favProvider.toggleFavorite(coffee.id);
                        },
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

class CoffeeListScreen extends StatefulWidget {
  const CoffeeListScreen({super.key});

  @override
  State<CoffeeListScreen> createState() => _CoffeeListScreenState();
}

class _CoffeeListScreenState extends State<CoffeeListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    // Fitur: Filter/Pencarian Canggih
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- Filter Logik ---
  List<Coffee> _getFilteredCoffees(CoffeeCategory category) {
    final all = dummyCoffees.where((c) => c.category == category).toList();
    if (_searchText.isEmpty) return all;
    return all.where((coffee) => coffee.name.toLowerCase().contains(_searchText.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final user = Provider.of<UserProvider>(context);

    return DefaultTabController(
      length: CoffeeCategory.values.length,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(context, user, cart),
            _buildSearchBox(context),

            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  isScrollable: true,
                  labelColor: Colors.brown.shade800,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  unselectedLabelColor: Colors.grey.shade600,
                  unselectedLabelStyle: const TextStyle(fontSize: 13),
                  indicatorColor: Colors.brown.shade700,
                  indicatorWeight: 3,
                  tabs: CoffeeCategory.values.map((c) => Tab(text: getCategoryName(c))).toList(),
                ),
              ),
            ),
            
            SliverFillRemaining(
              child: TabBarView(
                children: CoffeeCategory.values.map((category) {
                  final coffees = _getFilteredCoffees(category); // Gunakan fungsi filter
                  if (coffees.isEmpty) {
                      return const Center(child: Text('Menu tidak ditemukan.'));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, 
                      childAspectRatio: 0.7, 
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: coffees.length,
                    itemBuilder: (ctx, i) => CoffeeGridItem(coffee: coffees[i]),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context, UserProvider user, CartProvider cart) {
    final notif = Provider.of<NotificationProvider>(context);
    return SliverAppBar(
      expandedHeight: 160,
      floating: true,
      snap: true,
      backgroundColor: Colors.brown.shade700,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.brown.shade800, Colors.brown.shade600],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo and Name
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(230),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.coffee, size: 40, color: Colors.brown.shade700),
              ),
              const SizedBox(height: 12),
              const Text(
                'Kopi Kang Dafa',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Selamat Datang, ${user.username.split(' ')[0]}!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(200),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        // Fitur: Notifikasi In-App
        Stack(
          children: [
            IconButton(icon: const Icon(Icons.notifications_none, size: 28), onPressed: () { 
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationScreen()));
             }),
            if (notif.unreadCount > 0)
              Positioned(
                right: 8, top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(notif.unreadCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center),
                ),
              )
          ],
        ),
        
        Stack(
          children: [
            IconButton(icon: const Icon(Icons.shopping_bag_outlined, size: 28), onPressed: () { 
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CartScreen())); 
            }),
            if (cart.itemCount > 0)
              Positioned(
                right: 8, top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: Colors.redAccent.shade700, borderRadius: BorderRadius.circular(10)),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(cart.itemCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center),
                ),
              )
          ],
        ),
      ],
    );
  }
  
  // Fitur: Kotak Pencarian
  Widget _buildSearchBox(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      sliver: SliverToBoxAdapter(
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Cari menu (mis: Latte, Mocha...)',
            prefixIcon: const Icon(Icons.search, color: Colors.brown),
            suffixIcon: _searchText.isNotEmpty ? IconButton(icon: const Icon(Icons.clear, color: Colors.grey), onPressed: () => _searchController.clear()) : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.all(15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.brown.shade200, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.brown.shade700, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}