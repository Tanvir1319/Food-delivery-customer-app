import 'package:flutter_bloc/flutter_bloc.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(const CheckoutState());

  void setPromoCode(String code) {
    emit(state.copyWith(promoCode: code, hasPromoError: false, promoMessage: ''));
  }

  void applyPromoCode() {
    if (state.promoCode.trim().isEmpty) {
      return;
    }
    
    // Dummy validation
    if (state.promoCode.toUpperCase() == 'DISCOUNT50') {
      emit(state.copyWith(hasPromoError: false, discount: 50, promoMessage: 'Promo code applied!'));
    } else {
      emit(state.copyWith(hasPromoError: true, discount: 0, promoMessage: 'Invalid Promo Code'));
    }
  }
}
