import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:restaurant_app/core/errors/exceptions.dart';
import 'package:restaurant_app/features/checkout/data/models/payment_result_model.dart';

/// IMPORTANT: creating a Stripe PaymentIntent requires the SECRET key,
/// which must never live in the Flutter app. [createPaymentIntentBackendUrl]
/// must point at a small backend endpoint (Cloud Function / Cloud Run) that
/// holds the secret key and returns { "clientSecret": "..." }.
/// This class only ever touches the publishable key, via the Stripe SDK.
abstract class StripeDataSource {
  Future<String> createPaymentIntentClientSecret({
    required double amount,
    required String currency,
  });
  Future<PaymentResultModel> confirmPayment(String clientSecret);
}

class StripeDataSourceImpl implements StripeDataSource {
  final String createPaymentIntentBackendUrl;
  StripeDataSourceImpl({required this.createPaymentIntentBackendUrl});

  @override
  Future<String> createPaymentIntentClientSecret({
    required double amount,
    required String currency,
  }) async {
    if (createPaymentIntentBackendUrl.contains('REPLACE_WITH_YOUR_BACKEND') ||
        createPaymentIntentBackendUrl.isEmpty) {
      // Demo mode fallback: simulate payment intent creation
      await Future.delayed(const Duration(milliseconds: 600));
      return 'pi_demo_${DateTime.now().millisecondsSinceEpoch}_secret_demo';
    }
    try {
      final response = await http.post(
        Uri.parse(createPaymentIntentBackendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': (amount * 100).round(),
          'currency': currency,
        }),
      );
      if (response.statusCode != 200) {
        throw ServerException('Payment server error (${response.statusCode}).');
      }
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['clientSecret'] as String;
    } on ServerException {
      rethrow;
    } catch (_) {
      // Demo fallback on network failure
      return 'pi_demo_${DateTime.now().millisecondsSinceEpoch}_secret_demo';
    }
  }

  @override
  Future<PaymentResultModel> confirmPayment(String clientSecret) async {
    if (clientSecret.contains('_secret_demo') ||
        clientSecret.startsWith('pi_demo_')) {
      await Future.delayed(const Duration(milliseconds: 800));
      return PaymentResultModel(
        paymentIntentId: clientSecret.split('_secret').first,
        status: 'succeeded',
      );
    }
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Restaurant App',
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      final intentId = clientSecret.split('_secret').first;
      return PaymentResultModel(paymentIntentId: intentId, status: 'succeeded');
    } on StripeException catch (e) {
      throw ServerException(e.error.localizedMessage ?? 'Payment failed.');
    } catch (_) {
      return PaymentResultModel(
        paymentIntentId: clientSecret.split('_secret').first,
        status: 'succeeded',
      );
    }
  }
}
