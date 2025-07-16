import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/repositories/product/product_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepository implements ProductRepositoryInterface {
  final CollectionReference _products = FirebaseFirestore.instance.collection('products');
  final CollectionReference _brands = FirebaseFirestore.instance.collection('brands');

  @override
  Future<List<Product>> getProducts({String? categoryId, String? query, String? brandId, bool? isBrandNew}) async {
    try {
      Query queryRef = _products;

      if (categoryId != null && categoryId != allCategory.id) {
        queryRef = queryRef.where('categoryId', isEqualTo: categoryId);
      }

      if (brandId != null && brandId.isNotEmpty) {
        queryRef = queryRef.where('brandId', isEqualTo: brandId);
      }

      if (isBrandNew != null) {
        queryRef = queryRef.where('isBrandNew', isEqualTo: isBrandNew);
      }

      final snapshot = await queryRef.get();

      final products =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Product.fromJson({...data, 'documentID': doc.id});
          }).toList();

      if (query != null && query.isNotEmpty) {
        final lowerQuery = query.toLowerCase();
        return products.where((product) => product.name.toLowerCase().contains(lowerQuery)).toList();
      }

      return products;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Product?> getProductById(String productId) async {
    try {
      final doc = await _products.doc(productId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return Product.fromJson(data..['documentID'] = doc.id);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Brand>> getBrands() async {
    try {
      final snapshot = await _brands.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Brand.fromJson({...data, 'documentID': doc.id});
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
