import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/features/orders/data/models/delivery_address_model.dart';
import 'package:restaurant_app/features/orders/data/models/order_item_model.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_entity.dart';

/// Mirrors the Firestore schema from the PRD exactly, including the
/// nested `rating` object and `stripePaymentIntentId` field.
class OrderModel extends OrderEntity {
  const OrderModel({
    required super.orderId,
    required super.customerId,
    super.riderId,
    required super.items,
    required super.totalAmount,
    required super.paymentStatus,
    super.stripePaymentIntentId,
    required super.orderStatus,
    required super.deliveryAddress,
    super.ratingStars,
    super.ratingReview,
    required super.createdAt,
  });

  factory OrderModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final rating = data['rating'] as Map<String, dynamic>?;
    return OrderModel(
      orderId: doc.id,
      customerId: data['customerId'] as String? ?? '',
      riderId: data['riderId'] as String?,
      items: (data['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItemModel.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: data['paymentStatus'] as String? ?? 'unpaid',
      stripePaymentIntentId: data['stripePaymentIntentId'] as String?,
      orderStatus: data['orderStatus'] as String? ?? 'Order Placed',
      deliveryAddress: DeliveryAddressModel.fromMap(
        Map<String, dynamic>.from(data['deliveryAddress'] as Map? ?? {}),
      ),
      ratingStars: (rating?['stars'] as num?)?.toDouble(),
      ratingReview: rating?['review'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'riderId': riderId,
      'items': items
          .map((e) => OrderItemModel(
                itemId: e.itemId,
                name: e.name,
                quantity: e.quantity,
                price: e.price,
              ).toMap())
          .toList(),
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      'stripePaymentIntentId': stripePaymentIntentId,
      'orderStatus': orderStatus,
      'deliveryAddress': DeliveryAddressModel(
        street: deliveryAddress.street,
        latitude: deliveryAddress.latitude,
        longitude: deliveryAddress.longitude,
      ).toMap(),
      'rating': ratingStars == null ? null : {'stars': ratingStars, 'review': ratingReview},
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
