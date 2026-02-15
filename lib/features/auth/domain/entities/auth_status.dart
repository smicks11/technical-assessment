class AuthStatus {
  const AuthStatus({
    required this.hasToken,
    required this.storedEmail,
  });

  final bool hasToken;
  final String storedEmail;
}
