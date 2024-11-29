import 'dart:convert';
import 'package:front_end_moldme/models/project_dto.dart';
import 'package:http/http.dart' as http;

class ProjectService {
  final String baseUrl = "http://localhost:5213/api/Project";


  // Create a new project
  Future<void> createProject(String companyId, ProjectDto project) async {
    final url = Uri.parse('$baseUrl/addProject/$companyId');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(project.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create project: ${response.body}');
    }
  }

  // Update an existing project
  Future<void> updateProject(String projectId, ProjectDto updatedProject) async {
    final url = Uri.parse('$baseUrl/editProject/$projectId');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedProject.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update project: ${response.body}');
    }
  }

  // View a single project
  Future<ProjectDto> viewProject(String projectId) async {
    final url = Uri.parse('$baseUrl/viewProject/$projectId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProjectDto.fromJson(data);
    } else {
      throw Exception('Failed to fetch project: ${response.body}');
    }
  }

  // Delete a project
  Future<void> deleteProject(String projectId) async {
    final url = Uri.parse('$baseUrl/RemoveProject/$projectId');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete project: ${response.body}');
    }
  }

  // Assign an employee to a project
  Future<void> assignEmployee(String projectId, String employeeId) async {
    final url = Uri.parse('$baseUrl/$projectId/assignEmployee/$employeeId');
    final response = await http.post(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to assign employee: ${response.body}');
    }
  }

  // Remove an employee from a project
  Future<void> removeEmployee(String projectId, String employeeId) async {
    final url = Uri.parse('$baseUrl/$projectId/removeEmployee/$employeeId');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to remove employee: ${response.body}');
    }
  }

  // List all projects for a specific company
  Future<List<ProjectDto>> listAllProjects(String companyId) async {
    final url = Uri.parse('$baseUrl/$companyId/listAllProjects');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => ProjectDto.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch projects: ${response.body}');
    }
  }

  // List all projects with Status.NEW
  Future<List<ProjectDto>> listAllNewProjects(String companyId) async {
    final url = Uri.parse('$baseUrl/listAllNewProjects');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => ProjectDto.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch new projects: ${response.body}');
    }
  }
}
