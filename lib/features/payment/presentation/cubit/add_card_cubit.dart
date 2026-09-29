import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'add_card_state.dart';

class AddCardCubit extends Cubit<AddCardState> {
  AddCardCubit() : super(const AddCardState());
  
  final _storage = const FlutterSecureStorage();

  void updateCardNumber(String value) => emit(state.copyWith(cardNumber: value));
  void updateExpiryDate(String value) => emit(state.copyWith(expiryDate: value));
  void updateCvv(String value) => emit(state.copyWith(cvv: value));
  void updateCardholderName(String value) => emit(state.copyWith(cardholderName: value));
  void updateZipCode(String value) => emit(state.copyWith(zipCode: value));
  
  void toggleSaveCard() {
    emit(state.copyWith(saveCard: !state.saveCard));
  }

  Future<void> submitCard() async {
    emit(state.copyWith(isSubmitting: true));
    
    // Validate minimally here if needed, skipping for brevity
    
    if (state.saveCard) {
      await _storage.write(key: 'saved_card_number', value: state.cardNumber);
      await _storage.write(key: 'saved_card_expiry', value: state.expiryDate);
      await _storage.write(key: 'saved_card_cvv', value: state.cvv); // In real app, avoid saving CVV
      await _storage.write(key: 'saved_card_name', value: state.cardholderName);
      await _storage.write(key: 'saved_card_zip', value: state.zipCode);
    }
    
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    emit(state.copyWith(isSubmitting: false, isSuccess: true));
  }
}
