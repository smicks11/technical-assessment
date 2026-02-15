class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.currency,
    this.balance,
    this.accountNumber,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String? currency;
  final double? balance;
  final String? accountNumber;
  final String? createdAt;
  final String? updatedAt;

  static double? _parseBalance(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    double? balance = _parseBalance(json['balance']);
    String? accountNumber;
    if (json['account'] is Map) {
      final acc = Map<String, dynamic>.from(json['account'] as Map);
      balance = balance ?? _parseBalance(acc['balance']);
      final an = acc['account_number'] ?? acc['accountNumber'] ?? acc['number'];
      if (an != null) accountNumber = an.toString();
    }
    final id = json['id'];
    final name = json['name'];
    final email = json['email'];
    if (id == null || name == null || email == null) {
      throw FormatException('User json missing id, name or email: $json');
    }
    return User(
      id: (id as num).toInt(),
      name: name.toString(),
      email: email.toString(),
      emailVerifiedAt: json['email_verified_at'] as String?,
      currency: json['currency'] as String?,
      balance: balance,
      accountNumber: accountNumber ?? json['account_number'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'email_verified_at': emailVerifiedAt,
        'currency': currency,
        'balance': balance,
        'account_number': accountNumber,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? emailVerifiedAt,
    String? currency,
    double? balance,
    String? accountNumber,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      currency: currency ?? this.currency,
      balance: balance ?? this.balance,
      accountNumber: accountNumber ?? this.accountNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
