import 'dart:convert';
import 'package:front_end_moldme/dtos/chat_dto.dart';
import 'package:front_end_moldme/dtos/employee_dto.dart';
import 'package:front_end_moldme/services/authentication_service.dart';
import 'package:http/http.dart' as http;
import '../dtos/project_dto.dart';

class ProjectService {
  final String baseUrl = "https://moldme-ghh9b5b9c6azgfb8.canadacentral-01.azurewebsites.net";
  final AuthenticationService _authenticationService = AuthenticationService();
  final http.Client client;

  ProjectService({http.Client? client}) : client = client ?? http.Client();

  /// Adds a new project for a specific company.
  Future<String> addProject(String companyId, ProjectDto projectDto) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/api/Project/addProject/$companyId');
    final response = await client.post(
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
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/api/Project/editProject/$projectId');
    final response = await client.put(
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
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/api/Project/$companyId/getProjectById/$projectId');
    final response = await client.get(
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
      final String? token = await _authenticationService.getToken();

      if (token == null) {
        throw Exception("Token not found");
      }

      final url = Uri.parse('$baseUrl/api/Project/viewProject/$projectId');
      final response = await client.get(
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

  Future<ProjectDto> projectView2(String projectId) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/api/Project/viewProject/$projectId');
    final response = await client.get(
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

  /// Fetches the chat associated with a specific project.
  Future<ChatDto> getChatByProject(String projectId) async {
    final String? token = await _authenticationService.getToken();

    if (projectId.isEmpty) {
      throw Exception("Project ID cannot be null or empty.");
    }

    final url = Uri.parse('$baseUrl/api/Project/getChatByProject/$projectId');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ChatDto.fromJson(data);
    } else {
      throw Exception(json.decode(response.body)['error'] ?? "Failed to fetch chat for project");
    }
  }

  /// Removes a project by ID.
  Future<String> removeProject(String projectId) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/api/Project/RemoveProject/$projectId');
    final response = await client.delete(
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
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/api/Project/$projectId/assignEmployee/$employeeId');
    final response = await client.post(
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
      final errorMessage = json.decode(response.body)['error'] ?? "Failed to assign employee to project";
      throw Exception(errorMessage);
    }
  }

  //// Removes an employee from a project.
  Future<String> removeEmployee(String projectId, String employeeId) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/api/Project/$projectId/removeEmployee/$employeeId');
    final response = await client.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
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
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/api/Project/$companyId/listAllProjects');
    final response = await client.get(
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
      throw Exception(json.decode(response.body)['error'] ?? "Failed to fetch projects for company");
    }
  }

  /// Lists all new projects.
  Future<List<ProjectDto>> listAllNewProjects() async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/api/Project/listAllNewProjects');
    final response = await client.get(
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
        throw Exception("Falha ao buscar novos projetos: ${response.statusCode}");
      }
    }
  }

  /// Fetches all employees assigned to a specific project.
  Future<List<EmployeeDto>> getEmployeesByProject(String projectId) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/api/Project/$projectId/employees');
    final response = await client.get(
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
      throw Exception(json.decode(response.body)['error'] ?? "Failed to fetch employees for project");
    }
  }

}
