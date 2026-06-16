import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/core/constants/app_colors.dart';
import '../controllers/task_controller.dart';

class EmptyTasksState extends StatelessWidget {
  const EmptyTasksState({super.key});

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