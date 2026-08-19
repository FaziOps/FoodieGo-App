import 'package:equatable/equatable.dart';

class RiderEntity extends Equatable {
  final String uid;
  final String name;
  final bool isOnline;
  final double averageRating;

  const RiderEntity({
    required this.uid,
    required this.name,
    required this.isOnline,
    required this.averageRating,
  });

  @override
  List<Object?> get props => [uid, name, isOnline, averageRating];
}
