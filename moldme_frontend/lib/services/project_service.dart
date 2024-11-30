import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dtos/project_dto.dart';

class ProjectService {
  final String baseUrl = "http://localhost:5213/api/Project";
  static const String token ="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJ0aWFnb0BnbWFpbC5jb20iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJDb21wYW55IiwiZXhwIjoxNzM0NzA1MzY5LCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMifQ.R0Yh4yC-wKwmod93DuLfIq4dos5hc6IbJZqJVFp1hxg";

  /// Adds a new project for a specific company.
  Future<String> addProject(String companyId, ProjectDto projectDto) async {
    final url = Uri.parse('$baseUrl/api/Project/addProject/$companyId');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(projectDto.toJson()),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Success message
    } else {
      throw Exception(
          json.decode(response.body)['error'] ?? "Failed to add project");
    }
  }

  /// Updates an existing project.
  Future<String> updateProject(String projectId, ProjectDto projectDto) async {
    final url = Uri.parse('$baseUrl/api/Project/editProject/$projectId');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(projectDto.toJson()),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Success message
    } else {
      throw Exception(
          json.decode(response.body)['error'] ?? "Failed to update project");
    }
  }

  /// Fetches a specific project by ID.
  Future<ProjectDto> getProjectById(String companyId, String projectId) async {
    final url = Uri.parse(
        '$baseUrl/api/Project/$companyId/getProjectById/$projectId');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProjectDto.fromJson(data);
    } else {
      throw Exception(
          json.decode(response.body)['error'] ?? "Failed to fetch project");
    }
  }

  /// Removes a project by ID.
  Future<String> removeProject(String projectId) async {
    final url = Uri.parse('$baseUrl/api/Project/RemoveProject/$projectId');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Success message
    } else {
      throw Exception(
          json.decode(response.body)['error'] ?? "Failed to remove project");
    }
  }

  /// Assigns an employee to a project.
  Future<String> assignEmployee(String projectId, String employeeId) async {
    final url =
        Uri.parse('$baseUrl/api/Project/$projectId/assignEmployee/$employeeId');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Success message
    } else {
      throw Exception(json.decode(response.body)['error'] ??
          "Failed to assign employee to project");
    }
  }

  /// Removes an employee from a project.
  Future<String> removeEmployee(String projectId, String employeeId) async {
    final url = Uri.parse(
        '$baseUrl/api/Project/$projectId/removeEmployee/$employeeId');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Success message
    } else {
      throw Exception(json.decode(response.body)['error'] ??
          "Failed to remove employee from project");
    }
  }

  /// Lists all projects associated with a company.
  Future<List<ProjectDto>> listAllProjectsFromCompany(String companyId) async {
    final url = Uri.parse('$baseUrl/api/Project/$companyId/listAllProjects');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return data.map((e) => ProjectDto.fromJson(e)).toList();
    } else {
      throw Exception(json.decode(response.body)['error'] ??
          "Failed to fetch projects for company");
    }
  }

  /// Lists all new projects.
  Future<List<ProjectDto>> listAllNewProjects() async {
    final url = Uri.parse('$baseUrl/api/Project/listAllNewProjects');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return data.map((e) => ProjectDto.fromJson(e)).toList();
    } else {
      throw Exception(
          json.decode(response.body)['error'] ?? "Failed to fetch new projects");
    }
  }
}
