import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/task_status_filter.dart';
import '../controllers/task_controller.dart';

class TaskFilterChips extends StatelessWidget {
  const TaskFilterChips({
    required this.controller,
    super.key,
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