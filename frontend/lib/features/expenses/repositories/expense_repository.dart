import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../models/expense.dart';
import '../models/expense_create_request.dart';

final expenseRepositoryProvider =
    Provider<ExpenseRepository>(
  (ref) => ExpenseRepository(),
);

final groupExpensesProvider =
    FutureProvider.family<List<Expense>, String>(
  (ref, groupId) async {
    return ref
        .read(expenseRepositoryProvider)
        .getGroupExpenses(groupId);
  },
);

final expenseProvider =
    FutureProvider.family<Expense, String>(
  (ref, expenseId) async {
    return ref
        .read(expenseRepositoryProvider)
        .getExpense(expenseId);
  },
);

class ExpenseRepository {
  Future<List<Expense>> getGroupExpenses(
    String groupId,
  ) async {
    final response = await DioClient.dio.get(
      "${ApiConstants.expenses}/group/$groupId",
    );

    return (response.data as List)
        .map((e) => Expense.fromJson(e))
        .toList();
  }

  Future<void> createExpense(
    ExpenseCreateRequest request,
  ) async {
    await DioClient.dio.post(
      "/expenses",
      data: request.toJson(),
    );
  }

  Future<Expense> getExpense(
    String expenseId,
  ) async {
    final response = await DioClient.dio.get(
      "${ApiConstants.expenses}/$expenseId",
    );

    return Expense.fromJson(response.data);
  }

  Future<void> deleteExpense(
    String expenseId,
  ) async {
    await DioClient.dio.delete(
      "${ApiConstants.expenses}/$expenseId",
    );
  }
}