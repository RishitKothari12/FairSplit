import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';
import '../repositories/profile_repository.dart';

final profileProvider =
    FutureProvider<UserProfile>(
  (ref) {
    return ref
        .read(profileRepositoryProvider)
        .getProfile();
  },
);

final profileControllerProvider =
    Provider(
  (ref) => ProfileController(ref),
);

class ProfileController {
  final Ref ref;

  ProfileController(this.ref);

  Future<void> updateUpiId(
    String? upiId,
  ) async {
    await ref
        .read(profileRepositoryProvider)
        .updateUpiId(upiId);

    ref.invalidate(profileProvider);
  }
}