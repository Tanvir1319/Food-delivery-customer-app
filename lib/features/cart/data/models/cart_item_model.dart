import 'package:equatable/equatable.dart';

class CartItemModel extends Equatable {
  final String id;
  final String title;
  final String restaurantName;
  final String imageUrl;
  final String size;
  final String spiceLevel;
  final List<String> addons;
  final int unitPrice;
  final int quantity;

  const CartItemModel({
    required this.id,
    required this.title,
    required this.restaurantName,
    required this.imageUrl,
    required this.size,
    required this.spiceLevel,
    required this.addons,
    required this.unitPrice,
    required this.quantity,
  });

  CartItemModel copyWith({
    String? id,
    String? title,
    String? restaurantName,
    String? imageUrl,
    String? size,
    String? spiceLevel,
    List<String>? addons,
    int? unitPrice,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      restaurantName: restaurantName ?? this.restaurantName,
      imageUrl: imageUrl ?? this.imageUrl,
      size: size ?? this.size,
      spiceLevel: spiceLevel ?? this.spiceLevel,
      addons: addons ?? this.addons,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
    );
  }

  int get totalPrice => unitPrice * quantity;

  @override
  List<Object?> get props => [id, title, restaurantName, imageUrl, size, spiceLevel, addons, unitPrice, quantity];
}
