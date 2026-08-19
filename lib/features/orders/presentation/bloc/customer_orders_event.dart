part of 'customer_orders_bloc.dart';

abstract class CustomerOrdersEvent extends Equatable {
  const CustomerOrdersEvent();
  @override
  List<Object?> get props => [];
}

class LoadCustomerOrders extends CustomerOrdersEvent {
  final String customerId;
  const LoadCustomerOrders(this.customerId);
  @override
  List<Object?> get props => [customerId];
}
