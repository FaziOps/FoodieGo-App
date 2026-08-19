import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:restaurant_app/core/constants/app_constants.dart';
import 'package:restaurant_app/core/errors/exceptions.dart';

/// Actually *sending* a push requires a privileged context (Cloud Function
/// or backend with the service-account key) — a Flutter client cannot call
/// the FCM send API directly. This data source therefore does two things:
/// stores the device token so a Cloud Function can look it up, and exposes
/// a stub send() that should be replaced with a Cloud Function call
/// (e.g. via cloud_functions' httpsCallable) once that function exists.
abstract class FCMDataSource {
  Future<void> registerToken(String userId);
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
  });
}

class FCMDataSourceImpl implements FCMDataSource {
  final FirebaseMessaging messaging;
  final FirebaseFirestore firestore;

  FCMDataSourceImpl({required this.messaging, required this.firestore});

  @override
  Future<void> registerToken(String userId) async {
    try {
      final token = await messaging.getToken();
      if (token == null) return;
      await firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({'fcmToken': token});
    } catch (_) {
      throw ServerException('Could not register for notifications.');
    }
  }

  @override
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    // TODO: replace with a callable Cloud Function that reads the user's
    // fcmToken from Firestore and sends via the Admin SDK server-side.
    // Left as a documented no-op rather than a silent stub that looks done.
    throw ServerException(
      'Push sending requires a backend Cloud Function — not implemented client-side.',
    );
  }
}
