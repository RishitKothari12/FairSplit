class ExpenseParticipant {
  final String userId;
  final double? amount;
  final double? percentage;
  final int? shares;

  ExpenseParticipant({
    required this.userId,
    this.amount,
    this.percentage,
    this.shares,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "amount": amount,
      "percentage": percentage,
      "shares": shares,
    };
  }
}