import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskflow_app/features/tasks/presentation/widgets/empty_task_state.dart';

import '../../../../app/routes/app_routes.dart';
import '../../data/models/task_model.dart';
import '../controllers/task_controller.dart';
import '../widgets/task_error_state.dart';
import '../widgets/task_filter_chips.dart';
import '../widgets/task_header.dart';
import '../widgets/task_tile.dart';

class TaskListPage extends GetView<TaskController> {
  const TaskListPage({super.key});

  Future<void> _confirmDelete(TaskModel task) async {
    final shouldDelete = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Excluir tarefa'),
        content: Text(
          'Deseja excluir a tarefa "${task.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await controller.deleteTask(task);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.taskForm),
        icon: const Icon(Icons.add),
        label: const Text('Nova tarefa'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TaskHeader(controller: controller),
            TaskFilterChips(controller: controller),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final errorMessage = controller.errorMessage.value;

                if (errorMessage != null) {
                  return TaskErrorState(
                    message: errorMessage,
                    onRetry: controller.loadTasks,
                  );
                }

                if (controller.tasks.isEmpty) {
                  return const EmptyTasksState();
                }

                return RefreshIndicator(
                  onRefresh: controller.loadTasks,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    itemCount: controller.tasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final task = controller.tasks[index];
                      final isActionLoading =
                          controller.isActionLoading.value;

                      return TaskTile(
                        task: task,
                        isActionLoading: isActionLoading,
                        onToggleStatus: () =>
                            controller.toggleTaskStatus(task),
                        onDelete: () => _confirmDelete(task),
                        onEdit: () => Get.toNamed(
                          AppRoutes.taskForm,
                          arguments: task,
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}