class RegisterRequest {
  RegisterRequest({
    required this.name,
    required this.email,
    required this.currency,
    required this.password,
  });

  final String name;
  final String email;
  final String currency;
  final String password;

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'currency': currency,
        'password': password,
      };
}
