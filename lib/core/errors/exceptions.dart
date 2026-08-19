/// Raw exceptions thrown by the Data layer (data sources).
/// RepositoryImpl catches these and converts them to Failures.
/// Domain and Presentation never see these directly.
class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error']);
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class PaymentException implements Exception {
  final String message;
  PaymentException(this.message);
}
