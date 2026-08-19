import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/features/menu/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({required super.id, required super.name});

  factory CategoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return CategoryModel(id: doc.id, name: data['name'] as String? ?? '');
  }

  Map<String, dynamic> toMap() => {'name': name};
}
