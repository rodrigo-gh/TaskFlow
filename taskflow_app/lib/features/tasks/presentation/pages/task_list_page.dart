import 'package:flutter/material.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('TaskFlow')),
        body: const Center(child: Text('Task list will be here')),
      ),
    );
  }
}
