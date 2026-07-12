class Expense {
  final String id;
  final String title;
  final double amount;
  final String paidBy;
  final String? description;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.paidBy,
    this.description,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json["id"],
      title: json["title"],
      amount: double.parse(json["amount"].toString()),
      paidBy: json["paid_by"],
      description: json["description"],
    );
  }
}