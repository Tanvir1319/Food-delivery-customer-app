import 'package:equatable/equatable.dart';
import '../../data/models/restaurant_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object?> get props => [];
}

class HomeLoaded extends HomeState {
  final List<String> selectedCategories;
  final List<RestaurantModel> restaurants;

  const HomeLoaded({
    required this.selectedCategories,
    required this.restaurants,
  });

  @override
  List<Object?> get props => [selectedCategories, restaurants];
}
