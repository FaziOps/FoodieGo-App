import 'package:url_launcher/url_launcher.dart';
import 'package:restaurant_app/core/errors/exceptions.dart';

abstract class MapsLauncherDataSource {
  Future<void> launch({required double latitude, required double longitude});
}

class MapsLauncherDataSourceImpl implements MapsLauncherDataSource {
  @override
  Future<void> launch({required double latitude, required double longitude}) async {
    final Uri uri = (latitude != 0.0 || longitude != 0.0)
        ? Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude')
        : Uri.parse('https://www.google.com/maps');

    try {
      bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
      if (!launched) {
        throw ServerException('Could not open Google Maps.');
      }
    } catch (_) {
      try {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      } catch (e) {
        throw ServerException('Could not open Google Maps: $e');
      }
    }
  }
}
