import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../expenses/repositories/expense_repository.dart';
import '../../expenses/screens/add_expense_screen.dart';
import 'group_info_screen.dart';
import '../../expenses/screens/expense_details_screen.dart';
import '../../balances/repositories/balance_repository.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../settlements/models/settlement_request.dart';
import '../../settlements/repositories/settlement_repository.dart';
import '../../settlements/controllers/settlement_controller.dart';
import '../../../core/utils/date_formatter.dart';
import '../../expenses/screens/all_expenses_screen.dart';
import '../../settlements/screens/all_settlements_screen.dart';
import '../../profile/repositories/profile_repository.dart';
import '../../../core/services/upi_service.dart';


String getUpiIcon(
  String packageName,
) {
  switch (packageName) {
    case "com.phonepe.app":
      return "assets/icons/upi/phone_pe.webp";

    case "com.google.android.apps.nbu.paisa.user":
      return "assets/icons/upi/google_pay.webp";

    case "net.one97.paytm":
      return "assets/icons/upi/paytm.png";

    case "in.org.npci.upiapp":
      return "assets/icons/upi/bhim.png";

    default:
      return "assets/icons/upi/google_pay.webp";
  }
}

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
            ref.watch(groupBalanceProvider(groupId)).when(
              loading: () => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
              error: (_, _) => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Unable to load balance",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              data: (balance) {
                final canPayViaUpi = balance.youOwe > 0;
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            balance.youAreOwed > 0
                                ? "You are owed"
                                : balance.youOwe > 0
                                    ? "You owe"
                                    : "You're settled up",
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            CurrencyFormatter.format(
                              balance.youAreOwed > 0
                                  ? balance.youAreOwed
                                  : balance.youOwe,
                            ),
                            style: TextStyle(
                              color: balance.youAreOwed > 0
                                  ? AppColors.positive
                                  : balance.youOwe > 0
                                      ? AppColors.negative
                                      : AppColors.settled,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (balance.transactions.isNotEmpty) ...[
                      const SizedBox(height: 24),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Settlement Summary",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      ...balance.transactions.map(
                        (transaction) => Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundColor: balance.youAreOwed > 0
                                          ? AppColors.positive.withOpacity(0.12)
                                          : AppColors.negative.withOpacity(0.12),
                                      child: Icon(
                                        balance.youAreOwed > 0
                                            ? Icons.arrow_downward
                                            : Icons.arrow_upward,
                                        color: balance.youAreOwed > 0
                                            ? AppColors.positive
                                            : AppColors.negative,
                                      ),
                                    ),

                                    const SizedBox(width: 14),

                                    Expanded(
                                      child: Text(
                                        balance.youAreOwed > 0
                                            ? "${transaction.fromUserName} owes you"
                                            : "You owe ${transaction.toUserName}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                Row(
                                  children: [
                                    Text(
                                      CurrencyFormatter.format(
                                        transaction.amount,
                                      ),
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: balance.youAreOwed > 0
                                            ? AppColors.positive
                                            : AppColors.negative,
                                      ),
                                    ),

                                    const Spacer(),

                                    ElevatedButton.icon(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          showDragHandle: true,
                                          builder: (_) {
                                            return SafeArea(
                                              child: Padding(
                                                padding: const EdgeInsets.all(20),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                      "Complete Settlement",
                                                      style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),

                                                    const SizedBox(height: 24),

                                                    if (canPayViaUpi)
                                                      ListTile(
                                                        leading: const Icon(Icons.account_balance_wallet),
                                                        title: const Text("Pay via UPI"),
                                                        subtitle: const Text(
                                                          "Use PhonePe, GPay, Paytm etc.",
                                                        ),
                                                        onTap: () async {
                                                          final paymentUser = await ProfileRepository().getPaymentUser(
                                                            transaction.toUserId,
                                                          );

                                                          if (!context.mounted) return;

                                                          if (paymentUser.upiId == null ||
                                                              paymentUser.upiId!.trim().isEmpty) {
                                                            showDialog(
                                                              context: context,
                                                              builder: (_) => AlertDialog(
                                                                title: const Text("UPI ID Not Available"),
                                                                content: Text(
                                                                  "${paymentUser.fullName} hasn't added a UPI ID yet.",
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () => Navigator.pop(context),
                                                                    child: const Text("OK"),
                                                                  ),
                                                                ],
                                                              ),
                                                            );

                                                            return;
                                                          }
                                                          final apps = await UpiService.getInstalledApps();

                                                            if (!context.mounted) return;
                                                            
                                                            showModalBottomSheet(
                                                              context: context,
                                                              showDragHandle: true,
                                                              builder: (_) {
                                                                return SafeArea(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(20),
                                                                    child: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [

                                                                        const Text(
                                                                          "Choose UPI App",
                                                                          style: TextStyle(
                                                                            fontSize: 22,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),

                                                                        const SizedBox(height: 20),

                                                                        ...apps.map(
                                                                          (app) => ListTile(
                                                                            leading: ClipRRect(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              child: Image.asset(
                                                                                getUpiIcon(app.packageName),
                                                                                width: 42,
                                                                                height: 42,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),

                                                                            title: Text(
                                                                              app.name,
                                                                              style: const TextStyle(
                                                                                fontSize: 17,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),

                                                                            trailing: const Icon(
                                                                              Icons.arrow_forward_ios_rounded,
                                                                              size: 18,
                                                                            ),

                                                                            onTap: () async {

                                                                              Navigator.pop(context);

                                                                              await UpiService.launch(
                                                                                packageName: app.packageName,
                                                                                upiId: paymentUser.upiId!,
                                                                                name: paymentUser.fullName,
                                                                                amount: transaction.amount,
                                                                                note: "FairSplit Settlement",
                                                                              );

                                                                              // Launch code goes here
                                                                            },
                                                                          ),
                                                                        ),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                        },
                                                      ),

                                                    ListTile(
                                                      leading: const Icon(Icons.payments),
                                                      title: const Text("Record Cash Settlement"),
                                                      subtitle: const Text(
                                                        "Record an offline settlement",
                                                      ),
                                                      onTap: () async {
                                                        Navigator.pop(context);

                                                        final receiverId = balance.youAreOwed > 0
                                                            ? transaction.toUserId
                                                            : transaction.fromUserId;

                                                        await SettlementRepository().createSettlement(
                                                          SettlementRequest(
                                                            groupId: groupId,
                                                            payerId: transaction.fromUserId,
                                                            receiverId: transaction.toUserId,
                                                            amount: transaction.amount,
                                                            note: "Cash Settlement",
                                                          )
                                                        );

                                                        ref.invalidate(
                                                          groupBalanceProvider(groupId),
                                                        );

                                                        ref.invalidate(
                                                          groupExpensesProvider(groupId),
                                                        );

                                                        ref.invalidate(
                                                          groupSettlementProvider(groupId),
                                                        );

                                                        if (!context.mounted) return;

                                                        showDialog(
                                                          context: context,
                                                          builder: (_) => AlertDialog(
                                                            icon: const Icon(
                                                              Icons.check_circle,
                                                              color: Colors.green,
                                                              size: 48,
                                                            ),
                                                            title: const Text("Settlement Recorded"),
                                                            content: Text(
                                                              "${CurrencyFormatter.format(transaction.amount)} settled successfully.",
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: const Text("OK"),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.payments_outlined),
                                      label: const Text("Settle Up"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 30),

            const Text(
              "Recent Expenses",
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
                final recentExpenses = expenses.take(5).toList();
                if (expenses.isEmpty) {
                  return Column(
                    children: [
                      const Card(
                        child: ListTile(
                          leading: Icon(Icons.receipt_long),
                          title: Text("No expenses yet"),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GroupInfoScreen(
                                  groupId: groupId,
                                  groupName: groupName,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.group),
                          label: const Text("Group Info"),
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    ...recentExpenses.map(
                      (expense) => Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
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
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.12),
                            child: Icon(
                              Icons.receipt_long,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          title: Text(
                            expense.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              "Paid by ${expense.paidBy.fullName}",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                CurrencyFormatter.format(
                                  expense.amount,
                                ),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Icon(
                                Icons.chevron_right,
                                size: 18,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    if (expenses.length > 5)
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AllExpensesScreen(
                                  groupId: groupId,
                                ),
                              ),
                            );
                          },
                          child: const Text("See All Expenses"),
                        ),
                      ),
                    const SizedBox(height: 24),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Settlement History",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    ref.watch(groupSettlementProvider(groupId)).when(
                      loading: () => const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),

                      error: (e, _) => Text(
                        e.toString(),
                      ),

                      data: (settlements) {
                        final recentSettlements =
                          settlements.take(5).toList();
                        if (settlements.isEmpty) {
                          return const Card(
                            child: ListTile(
                              leading: Icon(Icons.payments),
                              title: Text("No settlements yet"),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            ...recentSettlements.map(
                              (settlement) => Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.payments),
                                  ),

                                  title: Text(
                                    "${settlement.payerName} paid ${settlement.receiverName}",
                                  ),

                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (settlement.note != null)
                                        Text(settlement.note!),

                                      const SizedBox(height: 4),

                                      Text(
                                        DateFormatter.format(
                                          settlement.settledAt,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),

                                  trailing: Text(
                                    CurrencyFormatter.format(
                                      settlement.amount,
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.positive,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            if (settlements.length > 5)
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AllSettlementsScreen(
                                          groupId: groupId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text("See All Settlements"),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    Center(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GroupInfoScreen(
                                groupId: groupId,
                                groupName: groupName,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.group),
                        label: const Text("Group Info"),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
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