import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/core/constants/app_colors.dart';
import '../../../../app/routes/app_routes.dart';
import '../../data/models/task_model.dart';
import '../../data/models/task_status_filter.dart';
import '../controllers/task_controller.dart';

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
            _Header(controller: controller),
            _TaskFilterChips(controller: controller),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
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

                      return _TaskTile(
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

class _Header extends StatelessWidget {
  const _Header({
    required this.controller,
  });

  final TaskController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Obx(() {
              final total = controller.tasks.length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TaskFlow',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    total == 1
                        ? '1 tarefa encontrada'
                        : '$total tarefas encontradas',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              );
            }),
          ),
          IconButton.filledTonal(
            onPressed: controller.loadTasks,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}

class _TaskFilterChips extends StatelessWidget {
  const _TaskFilterChips({
    required this.controller,
  });

  final TaskController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: TaskStatusFilter.values.map((filter) {
            final isSelected = controller.selectedFilter.value == filter;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(filter.label),
                selected: isSelected,
                showCheckmark: false,
                avatar: Icon(
                  _getFilterIcon(filter),
                  size: 18,
                ),
                onSelected: (_) => controller.changeFilter(filter),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getFilterIcon(TaskStatusFilter filter) {
    switch (filter) {
      case TaskStatusFilter.all:
        return Icons.list_alt;
      case TaskStatusFilter.pending:
        return Icons.radio_button_unchecked;
      case TaskStatusFilter.completed:
        return Icons.check_circle_outline;
    }
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.isActionLoading,
    required this.onToggleStatus,
    required this.onDelete,
    required this.onEdit,
  });

  final TaskModel task;
  final bool isActionLoading;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final statusColor =
        task.isCompleted ? AppColors.success : AppColors.warning;

    final statusText = task.isCompleted ? 'Concluída' : 'Pendente';

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: isActionLoading ? null : onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: isActionLoading ? null : (_) => onToggleStatus(),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      if (task.description != null &&
                          task.description!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          task.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      _StatusBadge(
                        label: statusText,
                        color: statusColor,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              isActionLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          onEdit();
                        }

                        if (value == 'delete') {
                          onDelete();
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined),
                              SizedBox(width: 8),
                              Text('Editar'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline),
                              SizedBox(width: 8),
                              Text('Excluir'),
                            ],
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Não foi possível carregar as tarefas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: Get.find<TaskController>().loadTasks,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: const [
          SizedBox(height: 96),
          Icon(
            Icons.task_alt,
            size: 72,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 16),
          Text(
            'Nenhuma tarefa por aqui',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Crie uma nova tarefa para começar a organizar seu fluxo.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}