import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_primary_button.dart';
import '../cubit/add_card_cubit.dart';
import '../cubit/add_card_state.dart';

class AddCardScreen extends StatelessWidget {
  const AddCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCardCubit(),
      child: const _AddCardView(),
    );
  }
}

class _AddCardView extends StatelessWidget {
  const _AddCardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add New Card', style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<AddCardCubit, AddCardState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Card added successfully!'), backgroundColor: Colors.green),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final cubit = context.read<AddCardCubit>();
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Credit Card Virtual UI
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.grey[300]!, Colors.grey[400]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card Number Input
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: TextField(
                                onChanged: cubit.updateCardNumber,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'XXXX XXXX XXXX XXXX',
                                  hintStyle: TextStyle(color: Colors.grey[400], letterSpacing: 2),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(right: 12.w, top: 12.h),
                                    child: Text(
                                      'VISA',
                                      style: TextStyle(
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                // Expiry Date
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Expiry Date', style: TextStyle(fontSize: 12.sp, color: Colors.black87)),
                                      SizedBox(height: 4.h),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: TextField(
                                          onChanged: cubit.updateExpiryDate,
                                          keyboardType: TextInputType.datetime,
                                          decoration: InputDecoration(
                                            hintText: 'MM/YY',
                                            hintStyle: TextStyle(color: Colors.grey[400]),
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                // CVV
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('CVV', style: TextStyle(fontSize: 12.sp, color: Colors.black87)),
                                          SizedBox(width: 4.w),
                                          Icon(Icons.info_outline, size: 14.sp, color: Colors.black54),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: TextField(
                                          onChanged: cubit.updateCvv,
                                          keyboardType: TextInputType.number,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            hintText: 'XXX',
                                            hintStyle: TextStyle(color: Colors.grey[400]),
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                            suffixIcon: Icon(Icons.info_outline, color: Colors.grey, size: 20.sp),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Cardholder Name
                      Text('Cardholder Name', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                      SizedBox(height: 8.h),
                      TextField(
                        onChanged: cubit.updateCardholderName,
                        decoration: InputDecoration(
                          hintText: 'e.g., Md. Rahim Khan',
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Zip Code
                      Text('Zip/Postal Code (Optional)', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                      SizedBox(height: 8.h),
                      TextField(
                        onChanged: cubit.updateZipCode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'e.g., 1212',
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Save Card Checkbox
                      InkWell(
                        onTap: cubit.toggleSaveCard,
                        child: Row(
                          children: [
                            Icon(
                              state.saveCard ? Icons.check_box : Icons.check_box_outline_blank,
                              color: state.saveCard ? Colors.green : Colors.grey,
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text('Save this card for future payments', style: TextStyle(fontSize: 14.sp)),
                          ],
                        ),
                      ),
                      SizedBox(height: 60.h),
                      
                      // Terms Text
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
                            children: const [
                              TextSpan(text: 'By adding a card, you agree to our '),
                              TextSpan(text: 'Terms & Conditions.', style: TextStyle(decoration: TextDecoration.underline)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),

              // Bottom Button
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
                  ],
                ),
                child: CustomPrimaryButton(
                  text: state.isSubmitting ? 'Adding...' : 'Add Card',
                  onPressed: state.isSubmitting ? () {} : cubit.submitCard,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
