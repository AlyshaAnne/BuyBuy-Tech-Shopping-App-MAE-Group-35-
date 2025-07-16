import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/repositories/cart/cart_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartRepository implements CartRepositoryInterface {
  final CollectionReference _carts = FirebaseFirestore.instance.collection('carts');

  @override
  Future<List<CartItem>> getCartItems() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return [];

      final doc = await _carts.doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final List<dynamic> products = data['products'] ?? [];
        return products.map((item) {
          return CartItem.fromJson(item);
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> updateCart({required List<CartItem> cartItems}) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final doc = _carts.doc(uid);
      await doc.set({'products': cartItems.map((item) => item.toJson()).toList()});
    } catch (e) {
      return;
    }
  }
}
