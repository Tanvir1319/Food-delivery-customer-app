import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_primary_button.dart';
import '../../../../core/widgets/quantity_selector.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../cubit/item_detail_cubit.dart';
import '../cubit/item_detail_state.dart';
import '../cubit/nav_cubit.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String restaurantName;
  const RestaurantDetailScreen({super.key, required this.restaurantName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemDetailCubit(),
      child: _RestaurantDetailView(restaurantName: restaurantName),
    );
  }
}

class _RestaurantDetailView extends StatelessWidget {
  final String restaurantName;
  const _RestaurantDetailView({required this.restaurantName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Restaurant Detail & Menu', style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            height: 200.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/logo.png'), // placeholder
                fit: BoxFit.cover,
              ),
              color: Colors.grey,
            ),
          ),
          
          // Bottom Sheet Content
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height - 240.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -5)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60.w,
                            height: 60.w,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(Icons.fastfood, color: Colors.grey[400]),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Green Curry Chicken',
                                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Spicy coconut milk curry with bamboo shoots, basil, and chicken.',
                                  style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    _buildTag('Thai'),
                                    SizedBox(width: 8.w),
                                    _buildTag('Main Course'),
                                    SizedBox(width: 8.w),
                                    _buildTag('Spicy'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '৳380',
                            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Size Selection
                      BlocBuilder<ItemDetailCubit, ItemDetailState>(
                        buildWhen: (previous, current) => previous.selectedSize != current.selectedSize || previous.hasSizeError != current.hasSizeError,
                        builder: (context, state) {
                          final cubit = context.read<ItemDetailCubit>();
                          return Container(
                            decoration: BoxDecoration(
                              color: state.hasSizeError ? Colors.red.withValues(alpha: 0.1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: state.hasSizeError ? Colors.red : Colors.grey[300]!),
                            ),
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Choose your size ', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
                                    Text('(Required)', style: TextStyle(fontSize: 13.sp, color: Colors.red)),
                                  ],
                                ),
                                if (state.hasSizeError) ...[
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(Icons.error, size: 14.sp, color: Colors.red),
                                      SizedBox(width: 4.w),
                                      Text('Please select one', style: TextStyle(fontSize: 12.sp, color: Colors.red)),
                                    ],
                                  ),
                                ],
                                SizedBox(height: 8.h),
                                _buildRadioOption(context, 'Small', '৳380', state.selectedSize, cubit.setSize),
                                _buildRadioOption(context, 'Medium', '৳430', state.selectedSize, cubit.setSize),
                                _buildRadioOption(context, 'Large', '৳480', state.selectedSize, cubit.setSize),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Spice Level
                      Text('Spice Level', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.h),
                      BlocBuilder<ItemDetailCubit, ItemDetailState>(
                        buildWhen: (previous, current) => previous.selectedSpiceLevel != current.selectedSpiceLevel,
                        builder: (context, state) {
                          final cubit = context.read<ItemDetailCubit>();
                          return Row(
                            children: [
                              Expanded(child: _buildSpiceToggle('Mild', state.selectedSpiceLevel, cubit.setSpiceLevel, 0)),
                              SizedBox(width: 12.w),
                              Expanded(child: _buildSpiceToggle('Medium', state.selectedSpiceLevel, cubit.setSpiceLevel, 20)),
                              SizedBox(width: 12.w),
                              Expanded(child: _buildSpiceToggle('Spicy', state.selectedSpiceLevel, cubit.setSpiceLevel, 50)),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Add-ons
                      Text('Select Add-ons (Optional)', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.h),
                      BlocBuilder<ItemDetailCubit, ItemDetailState>(
                        buildWhen: (previous, current) => previous.selectedAddons != current.selectedAddons,
                        builder: (context, state) {
                          final cubit = context.read<ItemDetailCubit>();
                          return Column(
                            children: [
                              _buildCheckboxOption(context, 'Extra Chicken', '৳50', state.selectedAddons, cubit.toggleAddon),
                              _buildCheckboxOption(context, 'Extra Bamboo Shoots', '৳30', state.selectedAddons, cubit.toggleAddon),
                              _buildCheckboxOption(context, 'Steamed Rice', '৳40', state.selectedAddons, cubit.toggleAddon),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 100.h), // space for bottom bar
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
                ],
              ),
              child: BlocBuilder<ItemDetailCubit, ItemDetailState>(
                builder: (context, state) {
                  final cubit = context.read<ItemDetailCubit>();
                  final total = cubit.calculateTotal();
                  
                  return Row(
                    children: [
                      QuantitySelector(
                        quantity: state.quantity,
                        onIncrement: cubit.incrementQuantity,
                        onDecrement: cubit.decrementQuantity,
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: CustomPrimaryButton(
                          text: 'Total: ৳$total   CONFIRM',
                          onPressed: () {
                            if (cubit.validateSelection()) {
                              final cartItem = CartItemModel(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                title: 'Green Curry Chicken',
                                restaurantName: restaurantName,
                                imageUrl: 'asset/logo.png',
                                size: state.selectedSize,
                                spiceLevel: state.selectedSpiceLevel,
                                addons: state.selectedAddons,
                                unitPrice: total ~/ state.quantity,
                                quantity: state.quantity,
                              );
                              
                              final navCubit = context.read<NavCubit>();
                              final navigator = Navigator.of(context);
                              context.read<CartCubit>().addItem(cartItem);
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Added to cart'),
                                  backgroundColor: AppColors.primary,
                                  duration: const Duration(seconds: 4),
                                  action: SnackBarAction(
                                    label: 'VIEW NOW',
                                    textColor: Colors.white,
                                    onPressed: () {
                                      navigator.pop();
                                      navCubit.changeTab(1); // Jump to cart
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(text, style: TextStyle(fontSize: 10.sp, color: Colors.black87)),
    );
  }

  Widget _buildRadioOption(BuildContext context, String title, String priceStr, String selectedValue, Function(String) onChanged) {
    final isSelected = title == selectedValue;
    return InkWell(
      onTap: () => onChanged(title),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: isSelected ? AppColors.primary : Colors.grey, size: 20.sp),
            SizedBox(width: 8.w),
            Text(title, style: TextStyle(fontSize: 14.sp)),
            Text(' ($priceStr)', style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxOption(BuildContext context, String title, String priceStr, List<String> selectedAddons, Function(String) onToggle) {
    final isSelected = selectedAddons.contains(title);
    return InkWell(
      onTap: () => onToggle(title),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          children: [
            Icon(isSelected ? Icons.check_box : Icons.check_box_outline_blank, color: isSelected ? AppColors.primary : Colors.grey, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(child: Text(title, style: TextStyle(fontSize: 14.sp))),
            Text('($priceStr)', style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildSpiceToggle(String label, String selectedValue, Function(String) onSelect, int extraPrice) {
    final isSelected = label == selectedValue;
    return GestureDetector(
      onTap: () => onSelect(label),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: isSelected ? AppColors.accent : Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            if (extraPrice > 0)
              Text(
                '+৳$extraPrice',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isSelected ? Colors.white70 : AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}


