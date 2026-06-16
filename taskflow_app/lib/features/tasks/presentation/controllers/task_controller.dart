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

      final result = await _repository.getTasks(
        status: selectedFilter.value,
      );

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
      Get.snackbar(
        'Erro',
        error.message,
        snackPosition: SnackPosition.BOTTOM,
      );
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
      Get.snackbar(
        'Erro',
        error.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (_) {
      Get.snackbar(
        'Erro',
        'Erro inesperado ao remover tarefa.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}