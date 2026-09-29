import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/restaurant_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeLoaded(selectedCategories: [], restaurants: [])) {
    _loadInitialData();
  }

  final List<RestaurantModel> _allRestaurants = [
    const RestaurantModel(
      id: '1',
      name: 'Double Beef Burger',
      restaurantName: 'The Burger Joint',
      imageUrl: 'burger.png',
      rating: 4.5,
      price: '৳380',
      discountedPrice: '৳350',
      deliveryTime: '25-35 min',
      categories: ['Burgers', 'Offers'],
    ),
    const RestaurantModel(
      id: '2',
      name: 'Salmon Nigiri',
      restaurantName: 'Sakura Sushi',
      imageUrl: 'sushi.png',
      rating: 4.5,
      price: '৳450',
      discountedPrice: '৳400',
      deliveryTime: '25-6 min',
      categories: ['Sushi'],
    ),
    const RestaurantModel(
      id: '3',
      name: 'Spicy Tuna Roll',
      restaurantName: 'Sushi Sushi',
      imageUrl: 'sushi2.png',
      rating: 4.5,
      price: '৳300',
      discountedPrice: '',
      deliveryTime: '20-30 min',
      categories: ['Sushi'],
    ),
    const RestaurantModel(
      id: '4',
      name: 'Vegan Salad Bowl',
      restaurantName: 'Vegan Delights',
      imageUrl: 'vegan.png',
      rating: 4.8,
      price: '৳250',
      discountedPrice: '৳220',
      deliveryTime: '30-45 min',
      categories: ['Vegan'],
    ),
    const RestaurantModel(
      id: '5',
      name: 'Cheeseburger',
      restaurantName: 'The Burger Joint',
      imageUrl: 'burger2.png',
      rating: 4.6,
      price: '৳280',
      discountedPrice: '',
      deliveryTime: '25-35 min',
      categories: ['Burgers'],
    ),
    const RestaurantModel(
      id: '6',
      name: 'Margherita Pizza',
      restaurantName: 'Pizza Hut',
      imageUrl: 'pizza.png',
      rating: 4.2,
      price: '৳650',
      discountedPrice: '৳500',
      deliveryTime: '40-50 min',
      categories: ['Pizza', 'Offers'],
    ),
    const RestaurantModel(
      id: '7',
      name: 'Pepperoni Pizza',
      restaurantName: 'Pizza Express',
      imageUrl: 'pizza2.png',
      rating: 4.7,
      price: '৳700',
      discountedPrice: '',
      deliveryTime: '35-45 min',
      categories: ['Pizza'],
    ),
    const RestaurantModel(
      id: '8',
      name: 'Vegan Wrap',
      restaurantName: 'Vegan Delights',
      imageUrl: 'vegan_wrap.png',
      rating: 4.3,
      price: '৳180',
      discountedPrice: '',
      deliveryTime: '20-30 min',
      categories: ['Vegan'],
    ),
  ];

  void _loadInitialData() {
    emit(HomeLoaded(selectedCategories: const [], restaurants: _allRestaurants));
  }

  void toggleCategory(String category) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final currentSelected = List<String>.from(currentState.selectedCategories);
      
      if (currentSelected.contains(category)) {
        currentSelected.remove(category);
      } else {
        currentSelected.add(category);
      }

      List<RestaurantModel> filteredRestaurants;
      if (currentSelected.isEmpty) {
        filteredRestaurants = _allRestaurants;
      } else {
        filteredRestaurants = _allRestaurants.where((restaurant) {
          return currentSelected.any((c) => restaurant.categories.contains(c));
        }).toList();
      }

      emit(HomeLoaded(
        selectedCategories: currentSelected,
        restaurants: filteredRestaurants,
      ));
    }
  }
}
