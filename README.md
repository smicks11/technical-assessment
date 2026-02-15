# technical_assesment

Banking-style Flutter app: Register, Login, Logout, Fetch profile, Credit/Debit account.

## Production notes

- **Token storage:** Auth token is stored with `flutter_secure_storage` (encrypted). Tests use `AuthStorageServiceImpl` with SharedPreferences for compatibility.
- **Debit / balance:** When the API returns `balance` (on user or `account.balance`), the app validates before debit and shows "Insufficient balance" without calling the API. When the API does not return balance, the server enforces rules and the app displays the server error.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
