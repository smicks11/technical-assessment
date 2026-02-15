class AccountOperationResponse {
  AccountOperationResponse({
    this.message,
    this.balance,
  });

  final String? message;
  final double? balance;

  factory AccountOperationResponse.fromJson(Map<String, dynamic> json) {
    return AccountOperationResponse(
      message: json['message'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
    );
  }
}
