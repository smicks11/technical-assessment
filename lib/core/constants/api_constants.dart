class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://recruitment.africremit.ca/api';
  static const int connectTimeoutMs = 15000;
  static const int sendTimeoutMs = 15000;
  static const int receiveTimeoutMs = 15000;

  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String user = '/user';
  static const String accountCredit = '/account/credit';
  static const String accountDebit = '/account/debit';
}
