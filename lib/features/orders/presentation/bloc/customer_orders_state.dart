part of 'customer_orders_bloc.dart';

abstract class CustomerOrdersState extends Equatable {
  const CustomerOrdersState();
  @override
  List<Object?> get props => [];
}

class CustomerOrdersInitial extends CustomerOrdersState {
  const CustomerOrdersInitial();
}

class CustomerOrdersLoading extends CustomerOrdersState {
  const CustomerOrdersLoading();
}

class CustomerOrdersLoaded extends CustomerOrdersState {
  final List<OrderEntity> orders;
  const CustomerOrdersLoaded(this.orders);
  @override
  List<Object?> get props => [orders];
}

class CustomerOrdersError extends CustomerOrdersState {
  final String message;
  const CustomerOrdersError(this.message);
  @override
  List<Object?> get props => [message];
}
