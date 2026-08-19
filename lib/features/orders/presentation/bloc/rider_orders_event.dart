part of 'rider_orders_bloc.dart';

abstract class RiderOrdersEvent extends Equatable {
  const RiderOrdersEvent();
  @override
  List<Object?> get props => [];
}

class LoadRiderOrders extends RiderOrdersEvent {
  final String riderId;
  const LoadRiderOrders(this.riderId);
  @override
  List<Object?> get props => [riderId];
}

class AdvanceOrderStatusTapped extends RiderOrdersEvent {
  final String orderId;
  final String newStatus;
  const AdvanceOrderStatusTapped({required this.orderId, required this.newStatus});
  @override
  List<Object?> get props => [orderId, newStatus];
}
