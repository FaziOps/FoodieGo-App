import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:restaurant_app/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:restaurant_app/features/cart/domain/usecases/calculate_cart_total_usecase.dart';
import 'package:restaurant_app/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:restaurant_app/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:restaurant_app/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:restaurant_app/features/cart/domain/usecases/update_quantity_usecase.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final UpdateQuantityUseCase updateQuantityUseCase;
  final ClearCartUseCase clearCartUseCase;
  final CalculateCartTotalUseCase calculateCartTotalUseCase;

  CartBloc({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.updateQuantityUseCase,
    required this.clearCartUseCase,
    required this.calculateCartTotalUseCase,
  }) : super(const CartInitial()) {
    on<LoadCartEvent>(_onLoad);
    on<AddToCartEvent>(_onAdd);
    on<RemoveFromCartEvent>(_onRemove);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClear);
  }

  Future<void> _emitCurrentCart(Emitter<CartState> emit) async {
    final result = await getCartUseCase(const NoParams());
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (items) => emit(CartLoaded(items: items, total: calculateCartTotalUseCase(items))),
    );
  }

  Future<void> _onLoad(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    await _emitCurrentCart(emit);
  }

  Future<void> _onAdd(AddToCartEvent event, Emitter<CartState> emit) async {
    await addToCartUseCase(event.item);
    await _emitCurrentCart(emit);
  }

  Future<void> _onRemove(RemoveFromCartEvent event, Emitter<CartState> emit) async {
    await removeFromCartUseCase(RemoveFromCartParams(event.itemId));
    await _emitCurrentCart(emit);
  }

  Future<void> _onUpdateQuantity(UpdateQuantityEvent event, Emitter<CartState> emit) async {
    await updateQuantityUseCase(
      UpdateQuantityParams(itemId: event.itemId, quantity: event.quantity),
    );
    await _emitCurrentCart(emit);
  }

  Future<void> _onClear(ClearCartEvent event, Emitter<CartState> emit) async {
    await clearCartUseCase(const NoParams());
    await _emitCurrentCart(emit);
  }
}
