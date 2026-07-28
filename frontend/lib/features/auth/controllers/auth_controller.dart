import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/secure_storage.dart';
import '../models/login_request.dart';
import '../repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    ref.read(authRepositoryProvider),
  ),
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(false);

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = true;

    try {
      final response = await _repository.login(
        LoginRequest(
          email: email,
          password: password,
        ),
      );

      await SecureStorage.saveToken(response.accessToken);

      return true;
    } on DioException catch (e) {
      return false;
    } catch (e, stackTrace) {
      return false;
    } finally {
      state = false;
    }
  }
}