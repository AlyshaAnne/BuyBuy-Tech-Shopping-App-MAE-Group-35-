import 'package:buy_buy/models/models.dart';

abstract interface class ProductRepositoryInterface {
  Future<List<Product>> getProducts({String? categoryId, String? query, String? brandId, bool? isBrandNew});

  Future<Product?> getProductById(String id);

  Future<List<Brand>> getBrands();
}
