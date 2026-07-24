import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../controllers/settlement_controller.dart';

class AllSettlementsScreen extends ConsumerWidget {
  final String groupId;

  const AllSettlementsScreen({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settlement History"),
      ),
      body: ref.watch(groupSettlementProvider(groupId)).when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (e, _) => Center(
          child: Text(e.toString()),
        ),

        data: (settlements) {
          if (settlements.isEmpty) {
            return const Center(
              child: Text("No settlements yet."),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: settlements.length,
            itemBuilder: (_, index) {
              final settlement = settlements[index];

              return Card(
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
                          color: Colors.grey,
                          fontSize: 12,
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
                      color: Colors.green,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}