import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dtos/employee_dto.dart';

class EmployeeService {
  final String baseUrl = "http://localhost:5213";
  final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJ0aWFnb0BnbWFpbC5jb20iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJDb21wYW55IiwiZXhwIjoxNzM0NzM0OTUxLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMifQ.B4clMA8cuR4cH6YPs9WbYSbr6PQeb3TE8IaeH7_ixFA"; // Replace with actual token
  final http.Client client;

  EmployeeService({http.Client? client}) : client = client ?? http.Client();

  /// Adds a new employee to a company.
  Future<String> addEmployee(String companyId, EmployeeDto employeeDto) async {
    final url = Uri.parse('$baseUrl/api/Employee/$companyId/addEmployee');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(employeeDto.toJson()),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['Message'] ?? "Employee created successfully";
    } else {
      throw Exception(
          json.decode(response.body)['error'] ?? "Failed to add employee");
    }
  }

  /// Updates an existing employee in a company.
  Future<String> updateEmployee(
      String companyId, String employeeId, EmployeeDto employeeDto) async {
    final url =
        Uri.parse('$baseUrl/api/Employee/$companyId/editEmployee/$employeeId');
    final response = await client.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(employeeDto.toJson()),
    );

    if (response.statusCode == 200) {
      return "Employee updated successfully";
    } else {
      throw Exception(
          json.decode(response.body)['error'] ?? "Failed to update employee");
    }
  }

  /// Removes an employee from a company.
  Future<String> removeEmployee(String companyId, String employeeId) async {
    final url =
        Uri.parse('$baseUrl/api/Employee/$companyId/removeEmployee/$employeeId');
    final response = await client.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return "Employee removed successfully";
    } else {
      throw Exception(
          json.decode(response.body)['error'] ?? "Failed to remove employee");
    }
  }

  /// Gets all employees associated with a company.
  Future<List<EmployeeDto>> listAllEmployeesFromCompany(String companyId) async {
    final url = Uri.parse('$baseUrl/api/Employee/$companyId/listAllEmployees');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body); // Decode as list
      return data.map((e) => EmployeeDto.fromJson(e)).toList();
    } else {
      throw Exception(
        json.decode(response.body)['error'] ?? "Failed to fetch employees",
      );
    }
  }

  /// Gets a single employee by ID.
  Future<EmployeeDto> getEmployeeById(String employeeId) async {
    final url = Uri.parse('$baseUrl/api/Employee/getEmployeeById/$employeeId');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
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
    final url =
        Uri.parse('$baseUrl/api/Employee/employees/$employeeId/projects');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
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