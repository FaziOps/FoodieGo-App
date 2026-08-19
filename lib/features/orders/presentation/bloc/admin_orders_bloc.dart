import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_entity.dart';
import 'package:restaurant_app/features/orders/domain/usecases/accept_order_usecase.dart';
import 'package:restaurant_app/features/orders/domain/usecases/assign_rider_usecase.dart';
import 'package:restaurant_app/features/orders/domain/usecases/get_all_orders_usecase.dart';

part 'admin_orders_event.dart';
part 'admin_orders_state.dart';

class AdminOrdersBloc extends Bloc<AdminOrdersEvent, AdminOrdersState> {
  final GetAllOrdersUseCase getAllOrdersUseCase;
  final AcceptOrderUseCase acceptOrderUseCase;
  final AssignRiderUseCase assignRiderUseCase;

  AdminOrdersBloc({
    required this.getAllOrdersUseCase,
    required this.acceptOrderUseCase,
    required this.assignRiderUseCase,
  }) : super(const AdminOrdersInitial()) {
    on<LoadAllOrders>(_onLoad);
    on<AcceptOrderTapped>(_onAccept);
    on<AssignRiderTapped>(_onAssignRider);
  }

  Future<void> _reload(Emitter<AdminOrdersState> emit) async {
    final result = await getAllOrdersUseCase(const NoParams());
    result.fold(
      (failure) => emit(AdminOrdersError(failure.message)),
      (orders) => emit(AdminOrdersLoaded(orders)),
    );
  }

  Future<void> _onLoad(LoadAllOrders event, Emitter<AdminOrdersState> emit) async {
    emit(const AdminOrdersLoading());
    await _reload(emit);
  }

  Future<void> _onAccept(AcceptOrderTapped event, Emitter<AdminOrdersState> emit) async {
    final result = await acceptOrderUseCase(AcceptOrderParams(event.orderId));
    result.fold(
      (failure) => emit(AdminOrdersError(failure.message)),
      (_) => _reload(emit),
    );
  }

  Future<void> _onAssignRider(
    AssignRiderTapped event,
    Emitter<AdminOrdersState> emit,
  ) async {
    final result = await assignRiderUseCase(
      AssignRiderParams(orderId: event.orderId, riderId: event.riderId),
    );
    result.fold(
      (failure) => emit(AdminOrdersError(failure.message)),
      (_) => _reload(emit),
    );
  }
}
