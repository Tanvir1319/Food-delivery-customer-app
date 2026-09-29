import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cart_item_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addItem(CartItemModel newItem) {
    final List<CartItemModel> currentItems = List.from(state.items);
    
    // Check if item already exists with exact same configurations
    final existingIndex = currentItems.indexWhere((item) => 
      item.title == newItem.title && 
      item.size == newItem.size && 
      item.spiceLevel == newItem.spiceLevel &&
      item.addons.join(',') == newItem.addons.join(',')
    );

    if (existingIndex >= 0) {
      final existingItem = currentItems[existingIndex];
      currentItems[existingIndex] = existingItem.copyWith(quantity: existingItem.quantity + newItem.quantity);
    } else {
      currentItems.add(newItem);
    }

    emit(state.copyWith(items: currentItems));
  }

  void incrementItem(String id) {
    final List<CartItemModel> currentItems = List.from(state.items);
    final index = currentItems.indexWhere((item) => item.id == id);
    if (index >= 0) {
      currentItems[index] = currentItems[index].copyWith(quantity: currentItems[index].quantity + 1);
      emit(state.copyWith(items: currentItems));
    }
  }

  void decrementItem(String id) {
    final List<CartItemModel> currentItems = List.from(state.items);
    final index = currentItems.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (currentItems[index].quantity > 1) {
        currentItems[index] = currentItems[index].copyWith(quantity: currentItems[index].quantity - 1);
        emit(state.copyWith(items: currentItems));
      } else {
        // If quantity is 1, decrementing removes the item
        removeItem(id);
      }
    }
  }

  void removeItem(String id) {
    final List<CartItemModel> currentItems = state.items.where((item) => item.id != id).toList();
    emit(state.copyWith(items: currentItems));
  }
}
