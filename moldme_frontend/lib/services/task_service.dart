import 'dart:io';
import 'package:front_end_moldme/dtos/create_task_dto.dart';
import 'package:front_end_moldme/dtos/task_dto.dart';
import 'package:dio/dio.dart';

class TaskService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://localhost:5213/api/Task"));

  Future<String> createTask(CreateTaskDto taskDto, String projectId, String employeeId) async {
    try {
      
      final response = await _dio.post(
        '/createTask',
        queryParameters: {'projectId': projectId, 'employeeId': employeeId},
        data: taskDto.toJson(),
      );
      return response.data; // "Task created successfully"
    } catch (e) {
      throw Exception("Failed to create task: $e");
    }
  }

Future<List<TaskDto>> getTasksByProjectId(String projectId) async {
  try {
    final response = await _dio.get('/project/$projectId/tasks');

    // Check if the response data contains the $values key
    if (response.data is Map<String, dynamic>) {
      final tasksData = response.data['\$values']; // Corrected: Use the correct string key '$values'
      if (tasksData is List) {
        // Map each item to a TaskDto and filter out nulls
        return tasksData
            .map((json) {
              if (json is Map<String, dynamic>) {
                return TaskDto.fromJson(json); // Convert to TaskDto if it's a valid map
              } else {
                return null; // Return null if the item is a reference or invalid
              }
            })
            .whereType<TaskDto>() // Remove null values
            .toList(); // Convert to List<TaskDto>
      } else {
        throw Exception("Expected a list of tasks, but got: ${tasksData.runtimeType}");
      }
    } else {
      throw Exception("Unexpected response format: ${response.data.runtimeType}");
    }
  } catch (e) {
    throw Exception("Failed to fetch tasks: $e");
  }
}






  Future<TaskDto> getTaskById(String taskId) async {
    try {
      final response = await _dio.get('/task/$taskId');
      return TaskDto.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to fetch task: $e");
    }
  }

  Future<String> updateTask(String taskId, TaskDto taskDto) async {
    try {
      final response = await _dio.put(
        '/updateTask/$taskId',
        data: taskDto.toJson(),
      );
      return response.data; // "Task updated successfully"
    } catch (e) {
      throw Exception("Failed to update task: $e");
    }
  }

  Future<String> deleteTask(String taskId) async {
    try {
      final response = await _dio.delete('/delete/$taskId');
      return response.data; // "Task deleted successfully"
    } catch (e) {
      throw Exception("Failed to delete task: $e");
    }
  }

  Future<void> downloadFile(String taskId, String savePath) async {
    try {
      final response = await _dio.get(
        '/task/$taskId/file',
        options: Options(responseType: ResponseType.bytes),
      );
      final file = File(savePath);
      await file.writeAsBytes(response.data);
    } catch (e) {
      throw Exception("Failed to download file: $e");
    }
  }
}
