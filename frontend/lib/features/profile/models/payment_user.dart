class PaymentUser {
  final String id;
  final String fullName;
  final String? upiId;

  PaymentUser({
    required this.id,
    required this.fullName,
    required this.upiId,
  });

  factory PaymentUser.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaymentUser(
      id: json["id"],
      fullName: json["full_name"],
      upiId: json["upi_id"],
    );
  }
}