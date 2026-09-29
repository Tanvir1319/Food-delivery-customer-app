import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatelessWidget {
  const _RegisterView();

  @override
  Widget build(BuildContext context) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo & Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'asset/logo.png',
                      width: 40.w,
                      height: 40.w,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.fastfood,
                        size: 40.w,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'BiteDash',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Sign up to get started',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 28.h),

                // Form Fields wrapped in BlocBuilder to listen for Validation Errors
                BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (previous, current) =>
                      current is AuthValidationError || current is AuthInitial || current is PasswordVisibilityToggled,
                  builder: (context, state) {
                    bool fNameError = false;
                    bool lNameError = false;
                    bool emailError = false;
                    bool passError = false;

                    if (state is AuthValidationError) {
                      fNameError = state.isFirstNameEmpty;
                      lNameError = state.isLastNameEmpty;
                      emailError = state.isEmailEmpty;
                      passError = state.isPasswordEmpty;
                    }

                    final cubit = context.read<AuthCubit>();
                    final isObscured = cubit.isPasswordObscured;

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AuthTextField(
                                label: 'First Name',
                                hintText: 'John',
                                controller: firstNameController,
                                hasError: fNameError,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: AuthTextField(
                                label: 'Last Name',
                                hintText: 'Doe',
                                controller: lastNameController,
                                hasError: lNameError,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        AuthTextField(
                          label: 'Email Address',
                          hintText: 'alex.j@email.com',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          hasError: emailError,
                        ),
                        SizedBox(height: 16.h),
                        AuthTextField(
                          label: 'Password',
                          hintText: '••••••••••••',
                          controller: passwordController,
                          isPassword: isObscured,
                          hasError: passError,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isObscured
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18.sp,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () {
                              cubit.togglePasswordVisibility();
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 12.h),

                // Switch to Login Text
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'Log in now',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Sign Up Button
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Redirect to login screen on success
                      Future.delayed(const Duration(seconds: 1), () {
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      });
                    } else if (state is AuthFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (state is AuthValidationError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill up all the required fields"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return SizedBox(
                      height: 48.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                // Clear focus to dismiss keyboard
                                FocusScope.of(context).unfocus();
                                context.read<AuthCubit>().register(
                                      firstName: firstNameController.text.trim(),
                                      lastName: lastNameController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                    );
                              },
                        child: isLoading
                            ? SizedBox(
                                height: 20.w,
                                width: 20.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
