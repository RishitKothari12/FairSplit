import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/bottom_nav.dart';
import '../widgets/balance_card.dart';
import '../widgets/greeting_header.dart';
import '../widgets/group_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../groups/controllers/group_controller.dart';
import '../../groups/screens/group_details_screen.dart';
import '../../expenses/screens/add_expense_screen.dart';

class HomeScreen extends ConsumerStatefulWidget  {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF16A34A),
        foregroundColor: Colors.white,
        elevation: 6,
        onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (_) => const AddExpenseScreen(
                  groupId: "4056e554-37a5-4c4e-a3aa-fba9bc5c7f9f",
                ),
                ),
            );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Expense"),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNav(
        currentIndex: index,
        onTap: (i) {
          setState(() {
            index = i;
          });
        },
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GreetingHeader(
                name: "Rishit",
              ),

              SizedBox(height: 24),

              BalanceCard(
                totalBalance: 2150,
                youOwe: 1250,
                youAreOwed: 3400,
              ),

              SizedBox(height: 32),

              Text(
                "Your Groups",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),
              
              ref.watch(groupControllerProvider).when(
                loading: () => const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                    child: CircularProgressIndicator(),
                    ),
                ),

                error: (error, _) => Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                    error.toString(),
                    style: const TextStyle(
                        color: Colors.red,
                    ),
                    ),
                ),

                data: (groups) {
                    if (groups.isEmpty) {
                    return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                        child: Text("No Groups Yet"),
                        ),
                    );
                    }

                    return Column(
                    children: groups.map((group) {
                        return GroupCard(
                        name: group.name,
                        subtitle: group.description ?? "No description",
                        balance: 0,
                        onTap: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => GroupDetailsScreen(
                                groupId: group.id,
                                groupName: group.name,
                                ),
                            ),
                            );
                        },
                        );
                    }).toList(),
                    );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}