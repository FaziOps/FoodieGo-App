part of 'rider_orders_bloc.dart';

abstract class RiderOrdersState extends Equatable {
  const RiderOrdersState();
  @override
  List<Object?> get props => [];
}

class RiderOrdersInitial extends RiderOrdersState {
  const RiderOrdersInitial();
}

class RiderOrdersLoading extends RiderOrdersState {
  const RiderOrdersLoading();
}

class RiderOrdersLoaded extends RiderOrdersState {
  final List<OrderEntity> orders;
  const RiderOrdersLoaded(this.orders);
  @override
  List<Object?> get props => [orders];
}

class RiderOrdersError extends RiderOrdersState {
  final String message;
  const RiderOrdersError(this.message);
  @override
  List<Object?> get props => [message];
}
