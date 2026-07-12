import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final double balance;
  final VoidCallback? onTap;

  const GroupCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.balance,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = balance > 0;
    final isSettled = balance == 0;

    Color amountColor = Colors.grey;

    if (isPositive) {
      amountColor = const Color(0xFF22C55E);
    } else if (!isSettled) {
      amountColor = const Color(0xFFEF4444);
    }

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),

          leading: CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFFEDE9FE),
            child: Text(
              name[0].toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),

          title: Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(subtitle),
          ),

          trailing: isSettled
              ? const Text(
                  "View",
                  style: TextStyle(
                    color: Color(0xFF6C4DFF),
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isPositive ? "You are owed" : "You owe",
                      style: TextStyle(
                        color: amountColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₹${balance.abs().toStringAsFixed(0)}",
                      style: TextStyle(
                        color: amountColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}