import 'package:flutter/material.dart';

import '../../../../app/core/constants/app_colors.dart';
import '../../data/models/task_model.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.task,
    required this.isActionLoading,
    required this.onToggleStatus,
    required this.onDelete,
    required this.onEdit,
    super.key,
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