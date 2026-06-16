import 'package:get/get.dart';
import 'package:taskflow_app/app/core/http/dio_client.dart';
import 'package:taskflow_app/features/tasks/data/repositories/task_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DioClient>(() => DioClient(), fenix: true);

    Get.lazyPut<TaskRepository>(
      () => TaskRepository(Get.find<DioClient>()),
      fenix: true,
    );
  }
}
