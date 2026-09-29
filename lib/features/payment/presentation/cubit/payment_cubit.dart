import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(const PaymentState());

  void selectMethod(String method) {
    emit(state.copyWith(selectedMethod: method, status: PaymentStatus.initial));
  }

  Future<void> processPayment() async {
    emit(state.copyWith(status: PaymentStatus.processing));
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate failure to show the error UI from the mockup
    emit(state.copyWith(
      status: PaymentStatus.failed,
      errorMessage: 'Payment Gateway Error: Insufficient Funds. Please try again or select a different method.',
    ));
  }

  void cancelRetry() {
    emit(state.copyWith(status: PaymentStatus.initial, errorMessage: ''));
  }
}
