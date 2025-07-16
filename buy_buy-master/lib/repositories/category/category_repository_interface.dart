import 'package:buy_buy/models/models.dart';

abstract interface class CategoryRepositoryInterface {
  Future<List<Category>> getAllCategories();

  Future<Category> getCategoryById(String id);
}
