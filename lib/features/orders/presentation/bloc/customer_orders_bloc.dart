import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_entity.dart';
import 'package:restaurant_app/features/orders/domain/usecases/get_customer_orders_usecase.dart';

part 'customer_orders_event.dart';
part 'customer_orders_state.dart';

class CustomerOrdersBloc extends Bloc<CustomerOrdersEvent, CustomerOrdersState> {
  final GetCustomerOrdersUseCase getCustomerOrdersUseCase;

  CustomerOrdersBloc({required this.getCustomerOrdersUseCase})
      : super(const CustomerOrdersInitial()) {
    on<LoadCustomerOrders>(_onLoad);
  }

  Future<void> _onLoad(
    LoadCustomerOrders event,
    Emitter<CustomerOrdersState> emit,
  ) async {
    emit(const CustomerOrdersLoading());
    final result = await getCustomerOrdersUseCase(GetCustomerOrdersParams(event.customerId));
    result.fold(
      (failure) => emit(CustomerOrdersError(failure.message)),
      (orders) => emit(CustomerOrdersLoaded(orders)),
    );
  }
}
