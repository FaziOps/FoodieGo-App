import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:restaurant_app/core/errors/exceptions.dart';
import 'package:restaurant_app/features/cart/data/models/cart_item_model.dart';

/// Cart lives on-device isolated per authenticated user UID until checkout.
abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCart();
  Future<void> saveCart(List<CartItemModel> items);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String boxName = 'cartBox';

  String get _cartKey {
    final uid = fb.FirebaseAuth.instance.currentUser?.uid;
    return (uid != null && uid.isNotEmpty) ? 'cart_$uid' : 'cart_guest';
  }

  Future<Box> _openBox() => Hive.openBox(boxName);

  @override
  Future<List<CartItemModel>> getCart() async {
    try {
      final box = await _openBox();
      final raw = box.get(_cartKey) as List<dynamic>? ?? [];
      return raw
          .map((e) => CartItemModel.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      throw CacheException('Could not load cart.');
    }
  }

  @override
  Future<void> saveCart(List<CartItemModel> items) async {
    try {
      final box = await _openBox();
      await box.put(_cartKey, items.map((e) => e.toMap()).toList());
    } catch (_) {
      throw CacheException('Could not save cart.');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      final box = await _openBox();
      await box.delete(_cartKey);
    } catch (_) {
      throw CacheException('Could not clear cart.');
    }
  }
}
