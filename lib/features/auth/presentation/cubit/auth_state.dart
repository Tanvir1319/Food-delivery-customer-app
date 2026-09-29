import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class PasswordVisibilityToggled extends AuthState {
  final bool isObscured;
  const PasswordVisibilityToggled(this.isObscured);

  @override
  List<Object?> get props => [isObscured];
}

class RememberMeToggled extends AuthState {
  final bool isTicked;
  const RememberMeToggled(this.isTicked);

  @override
  List<Object?> get props => [isTicked];
}

class AuthValidationError extends AuthState {
  final bool isFirstNameEmpty;
  final bool isLastNameEmpty;
  final bool isEmailEmpty;
  final bool isPasswordEmpty;

  const AuthValidationError({
    this.isFirstNameEmpty = false,
    this.isLastNameEmpty = false,
    this.isEmailEmpty = false,
    this.isPasswordEmpty = false,
  });

  @override
  List<Object?> get props => [
        isFirstNameEmpty,
        isLastNameEmpty,
        isEmailEmpty,
        isPasswordEmpty,
      ];
}

class LoginValidationError extends AuthState {
  final bool isEmailEmpty;
  final bool isPasswordEmpty;

  const LoginValidationError({
    this.isEmailEmpty = false,
    this.isPasswordEmpty = false,
  });

  @override
  List<Object?> get props => [isEmailEmpty, isPasswordEmpty];
}

class AuthSuccess extends AuthState {
  final String message;
  const AuthSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}
