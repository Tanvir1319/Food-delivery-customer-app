class RestaurantModel {
  final String id;
  final String name; // Title of the card (e.g. Food Name)
  final String restaurantName; // e.g. "abc restaurant"
  final String imageUrl;
  final double rating;
  final String price;
  final String discountedPrice;
  final String deliveryTime;
  final List<String> categories;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.restaurantName,
    required this.imageUrl,
    required this.rating,
    required this.price,
    this.discountedPrice = '',
    required this.deliveryTime,
    required this.categories,
  });
}
