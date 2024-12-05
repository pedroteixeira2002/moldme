import 'dart:convert';
import 'package:front_end_moldme/dtos/employee_dto.dart';
import 'package:http/http.dart' as http;
import '../dtos/project_dto.dart';

class ProjectService {
  final String baseUrl = "http://localhost:5213";
  static const String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJ0aWFnb0BnbWFpbC5jb20iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJDb21wYW55IiwiZXhwIjoxNzM0NzM0OTUxLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMifQ.B4clMA8cuR4cH6YPs9WbYSbr6PQeb3TE8IaeH7_ixFA";

  /// Adds a new project for a specific company.
  Future<String> addProject(String companyId, ProjectDto projectDto) async {
    final url = Uri.parse('$baseUrl/api/Project/addProject/$companyId');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: json.encode(projectDto.toJson()),
    );

    if (response.statusCode == 200) {
      // Verifique se o corpo é JSON ou texto
      try {
        final data = json.decode(response.body); // Tenta processar como JSON
        return data['Message'] ?? 'Project added successfully';
      } catch (e) {
        // Se falhar, retorne o texto diretamente
        return response.body; // Texto como "Project added successfully"
      }
    } else {
      // Caso de erro
      try {
        final error = json.decode(response.body)['error'];
        throw Exception(error ?? "Failed to add project");
      } catch (_) {
        throw Exception("Failed to add project");
      }
    }
  }

  /// Updates an existing project.
  Future<String> updateProject(String projectId, ProjectDto projectDto) async {
    final url = Uri.parse('$baseUrl/api/Project/editProject/$projectId');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: json.encode(projectDto.toJson()),
    );

    if (response.statusCode == 200) {
      // Verifica se o corpo da resposta é JSON ou texto
      try {
        final data = json.decode(response.body); // Tenta decodificar como JSON
        return data['Message'] ?? 'Project updated successfully';
      } catch (e) {
        // Se falhar, assume que a resposta é uma string simples
        return response.body; // Retorna a mensagem como está
      }
    } else {
      // Trata erros
      try {
        final error = json.decode(response.body)['error'];
        throw Exception(error ?? "Failed to update project");
      } catch (_) {
        throw Exception("Failed to update project");
      }
    }
  }

  /// Fetches a specific project by ID.
  Future<ProjectDto> getProjectById(String companyId, String projectId) async {
    final url =
        Uri.parse('$baseUrl/api/Project/$companyId/getProjectById/$projectId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProjectDto.fromJson(data);
    } else {
      throw Exception(
          json.decode(response.body)['error'] ?? "Failed to fetch project");
    }
  }

  Future<ProjectDto> projectView(String companyId, String projectId) async {
    final url = Uri.parse('$baseUrl/api/Project/viewProject/$projectId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
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
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Success message
    } else {
      throw Exception(
          json.decode(response.body)['error'] ?? "Failed to remove project");
    }
  }

  /// Assigns an employee to a project.
  Future<void> assignEmployee(String projectId, String employeeId) async {
    final url =
        Uri.parse('$baseUrl/api/Project/$projectId/assignEmployee/$employeeId');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      // Atribuição bem-sucedida; não retorna nada
      return;
    } else {
      // Levanta uma exceção com a mensagem de erro apropriada
      final errorMessage = json.decode(response.body)['error'] ??
          "Failed to assign employee to project";
      throw Exception(errorMessage);
    }
  }

  /// Removes an employee from a project.
  Future<String> removeEmployee(String projectId, String employeeId) async {
    final url =
        Uri.parse('$baseUrl/api/Project/$projectId/removeEmployee/$employeeId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJsZW9uZWxAZ21haWwuY29tIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiQ29tcGFueSIsImV4cCI6MTczNTEzOTEwNiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo1MjEzIiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDo1MjEzIn0.qzU2McQ9tpCCXKEHsoxyIGpni7fK1dwjsp3AmJnz7XA",
      },
    );

    if (response.statusCode == 200) {
      try {
        // Tenta processar a resposta como JSON
        final data = json.decode(response.body);
        return data['message'] ?? "Employee removed successfully";
      } catch (_) {
        // Se falhar, trata como texto simples
        return response.body; // Texto simples da resposta
      }
    } else {
      try {
        final error = json.decode(response.body)['error'];
        throw Exception(error ?? "Failed to remove employee");
      } catch (_) {
        throw Exception("Failed to remove employee");
      }
    }
  }

  /// Lists all projects associated with a company.
  Future<List<ProjectDto>> listAllProjectsFromCompany(String companyId) async {
    final url = Uri.parse('$baseUrl/api/Project/$companyId/listAllProjects');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
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
    const String token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJsZW9uZWxAZ21haWwuY29tIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiQ29tcGFueSIsImV4cCI6MTczNTEzOTEwNiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo1MjEzIiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDo1MjEzIn0.qzU2McQ9tpCCXKEHsoxyIGpni7fK1dwjsp3AmJnz7XA";

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        throw Exception("Resposta da API está vazia");
      }

      final List<dynamic> data = json.decode(response.body);

      // Mapeia diretamente a lista JSON para uma lista de ProjectDto
      return data.map((e) => ProjectDto.fromJson(e)).toList();
    } else {
      // Trata erros retornados pela API
      try {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? "Erro desconhecido na API");
      } catch (_) {
        throw Exception(
            "Falha ao buscar novos projetos: ${response.statusCode}");
      }
    }
  }

  /// Fetches all employees assigned to a specific project.
  Future<List<EmployeeDto>> getEmployeesByProject(String projectId) async {
    final url = Uri.parse('$baseUrl/api/Project/$projectId/employees');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return data.map((e) => EmployeeDto.fromJson(e)).toList();
    } else {
      throw Exception(json.decode(response.body)['error'] ??
          "Failed to fetch employees for project");
    }
  }

}
