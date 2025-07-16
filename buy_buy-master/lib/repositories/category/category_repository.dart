import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/repositories/category/category_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryRepository implements CategoryRepositoryInterface {
  final CollectionReference _categories = FirebaseFirestore.instance.collection('categories');

  @override
  Future<List<Category>> getAllCategories() async {
    try {
      final querySnapshot = await _categories.get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Category.fromJson({...data, 'documentID': doc.id});
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Category> getCategoryById(String id) {
    // TODO: implement getCategoryById
    throw UnimplementedError();
  }
}
