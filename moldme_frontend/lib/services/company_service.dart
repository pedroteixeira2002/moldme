import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project_dto.dart';

class CompanyService {
  final String baseUrl = "http://localhost:5213/api/Company";
  
  Future<String> addProject(ProjectDto project, String companyId) async {
    const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJhdWRpQGdtYWlsLnB0IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiQ29tcGFueSIsImV4cCI6MTczMzkzMzk0MCwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo1MjEzIiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDo1MjEzIn0.AhLZw4rh0_qJ9WLBRx3CjGCe4ja5Thv8r4LfxknFVGc";
    final url = Uri.parse('$baseUrl/addProject/$companyId');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json",
      "Authorization": "Bearer $token"},
      
      body: json.encode(project.toJson()),
    );

    if (response.statusCode == 200) {
      return "Project added successfully";
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to add project");
    }
  }

  Future<String> editProject(String projectId, ProjectDto updatedProject) async {
    final url = Uri.parse('$baseUrl/EditProject/$projectId');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(updatedProject.toJson()),
    );

    if (response.statusCode == 200) {
      return "Project updated successfully";
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to update project");
    }
  }

  Future<ProjectDto> viewProject(String projectId) async {
    final url = Uri.parse('$baseUrl/ViewProject/$projectId');
    final response = await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ProjectDto.fromJson(data);
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to fetch project");
    }
  }

  Future<String> removeProject(String projectId) async {
    final url = Uri.parse('$baseUrl/RemoveProject/$projectId');
    final response = await http.delete(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return "Project removed successfully";
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to remove project");
    }
  }
}
