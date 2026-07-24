class SettlementRequest {
  final String groupId;
  final String payerId;
  final String receiverId;
  final double amount;
  final String? note;

  SettlementRequest({
    required this.groupId,
    required this.payerId,
    required this.receiverId,
    required this.amount,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      "group_id": groupId,
      "payer_id": payerId,
      "receiver_id": receiverId,
      "amount": amount,
      "note": note,
    };
  }
}