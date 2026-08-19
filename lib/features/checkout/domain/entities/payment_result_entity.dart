import 'package:equatable/equatable.dart';

class PaymentResultEntity extends Equatable {
  final String paymentIntentId;
  final String status; // succeeded | failed | requires_action

  const PaymentResultEntity({required this.paymentIntentId, required this.status});

  bool get isSuccess => status == 'succeeded';

  @override
  List<Object?> get props => [paymentIntentId, status];
}
