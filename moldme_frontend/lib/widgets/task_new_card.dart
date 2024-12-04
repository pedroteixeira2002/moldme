import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../dtos/create_task_dto.dart';
import '../services/task_service.dart';

<<<<<<< Updated upstream:moldme_frontend/lib/widgets/task_new.dart
void main() {
  runApp(MaterialApp(
    home: CreateTaskScreen(),
  ));
=======
void main() => runApp(const MaterialApp(
        home: CreateTaskCard(
      projectId: '014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08',
      employeeId: '675943a6-6a50-40b9-a1c3-168b9dfc87a9',
    )));

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
>>>>>>> Stashed changes:moldme_frontend/lib/widgets/task_new_card.dart
}

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Uint8List? _fileBytes;
  String? _fileName;
  String? _mimeType;

  final _taskService = TaskService();

  // Replace these with actual values from your app
  final String projectId =  "356cc104-af87-40c5-8351-bfb7a0095be3";
  final String employeeId = "9d738649-8773-4bf2-b046-39ac3c6f3113";
  final String companyId =  "bf498b3e-74df-4a7c-ac5a-b9b00d097498";

  bool _isLoading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _fileBytes = result.files.single.bytes;
        _fileName = result.files.single.name;
        _mimeType = result.files.single.extension;
      });
    }
  }

  Future<void> _createTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Create the TaskDto object
      final taskDto = CreateTaskDto(
<<<<<<< Updated upstream:moldme_frontend/lib/widgets/task_new.dart
        titleName: _titleController.text,
        description: _descriptionController.text,
        date: DateTime.now(),
        status: 0,
        filePath: "D:\\OneDrive\\Imagens\\descarregar.png"
      );

      // Call TaskService to create the task
      final response = await _taskService.createTask(taskDto, projectId, employeeId);
=======
          titleName: _titleController.text,
          description: _descriptionController.text,
          date: DateTime.now(),
          status: 0,
          fileContent: _fileBytes,
          fileName: _fileName,
          mimeType: _mimeType);

      final response = await _taskService.createTask(
          taskDto, widget.projectId, widget.employeeId);
>>>>>>> Stashed changes:moldme_frontend/lib/widgets/task_new_card.dart
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 80, 125, 156),
      appBar: AppBar(
        title: const Text("Create New Task"),
        backgroundColor: const Color.fromARGB(255, 78, 104, 191),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  filled: true,
                  fillColor: Colors.white,
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

              // Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Description',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
<<<<<<< Updated upstream:moldme_frontend/lib/widgets/task_new.dart
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button color
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
=======
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _pickFile,
                    child:
                        Text(_fileName == null ? 'Upload File' : 'Change File'),
                  ),
                  if (_fileName != null) Text('Selected file: $_fileName'),
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
>>>>>>> Stashed changes:moldme_frontend/lib/widgets/task_new_card.dart
                        ),
                ),
              ),
            ],
          ),
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
