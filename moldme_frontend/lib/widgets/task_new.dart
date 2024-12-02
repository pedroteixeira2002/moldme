import 'package:flutter/material.dart';
import '../dtos/create_task_dto.dart';
import '../services/task_service.dart';

class CreateTaskCard extends StatefulWidget {
  final String projectId;
  final String employeeId;

  const CreateTaskCard({
    super.key,
    required this.projectId,
    required this.employeeId,
  });

  @override
  _CreateTaskCardState createState() => _CreateTaskCardState();
}

class _CreateTaskCardState extends State<CreateTaskCard> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _taskService = TaskService();
  bool _isLoading = false;

  Future<void> _createTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final taskDto = CreateTaskDto(
        titleName: _titleController.text,
        description: _descriptionController.text,
        date: DateTime.now(),
        status: 0,
        filePath: "", // Caso seja necessário, ajuste a lógica para arquivos.
      );

      final response =
          await _taskService.createTask(taskDto, widget.projectId, widget.employeeId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create task: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create a Task",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campo do título
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Task Title',
                      hintText: 'Enter task title...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a task title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Campo da descrição
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Provide task details...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Botão de envio
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Cor do botão
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Create Task',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
