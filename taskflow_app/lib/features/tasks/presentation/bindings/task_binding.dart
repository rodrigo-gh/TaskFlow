import 'package:get/get.dart';

import '../../data/repositories/task_repository.dart';
import '../controllers/task_controller.dart';

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskController>(
      () => TaskController(Get.find<TaskRepository>()),
    );
  }
}