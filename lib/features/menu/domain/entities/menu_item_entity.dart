import 'package:equatable/equatable.dart';

class MenuItemEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final String imageUrl;
  final bool isAvailable;

  const MenuItemEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.imageUrl,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props =>
      [id, name, description, price, categoryId, imageUrl, isAvailable];
}
