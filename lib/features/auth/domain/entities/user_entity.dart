import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String role; // customer | admin | rider
  final String phone;
  final double averageRating; // meaningful for riders only
  final bool isOnline; // meaningful for riders only
  final String profilePic;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    this.averageRating = 0.0,
    this.isOnline = false,
    this.profilePic = '',
  });

  bool get isCustomer => role == 'customer';
  bool get isAdmin => role == 'admin';
  bool get isRider => role == 'rider';

  UserEntity copyWith({
    String? uid,
    String? name,
    String? email,
    String? role,
    String? phone,
    double? averageRating,
    bool? isOnline,
    String? profilePic,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      averageRating: averageRating ?? this.averageRating,
      isOnline: isOnline ?? this.isOnline,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  @override
  List<Object?> get props => [uid, name, email, role, phone, averageRating, isOnline, profilePic];
}
