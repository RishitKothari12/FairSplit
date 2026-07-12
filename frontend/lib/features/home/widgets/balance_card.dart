import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double totalBalance;
  final double youOwe;
  final double youAreOwed;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.youOwe,
    required this.youAreOwed,
  });

  @override
  Widget build(BuildContext context) {
    Color totalBalanceColor;

    if (totalBalance > 0) {
      totalBalanceColor = const Color(0xFF22C55E); // Green
    } else if (totalBalance < 0) {
      totalBalanceColor = const Color(0xFFEF4444); // Red
    } else {
      totalBalanceColor = Colors.white; // Settled
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            "Total Balance",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "${totalBalance >= 0 ? "+" : "-"}₹${totalBalance.abs().toStringAsFixed(2)}",
            style: TextStyle(
              color: totalBalanceColor,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 28),

          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      "You Owe",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "₹${youOwe.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Color(0xFFEF4444),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 1,
                height: 48,
                color: Colors.white24,
              ),

              Expanded(
                child: Column(
                  children: [
                    const Text(
                      "You Are Owed",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "₹${youAreOwed.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Color(0xFF22C55E),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}