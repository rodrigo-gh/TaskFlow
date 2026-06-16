import 'package:get/get.dart';

import '../../../../app/core/errors/api_exception.dart';
import '../../data/models/task_model.dart';
import '../../data/models/task_status_filter.dart';
import '../../data/repositories/task_repository.dart';

class TaskController extends GetxController {
  TaskController(this._repository);

  final TaskRepository _repository;

  final RxList<TaskModel> tasks = <TaskModel>[].obs;

  final RxBool isLoading = false.obs;

  final RxnString errorMessage = RxnString();

  final Rx<TaskStatusFilter> selectedFilter = TaskStatusFilter.all.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final result = await _repository.getTasks(status: selectedFilter.value);

      tasks.assignAll(result);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = 'Erro inesperado ao carregar tarefas.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeFilter(TaskStatusFilter filter) async {
    selectedFilter.value = filter;
    await loadTasks();
  }

  Future<void> toggleTaskStatus(TaskModel task) async {
    try {
      errorMessage.value = null;

      if (task.isCompleted) {
        await _repository.reopenTask(task.id);
      } else {
        await _repository.completeTask(task.id);
      }

      await loadTasks();
    } on ApiException catch (error) {
      Get.snackbar('Erro', error.message, snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar(
        'Erro',
        'Erro inesperado ao atualizar tarefa.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteTask(TaskModel task) async {
    try {
      await _repository.deleteTask(task.id);

      tasks.removeWhere((item) => item.id == task.id);

      Get.snackbar(
        'Sucesso',
        'Tarefa removida com sucesso.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on ApiException catch (error) {
      Get.snackbar('Erro', error.message, snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar(
        'Erro',
        'Erro inesperado ao remover tarefa.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<bool> createTask({required String title, String? description}) async {
    try {
      final trimmedDescription = description?.trim();

      final task = await _repository.createTask(
        title: title.trim(),
        description: trimmedDescription == null || trimmedDescription.isEmpty
            ? null
            : trimmedDescription,
      );

      tasks.insert(0, task);

      return true;
    } on ApiException catch (error) {
      Get.snackbar('Erro', error.message, snackPosition: SnackPosition.BOTTOM);

      return false;
    } catch (_) {
      Get.snackbar(
        'Erro',
        'Erro inesperado ao criar tarefa.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    }
  }

  Future<bool> updateTask({
    required TaskModel task,
    required String title,
    String? description,
  }) async {
    try {
      final trimmedDescription = description?.trim();

      final updatedTask = await _repository.updateTask(
        id: task.id,
        title: title.trim(),
        description: trimmedDescription == null || trimmedDescription.isEmpty
            ? null
            : trimmedDescription,
        isCompleted: task.isCompleted,
      );

      final index = tasks.indexWhere((item) => item.id == updatedTask.id);

      if (index != -1) {
        tasks[index] = updatedTask;
      }

      return true;
    } on ApiException catch (error) {
      Get.snackbar('Erro', error.message, snackPosition: SnackPosition.BOTTOM);

      return false;
    } catch (_) {
      Get.snackbar(
        'Erro',
        'Erro inesperado ao atualizar tarefa.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    }
  }
}
