import 'package:get/get.dart';
import 'package:taskflow_app/features/tasks/presentation/bindings/task_binding.dart';
import 'package:taskflow_app/features/tasks/presentation/pages/task_form_page.dart';

import '../../features/tasks/presentation/pages/task_list_page.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.tasks;

  static final routes = [
    GetPage(
      name: AppRoutes.tasks,
      page: () => const TaskListPage(),
      binding: TaskBinding(),
    ),
    GetPage(name: AppRoutes.taskForm, page: () => TaskFormPage()),
  ];
}
