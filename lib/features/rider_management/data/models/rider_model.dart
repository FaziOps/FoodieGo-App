import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/features/rider_management/domain/entities/rider_entity.dart';

class RiderModel extends RiderEntity {
  const RiderModel({
    required super.uid,
    required super.name,
    required super.isOnline,
    required super.averageRating,
  });

  factory RiderModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return RiderModel(
      uid: doc.id,
      name: data['name'] as String? ?? '',
      isOnline: data['isOnline'] as bool? ?? false,
      averageRating: (data['averageRating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
