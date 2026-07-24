class ExpensePayer {
  final String id;
  final String fullName;

  ExpensePayer({
    required this.id,
    required this.fullName,
  });

  factory ExpensePayer.fromJson(
    Map<String, dynamic> json,
  ) {
    return ExpensePayer(
      id: json["id"],
      fullName: json["full_name"],
    );
  }
}

class ExpenseParticipant {
  final String userId;
  final String fullName;
  final String email;
  final double amountOwed;
  final bool isSettled;

  ExpenseParticipant({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.amountOwed,
    required this.isSettled,
  });

  factory ExpenseParticipant.fromJson(
    Map<String, dynamic> json,
  ) {
    return ExpenseParticipant(
      userId: json["user_id"],
      fullName: json["full_name"],
      email: json["email"],
      amountOwed: double.parse(
        json["amount_owed"].toString(),
      ),
      isSettled: json["is_settled"],
    );
  }
}

class Expense {
  final String id;
  final String groupId;

  final String title;
  final String? description;

  final double amount;
  final String currency;

  final String splitType;
  final DateTime expenseDate;

  final ExpensePayer paidBy;

  final List<ExpenseParticipant> participants;

  Expense({
    required this.id,
    required this.groupId,
    required this.title,
    required this.description,
    required this.amount,
    required this.currency,
    required this.splitType,
    required this.expenseDate,
    required this.paidBy,
    required this.participants,
  });

  factory Expense.fromJson(
    Map<String, dynamic> json,
  ) {
    return Expense(
      id: json["id"],
      groupId: json["group_id"],
      title: json["title"],
      description: json["description"],
      amount: double.parse(
        json["amount"].toString(),
      ),
      currency: json["currency"],
      splitType: json["split_type"],
      expenseDate: DateTime.parse(
        json["expense_date"],
      ),
      paidBy: ExpensePayer.fromJson(
        json["paid_by"],
      ),
      participants: (json["participants"] as List)
          .map(
            (e) => ExpenseParticipant.fromJson(e),
          )
          .toList(),
    );
  }
}
