import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../models/group.dart';

class GroupRepository {
  Future<List<Group>> getGroups() async {
    final response = await DioClient.dio.get(
      ApiConstants.groups,
    );

    return (response.data as List)
        .map((e) => Group.fromJson(e))
        .toList();
  }
}