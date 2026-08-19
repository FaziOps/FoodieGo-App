import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/menu/domain/entities/category_entity.dart';
import 'package:restaurant_app/features/menu/domain/entities/menu_item_entity.dart';
import 'package:restaurant_app/features/menu/domain/usecases/get_categories_usecase.dart';
import 'package:restaurant_app/features/menu/domain/usecases/get_menu_items_usecase.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetMenuItemsUseCase getMenuItemsUseCase;

  MenuBloc({required this.getCategoriesUseCase, required this.getMenuItemsUseCase})
      : super(const MenuInitial()) {
    on<LoadMenu>(_onLoadMenu);
    on<FilterByCategory>(_onFilterByCategory);
  }

  Future<void> _onLoadMenu(LoadMenu event, Emitter<MenuState> emit) async {
    emit(const MenuLoading());
    final categoriesResult = await getCategoriesUseCase(const NoParams());
    final itemsResult = await getMenuItemsUseCase(const GetMenuItemsParams());

    categoriesResult.fold(
      (failure) => emit(MenuError(failure.message)),
      (categories) {
        itemsResult.fold(
          (failure) => emit(MenuError(failure.message)),
          (items) => emit(MenuLoaded(categories: categories, items: items)),
        );
      },
    );
  }

  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<MenuState> emit,
  ) async {
    final current = state;
    if (current is! MenuLoaded) return;
    emit(const MenuLoading());
    final itemsResult =
        await getMenuItemsUseCase(GetMenuItemsParams(categoryId: event.categoryId));
    itemsResult.fold(
      (failure) => emit(MenuError(failure.message)),
      (items) => emit(MenuLoaded(
        categories: current.categories,
        items: items,
        selectedCategoryId: event.categoryId,
      )),
    );
  }
}
