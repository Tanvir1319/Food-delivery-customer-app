import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final bool hasError;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.isPassword = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: hasError ? Colors.red : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: hasError ? Colors.red : AppColors.border),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
              suffixIcon: suffixIcon,
              suffixIconConstraints: BoxConstraints(
                minWidth: 24.w,
                minHeight: 24.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
