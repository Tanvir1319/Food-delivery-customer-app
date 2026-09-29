import 'package:equatable/equatable.dart';

enum PaymentStatus { initial, processing, failed, success }

class PaymentState extends Equatable {
  final String selectedMethod;
  final PaymentStatus status;
  final String errorMessage;

  const PaymentState({
    this.selectedMethod = 'bkash',
    this.status = PaymentStatus.initial,
    this.errorMessage = '',
  });

  PaymentState copyWith({
    String? selectedMethod,
    PaymentStatus? status,
    String? errorMessage,
  }) {
    return PaymentState(
      selectedMethod: selectedMethod ?? this.selectedMethod,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [selectedMethod, status, errorMessage];
}
