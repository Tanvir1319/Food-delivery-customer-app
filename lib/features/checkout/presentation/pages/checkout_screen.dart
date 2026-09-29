import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_primary_button.dart';
import '../../../../core/widgets/quantity_selector.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../cubit/checkout_cubit.dart';
import '../cubit/checkout_state.dart';
import '../../../payment/presentation/pages/payment_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutCubit(),
      child: const _CheckoutView(),
    );
  }
}

class _CheckoutView extends StatelessWidget {
  const _CheckoutView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Review Your Order', style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          if (cartState.items.isEmpty) {
            return Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Items
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartState.items.length,
                          separatorBuilder: (context, index) => Divider(color: Colors.grey[200], height: 1),
                          itemBuilder: (context, index) {
                            final item = cartState.items[index];
                            final customizations = [item.size, item.spiceLevel, ...item.addons].where((e) => e.isNotEmpty).join(', ');
                            
                            return Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Food image
                                  Container(
                                    width: 50.w,
                                    height: 50.w,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(Icons.fastfood, color: Colors.grey[400], size: 24.sp),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          item.restaurantName,
                                          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                                        ),
                                        if (customizations.isNotEmpty) ...[
                                          SizedBox(height: 4.h),
                                          Text(
                                            'Customizes: $customizations.',
                                            style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () => context.read<CartCubit>().removeItem(item.id),
                                            child: Padding(
                                              padding: EdgeInsets.all(4.w),
                                              child: Icon(Icons.delete_outline, color: Colors.red, size: 20.sp),
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            '৳${item.totalPrice}',
                                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                      QuantitySelector(
                                        quantity: item.quantity,
                                        onIncrement: () => context.read<CartCubit>().incrementItem(item.id),
                                        onDecrement: () => context.read<CartCubit>().decrementItem(item.id),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Promo Code Section
                      Text('Promo Code Section', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.h),
                      BlocBuilder<CheckoutCubit, CheckoutState>(
                        builder: (context, checkoutState) {
                          final cubit = context.read<CheckoutCubit>();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 44.h,
                                      decoration: BoxDecoration(
                                        color: checkoutState.hasPromoError ? Colors.red.withValues(alpha: 0.05) : Colors.grey[100],
                                        borderRadius: BorderRadius.circular(8.r),
                                        border: Border.all(color: checkoutState.hasPromoError ? Colors.red : Colors.grey[300]!),
                                      ),
                                      child: TextField(
                                        onChanged: cubit.setPromoCode,
                                        decoration: InputDecoration(
                                          hintText: 'Promo Code (try DISCOUNT50)',
                                          hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                          suffixIcon: checkoutState.hasPromoError 
                                              ? Icon(Icons.cancel, color: Colors.red, size: 20.sp) 
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  SizedBox(
                                    height: 44.h,
                                    child: ElevatedButton(
                                      onPressed: cubit.applyPromoCode,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey[300],
                                        foregroundColor: Colors.black87,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                      ),
                                      child: Text('Apply', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
                                    ),
                                  ),
                                ],
                              ),
                              if (checkoutState.promoMessage.isNotEmpty) ...[
                                SizedBox(height: 4.h),
                                Text(
                                  checkoutState.promoMessage,
                                  style: TextStyle(
                                    fontSize: 12.sp, 
                                    color: checkoutState.hasPromoError ? Colors.red : Colors.green
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Bill Breakdown Summary Card
                      Text('Bill Breakdown Summary Card', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.h),
                      BlocBuilder<CheckoutCubit, CheckoutState>(
                        builder: (context, checkoutState) {
                          final int taxes = (cartState.subtotal * 0.05).toInt();
                          final int grandTotal = cartState.subtotal + cartState.deliveryFee + taxes - checkoutState.discount;

                          return Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              children: [
                                _buildSummaryRow('Subtotal', '৳${cartState.subtotal}'),
                                SizedBox(height: 8.h),
                                _buildSummaryRow('Delivery Fee', '৳${cartState.deliveryFee}'),
                                SizedBox(height: 8.h),
                                _buildSummaryRow('Taxes', '৳$taxes'),
                                SizedBox(height: 8.h),
                                _buildSummaryRow('Discount', '-৳${checkoutState.discount}', isDiscount: true),
                                SizedBox(height: 12.h),
                                const Divider(),
                                SizedBox(height: 12.h),
                                _buildSummaryRow('Grand Total', '৳$grandTotal', isTotal: true),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
              
              // Bottom Bar
              BlocBuilder<CheckoutCubit, CheckoutState>(
                builder: (context, checkoutState) {
                  final int taxes = (cartState.subtotal * 0.05).toInt();
                  final int grandTotal = cartState.subtotal + cartState.deliveryFee + taxes - checkoutState.discount;
                  
                  return Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
                      ],
                    ),
                    child: CustomPrimaryButton(
                      text: 'Proceed to Payment • ৳$grandTotal',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PaymentScreen(totalAmount: grandTotal)),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false, bool isDiscount = false}) {
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
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isDiscount ? Colors.red : (isTotal ? AppColors.primary : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}




