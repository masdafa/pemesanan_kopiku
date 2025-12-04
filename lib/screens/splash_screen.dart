// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'auth_screen.dart';
import 'main_tabs_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer yang mendengarkan perubahan pada status otentikasi
    return Consumer<UserProvider>(
      builder: (ctx, userProvider, _) {
        if (userProvider.isAuthenticated) {
          // Jika sudah login, langsung ke halaman utama
          return const MainTabsScreen(); 
        } else {
          // Jika belum login, tampilkan layar otentikasi
          return const AuthScreen();
        }
      },
    );
  }
}