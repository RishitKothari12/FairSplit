class BalanceTransaction {
  final String fromUserId;
  final String fromUserName;

  final String toUserId;
  final String toUserName;

  final double amount;

  BalanceTransaction({
    required this.fromUserId,
    required this.fromUserName,
    required this.toUserId,
    required this.toUserName,
    required this.amount,
  });

  factory BalanceTransaction.fromJson(
    Map<String, dynamic> json,
  ) {
    return BalanceTransaction(
      fromUserId: json["from_user_id"],
      fromUserName: json["from_user_name"],
      toUserId: json["to_user_id"],
      toUserName: json["to_user_name"],
      amount: double.parse(
        json["amount"].toString(),
      ),
    );
  }
}

class BalanceSummary {
  final String groupId;

  final double youOwe;
  final double youAreOwed;
  final double netBalance;

  final List<BalanceTransaction> transactions;

  BalanceSummary({
    required this.groupId,
    required this.youOwe,
    required this.youAreOwed,
    required this.netBalance,
    required this.transactions,
  });

  factory BalanceSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return BalanceSummary(
      groupId: json["group_id"],
      youOwe: double.parse(
        json["you_owe"].toString(),
      ),
      youAreOwed: double.parse(
        json["you_are_owed"].toString(),
      ),
      netBalance: double.parse(
        json["net_balance"].toString(),
      ),
      transactions: (json["transactions"] as List)
          .map(
            (e) => BalanceTransaction.fromJson(e),
          )
          .toList(),
    );
  }
}