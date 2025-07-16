import 'package:buy_buy/repositories/favorite/favorite_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteRepository implements FavoriteRepositoryInterface {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _favorites = FirebaseFirestore.instance.collection('favorites');

  @override
  Future<List<String>> getFavoriteIds() async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) return [];

    try {
      final doc = await _favorites.doc(uid).get();
      final data = doc.data() as Map<String, dynamic>?;

      return data?['productIds']?.cast<String>() ?? [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> toggleFavorite(String productId) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');

    final doc = _favorites.doc(uid);
    final snapshot = await doc.get();

    final List<String> currentFavorites =
        (snapshot.data() as Map<String, dynamic>?)?['productIds']?.cast<String>() ?? [];

    if (currentFavorites.contains(productId)) {
      await doc.update({
        'productIds': FieldValue.arrayRemove([productId]),
      });
    } else {
      if (snapshot.exists) {
        await doc.update({
          'productIds': FieldValue.arrayUnion([productId]),
        });
      } else {
        await doc.set({
          'productIds': [productId],
        });
      }
    }
  }
}
