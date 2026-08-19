import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/features/menu/domain/entities/menu_item_entity.dart';

class MenuItemModel extends MenuItemEntity {
  const MenuItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.categoryId,
    required super.imageUrl,
    super.isAvailable = true,
  });

  factory MenuItemModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return MenuItemModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      categoryId: data['categoryId'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      isAvailable: data['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'price': price,
        'categoryId': categoryId,
        'imageUrl': imageUrl,
        'isAvailable': isAvailable,
      };

  factory MenuItemModel.fromEntity(MenuItemEntity e) => MenuItemModel(
        id: e.id,
        name: e.name,
        description: e.description,
        price: e.price,
        categoryId: e.categoryId,
        imageUrl: e.imageUrl,
        isAvailable: e.isAvailable,
      );
}
