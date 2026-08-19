import 'package:restaurant_app/features/orders/domain/entities/delivery_address_entity.dart';

class DeliveryAddressModel extends DeliveryAddressEntity {
  const DeliveryAddressModel({
    required super.street,
    required super.latitude,
    required super.longitude,
  });

  factory DeliveryAddressModel.fromMap(Map<String, dynamic> map) => DeliveryAddressModel(
        street: map['street'] as String? ?? '',
        latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toMap() =>
      {'street': street, 'latitude': latitude, 'longitude': longitude};
}
