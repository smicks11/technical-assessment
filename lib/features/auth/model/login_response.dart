import 'user.dart';

class LoginResponse {
  LoginResponse({
    required this.user,
    required this.token,
  });

  final User user;
  final String token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;
    final auth = json['authorization'] as Map<String, dynamic>?;
    final token = auth?['token'] as String? ?? '';
    return LoginResponse(
      user: User.fromJson(userJson),
      token: token,
    );
  }
}
