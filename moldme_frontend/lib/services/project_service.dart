import 'dart:convert';
import 'package:http/http.dart' as http;

class ProjectService {
  final String baseUrl = "http://localhost:5213/api/Project";
  static const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
      "AhLZw4rh0_qJ9WLBRx3CjGCe4ja5Thv8r4LfxknFVGc";

  /// Add a new project to a company
  Future<String> addProject(String companyId, Map<String, dynamic> projectDto) async {
  final url = Uri.parse('$baseUrl/addProject/$companyId');

  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", // Inclua seu token aqui
    },
    body: json.encode(projectDto), // Serializa o DTO como JSON
  );

  if (response.statusCode == 200) {
    return "Project added successfully";
  } else {
    final Map<String, dynamic> errorResponse = json.decode(response.body);
    throw Exception(errorResponse['message'] ?? "Failed to add project");
  }
}


  /// Update an existing project
  Future<String> editProject(String projectId, Map<String, dynamic> projectDto) async {
    final url = Uri.parse('$baseUrl/editProject/$projectId');
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(projectDto),
    );

    if (response.statusCode == 200) {
      return "Project updated successfully";
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to update project");
    }
  }

  /// View project details by ID
  Future<Map<String, dynamic>> viewProject(String projectId) async {
    final url = Uri.parse('$baseUrl/viewProject/$projectId');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to fetch project");
    }
  }

  /// Remove a project by ID
  Future<String> removeProject(String projectId) async {
    final url = Uri.parse('$baseUrl/RemoveProject/$projectId');
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return "Project removed successfully";
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to remove project");
    }
  }

  /// Assign an employee to a project
  Future<String> assignEmployee(String projectId, String employeeId) async {
    final url = Uri.parse('$baseUrl/$projectId/assignEmployee/$employeeId');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return "Employee assigned to project successfully";
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to assign employee");
    }
  }

  /// Remove an employee from a project
  Future<String> removeEmployee(String projectId, String employeeId) async {
    final url = Uri.parse('$baseUrl/$projectId/removeEmployee/$employeeId');
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return "Employee removed from project successfully";
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to remove employee");
    }
  }

  /// List all projects from a company
  Future<List<dynamic>> listAllProjectsFromCompany(String companyId) async {
    final url = Uri.parse('$baseUrl/$companyId/listAllProjects');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to fetch projects");
    }
  }

  /// Get project by ID from a company
  Future<Map<String, dynamic>> getProjectById(String companyId, String projectId) async {
    final url = Uri.parse('$baseUrl/$companyId/getProjectById/$projectId');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to fetch project details");
    }
  }
}
