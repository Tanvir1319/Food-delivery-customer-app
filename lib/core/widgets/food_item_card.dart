import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class FoodItemCard extends StatelessWidget {
  final String title;
  final String? restaurantName;
  final String description;
  final String price;
  final String? discountedPrice;
  final String imageUrl;
  final double rating;
  final String? deliveryTime;
  final bool isGrid;
  final VoidCallback? onTap;

  const FoodItemCard({
    super.key,
    required this.title,
    this.restaurantName,
    required this.description,
    required this.price,
    this.discountedPrice,
    required this.imageUrl,
    this.rating = 0.0,
    this.deliveryTime,
    this.isGrid = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: isGrid ? _buildGridCard() : _buildListCard(),
      ),
    );
  }

  Widget _buildGridCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Placeholder (Using Container since URL might be invalid during test)
        Expanded(
          child: Container(
            width: double.infinity,
            color: Colors.grey[300],
            child: Icon(Icons.image, color: Colors.grey[500], size: 40.sp),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (restaurantName != null && restaurantName!.isNotEmpty) ...[
                SizedBox(height: 2.h),
                Text(
                  restaurantName!,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 14.sp),
                  SizedBox(width: 4.w),
                  Text(
                    rating.toString(),
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  if (deliveryTime != null) ...[
                    SizedBox(width: 8.w),
                    Text(
                      '• ',
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                    ),
                    Text(
                      deliveryTime!,
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                    ),
                  ]
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  if (discountedPrice != null && discountedPrice!.isNotEmpty) ...[
                    Text(
                      discountedPrice!,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 12.sp, 
                        fontWeight: FontWeight.normal, 
                        color: AppColors.textSecondary,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ] else ...[
                    Text(
                      price,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListCard() {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                if (restaurantName != null && restaurantName!.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    restaurantName!,
                    style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                  ),
                ],
                if (description.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 8.h),
                Row(
                  children: [
                    if (discountedPrice != null && discountedPrice!.isNotEmpty) ...[
                      Text(
                        discountedPrice!,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 12.sp, 
                          fontWeight: FontWeight.normal, 
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ] else ...[
                      Text(
                        price,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            height: 80.w,
            width: 80.w,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.image, color: Colors.grey[500], size: 30.sp),
          ),
        ],
      ),
    );
  }
}
