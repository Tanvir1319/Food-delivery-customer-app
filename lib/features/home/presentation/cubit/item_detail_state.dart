import 'package:equatable/equatable.dart';

class ItemDetailState extends Equatable {
  final int quantity;
  final String selectedSize;
  final String selectedSpiceLevel;
  final List<String> selectedAddons;
  final bool hasSizeError;

  const ItemDetailState({
    this.quantity = 1,
    this.selectedSize = '',
    this.selectedSpiceLevel = 'Medium',
    this.selectedAddons = const [],
    this.hasSizeError = false,
  });

  ItemDetailState copyWith({
    int? quantity,
    String? selectedSize,
    String? selectedSpiceLevel,
    List<String>? selectedAddons,
    bool? hasSizeError,
  }) {
    return ItemDetailState(
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedSpiceLevel: selectedSpiceLevel ?? this.selectedSpiceLevel,
      selectedAddons: selectedAddons ?? this.selectedAddons,
      hasSizeError: hasSizeError ?? this.hasSizeError,
    );
  }

  @override
  List<Object?> get props => [quantity, selectedSize, selectedSpiceLevel, selectedAddons, hasSizeError];
}
