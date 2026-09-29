import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/api_constants.dart';
import '../../data/models/login_response_model.dart';
import '../../data/models/register_response_model.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  bool isPasswordObscured = true;
  bool isRememberMeTicked = false;
  final Dio _dio = Dio();
  final _secureStorage = const FlutterSecureStorage();

  AuthCubit() : super(AuthInitial());

  void togglePasswordVisibility() {
    isPasswordObscured = !isPasswordObscured;
    emit(PasswordVisibilityToggled(isPasswordObscured));
  }

  void toggleRememberMe() {
    isRememberMeTicked = !isRememberMeTicked;
    emit(RememberMeToggled(isRememberMeTicked));
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    // Validation
    if (email.isEmpty || password.isEmpty) {
      emit(LoginValidationError(
        isEmailEmpty: email.isEmpty,
        isPasswordEmpty: password.isEmpty,
      ));
      return;
    }

    emit(AuthLoading());
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          "email": email,
          "password": password,
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = LoginResponseModel.fromJson(response.data);
        
        // Save tokens unconditionally so user stays logged in
        await _secureStorage.write(key: 'access_token', value: data.access);
        await _secureStorage.write(key: 'refresh_token', value: data.refresh);
        
        // Save credentials only if ticked
        if (isRememberMeTicked) {
          await _secureStorage.write(key: 'saved_email', value: email);
          await _secureStorage.write(key: 'saved_password', value: password);
        } else {
          // Clear if unticked
          await _secureStorage.delete(key: 'saved_email');
          await _secureStorage.delete(key: 'saved_password');
        }
        
        emit(const AuthSuccess("Login Successful"));
      } else {
        emit(const AuthFailure("Failed to login. Please try again."));
      }
    } on DioException catch (e) {
      String errorMessage = "An error occurred during login.";
      if (e.response != null && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map) {
          if (data.containsKey('detail')) {
            errorMessage = data['detail']; 
          } else if (data.containsKey('non_field_errors')) {
            errorMessage = data['non_field_errors'][0];
          } else {
            errorMessage = data['message'] ?? errorMessage;
          }
        }
      }
      emit(AuthFailure(errorMessage));
    } catch (e) {
      emit(AuthFailure("Error: $e"));
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    // Validation
    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
      emit(AuthValidationError(
        isFirstNameEmpty: firstName.isEmpty,
        isLastNameEmpty: lastName.isEmpty,
        isEmailEmpty: email.isEmpty,
        isPasswordEmpty: password.isEmpty,
      ));
      return;
    }

    emit(AuthLoading());
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "password": password,
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = RegisterResponseModel.fromJson(response.data);
        emit(AuthSuccess(data.message));
      } else {
        emit(const AuthFailure("Failed to register. Please try again."));
      }
    } on DioException catch (e) {
      String errorMessage = "An error occurred during registration.";
      if (e.response != null && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map) {
          if (data.containsKey('email')) {
            errorMessage = "This email is already taken";
          } else {
            errorMessage = data['message'] ?? errorMessage;
          }
        }
      }
      emit(AuthFailure(errorMessage));
    } catch (e) {
      emit(AuthFailure("Error: $e"));
    }
  }
}
