import 'package:equatable/equatable.dart';

class CheckoutState extends Equatable {
  final String promoCode;
  final bool hasPromoError;
  final int discount;
  final String promoMessage;

  const CheckoutState({
    this.promoCode = '',
    this.hasPromoError = false,
    this.discount = 0,
    this.promoMessage = '',
  });

  CheckoutState copyWith({
    String? promoCode,
    bool? hasPromoError,
    int? discount,
    String? promoMessage,
  }) {
    return CheckoutState(
      promoCode: promoCode ?? this.promoCode,
      hasPromoError: hasPromoError ?? this.hasPromoError,
      discount: discount ?? this.discount,
      promoMessage: promoMessage ?? this.promoMessage,
    );
  }

  @override
  List<Object?> get props => [promoCode, hasPromoError, discount, promoMessage];
}
