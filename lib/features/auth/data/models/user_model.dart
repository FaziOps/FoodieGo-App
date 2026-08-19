import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.role,
    required super.phone,
    super.averageRating = 0.0,
    super.isOnline = false,
    super.profilePic = '',
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: map['role'] as String? ?? 'customer',
      phone: map['phone'] as String? ?? '',
      averageRating: (map['averageRating'] as num?)?.toDouble() ?? 0.0,
      isOnline: map['isOnline'] as bool? ?? false,
      profilePic: map['profilePic'] as String? ?? map['photoUrl'] as String? ?? '',
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserModel.fromMap({...data, 'uid': doc.id});
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'averageRating': averageRating,
      'isOnline': isOnline,
      'profilePic': profilePic,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      name: entity.name,
      email: entity.email,
      role: entity.role,
      phone: entity.phone,
      averageRating: entity.averageRating,
      isOnline: entity.isOnline,
      profilePic: entity.profilePic,
    );
  }
}
