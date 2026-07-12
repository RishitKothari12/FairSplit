import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/group_member.dart';
import '../repositories/group_member_repository.dart';

final groupMemberRepositoryProvider =
    Provider(
  (ref) => GroupMemberRepository(),
);

final groupMembersProvider =
    FutureProvider.family<List<GroupMember>, String>(
  (ref, groupId) async {
    return ref
        .read(groupMemberRepositoryProvider)
        .getMembers(groupId);
  },
);