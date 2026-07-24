import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/expense_create_request.dart';
import '../repositories/expense_repository.dart';

final expenseControllerProvider =
    StateNotifierProvider<ExpenseController, bool>(
  (ref) => ExpenseController(
    ref.read(expenseRepositoryProvider),
  ),
);

class ExpenseController extends StateNotifier<bool> {
  final ExpenseRepository _repository;

  ExpenseController(this._repository) : super(false);

  Future<bool> createExpense(
    ExpenseCreateRequest request,
  ) async {
    state = true;

    try {
      await _repository.createExpense(request);
      return true;
    } catch (_) {
      return false;
    } finally {
      state = false;
    }
  }

  Future<bool> deleteExpense(
    String expenseId,
  ) async {
    state = true;

    try {
      await _repository.deleteExpense(expenseId);
      return true;
    } catch (_) {
      return false;
    } finally {
      state = false;
    }
  }
}