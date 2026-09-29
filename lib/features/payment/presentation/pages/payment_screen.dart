import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';
import 'add_card_screen.dart';

class PaymentScreen extends StatelessWidget {
  final int totalAmount;
  const PaymentScreen({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentCubit(),
      child: _PaymentView(totalAmount: totalAmount),
    );
  }
}

class _PaymentView extends StatelessWidget {
  final int totalAmount;
  const _PaymentView({required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Select Payment Method', style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          final cubit = context.read<PaymentCubit>();
          
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mobile Financial Services (MFS)', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(child: _buildMfsOption('bkash', 'bKash', Colors.pink, state.selectedMethod, cubit.selectMethod)),
                        SizedBox(width: 12.w),
                        Expanded(child: _buildMfsOption('nagad', 'Nagad', Colors.orange, state.selectedMethod, cubit.selectMethod)),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    Text('Cards', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12.h),
                    _buildListOption('card_1234', '.... 1234', 'VISA', Colors.blue[900]!, state.selectedMethod, cubit.selectMethod),
                    SizedBox(height: 8.h),
                    _buildListOption('card_5678', '.... 5678', 'Mastercard', Colors.red, state.selectedMethod, cubit.selectMethod),
                    SizedBox(height: 8.h),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCardScreen()));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.credit_card, color: Colors.grey, size: 20.sp),
                            SizedBox(width: 12.w),
                            Text('Add New Card', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    Text('Other Options', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12.h),
                    _buildTextOption('wallet', 'Digital Wallet', '৳150', state.selectedMethod, cubit.selectMethod),
                    SizedBox(height: 8.h),
                    _buildTextOption('cod', 'Cash on Delivery (COD)', '', state.selectedMethod, cubit.selectMethod),
                    
                    SizedBox(height: 140.h), // Bottom padding for fixed buttons
                  ],
                ),
              ),
              
              // Bottom Fixed Area
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.status == PaymentStatus.failed) ...[
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            state.errorMessage,
                            style: TextStyle(color: Colors.red[700], fontSize: 12.sp),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            onPressed: cubit.processPayment,
                            child: Text('Retry Payment', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextButton(
                          onPressed: cubit.cancelRetry,
                          child: Text('Cancel', style: TextStyle(color: Colors.grey[600], fontSize: 14.sp)),
                        ),
                      ],
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (state.status == PaymentStatus.failed || state.status == PaymentStatus.processing) 
                                ? Colors.grey[300] 
                                : AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            elevation: 0,
                          ),
                          onPressed: (state.status == PaymentStatus.failed || state.status == PaymentStatus.processing) 
                              ? null 
                              : cubit.processPayment,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Pay ৳$totalAmount',
                                style: TextStyle(
                                  color: (state.status == PaymentStatus.failed || state.status == PaymentStatus.processing) 
                                      ? Colors.grey[500] 
                                      : Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (state.status == PaymentStatus.processing) ...[
                                SizedBox(width: 12.w),
                                SizedBox(
                                  width: 16.w,
                                  height: 16.w,
                                  child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.grey),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMfsOption(String id, String name, Color color, String selectedValue, Function(String) onSelect) {
    final isSelected = id == selectedValue;
    return GestureDetector(
      onTap: () => onSelect(id),
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: isSelected ? Colors.green : Colors.grey[300]!, width: isSelected ? 1.5 : 1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16.sp)),
            SizedBox(width: 12.w),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? Colors.green : Colors.grey,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListOption(String id, String label, String trailing, Color trailingColor, String selectedValue, Function(String) onSelect) {
    final isSelected = id == selectedValue;
    return GestureDetector(
      onTap: () => onSelect(id),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: isSelected ? Colors.green : Colors.grey[300]!, width: isSelected ? 1.5 : 1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(Icons.credit_card, color: Colors.blue[900], size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(child: Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500))),
            Text(trailing, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: trailingColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextOption(String id, String label, String trailing, String selectedValue, Function(String) onSelect) {
    final isSelected = id == selectedValue;
    return GestureDetector(
      onTap: () => onSelect(id),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: isSelected ? Colors.green : Colors.grey[300]!, width: isSelected ? 1.5 : 1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500))),
            if (trailing.isNotEmpty) 
              Text(trailing, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}




