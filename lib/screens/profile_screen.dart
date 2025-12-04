// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'edit_profile_screen.dart';
import 'splash_screen.dart';
import 'rewards_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Saya'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Header Profil
            _buildProfileHeader(context, userProvider),
            const Divider(height: 10),

            // Saldo & Poin
            _buildWalletAndPoints(context, userProvider),
            const Divider(height: 20),

            // Daftar Menu
            _buildListTile(context, Icons.receipt_long, 'Riwayat Pesanan', () {
              // Navigasi ke Order Tab
              Navigator.of(context).pop();
              // Catatan: Ini harusnya mengarahkan ke OrderScreen. 
              // Karena OrderScreen ada di MainTabs, navigasi ini memastikan kita kembali ke home dan memilih tab Pesanan
            }),
            _buildListTile(context, Icons.favorite_border, 'Minuman Favorit', () {
              // Navigasi ke daftar favorit
            }),
            _buildListTile(context, Icons.notifications_outlined, 'Notifikasi', () {
              // Navigasi ke Notifikasi (sudah ada di CoffeeListScreen, ini cadangan)
            }),
            _buildListTile(context, Icons.card_giftcard, 'Rewards', () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RewardsScreen()));
            }),
            _buildListTile(context, Icons.settings_outlined, 'Pengaturan Akun', () {
              // Navigasi ke EditProfileScreen
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditProfileScreen()));
            }),

            // Tombol Logout
            const SizedBox(height: 30),
            _buildLogoutButton(context, userProvider),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProvider user) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.brown.shade200,
            child: Text(user.username.substring(0, 1), style: const TextStyle(fontSize: 40, color: Colors.white)),
            // 
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.username, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Text('Member Gold', style: TextStyle(fontSize: 14, color: Colors.amber)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletAndPoints(BuildContext context, UserProvider user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          _buildWalletCard(context, Icons.account_balance_wallet, 'Saldo Dompet', 'Rp ${user.walletBalance.toStringAsFixed(0)}'),
          const SizedBox(width: 10),
          _buildWalletCard(context, Icons.star, 'Poin Reward', '${user.rewardPoints} Poin'),
        ],
      ),
    );
  }

  Widget _buildWalletCard(BuildContext context, IconData icon, String title, String value) {
    return Expanded(
      child: Card(
        elevation: 2,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.green.shade700, size: 30),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 5),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Icon(icon, color: Colors.brown.shade700),
            title: Text(title, style: TextStyle(color: Colors.brown.shade800)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, UserProvider userProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {
            userProvider.logout();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SplashScreen()),
              (Route<dynamic> route) => false,
            );
          },
          icon: const Icon(Icons.logout, color: Colors.red),
          label: const Text('LOGOUT', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            side: const BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}