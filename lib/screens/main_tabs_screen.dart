// lib/screens/main_tabs_screen.dart

import 'package:flutter/material.dart';
import 'coffee_list_screen.dart';
import 'order_screen.dart';
import 'voucher_screen.dart';
import 'profile_screen.dart';

class MainTabsScreen extends StatefulWidget {
  const MainTabsScreen({super.key});

  @override
  State<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen> {
  int _selectedPageIndex = 0;

  final List<Widget> _pages = [
    const CoffeeListScreen(),
    const OrderScreen(),
    const VoucherScreen(),
    const ProfileScreen(),
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6F4E37));
            }
            return TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey.shade600);
          }),
        ),
        child: NavigationBar(
          onDestinationSelected: _selectPage,
          selectedIndex: _selectedPageIndex,
          elevation: 5,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFFFCC80), // Warna indikator oranye muda yang ceria
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.coffee_outlined),
              selectedIcon: Icon(Icons.coffee, color: Color(0xFF5D4037)),
              label: 'Menu',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long, color: Color(0xFF5D4037)),
              label: 'Pesanan',
            ),
            NavigationDestination(
              icon: Icon(Icons.confirmation_number_outlined),
              selectedIcon: Icon(Icons.confirmation_number, color: Color(0xFF5D4037)),
              label: 'Promo', // Ubah label biar lebih menarik
            ),
            NavigationDestination(
              icon: Icon(Icons.account_circle_outlined),
              selectedIcon: Icon(Icons.account_circle, color: Color(0xFF5D4037)),
              label: 'Akun',
            ),
          ],
        ),
      ),
    );
  }
}
