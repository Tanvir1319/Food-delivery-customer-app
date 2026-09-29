import 'package:equatable/equatable.dart';
import '../../data/models/cart_item_model.dart';

class CartState extends Equatable {
  final List<CartItemModel> items;

  const CartState({this.items = const []});

  int get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  int get deliveryFee => items.isEmpty ? 0 : 40; // Static delivery fee
  int get grandTotal => subtotal + deliveryFee;

  CartState copyWith({
    List<CartItemModel>? items,
  }) {
    return CartState(
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [items];
}
