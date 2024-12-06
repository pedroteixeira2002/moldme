import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dtos/employee_dto.dart';

class EmployeeService {
  final String baseUrl = "http://localhost:5213/api/Employee";
  final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJ0aWFnb0BnbWFpbC5jb20iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJDb21wYW55IiwiZXhwIjoxNzM0NzM0OTUxLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMifQ.B4clMA8cuR4cH6YPs9WbYSbr6PQeb3TE8IaeH7_ixFA"; // Replace with actual token


  /// Adds a new employee to a company.
Future<String> addEmployee(
      String companyId, Map<String, dynamic> payload) async {
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
Future<String> updateEmployee(
      String companyId, String employeeId, EmployeeDto employeeDto) async {
    final url = Uri.parse('$baseUrl/$companyId/editEmployee/$employeeId');
    final body = json.encode(employeeDto.toJson());

    print('Payload: $body');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
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
    final url =
        Uri.parse('$baseUrl/api/Employee/$companyId/removeEmployee/$employeeId');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',},
    );

    if (response.statusCode == 200) {
      return "Employee removed successfully";
    } else {
      throw Exception(
          json.decode(response.body)['error'] ?? "Failed to remove employee");
    }
  }

  Future<List<EmployeeDto>> listAllEmployeesFromCompany(
      String companyId) async {
    final Uri url = Uri.parse("$baseUrl/$companyId/listAllEmployees");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
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
    final url = Uri.parse('$baseUrl/getEmployeeById/$employeeId');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',},
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
    final url =
        Uri.parse('$baseUrl/api/Employee/employees/$employeeId/projects');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception(
          json.decode(response.body)['error'] ?? "Failed to fetch projects");
    }
  }

  /// Gets all employees.
  Future<List<EmployeeDto>> getAllEmployees() async {
    final url = Uri.parse('$baseUrl/api/Employee/listAllEmployees');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',},
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
