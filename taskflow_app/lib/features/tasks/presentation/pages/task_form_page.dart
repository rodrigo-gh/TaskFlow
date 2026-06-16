import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/task_model.dart';
import '../controllers/task_controller.dart';

class TaskFormPage extends StatefulWidget {
  const TaskFormPage({super.key});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _taskController = Get.find<TaskController>();

  late final TaskModel? _task;

  bool get _isEditing => _task != null;

  @override
  void initState() {
    super.initState();

    final arguments = Get.arguments;

    if (arguments is TaskModel) {
      _task = arguments;
      _titleController.text = _task!.title;
      _descriptionController.text = _task.description ?? '';
    } else {
      _task = null;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final bool saved;

    if (_isEditing) {
      saved = await _taskController.updateTask(
        task: _task!,
        title: _titleController.text,
        description: _descriptionController.text,
      );
    } else {
      saved = await _taskController.createTask(
        title: _titleController.text,
        description: _descriptionController.text,
      );
    }

    if (!mounted) {
      return;
    }

    if (saved) {
      Get.back();

      Get.snackbar(
        'Sucesso',
        _isEditing
            ? 'Tarefa atualizada com sucesso.'
            : 'Tarefa criada com sucesso.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Editar tarefa' : 'Nova tarefa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final title = value?.trim() ?? '';

                  if (title.isEmpty) {
                    return 'Informe o título da tarefa.';
                  }

                  if (title.length < 3) {
                    return 'O título deve ter pelo menos 3 caracteres.';
                  }

                  if (title.length > 100) {
                    return 'O título deve ter no máximo 100 caracteres.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  final description = value?.trim() ?? '';

                  if (description.length > 500) {
                    return 'A descrição deve ter no máximo 500 caracteres.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  final isSaving = _taskController.isActionLoading.value;

                  return FilledButton(
                    onPressed: isSaving ? null : _saveTask,
                    child: isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_isEditing ? 'Salvar alterações' : 'Salvar'),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
