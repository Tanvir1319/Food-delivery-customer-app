import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildButton(Icons.remove, onDecrement, quantity > 1),
        SizedBox(width: 12.w),
        Text(
          quantity.toString(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: 12.w),
        _buildButton(Icons.add, onIncrement, true),
      ],
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onTap, bool enabled) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: enabled ? AppColors.accent : AppColors.border,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Icon(
          icon,
          size: 16.sp,
          color: Colors.white,
        ),
      ),
    );
  }
}
