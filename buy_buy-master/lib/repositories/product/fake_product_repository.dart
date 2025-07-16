import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/repositories/product/product_repository_interface.dart';

class FakeProductRepository implements ProductRepositoryInterface {
  final List<Product> products;

  FakeProductRepository({List<Product>? products}) : products = products ?? [];

  @override
  Future<List<Brand>> getBrands() async {
    return [];
  }

  @override
  Future<Product?> getProductById(String id) async {
    return products.firstWhere((p) => p.id == id);
  }

  @override
  Future<List<Product>> getProducts({String? categoryId, String? query, String? brandId, bool? isBrandNew}) async {
    return products.where((product) {
      final matchesCategory = categoryId == null || product.categoryId == categoryId;
      final matchesQuery = query == null || product.name.toLowerCase().contains(query.toLowerCase());
      final matchesBrand = brandId == null || product.brandId == brandId;
      final matchesIsBrandNew = isBrandNew == null || product.isBrandNew == isBrandNew;

      return matchesCategory && matchesQuery && matchesBrand && matchesIsBrandNew;
    }).toList();
  }
}


class FakeProductRepositoryWithError implements ProductRepositoryInterface {
  @override
  Future<List<Brand>> getBrands() async {
    throw Exception('Failed to load brands');
  }

  @override
  Future<Product?> getProductById(String id) async {
    throw Exception('Failed to load product');
  }

  @override
  Future<List<Product>> getProducts({String? categoryId, String? query, String? brandId, bool? isBrandNew}) async {
    throw Exception('Failed to load products');
  }
}
