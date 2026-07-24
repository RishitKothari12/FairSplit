class Settlement {
  final String id;

  final String payerId;
  final String payerName;

  final String receiverId;
  final String receiverName;

  final double amount;
  final String? note;

  final DateTime settledAt;

  Settlement({
    required this.id,
    required this.payerId,
    required this.payerName,
    required this.receiverId,
    required this.receiverName,
    required this.amount,
    required this.note,
    required this.settledAt,
  });

  factory Settlement.fromJson(
    Map<String, dynamic> json,
  ) {
    return Settlement(
      id: json["id"],
      payerId: json["payer_id"],
      payerName: json["payer_name"],
      receiverId: json["receiver_id"],
      receiverName: json["receiver_name"],
      amount: double.parse(
        json["amount"].toString(),
      ),
      note: json["note"],
      settledAt: DateTime.parse(
        json["settled_at"],
      ),
    );
  }
}