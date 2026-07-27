import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/expense_repository.dart';
import '../controllers/expense_controller.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../balances/repositories/balance_repository.dart';
import '../../settlements/controllers/settlement_controller.dart';

class ExpenseDetailsScreen extends ConsumerWidget {
  final String expenseId;

  const ExpenseDetailsScreen({
    super.key,
    required this.expenseId,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final expenseAsync = ref.watch(
      expenseProvider(expenseId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Details"),
      ),
      body: expenseAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text(e.toString()),
        ),
        data: (expense) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        CurrencyFormatter.format(
                          expense.amount,
                        ),
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .primary,
                        ),
                      ),

                      if (expense.description != null &&
                          expense.description!.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text(
                          expense.description!,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Paid by"),
                  subtitle: Text(
                    expense.paidBy.fullName,
                  ),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.call_split),
                  title: const Text("Split Type"),
                  subtitle: Text(
                    expense.splitType.toUpperCase(),
                  ),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text("Date"),
                  subtitle: Text(
                    DateFormatter.format(
                      expense.expenseDate,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Participants",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              ...expense.participants.map(
                (participant) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        participant.fullName[0]
                            .toUpperCase(),
                      ),
                    ),
                    title: Text(
                      participant.fullName,
                    ),
                    subtitle: Text(
                      participant.email,
                    ),
                    trailing: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      children: [
                        Text(
                          CurrencyFormatter.format(
                            participant.amountOwed,
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          participant.isSettled
                              ? "Settled"
                              : "Pending",
                          style: TextStyle(
                            color: participant.isSettled
                                ? Colors.green
                                : Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                        title: const Text("Delete Expense"),
                        content: const Text(
                            "Are you sure you want to delete this expense?",
                        ),
                        actions: [
                            TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancel"),
                            ),
                            FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Delete"),
                            ),
                        ],
                        ),
                    );

                    if (confirm != true) return;

                    final success = await ref
                        .read(expenseControllerProvider.notifier)
                        .deleteExpense(expense.id);

                    if (!context.mounted) return;

                    if (success) {
                        ref.invalidate(
                          groupExpensesProvider(expense.groupId),
                        );

                        ref.invalidate(
                          groupBalanceProvider(expense.groupId),
                        );

                        ref.invalidate(
                          groupSettlementProvider(expense.groupId),
                        );

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Expense deleted"),
                        ),
                        );
                    } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Failed to delete expense"),
                        ),
                        );
                    }
                    },
                  icon: const Icon(Icons.delete),
                  label: const Text(
                    "Delete Expense",
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}