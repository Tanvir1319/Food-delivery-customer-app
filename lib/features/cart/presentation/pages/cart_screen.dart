import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_primary_button.dart';
import '../../../../core/widgets/quantity_selector.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../../../checkout/presentation/pages/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Your Cart', style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false, // Since it's a bottom nav tab
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80.sp, color: Colors.grey[400]),
                  SizedBox(height: 16.h),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Looks like you haven\'t added anything yet.',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: state.items.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.grey[300], height: 32.h),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
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
                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                    ),
                                  ),
                                  Text(
                                    '৳${item.totalPrice}',
                                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                item.restaurantName,
                                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Size: ${item.size} • Spice: ${item.spiceLevel}',
                                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                              ),
                              if (item.addons.isNotEmpty) ...[
                                SizedBox(height: 4.h),
                                Text(
                                  'Addons: ${item.addons.join(', ')}',
                                  style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                                ),
                              ],
                              SizedBox(height: 12.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  QuantitySelector(
                                    quantity: item.quantity,
                                    onIncrement: () => context.read<CartCubit>().incrementItem(item.id),
                                    onDecrement: () => context.read<CartCubit>().decrementItem(item.id),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, color: Colors.red, size: 20.sp),
                                    onPressed: () => context.read<CartCubit>().removeItem(item.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              
              // Calculation Summary
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSummaryRow('Subtotal', '৳${state.subtotal}'),
                    SizedBox(height: 8.h),
                    _buildSummaryRow('Delivery Fee', '৳${state.deliveryFee}'),
                    SizedBox(height: 12.h),
                    const Divider(),
                    SizedBox(height: 12.h),
                    _buildSummaryRow('Grand Total', '৳${state.grandTotal}', isTotal: true),
                    SizedBox(height: 16.h),
                    CustomPrimaryButton(
                      text: 'Order Now',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}


