import 'package:get/get.dart';

import '../../features/tasks/presentation/pages/task_list_page.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.tasks;

  static final routes = [
    GetPage(
      name: AppRoutes.tasks,
      page: () => const TaskListPage(),
    ),
  ];
}