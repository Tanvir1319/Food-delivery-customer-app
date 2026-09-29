import 'package:flutter_bloc/flutter_bloc.dart';
import 'item_detail_state.dart';

class ItemDetailCubit extends Cubit<ItemDetailState> {
  ItemDetailCubit() : super(const ItemDetailState());

  final Map<String, int> sizePrices = {
    'Small': 380,
    'Medium': 430,
    'Large': 480,
  };

  final Map<String, int> addonPrices = {
    'Extra Chicken': 50,
    'Extra Bamboo Shoots': 30,
    'Steamed Rice': 40,
  };

  final Map<String, int> spicePrices = {
    'Mild': 0,
    'Medium': 20,
    'Spicy': 50,
  };

  void setSize(String size) {
    emit(state.copyWith(selectedSize: size, hasSizeError: false));
  }

  void setSpiceLevel(String level) {
    emit(state.copyWith(selectedSpiceLevel: level));
  }

  void toggleAddon(String addon) {
    final currentAddons = List<String>.from(state.selectedAddons);
    if (currentAddons.contains(addon)) {
      currentAddons.remove(addon);
    } else {
      currentAddons.add(addon);
    }
    emit(state.copyWith(selectedAddons: currentAddons));
  }

  void incrementQuantity() {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void decrementQuantity() {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  bool validateSelection() {
    if (state.selectedSize.isEmpty) {
      emit(state.copyWith(hasSizeError: true));
      return false;
    }
    return true;
  }

  int calculateTotal() {
    int basePrice = 380; // default base price
    if (state.selectedSize.isNotEmpty) {
      basePrice = sizePrices[state.selectedSize]!;
    }
    
    int addonsTotal = 0;
    for (String addon in state.selectedAddons) {
      addonsTotal += addonPrices[addon]!;
    }

    int spicePrice = spicePrices[state.selectedSpiceLevel] ?? 0;

    return (basePrice + addonsTotal + spicePrice) * state.quantity;
  }
}
