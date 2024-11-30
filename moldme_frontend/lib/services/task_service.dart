import 'dart:io';
import 'package:front_end_moldme/dtos/task_dto.dart';
import 'package:dio/dio.dart';

class TaskService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://your-backend-url.com/api/task"));

  Future<String> createTask(TaskDto taskDto, String projectId, String employeeId) async {
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
      return (response.data as List).map((json) => TaskDto.fromJson(json)).toList();
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
