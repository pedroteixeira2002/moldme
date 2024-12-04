import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import '../dtos/task_dto.dart';
import '../services/task_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TaskDto task =
      await TaskService().getTaskById("b3461c4e-c756-4996-a65c-80e680649c24");
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: TaskCard(
        onEdit: () {
        },
        onRemove: () {
        },
        task: task,
        currentUserId: "1",
      ),
    ),
  ));
}

class TaskCard extends StatelessWidget {
  final TaskDto task;
  final String currentUserId;
  final VoidCallback onEdit; // Callback for edit action
  final VoidCallback onRemove; // Callback for remove action

  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.currentUserId,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Title and Edit/Remove Buttons
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.titleName,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                // Edit Icon
                if (task.employeeId == currentUserId)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    tooltip: 'Edit Task',
                    onPressed: onEdit,
                  ),
                // Remove Icon
                if (task.employeeId == currentUserId)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Remove Task',
                    onPressed: onRemove,
                  ),
              ],
            ),
            const SizedBox(height: 8.0),

            // Description
            Text(
              task.description,
              style: const TextStyle(fontSize: 14.0, color: Colors.black54),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16.0),

            // Footer Row
            Row(
              children: [
                // Date
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 16.0, color: Colors.grey),
                    const SizedBox(width: 4.0),
                    Text(
                      task.date,
                      style: const TextStyle(
                          fontSize: 12.0, color: Colors.black54),
                    ),
                  ],
                ),
                // Attachments Count
                Row(
                  children: [
                    const Icon(Icons.attach_file,
                        size: 16.0, color: Colors.grey),
                    const SizedBox(width: 4.0),
                    Text(
                      task.fileContent != null
                          ? "1"
                          : "0", // Indicate if file exists
                      style: const TextStyle(
                          fontSize: 12.0, color: Colors.black54),
                    ),
                    // File Download
                    if (task.fileName != null &&
                        task.fileName!.isNotEmpty) // Show if file exists
                      TextButton.icon(
                        icon: const Icon(Icons.download, size: 16.0),
                        label: const Text("Download File"),
                        onPressed: () => _downloadFileHandler(context, task),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _downloadFileHandler(BuildContext context, TaskDto task) async {
  try {
    // Call the downloadFile service method
    final taskService = TaskService();
    final fileBytes = await taskService.downloadFile(task.taskId);

    // Create a Blob from the file bytes
    final blob = html.Blob([fileBytes]);

    // Create an anchor element and trigger a download
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", task.fileName!)
      ..click();
    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File downloaded: ${task.fileName}')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to download file: $e')),
    );
  }
}
