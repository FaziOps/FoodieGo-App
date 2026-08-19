import 'package:equatable/equatable.dart';

class DeliveryAddressEntity extends Equatable {
  final String street;
  final double latitude;
  final double longitude;

  const DeliveryAddressEntity({
    required this.street,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [street, latitude, longitude];
}
