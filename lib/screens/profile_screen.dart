// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'edit_profile_screen.dart';
import 'splash_screen.dart';
import 'rewards_screen.dart';
import 'order_screen.dart';
import 'favorites_screen.dart'; // Impor halaman favorit

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Header Profil Modern
            _buildProfileHeader(context, userProvider),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  // Saldo & Poin
                  _buildWalletAndPoints(context, userProvider),
                  const SizedBox(height: 30),

                  // Daftar Menu Settings
                  const Align(alignment: Alignment.centerLeft, child: Text("Akun", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                  const SizedBox(height: 10),
                  _buildMenuCard([
                    _buildMenuItem(context, Icons.receipt_long_rounded, 'Riwayat Pesanan', Colors.blue, () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OrderScreen()));
                    }),
                    // Tambahkan navigasi ke halaman favorit
                    _buildMenuItem(context, Icons.favorite_rounded, 'Minuman Favorit', Colors.red, () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FavoritesScreen()));
                    }),
                    _buildMenuItem(context, Icons.notifications_active_rounded, 'Notifikasi', Colors.orange, () {}),
                  ]),

                  const SizedBox(height: 20),
                  const Align(alignment: Alignment.centerLeft, child: Text("Lainnya", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                  const SizedBox(height: 10),
                  _buildMenuCard([
                    _buildMenuItem(context, Icons.card_giftcard_rounded, 'Rewards', Colors.purple, () {
                       Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RewardsScreen()));
                    }),
                    _buildMenuItem(context, Icons.settings_rounded, 'Pengaturan Akun', Colors.grey, () {
                       Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditProfileScreen()));
                    }),
                  ]),

                  // Tombol Logout
                  const SizedBox(height: 30),
                  _buildLogoutButton(context, userProvider),
                  const SizedBox(height: 20),
                  Text("Versi 1.0.0", style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProvider user) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: const Color(0xFF6F4E37),
              child: Text(user.username.isNotEmpty ? user.username.substring(0, 1) : 'U', style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.username, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4E342E))),
                const SizedBox(height: 4),
                const Text('admin@kopi.com', style: TextStyle(fontSize: 14, color: Colors.grey)), // Idealnya ambil dari UserProvider
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.stars, size: 16, color: Colors.amber.shade800),
                      const SizedBox(width: 4),
                      Text('Gold Member', style: TextStyle(fontSize: 12, color: Colors.amber.shade900, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.grey),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditProfileScreen()));
            },
          )
        ],
      ),
    );
  }

  Widget _buildWalletAndPoints(BuildContext context, UserProvider user) {
    return Row(
      children: [
        _buildStatCard(
          context, 
          "Saldo", 
          "Rp ${user.walletBalance.toStringAsFixed(0)}", 
          Icons.account_balance_wallet_rounded, 
          Colors.green
        ),
        const SizedBox(width: 15),
        _buildStatCard(
          context, 
          "Poin", 
          "${user.rewardPoints} Pts", 
          Icons.star_rounded, 
          Colors.amber
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, MaterialColor color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color.shade700, size: 24),
            ),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildLogoutButton(BuildContext context, UserProvider userProvider) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () {
          userProvider.logout();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SplashScreen()),
            (Route<dynamic> route) => false,
          );
        },
        icon: const Icon(Icons.logout_rounded, color: Colors.red),
        label: const Text('Keluar dari Aplikasi', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.red.shade50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
