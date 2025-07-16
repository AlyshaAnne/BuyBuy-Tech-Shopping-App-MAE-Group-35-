abstract interface class FavoriteRepositoryInterface {
  Future<List<String>> getFavoriteIds();

  Future<void> toggleFavorite(String productId);
}
