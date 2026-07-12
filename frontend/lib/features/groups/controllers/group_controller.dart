import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/group.dart';
import '../repositories/group_repository.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(),
);

final groupControllerProvider =
    FutureProvider<List<Group>>((ref) async {
  return ref.read(groupRepositoryProvider).getGroups();
});