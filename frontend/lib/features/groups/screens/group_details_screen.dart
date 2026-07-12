import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../expenses/repositories/expense_repository.dart';
import '../../expenses/screens/add_expense_screen.dart';


class GroupDetailsScreen extends ConsumerWidget {
  final String groupId;
  final String groupName;

  const GroupDetailsScreen({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Text(
                    "Group Balance",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "₹0.00",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Members",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text("R"),
                ),
                title: Text("Rishit"),
                subtitle: Text("You"),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Expenses",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ref.watch(groupExpensesProvider(groupId)).when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => Text(e.toString()),
              data: (expenses) {
                if (expenses.isEmpty) {
                  return const Card(
                    child: ListTile(
                      leading: Icon(Icons.receipt_long),
                      title: Text("No expenses yet"),
                    ),
                  );
                }

                return Column(
                  children: expenses.map((expense) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text(expense.title),
                        subtitle: Text(
                          expense.description ?? "",
                        ),
                        trailing: Text(
                          "₹${expense.amount}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF16A34A),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddExpenseScreen(
                groupId: groupId,
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Expense"),
      ),
    );
  }
}