import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/core/constants/app_constants.dart';
import 'package:restaurant_app/core/errors/exceptions.dart';
import 'package:restaurant_app/features/rider_management/data/models/rider_model.dart';

abstract class RiderRemoteDataSource {
  Future<List<RiderModel>> getAvailableRiders();
  Future<void> updateRiderOnlineStatus(String riderId, bool isOnline);
}

class RiderRemoteDataSourceImpl implements RiderRemoteDataSource {
  final FirebaseFirestore firestore;
  RiderRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<RiderModel>> getAvailableRiders() async {
    try {
      final snapshot = await firestore
          .collection(AppConstants.usersCollection)
          .where('role', isEqualTo: AppConstants.roleRider)
          .where('isOnline', isEqualTo: true)
          .get();
      return snapshot.docs.map(RiderModel.fromSnapshot).toList();
    } catch (_) {
      throw ServerException('Could not load available riders.');
    }
  }

  @override
  Future<void> updateRiderOnlineStatus(String riderId, bool isOnline) async {
    try {
      await firestore
          .collection(AppConstants.usersCollection)
          .doc(riderId)
          .update({'isOnline': isOnline});
    } catch (_) {
      throw ServerException('Could not update online status.');
    }
  }
}
