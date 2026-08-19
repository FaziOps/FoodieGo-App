part of 'admin_orders_bloc.dart';

abstract class AdminOrdersEvent extends Equatable {
  const AdminOrdersEvent();
  @override
  List<Object?> get props => [];
}

class LoadAllOrders extends AdminOrdersEvent {
  const LoadAllOrders();
}

class AcceptOrderTapped extends AdminOrdersEvent {
  final String orderId;
  const AcceptOrderTapped(this.orderId);
  @override
  List<Object?> get props => [orderId];
}

class AssignRiderTapped extends AdminOrdersEvent {
  final String orderId;
  final String riderId;
  const AssignRiderTapped({required this.orderId, required this.riderId});
  @override
  List<Object?> get props => [orderId, riderId];
}
