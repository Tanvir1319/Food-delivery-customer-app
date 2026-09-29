import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/custom_chip.dart';
import '../../../../core/widgets/food_item_card.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../cubit/nav_cubit.dart';
import 'restaurant_detail_screen.dart';
import '../../../cart/presentation/pages/cart_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [BlocProvider(create: (context) => HomeCubit())],
      child: const _MainScaffold(),
    );
  }
}

class _MainScaffold extends StatelessWidget {
  const _MainScaffold();

  final List<Widget> _pages = const [
    _HomeContent(),
    CartScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: IndexedStack(
            index: currentIndex,
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            currentIndex: currentIndex,
            onTap: (index) {
              context.read<NavCubit>().changeTab(index);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
              BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final List<String> allCategories = ['Pizza', 'Sushi', 'Burgers', 'Vegan', 'Offers'];

    return SafeArea(
      child: Column(
        children: [
          // Top App Bar / Address Area
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            color: AppColors.primary,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Address',
                          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                        ),
                        Row(
                          children: [
                            Text(
                              '123 Banani, Dhaka',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16.sp),
                          ],
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 16.r,
                      child: Icon(Icons.person, color: AppColors.primary, size: 20.sp),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                const CustomSearchBar(
                  hintText: 'Search for restaurants, cuisines, or dishes...',
                ),
              ],
            ),
          ),
          
          // Categories
          SizedBox(height: 12.h),
          SizedBox(
            height: 36.h,
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeLoaded) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: allCategories.length,
                    separatorBuilder: (context, index) => SizedBox(width: 8.w),
                    itemBuilder: (context, index) {
                      final category = allCategories[index];
                      final isSelected = state.selectedCategories.contains(category);
                      return CustomChip(
                        label: category,
                        isSelected: isSelected,
                        onTap: () {
                          context.read<HomeCubit>().toggleCategory(category);
                        },
                        icon: Text(
                          category == 'Pizza' ? '🍕' :
                          category == 'Sushi' ? '🍣' :
                          category == 'Burgers' ? '🍔' :
                          category == 'Vegan' ? '🌱' : '🏷️',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          SizedBox(height: 16.h),

          // Grid View of Restaurants
          Expanded(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeLoaded) {
                  if (state.restaurants.isEmpty) {
                    return Center(
                      child: Text(
                        'No items found.',
                        style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
                      ),
                    );
                  }
                  
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                    ),
                    itemCount: state.restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = state.restaurants[index];
                      return FoodItemCard(
                        title: restaurant.name,
                        restaurantName: restaurant.restaurantName,
                        description: "",
                        price: restaurant.price,
                        discountedPrice: restaurant.discountedPrice,
                        imageUrl: restaurant.imageUrl,
                        rating: restaurant.rating,
                        deliveryTime: restaurant.deliveryTime,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantDetailScreen(
                                restaurantName: restaurant.name,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}




