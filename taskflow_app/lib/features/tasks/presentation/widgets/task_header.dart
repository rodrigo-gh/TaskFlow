import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/core/constants/app_colors.dart';
import '../controllers/task_controller.dart';

class TaskHeader extends StatelessWidget {
  const TaskHeader({
    required this.controller,
    super.key,
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