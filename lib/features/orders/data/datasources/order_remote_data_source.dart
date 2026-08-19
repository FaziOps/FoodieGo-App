import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/core/constants/app_constants.dart';
import 'package:restaurant_app/core/errors/exceptions.dart';
import 'package:restaurant_app/features/orders/data/models/order_model.dart';

/// Single source of truth for all Firestore reads/writes on `orders`.
abstract class OrderRemoteDataSource {
  Future<String> createOrder(OrderModel order);
  Future<List<OrderModel>> getCustomerOrders(String customerId);
  Future<List<OrderModel>> getAllOrders();
  Future<List<OrderModel>> getRiderOrders(String riderId);
  Stream<OrderModel> watchOrder(String orderId);
  Future<void> updateStatus(String orderId, String newStatus);
  Future<void> assignRider(String orderId, String riderId);
  Future<void> cancelOrder(String orderId, String reason);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore firestore;
  OrderRemoteDataSourceImpl(this.firestore);

  CollectionReference<Map<String, dynamic>> get _orders =>
      firestore.collection(AppConstants.ordersCollection);

  @override
  Future<String> createOrder(OrderModel order) async {
    try {
      final ref = await _orders.add(order.toMap());
      return ref.id;
    } catch (e) {
      throw ServerException('Could not place order: $e');
    }
  }

  @override
  Future<List<OrderModel>> getCustomerOrders(String customerId) async {
    try {
      Query<Map<String, dynamic>> query = _orders;
      if (customerId.isNotEmpty) {
        query = query.where('customerId', isEqualTo: customerId);
      }
      final snapshot = await query.get();
      final list = snapshot.docs.map(OrderModel.fromSnapshot).toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } catch (e) {
      throw ServerException('Could not load your orders: $e');
    }
  }

  @override
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final snapshot = await _orders.get();
      final list = snapshot.docs.map(OrderModel.fromSnapshot).toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } catch (e) {
      throw ServerException('Could not load orders: $e');
    }
  }

  @override
  Future<List<OrderModel>> getRiderOrders(String riderId) async {
    try {
      Query<Map<String, dynamic>> query = _orders;
      if (riderId.isNotEmpty) {
        query = query.where('riderId', isEqualTo: riderId);
      }
      final snapshot = await query.get();
      final list = snapshot.docs.map(OrderModel.fromSnapshot).toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } catch (e) {
      throw ServerException('Could not load your deliveries: $e');
    }
  }

  @override
  Stream<OrderModel> watchOrder(String orderId) {
    return _orders.doc(orderId).snapshots().map(OrderModel.fromSnapshot);
  }

  @override
  Future<void> updateStatus(String orderId, String newStatus) async {
    try {
      await _orders.doc(orderId).update({'orderStatus': newStatus});
    } catch (e) {
      throw ServerException('Could not update order status: $e');
    }
  }

  @override
  Future<void> assignRider(String orderId, String riderId) async {
    try {
      await _orders.doc(orderId).update({
        'riderId': riderId,
        'orderStatus': AppConstants.statusPreparing,
      });
    } catch (e) {
      throw ServerException('Could not assign rider: $e');
    }
  }

  @override
  Future<void> cancelOrder(String orderId, String reason) async {
    try {
      await _orders.doc(orderId).update({
        'orderStatus': AppConstants.statusCancelled,
        'cancelReason': reason,
      });
    } catch (e) {
      throw ServerException('Could not cancel order: $e');
    }
  }
}
