import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pemesanan_kopiku/providers/user_provider.dart';
import 'package:pemesanan_kopiku/providers/cart_provider.dart';
import 'package:pemesanan_kopiku/screens/rewards_screen.dart';

void main() {
  testWidgets('RewardsScreen redeem button applies voucher to cart', (WidgetTester tester) async {
    final user = UserProvider();
    final cart = CartProvider();

    // Ensure user has enough points (default is 500)
    expect(user.rewardPoints >= 100, isTrue);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>.value(value: user),
          ChangeNotifierProvider<CartProvider>.value(value: cart),
        ],
        child: const MaterialApp(home: RewardsScreen()),
      ),
    );

    // Wait for frames
    await tester.pumpAndSettle();

    // The redeem button should be present
    final redeemButton = find.text('Tukarkan Sekarang');
    expect(redeemButton, findsOneWidget);

    // Tap the redeem button
    await tester.tap(redeemButton);
    await tester.pumpAndSettle();

    // After tapping, the cart should have a currentVoucher
    expect(cart.currentVoucher, isNotNull);
    // And user's points should have decreased
    expect(user.rewardPoints < 500, isTrue);
  });
}
