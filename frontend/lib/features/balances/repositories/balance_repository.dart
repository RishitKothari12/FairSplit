import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../models/balance.dart';

final balanceRepositoryProvider =
    Provider<BalanceRepository>(
  (ref) => BalanceRepository(),
);

final groupBalanceProvider =
    FutureProvider.family<BalanceSummary, String>(
  (ref, groupId) async {
    return ref
        .read(balanceRepositoryProvider)
        .getGroupBalance(groupId);
  },
);

class BalanceRepository {
  Future<BalanceSummary> getGroupBalance(
    String groupId,
  ) async {
    final response = await DioClient.dio.get(
      "${ApiConstants.balances}/group/$groupId",
    );

    return BalanceSummary.fromJson(
      response.data,
    );
  }
}