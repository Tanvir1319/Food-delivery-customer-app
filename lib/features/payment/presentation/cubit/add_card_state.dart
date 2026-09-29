import 'package:equatable/equatable.dart';

class AddCardState extends Equatable {
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String cardholderName;
  final String zipCode;
  final bool saveCard;
  final bool isSubmitting;
  final bool isSuccess;

  const AddCardState({
    this.cardNumber = '',
    this.expiryDate = '',
    this.cvv = '',
    this.cardholderName = '',
    this.zipCode = '',
    this.saveCard = true, // Default checked in image
    this.isSubmitting = false,
    this.isSuccess = false,
  });

  AddCardState copyWith({
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? cardholderName,
    String? zipCode,
    bool? saveCard,
    bool? isSubmitting,
    bool? isSuccess,
  }) {
    return AddCardState(
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      cardholderName: cardholderName ?? this.cardholderName,
      zipCode: zipCode ?? this.zipCode,
      saveCard: saveCard ?? this.saveCard,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [cardNumber, expiryDate, cvv, cardholderName, zipCode, saveCard, isSubmitting, isSuccess];
}
