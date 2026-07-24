import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/settlement.dart';
import '../repositories/settlement_repository.dart';

final settlementRepositoryProvider =
    Provider(
  (ref) => SettlementRepository(),
);

final groupSettlementProvider =
    FutureProvider.family<List<Settlement>, String>(
  (ref, groupId) {
    return ref
        .read(settlementRepositoryProvider)
        .getGroupSettlements(groupId);
  },
);