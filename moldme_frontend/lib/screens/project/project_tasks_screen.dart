import 'package:flutter/material.dart';
import '../../dtos/task_dto.dart';
import '../../services/task_service.dart';
import '../../widgets/task_card.dart';

void main() {
  runApp(const MaterialApp(
    home: ProjectTasksScreen(
        projectId: "014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08",
        currentUserId: "675943a6-6a50-40b9-a1c3-168b9dfc87a9"),
  ));
}

class ProjectTasksScreen extends StatefulWidget {
  final String projectId;
  final String currentUserId;

  const ProjectTasksScreen({
    super.key,
    required this.projectId,
    required this.currentUserId,
  });

  @override
  _ProjectTasksScreenState createState() => _ProjectTasksScreenState();
}

class _ProjectTasksScreenState extends State<ProjectTasksScreen> {
  final TaskService _taskService = TaskService();
  List<TaskDto> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    setState(() => _isLoading = true);
    try {
      final tasks = await _taskService.getTasksByProjectId(widget.projectId);
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tasks: $e')),
      );
    }
  }

  Future<void> _deleteTask(TaskDto task) async {
    try {
      await _taskService.deleteTask(task.taskId);
      setState(() {
        _tasks.remove(task);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task: $e')),
      );
    }
  }

  Future<void> _updateTask(TaskDto task) async {
    try {
      await _taskService.updateTask(task);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: $e')),
      );
    }
  }

  void _editTask(TaskDto task) {
    // Handle edit task
  }

  void _removeTask(TaskDto task) {
    _deleteTask(task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Tasks')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return TaskCard(
                  task: task,
                  onEdit: () => _editTask(task),
                  onRemove: () => _removeTask(task),
                  currentUserId: widget.currentUserId,
                );
              },
            ),
    );
  }
}
