part of 'menu_bloc.dart';

abstract class MenuState extends Equatable {
  const MenuState();
  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {
  const MenuInitial();
}

class MenuLoading extends MenuState {
  const MenuLoading();
}

class MenuLoaded extends MenuState {
  final List<CategoryEntity> categories;
  final List<MenuItemEntity> items;
  final String? selectedCategoryId;

  const MenuLoaded({
    required this.categories,
    required this.items,
    this.selectedCategoryId,
  });

  @override
  List<Object?> get props => [categories, items, selectedCategoryId];
}

class MenuError extends MenuState {
  final String message;
  const MenuError(this.message);
  @override
  List<Object?> get props => [message];
}
