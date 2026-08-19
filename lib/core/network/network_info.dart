import 'dart:io';

/// Checked before any Firestore/Stripe call in a data source so a bad
/// connection produces a clean NetworkFailure instead of a raw socket error.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('firestore.googleapis.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
