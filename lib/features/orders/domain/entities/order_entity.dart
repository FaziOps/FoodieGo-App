import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/constants/app_constants.dart';
import 'package:restaurant_app/features/orders/domain/entities/delivery_address_entity.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_item_entity.dart';

class OrderEntity extends Equatable {
  final String orderId;
  final String customerId;
  final String? riderId;
  final List<OrderItemEntity> items;
  final double totalAmount;
  final String paymentStatus; // paid | unpaid
  final String? stripePaymentIntentId;
  final String orderStatus;
  final DeliveryAddressEntity deliveryAddress;
  final double? ratingStars;
  final String? ratingReview;
  final DateTime createdAt;

  const OrderEntity({
    required this.orderId,
    required this.customerId,
    this.riderId,
    required this.items,
    required this.totalAmount,
    required this.paymentStatus,
    this.stripePaymentIntentId,
    required this.orderStatus,
    required this.deliveryAddress,
    this.ratingStars,
    this.ratingReview,
    required this.createdAt,
  });

  bool get isRated => ratingStars != null;
  bool get isActive => orderStatus != AppConstants.statusDelivered &&
      orderStatus != AppConstants.statusRejected &&
      orderStatus != AppConstants.statusCancelled;

  /// Encodes the state machine from the PRD in one place instead of
  /// scattering "what comes next" logic across blocs.
  String? get nextStatus {
    const flow = AppConstants.orderStatusFlow;
    final index = flow.indexOf(orderStatus);
    if (index == -1 || index == flow.length - 1) return null;
    return flow[index + 1];
  }

  @override
  List<Object?> get props => [
        orderId,
        customerId,
        riderId,
        items,
        totalAmount,
        paymentStatus,
        stripePaymentIntentId,
        orderStatus,
        deliveryAddress,
        ratingStars,
        ratingReview,
        createdAt,
      ];
}
