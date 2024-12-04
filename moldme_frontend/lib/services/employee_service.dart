import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dtos/employee_dto.dart';

class EmployeeService {
  final String baseUrl = "http://localhost:5213/api/Employee";


  /// Adds a new employee to a company.
Future<String> addEmployee(
      String companyId, Map<String, dynamic> payload) async {
    final url = Uri.parse('$baseUrl/$companyId/addEmployee');
    const String token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJwcEBnbWFpbC5jb20iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJFbXBsb3llZSIsImV4cCI6MTczNDk3MzQ2MSwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo1MjEzIiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDo1MjEzIn0.FJBSAB0HLBRptEdxkf2AXqOQa-XAGFsbaXrwbHuISTo";

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
      headers: {'Content-Type': 'application/json'},
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
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJ0aWFnb0BnbWFpbC5jb20iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJDb21wYW55IiwiZXhwIjoxNzM0OTY1MTkwLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMifQ.lxm_4MitOq8He7tYbfRDD_AoaZd2BROonvg5V5gIJZI', // Substitua pelo token correto
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      // Verifica se a chave $values está presente e contém uma lista
      final List<dynamic> employeeList = jsonData['\$values'] ?? [];
      return employeeList
          .map((e) => EmployeeDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          "Erro na API: ${response.statusCode} - ${response.reasonPhrase}");
    }
  }

  /// Gets a single employee by ID.
  Future<EmployeeDto> getEmployeeById(String employeeId) async {
    final url = Uri.parse('$baseUrl/api/Employee/getEmployeeById/$employeeId');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
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
      headers: {'Content-Type': 'application/json'},
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
      headers: {'Content-Type': 'application/json'},
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
