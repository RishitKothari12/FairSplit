import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../models/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment_user.dart';

final profileRepositoryProvider =
    Provider<ProfileRepository>(
  (ref) => ProfileRepository(),
);

class ProfileRepository {
  Future<UserProfile> getProfile() async {
    final response = await DioClient.dio.get(
      "${ApiConstants.users}/me",
    );

    return UserProfile.fromJson(
      response.data,
    );
  }

  Future<UserProfile> updateUpiId(
    String? upiId,
  ) async {
    final response = await DioClient.dio.patch(
      "${ApiConstants.users}/me/upi-id",
      data: {
        "upi_id": upiId,
      },
    );

    return UserProfile.fromJson(
      response.data,
    );
  }

  Future<PaymentUser> getPaymentUser(
    String userId,
    ) async {
    final response = await DioClient.dio.get(
        "${ApiConstants.users}/$userId/payment",
    );

    return PaymentUser.fromJson(
        response.data,
    );
  }
}