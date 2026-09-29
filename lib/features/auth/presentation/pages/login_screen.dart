import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_text_field.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
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
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Sign in to continue',
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
                      current is LoginValidationError || current is AuthInitial || current is PasswordVisibilityToggled || current is RememberMeToggled,
                  builder: (context, state) {
                    bool emailError = false;
                    bool passError = false;

                    if (state is LoginValidationError) {
                      emailError = state.isEmailEmpty;
                      passError = state.isPasswordEmpty;
                    }

                    final cubit = context.read<AuthCubit>();
                    final isObscured = cubit.isPasswordObscured;
                    final isRememberMeTicked = cubit.isRememberMeTicked;

                    return Column(
                      children: [
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
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Checkbox(
                              value: isRememberMeTicked,
                              onChanged: (value) {
                                cubit.toggleRememberMe();
                              },
                              activeColor: AppColors.primary,
                            ),
                            Text(
                              'Save your login info',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 8.h),

                // Switch to Register Text
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Do not have an account? ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'Create one',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Sign In Button
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Redirect to HomeScreen on success
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                        }
                      });
                    } else if (state is AuthFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (state is LoginValidationError) {
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
                                FocusScope.of(context).unfocus();
                                context.read<AuthCubit>().login(
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
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),

                // Forgot Password
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
