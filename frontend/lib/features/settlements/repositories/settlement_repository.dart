import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../models/settlement_request.dart';
import '../models/settlement.dart';

class SettlementRepository {
  Future<void> createSettlement(
    SettlementRequest request,
  ) async {
    await DioClient.dio.post(
      ApiConstants.settlements,
      data: request.toJson(),
    );
  }

  Future<List<Settlement>> getGroupSettlements(
    String groupId,
    ) async {
        final response = await DioClient.dio.get(
            "${ApiConstants.settlements}/group/$groupId",
        );

    return (response.data as List)
        .map(
            (e) => Settlement.fromJson(e),
        )
        .toList();
    }
}