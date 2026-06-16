import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskflow_app/app/bindings/initial_binding.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TaskFlow',
      // debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
