import 'dart:convert';
import 'package:front_end_moldme/dtos/project_dto.dart';
import 'package:front_end_moldme/services/authentication_service.dart';
import 'package:http/http.dart' as http;
import '../dtos/employee_dto.dart';

class EmployeeService {
  final String baseUrl = "http://localhost:5213/api/Employee";
  final AuthenticationService _authenticationService = AuthenticationService();


  /// Adds a new employee to a company.
  Future<String> addEmployee(String companyId, Map<String, dynamic> payload) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/$companyId/addEmployee');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Adiciona o token no cabeçalho
      },
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['message'] ?? "Employee created successfully";
    } else {
      throw Exception("Erro na API: ${response.body}");
    }
  }


  /// Updates an existing employee in a company.
  Future<String> updateEmployee(String companyId, String employeeId, EmployeeDto employeeDto) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/$companyId/editEmployee/$employeeId');
    final body = json.encode(employeeDto.toJson());

    print('Payload: $body');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Adiciona o token no cabeçalho
      },
      body: body,
    );

    if (response.statusCode == 200) {
      // Verifica se o corpo da resposta não é JSON
      if (response.body.startsWith('{') && response.body.endsWith('}')) {
        final data = json.decode(response.body);
        return data['Message'] ?? "Employee updated successfully";
      } else {
        return response.body; // Retorna a resposta diretamente se não for JSON
      }
    } else {
      throw Exception(
          json.decode(response.body)['error'] ?? "Failed to update employee");
    }
  }

  /// Removes an employee from a company.
  Future<String> removeEmployee(String companyId, String employeeId) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/$companyId/removeEmployee/$employeeId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Adiciona o token no cabeçalho
      },
    );

    if (response.statusCode == 200) {
      return "Employee removed successfully";
    } else {
      throw Exception(
          json.decode(response.body)['error'] ?? "Failed to remove employee");
    }
  }

  Future<List<EmployeeDto>> listAllEmployeesFromCompany(String companyId) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final Uri url = Uri.parse("$baseUrl/$companyId/listAllEmployees");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Adiciona o token no cabeçalho
      },
    );

    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);

      if (jsonData is List<dynamic>) {
        // Trata diretamente como uma lista
        return jsonData.map((e) {
          final employeeData = e as Map<String, dynamic>;

          // Conversão manual para garantir os tipos corretos
          employeeData['nif'] =
              int.tryParse(employeeData['nif']?.toString() ?? '0') ?? 0;
          employeeData['contact'] =
              int.tryParse(employeeData['contact']?.toString() ?? '0');

          return EmployeeDto.fromJson(employeeData);
        }).toList();
      } else {
        throw Exception(
            "Formato inesperado para resposta da API: ${jsonData.runtimeType}");
      }
    } else {
      throw Exception(
          "Erro na API: ${response.statusCode} - ${response.reasonPhrase}");
    }
  }
  
  /// Gets a single employee by ID.
  Future<EmployeeDto> getEmployeeById(String employeeId) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/getEmployeeById/$employeeId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Adiciona o token no cabeçalho
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return EmployeeDto.fromJson(data);
    } else {
      throw Exception(
          json.decode(response.body)['error'] ?? "Failed to fetch employee");
    }
  }

  /// Gets all projects associated with an employee.
  Future<List<dynamic>> getEmployeeProjects(String employeeId) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/employees/$employeeId/projects');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Adiciona o token no cabeçalho
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception(
          json.decode(response.body)['error'] ?? "Failed to fetch projects");
    }
  }

  // Get all projects from employee by employee ID
  Future<List<ProjectDto>> getEmployeeProjects2(String employeeId) async {
    final String? token = await _authenticationService.getToken();
    print('Token: $token');
    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/employees/$employeeId/projects');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Adiciona o token no cabeçalho
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Converte cada item da lista em um ProjectDto
      return data.map((e) => ProjectDto.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception("Failed to fetch companies");
    }
  }


  /// Gets all employees.
  Future<List<EmployeeDto>> getAllEmployees() async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/listAllEmployees');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Adiciona o token no cabeçalho
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return data.map((e) => EmployeeDto.fromJson(e)).toList();
    } else {
      throw Exception(
          json.decode(response.body)['error'] ?? "Failed to fetch employees");
    }
  }
}
