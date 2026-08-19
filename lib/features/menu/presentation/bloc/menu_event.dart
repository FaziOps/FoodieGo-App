part of 'menu_bloc.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();
  @override
  List<Object?> get props => [];
}

class LoadMenu extends MenuEvent {
  const LoadMenu();
}

class FilterByCategory extends MenuEvent {
  final String? categoryId;
  const FilterByCategory(this.categoryId);
  @override
  List<Object?> get props => [categoryId];
}
