import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/core/constants/app_constants.dart';
import 'package:restaurant_app/core/errors/exceptions.dart';
import 'package:restaurant_app/features/menu/data/models/category_model.dart';
import 'package:restaurant_app/features/menu/data/models/menu_item_model.dart';

abstract class MenuRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<MenuItemModel>> getMenuItems({String? categoryId});
  Future<void> addMenuItem(MenuItemModel item);
  Future<void> updateMenuItem(MenuItemModel item);
  Future<void> deleteMenuItem(String itemId);
  Future<void> seedSampleData();
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final FirebaseFirestore firestore;
  MenuRemoteDataSourceImpl(this.firestore);

  CollectionReference<Map<String, dynamic>> get _categories =>
      firestore.collection(AppConstants.categoriesCollection);
  CollectionReference<Map<String, dynamic>> get _items =>
      firestore.collection(AppConstants.menuItemsCollection);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      var snapshot = await _categories.get();
      if (snapshot.docs.isEmpty) {
        await seedSampleData();
        snapshot = await _categories.get();
      }
      return snapshot.docs.map(CategoryModel.fromSnapshot).toList();
    } catch (_) {
      throw ServerException('Could not load categories.');
    }
  }

  @override
  Future<List<MenuItemModel>> getMenuItems({String? categoryId}) async {
    try {
      Query<Map<String, dynamic>> query = _items.where('isAvailable', isEqualTo: true);
      if (categoryId != null) {
        query = query.where('categoryId', isEqualTo: categoryId);
      }
      final snapshot = await query.get();
      return snapshot.docs.map(MenuItemModel.fromSnapshot).toList();
    } catch (_) {
      throw ServerException('Could not load menu items.');
    }
  }

  @override
  Future<void> addMenuItem(MenuItemModel item) async {
    try {
      await _items.add(item.toMap());
    } catch (_) {
      throw ServerException('Could not add menu item.');
    }
  }

  @override
  Future<void> updateMenuItem(MenuItemModel item) async {
    try {
      await _items.doc(item.id).update(item.toMap());
    } catch (_) {
      throw ServerException('Could not update menu item.');
    }
  }

  @override
  Future<void> deleteMenuItem(String itemId) async {
    try {
      await _items.doc(itemId).delete();
    } catch (_) {
      throw ServerException('Could not delete menu item.');
    }
  }

  @override
  Future<void> seedSampleData() async {
    try {
      final catSnap = await _categories.get();
      if (catSnap.docs.isEmpty) {
        final sampleCategories = [
          {'name': 'Burgers'},
          {'name': 'Pizza'},
          {'name': 'Asian & Bowls'},
          {'name': 'Beverages'},
          {'name': 'Desserts'},
        ];
        final Map<String, String> catIds = {};
        for (final c in sampleCategories) {
          final docRef = await _categories.add(c);
          catIds[c['name']!] = docRef.id;
        }

        final sampleItems = [
          {
            'name': 'Gourmet Bacon Cheeseburger',
            'description': 'Juicy beef patty, smoked bacon, cheddar, lettuce, tomato & secret sauce.',
            'price': 14.99,
            'categoryId': catIds['Burgers'] ?? '',
            'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
            'isAvailable': true,
          },
          {
            'name': 'Truffle Mushroom Pizza',
            'description': 'Wood-fired crust, mozzarella, wild mushrooms & black truffle oil.',
            'price': 18.50,
            'categoryId': catIds['Pizza'] ?? '',
            'imageUrl': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500',
            'isAvailable': true,
          },
          {
            'name': 'Spicy Tonkotsu Ramen',
            'description': 'Rich pork broth, chashu pork, soft-boiled egg, nori & scallions.',
            'price': 16.00,
            'categoryId': catIds['Asian & Bowls'] ?? '',
            'imageUrl': 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=500',
            'isAvailable': true,
          },
          {
            'name': 'Crispy Chicken Tacos',
            'description': '3 soft tacos, crispy tenders, chipotle slaw & avocado crema.',
            'price': 12.50,
            'categoryId': catIds['Asian & Bowls'] ?? '',
            'imageUrl': 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=500',
            'isAvailable': true,
          },
          {
            'name': 'Artisanal Iced Matcha Latte',
            'description': 'Organic Japanese matcha, oat milk & vanilla syrup.',
            'price': 5.50,
            'categoryId': catIds['Beverages'] ?? '',
            'imageUrl': 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=500',
            'isAvailable': true,
          },
          {
            'name': 'Warm Chocolate Lava Cake',
            'description': 'Molten chocolate center served warm with vanilla bean ice cream.',
            'price': 8.99,
            'categoryId': catIds['Desserts'] ?? '',
            'imageUrl': 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=500',
            'isAvailable': true,
          },
        ];

        for (final item in sampleItems) {
          await _items.add(item);
        }
      }
    } catch (e) {
      throw ServerException('Failed to seed menu data: $e');
    }
  }
}
