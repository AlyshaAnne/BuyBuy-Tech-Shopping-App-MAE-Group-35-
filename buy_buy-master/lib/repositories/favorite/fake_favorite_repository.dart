import 'package:buy_buy/repositories/repositories.dart';

class FakeFavoriteRepository implements FavoriteRepositoryInterface {
  final List<String> favoriteIds;

  FakeFavoriteRepository({List<String>? favoriteIds}) : favoriteIds = favoriteIds ?? [];

  @override
  Future<List<String>> getFavoriteIds() async {
    return favoriteIds;
  }

  @override
  Future<void> toggleFavorite(String productId) async {
    if (favoriteIds.contains(productId)) {
      favoriteIds.remove(productId);
    } else {
      favoriteIds.add(productId);
    }
  }
}
