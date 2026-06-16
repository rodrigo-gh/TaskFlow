import 'package:dio/dio.dart';

import '../../../../app/core/errors/api_exception.dart';
import '../../../../app/core/http/dio_client.dart';
import '../models/task_model.dart';
import '../models/task_status_filter.dart';

class TaskRepository {
  TaskRepository(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  Future<List<TaskModel>> getTasks({
    TaskStatusFilter status = TaskStatusFilter.all,
  }) async {
    try {
      final response = await _dio.get(
        '/api/tasks',
        queryParameters: {
          'status': status.apiValue,
        },
      );

      final data = response.data as List;

      return data
          .map((item) => TaskModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      throw ApiException(_getErrorMessage(error));
    }
  }

  Future<TaskModel> createTask({
    required String title,
    String? description,
  }) async {
    try {
      final response = await _dio.post(
        '/api/tasks',
        data: {
          'title': title,
          'description': description,
        },
      );

      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw ApiException(_getErrorMessage(error));
    }
  }

  Future<TaskModel> updateTask({
    required String id,
    required String title,
    String? description,
    required bool isCompleted,
  }) async {
    try {
      final response = await _dio.put(
        '/api/tasks/$id',
        data: {
          'title': title,
          'description': description,
          'isCompleted': isCompleted,
        },
      );

      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw ApiException(_getErrorMessage(error));
    }
  }

  Future<TaskModel> completeTask(String id) async {
    try {
      final response = await _dio.patch('/api/tasks/$id/complete');

      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw ApiException(_getErrorMessage(error));
    }
  }

  Future<TaskModel> reopenTask(String id) async {
    try {
      final response = await _dio.patch('/api/tasks/$id/reopen');

      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw ApiException(_getErrorMessage(error));
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _dio.delete('/api/tasks/$id');
    } on DioException catch (error) {
      throw ApiException(_getErrorMessage(error));
    }
  }

  String _getErrorMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];

      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'Tempo de conexão esgotado.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'Não foi possível conectar ao servidor.';
    }

    return 'Ocorreu um erro inesperado.';
  }
}