import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/presentation/pages/home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check credentials inside the future delay to maintain the splash duration
    Future.delayed(const Duration(seconds: 3), () async {
      const secureStorage = FlutterSecureStorage();
      final savedEmail = await secureStorage.read(key: 'saved_email');
      final savedPassword = await secureStorage.read(key: 'saved_password');

      if (context.mounted) {
        // If the user ticked "Save your login info", the credentials will exist
        if (savedEmail != null && savedPassword != null && savedEmail.isNotEmpty && savedPassword.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'asset/logo.png',
                    width: 48.w,
                    height: 48.w,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.fastfood,
                      size: 48.w,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'BiteDash',
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your Food, Delivered',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              'v2.1.0',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
