import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskflow_app/app/routes/app_routes.dart';

import '../../data/models/task_model.dart';
import '../../data/models/task_status_filter.dart';
import '../controllers/task_controller.dart';

class TaskListPage extends GetView<TaskController> {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        actions: [
          IconButton(
            onPressed: controller.loadTasks,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.taskForm),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _TaskFilterChips(controller: controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final errorMessage = controller.errorMessage.value;

              if (errorMessage != null) {
                return _ErrorState(
                  message: errorMessage,
                  onRetry: controller.loadTasks,
                );
              }

              if (controller.tasks.isEmpty) {
                return const _EmptyState();
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.tasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final task = controller.tasks[index];

                  return _TaskTile(
                    task: task,
                    onToggleStatus: () => controller.toggleTaskStatus(task),
                    onDelete: () => controller.deleteTask(task),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _TaskFilterChips extends StatelessWidget {
  const _TaskFilterChips({required this.controller});

  final TaskController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: TaskStatusFilter.values.map((filter) {
            final isSelected = controller.selectedFilter.value == filter;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(filter.label),
                selected: isSelected,
                onSelected: (_) => controller.changeFilter(filter),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.onToggleStatus,
    required this.onDelete,
  });

  final TaskModel task;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => onToggleStatus(),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: task.description == null || task.description!.isEmpty
            ? null
            : Text(task.description!),
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Nenhuma tarefa encontrada.'));
  }
}
