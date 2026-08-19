import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_entity.dart';
import 'package:restaurant_app/features/orders/domain/usecases/get_rider_orders_usecase.dart';
import 'package:restaurant_app/features/orders/domain/usecases/update_order_status_usecase.dart';

part 'rider_orders_event.dart';
part 'rider_orders_state.dart';

class RiderOrdersBloc extends Bloc<RiderOrdersEvent, RiderOrdersState> {
  final GetRiderOrdersUseCase getRiderOrdersUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;

  RiderOrdersBloc({
    required this.getRiderOrdersUseCase,
    required this.updateOrderStatusUseCase,
  }) : super(const RiderOrdersInitial()) {
    on<LoadRiderOrders>(_onLoad);
    on<AdvanceOrderStatusTapped>(_onAdvanceStatus);
  }

  String? _riderId;

  Future<void> _reload(Emitter<RiderOrdersState> emit) async {
    if (_riderId == null) return;
    final result = await getRiderOrdersUseCase(GetRiderOrdersParams(_riderId!));
    result.fold(
      (failure) => emit(RiderOrdersError(failure.message)),
      (orders) => emit(RiderOrdersLoaded(orders)),
    );
  }

  Future<void> _onLoad(LoadRiderOrders event, Emitter<RiderOrdersState> emit) async {
    _riderId = event.riderId;
    emit(const RiderOrdersLoading());
    await _reload(emit);
  }

  Future<void> _onAdvanceStatus(
    AdvanceOrderStatusTapped event,
    Emitter<RiderOrdersState> emit,
  ) async {
    final result = await updateOrderStatusUseCase(
      UpdateOrderStatusParams(orderId: event.orderId, newStatus: event.newStatus),
    );
    result.fold(
      (failure) => emit(RiderOrdersError(failure.message)),
      (_) => _reload(emit),
    );
  }
}
