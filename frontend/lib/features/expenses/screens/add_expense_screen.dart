import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../groups/controllers/group_member_controller.dart';
import '../repositories/expense_repository.dart';
import '../controllers/expense_controller.dart';
import '../models/expense_create_request.dart';
import '../models/expense_participant.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  final String groupId;

  const AddExpenseScreen({
    super.key,
    required this.groupId,
  });

  @override
  ConsumerState<AddExpenseScreen> createState() =>
      _AddExpenseScreenState();
}

class _AddExpenseScreenState
    extends ConsumerState<AddExpenseScreen> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  String splitType = "equal";

  String? paidBy;

  final Set<String> selectedParticipants = {};

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final members =
        ref.watch(groupMembersProvider(widget.groupId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
      ),
      body: members.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (e, _) => Center(
          child: Text(e.toString()),
        ),

        data: (memberList) {
          if (paidBy == null && memberList.isNotEmpty) {
            paidBy = memberList.first.userId;
          }

          if (selectedParticipants.isEmpty) {
            selectedParticipants.addAll(
              memberList.map((e) => e.userId),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Expense Title",
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Amount",
                  prefixText: "₹ ",
                ),
              ),

              const SizedBox(height: 24),

              DropdownButtonFormField<String>(
                initialValue: paidBy,
                decoration: const InputDecoration(
                  labelText: "Paid By",
                ),
                items: memberList.map((member) {
                  return DropdownMenuItem(
                    value: member.userId,
                    child: Text(member.fullName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    paidBy = value;
                  });
                },
              ),

              const SizedBox(height: 28),

              const Text(
                "Participants",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 12),

              ...memberList.map(
                (member) => CheckboxListTile(
                  value: selectedParticipants
                      .contains(member.userId),
                  title: Text(member.fullName),
                  subtitle: Text(member.email),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        selectedParticipants
                            .add(member.userId);
                      } else {
                        selectedParticipants
                            .remove(member.userId);
                      }
                    });
                  },
                ),
              ),

              const SizedBox(height: 24),

              DropdownButtonFormField<String>(
                initialValue: splitType,
                decoration: const InputDecoration(
                  labelText: "Split Type",
                ),
                items: const [
                  DropdownMenuItem(
                    value: "equal",
                    child: Text("Equal"),
                  ),
                  DropdownMenuItem(
                    value: "exact",
                    child: Text("Exact"),
                  ),
                  DropdownMenuItem(
                    value: "percentage",
                    child: Text("Percentage"),
                  ),
                  DropdownMenuItem(
                    value: "shares",
                    child: Text("Shares"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    splitType = value!;
                  });
                },
              ),

              const SizedBox(height: 40),

              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty ||
                        amountController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill all required fields"),
                        ),
                      );
                      return;
                    }

                    final request = ExpenseCreateRequest(
                      groupId: widget.groupId,
                      paidBy: paidBy!,
                      title: titleController.text.trim(),
                      amount: double.parse(amountController.text),
                      splitType: splitType,
                      participants: selectedParticipants
                          .map(
                            (id) => ExpenseParticipant(
                              userId: id,
                            ),
                          )
                          .toList(),
                    );

                    final success = await ref
                        .read(expenseControllerProvider.notifier)
                        .createExpense(request);

                    if (!mounted) return;

                    if (success) {
                      ref.invalidate(
                        groupExpensesProvider(widget.groupId),
                      );

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Expense added successfully"),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Failed to add expense"),
                        ),
                      );
                    }
                  },
                  child: ref.watch(expenseControllerProvider)
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Save Expense"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}