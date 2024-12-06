import 'package:flutter_test/flutter_test.dart';
import 'package:front_end_moldme/dtos/company_dto.dart';
import 'package:front_end_moldme/models/subscriptionPlan.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:front_end_moldme/services/employee_service.dart';
import 'package:front_end_moldme/dtos/employee_dto.dart';
import 'package:mockito/annotations.dart';

import 'employee_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late EmployeeService employeeService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    employeeService = EmployeeService(client: mockClient);
  });

  test('addEmployee throws exception on failure', () async {
    const companyId = 'companyId';
    final employeeDto = EmployeeDto(
      employeeId: 'employeeId',
      name: 'Employee Name',
      email: 'employee@example.com',
      profession: 'Developer',
      nif: 123456789,
      password: 'password123',
      companyId: companyId,
      company: CompanyDto(
        companyId: 'companyId',
        name: 'Company Name',
        taxId: 987654321,
        sector: 'IT',
        plan: SubscriptionPlan.Basic,
        password: 'password',
        address: 'Company Address',
        email: 'company@example.com',
        contact: 123456789,
      ),
    );

    // Mock the HTTP POST request
    when(mockClient.post(
      Uri.parse('http://localhost:5213/api/Employee/$companyId/addEmployee'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('Internal Server Error', 500));

    // Perform the service call and expect an exception
    expect(
        () async => await employeeService.addEmployee(companyId, employeeDto as Map<String, dynamic>),
        throwsException);
  });

  test('updateEmployee updates an employee successfully', () async {
    const companyId = 'companyId';
    const employeeId = 'employeeId';
    final employeeDto = EmployeeDto(
      employeeId: 'employeeId',
      name: 'Employee Name',
      email: 'employee@example.com',
      profession: 'Developer',
      nif: 123456789,
      password: 'password123',
      companyId: companyId,
      company: CompanyDto(
        companyId: 'companyId',
        name: 'Company Name',
        taxId: 987654321,
        sector: 'IT',
        plan: SubscriptionPlan.Basic,
        password: 'password',
        address: 'Company Address',
        email: 'company@example.com',
        contact: 123456789,
      ),
    );

    // Mock the HTTP PUT request
    when(mockClient.put(
      Uri.parse(
          'http://localhost:5213/api/Employee/$companyId/editEmployee/$employeeId'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer(
        (_) async => http.Response('Employee updated successfully', 200));

    // Perform the service call
    final result = await employeeService.updateEmployee(
        companyId, employeeId, employeeDto);

    // Assertions
    expect(result, 'Employee updated successfully');
  });

  test('updateEmployee throws exception on failure', () async {
    const companyId = 'companyId';
    const employeeId = 'employeeId';
    final employeeDto = EmployeeDto(
      employeeId: 'employeeId',
      name: 'Employee Name',
      email: 'employee@example.com',
      profession: 'Developer',
      nif: 123456789,
      password: 'password123',
      companyId: companyId,
      company: CompanyDto(
        companyId: 'companyId',
        name: 'Company Name',
        taxId: 987654321,
        sector: 'IT',
        plan: SubscriptionPlan.Basic,
        password: 'password',
        address: 'Company Address',
        email: 'company@example.com',
        contact: 123456789,
      ),
    );

    // Mock the HTTP PUT request
    when(mockClient.put(
      Uri.parse(
          'http://localhost:5213/api/Employee/$companyId/editEmployee/$employeeId'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('Internal Server Error', 500));

    // Perform the service call and expect an exception
    expect(
        () async => await employeeService.updateEmployee(
            companyId, employeeId, employeeDto),
        throwsException);
  });

  test('removeEmployee removes an employee successfully', () async {
    const companyId = 'companyId';
    const employeeId = 'employeeId';

    // Mock the HTTP DELETE request
    when(mockClient.delete(
      Uri.parse(
          'http://localhost:5213/api/Employee/$companyId/removeEmployee/$employeeId'),
      headers: anyNamed('headers'),
    )).thenAnswer(
        (_) async => http.Response('Employee removed successfully', 200));

    // Perform the service call
    final result = await employeeService.removeEmployee(companyId, employeeId);

    // Assertions
    expect(result, 'Employee removed successfully');
  });

  test('removeEmployee throws exception on failure', () async {
    const companyId = 'companyId';
    const employeeId = 'employeeId';

    // Mock the HTTP DELETE request
    when(mockClient.delete(
      Uri.parse(
          'http://localhost:5213/api/Employee/$companyId/removeEmployee/$employeeId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('Internal Server Error', 500));

    // Perform the service call and expect an exception
    expect(
        () async => await employeeService.removeEmployee(companyId, employeeId),
        throwsException);
  });

  test('listAllEmployeesFromCompany returns a list of EmployeeDto on success',
      () async {
    const companyId = 'companyId';
    final mockResponse = [
      {
        "employeeId": "employeeId1",
        "name": "Employee Name 1",
        "email": "employee1@example.com",
        "role": "Developer",
      },
      {
        "employeeId": "employeeId2",
        "name": "Employee Name 2",
        "email": "employee2@example.com",
        "role": "Tester",
      },
    ];

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse(
          'http://localhost:5213/api/Employee/$companyId/listAllEmployees'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

    // Perform the service call
    final result = await employeeService.listAllEmployeesFromCompany(companyId);

    // Assertions
    expect(result, isA<List<EmployeeDto>>());
    expect(result.length, 2);
    expect(result.first.employeeId, "employeeId1");
  });

  test('listAllEmployeesFromCompany throws exception on failure', () async {
    const companyId = 'companyId';

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse(
          'http://localhost:5213/api/Employee/$companyId/listAllEmployees'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('Not Found', 404));

    // Perform the service call and expect an exception
    expect(
        () async =>
            await employeeService.listAllEmployeesFromCompany(companyId),
        throwsException);
  });

  test('getEmployeeById returns EmployeeDto on success', () async {
    const employeeId = 'employeeId';
    final mockResponse = {
      "employeeId": employeeId,
      "name": "Employee Name",
      "email": "employee@example.com",
      "role": "Developer",
    };

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse(
          'http://localhost:5213/api/Employee/getEmployeeById/$employeeId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

    // Perform the service call
    final result = await employeeService.getEmployeeById(employeeId);

    // Assertions
    expect(result, isA<EmployeeDto>());
    expect(result.employeeId, employeeId);
  });

  test('getEmployeeById throws exception on failure', () async {
    const employeeId = 'employeeId';

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse(
          'http://localhost:5213/api/Employee/getEmployeeById/$employeeId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('Not Found', 404));

    // Perform the service call and expect an exception
    expect(() async => await employeeService.getEmployeeById(employeeId),
        throwsException);
  });

  test('getEmployeeProjects returns a list of projects on success', () async {
    const employeeId = 'employeeId';
    final mockResponse = [
      {
        "projectId": "projectId1",
        "name": "Project Name 1",
        "description": "Project Description 1",
        "startDate": "2023-10-01T00:00:00Z",
        "endDate": "2023-11-01T00:00:00Z",
        "status": "Active",
      },
      {
        "projectId": "projectId2",
        "name": "Project Name 2",
        "description": "Project Description 2",
        "startDate": "2023-10-01T00:00:00Z",
        "endDate": "2023-11-01T00:00:00Z",
        "status": "Active",
      },
    ];

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse(
          'http://localhost:5213/api/Employee/employees/$employeeId/projects'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

    // Perform the service call
    final result = await employeeService.getEmployeeProjects(employeeId);

    // Assertions
    expect(result, isA<List<dynamic>>());
    expect(result.length, 2);
    expect(result.first['projectId'], "projectId1");
  });

  test('getEmployeeProjects throws exception on failure', () async {
    const employeeId = 'employeeId';

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse(
          'http://localhost:5213/api/Employee/employees/$employeeId/projects'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('Not Found', 404));

    // Perform the service call and expect an exception
    expect(() async => await employeeService.getEmployeeProjects(employeeId),
        throwsException);
  });

  test('getAllEmployees returns a list of EmployeeDto on success', () async {
    final mockResponse = [
      {
        "employeeId": "employeeId1",
        "name": "Employee Name 1",
        "email": "employee1@example.com",
        "role": "Developer",
      },
      {
        "employeeId": "employeeId2",
        "name": "Employee Name 2",
        "email": "employee2@example.com",
        "role": "Tester",
      },
    ];

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse('http://localhost:5213/api/Employee/listAllEmployees'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

    // Perform the service call
    final result = await employeeService.getAllEmployees();

    // Assertions
    expect(result, isA<List<EmployeeDto>>());
    expect(result.length, 2);
    expect(result.first.employeeId, "employeeId1");
  });

  test('getAllEmployees throws exception on failure', () async {
    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse('http://localhost:5213/api/Employee/listAllEmployees'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('Not Found', 404));

    // Perform the service call and expect an exception
    expect(
        () async => await employeeService.getAllEmployees(), throwsException);
  });
}
