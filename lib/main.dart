// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/user_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/order_provider.dart';
import 'providers/notification_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const CoffeeApp());
}

class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'Kopi Kang Dafa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Roboto',
          // Skema warna yang lebih cerah dan "fun"
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6F4E37), // Kopi Brown
            primary: const Color(0xFF6F4E37),
            secondary: const Color(0xFFE65100), // Vibrant Orange
            tertiary: const Color(0xFF2E7D32), // Fresh Green
            surface: const Color(0xFFFFF8E1), // Creamy Background
            background: const Color(0xFFFFF8E1),
          ),
          scaffoldBackgroundColor: const Color(0xFFFFF8E1), // Background Cream Hangat
          
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            foregroundColor: Color(0xFF4E342E),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.w800, 
              color: Color(0xFF4E342E),
              fontFamily: 'Roboto',
            ),
          ),
          
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6F4E37),
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: Colors.brown.withOpacity(0.4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          
          // Card yang lebih lembut dan rounded
          cardTheme: CardThemeData(
            elevation: 2,
            shadowColor: Colors.brown.withOpacity(0.1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            color: Colors.white,
          ),
          
          // Input field yang lebih modern
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE65100), width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
