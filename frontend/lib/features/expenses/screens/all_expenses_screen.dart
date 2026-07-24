import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/currency_formatter.dart';
import '../repositories/expense_repository.dart';
import 'expense_details_screen.dart';

class AllExpensesScreen extends ConsumerWidget {
  final String groupId;

  const AllExpensesScreen({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Expenses"),
      ),
      body: ref.watch(groupExpensesProvider(groupId)).when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (e, _) => Center(
          child: Text(e.toString()),
        ),

        data: (expenses) {
          if (expenses.isEmpty) {
            return const Center(
              child: Text("No expenses found."),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: expenses.length,
            itemBuilder: (_, index) {
              final expense = expenses[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.receipt_long),

                  title: Text(expense.title),

                  subtitle: Text(
                    "Paid by ${expense.paidBy.fullName}",
                  ),

                  trailing: Text(
                    CurrencyFormatter.format(
                      expense.amount,
                    ),
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExpenseDetailsScreen(
                          expenseId: expense.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}