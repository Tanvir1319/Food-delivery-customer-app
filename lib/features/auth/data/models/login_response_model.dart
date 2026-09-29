class LoginResponseModel {
  final String refresh;
  final String access;
  final LoginUserModel user;

  LoginResponseModel({
    required this.refresh,
    required this.access,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      refresh: json['refresh'] ?? '',
      access: json['access'] ?? '',
      user: LoginUserModel.fromJson(json['user'] ?? {}),
    );
  }
}

class LoginUserModel {
  final int id;
  final String email;
  final String role;
  final String phoneNumber;
  final String firstName;
  final String lastName;

  LoginUserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
  });

  factory LoginUserModel.fromJson(Map<String, dynamic> json) {
    return LoginUserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }
}
