import '../../../core/network/dio_client.dart';
import '../models/group_member.dart';

class GroupMemberRepository {
  Future<List<GroupMember>> getMembers(
    String groupId,
  ) async {
    final response = await DioClient.dio.get(
      "/groups/$groupId/members",
    );

    return (response.data as List)
        .map((e) => GroupMember.fromJson(e))
        .toList();
  }
}