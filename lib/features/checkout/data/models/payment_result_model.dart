import 'package:restaurant_app/features/checkout/domain/entities/payment_result_entity.dart';

class PaymentResultModel extends PaymentResultEntity {
  const PaymentResultModel({required super.paymentIntentId, required super.status});
}
