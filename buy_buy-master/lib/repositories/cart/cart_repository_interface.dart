import 'package:buy_buy/models/models.dart';

abstract interface class CartRepositoryInterface {
  Future<List<CartItem>> getCartItems();

  Future<void> updateCart({required List<CartItem> cartItems});
}
