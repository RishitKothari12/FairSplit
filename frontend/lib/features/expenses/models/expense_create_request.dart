import 'expense_participant.dart';

class ExpenseCreateRequest {
  final String groupId;
  final String paidBy;
  final String title;
  final String? description;
  final double amount;
  final String currency;
  final String splitType;
  final List<ExpenseParticipant> participants;

  ExpenseCreateRequest({
    required this.groupId,
    required this.paidBy,
    required this.title,
    this.description,
    required this.amount,
    this.currency = "INR",
    required this.splitType,
    required this.participants,
  });

  Map<String, dynamic> toJson() {
    return {
      "group_id": groupId,
      "paid_by": paidBy,
      "title": title,
      "description": description,
      "amount": amount,
      "currency": currency,
      "split_type": splitType,
      "participants":
          participants.map((e) => e.toJson()).toList(),
    };
  }
}