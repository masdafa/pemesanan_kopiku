import 'package:flutter_test/flutter_test.dart';
import 'package:pemesanan_kopiku/providers/user_provider.dart';
import 'package:pemesanan_kopiku/providers/cart_provider.dart';

void main() {
  group('UserProvider.redeemPointsForVoucher', () {
    test('redeems points and applies voucher to cart', () {
      final user = UserProvider();
      final cart = CartProvider();

      final beforePoints = user.rewardPoints;

      final voucher = user.redeemPointsForVoucher(cart: cart, pointsNeeded: 100, voucherValue: 25000);

      expect(voucher, isNotNull);
      expect(cart.currentVoucher, isNotNull);
      expect(user.rewardPoints, equals(beforePoints - 100));
      expect(voucher.discountValue, equals(25000));
    });

    test('throws when not enough points', () {
      final user = UserProvider();
      final cart = CartProvider();

      // reduce points below requirement
      // We don't have a direct setter, but we can spend wallet not points;
      // so simulate by repeatedly redeeming until low
      while (user.rewardPoints >= 100) {
        user.redeemPointsForVoucher(cart: cart, pointsNeeded: 100, voucherValue: 1);
      }

      expect(() => user.redeemPointsForVoucher(cart: cart, pointsNeeded: 100, voucherValue: 1), throwsException);
    });
  });
}
