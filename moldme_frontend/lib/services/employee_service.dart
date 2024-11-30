import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dtos/employee_dto.dart';

class EmployeeService {
  final String baseUrl =" http://localhost:5213/api/Employee";



  /// Adds a new employee to a company.
  Future<String> addEmployee(String companyId, EmployeeDto employeeDto) async {
    final url = Uri.parse('$baseUrl/api/Employee/$companyId/addEmployee');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
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
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
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

  /// Gets all employees associated with a company.
  Future<List<EmployeeDto>> listAllEmployeesFromCompany(String companyId) async {
    final url = Uri.parse('$baseUrl/api/Employee/$companyId/listAllEmployees');
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
