import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:front_end_moldme/services/project_service.dart';
import 'package:front_end_moldme/dtos/project_dto.dart';
import 'package:mockito/annotations.dart';

import 'project_service_test.mocks.dart';

// Mock http.Client using Mockito
@GenerateMocks([http.Client])
void main() {
  late ProjectService projectService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    projectService = ProjectService(client: mockClient);
  });

  test('addProject adds a project successfully', () async {
    const companyId = 'companyId';
    final projectDto = ProjectDto(
      projectId: 'projectId',
      name: 'Project Name',
      description: 'Project Description',
      budget: 1000,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
      status: 1,
    );

    // Mock the HTTP POST request
    when(mockClient.post(
      Uri.parse('http://localhost:5213/api/Project/addProject/$companyId'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async =>
        http.Response('{"Message": "Project added successfully"}', 200));

    // Perform the service call
    final result = await projectService.addProject(companyId, projectDto);

    // Assertions
    expect(result, 'Project added successfully');
  });

  test('addProject throws exception on failure', () async {
    const companyId = 'companyId';
    final projectDto = ProjectDto(
      projectId: 'projectId',
      name: 'Project Name',
      budget: 1000,
      description: 'Project Description',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
      status: 1,
    );

    // Mock the HTTP POST request
    when(mockClient.post(
      Uri.parse('http://localhost:5213/api/Project/addProject/$companyId'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('Internal Server Error', 500));

    // Perform the service call and expect an exception
    expect(() async => await projectService.addProject(companyId, projectDto),
        throwsException);
  });

  test('deleteProject deletes a project successfully', () async {
    const projectId = 'projectId';

    // Mock the HTTP DELETE request
    when(mockClient.delete(
      Uri.parse('http://localhost:5213/api/Project/RemoveProject/$projectId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('', 200));

    // Perform the service call
    await projectService.removeProject(projectId);

    // Verify the call
    verify(mockClient.delete(
      Uri.parse('http://localhost:5213/api/Project/RemoveProject/$projectId'),
      headers: anyNamed('headers'),
    )).called(1);
  });

  test('deleteProject throws exception on failure', () async {
    const projectId = 'projectId';

    // Mock the HTTP DELETE request
    when(mockClient.delete(
      Uri.parse('http://localhost:5213/api/Project/RemoveProject/$projectId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('Internal Server Error', 500));

    // Perform the service call and expect an exception
    expect(() async => await projectService.removeProject(projectId),
        throwsException);
  });

  test('getProject returns ProjectDto on success', () async {
    const projectId = 'projectId';
    const companyId = 'companyId';
    final mockResponse = {
      "projectId": projectId,
      "name": "Testar",
      "description": "teste",
      "status": 0,
      "budget": 112121,
      "startDate": "2024-12-09T00:00:00",
      "endDate": "2024-12-24T00:00:00",
      "companyId": "bf498b3e-74df-4a7c-ac5a-b9b00d097498",
      "company": null,
      "employees": [],
      "tasks": [],
      "chat": null,
      "offers": []
    };

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse('http://localhost:5213/api/Project/viewProject/$projectId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

    // Perform the service call
    final result = await projectService.projectView(companyId, projectId);

    // Assertions
    expect(result, isA<ProjectDto>());
    expect(result.projectId, projectId);
  });

  test('getProject throws exception on failure', () async {
    const projectId = 'projectId';
    const companyId = 'companyId';

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse('http://localhost:5213/api/Project/viewProject/$projectId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('Not Found', 404));

    // Perform the service call and expect an exception
    expect(() async => await projectService.projectView(companyId, projectId),
        throwsException);
  });

  test('getProjectsByCompanyId returns a list of ProjectDto on success',() async {
    const companyId = 'companyId';
    final mockResponse = [
      {
        "projectId": "014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08",
        "name": "Teste",
        "description": "teste",
        "status": 0,
        "budget": 12121,
        "startDate": "2024-11-30T00:00:00",
        "endDate": "2024-11-30T00:00:00",
        "companyId": "bf498b3e-74df-4a7c-ac5a-b9b00d097498",
        "company": null,
        "employees": [],
        "tasks": [],
        "chat": null,
        "offers": []
      },
      {
        "projectId": "07d80df4-b124-4f3c-a4a8-09b38a55b15e",
        "name": "Testar",
        "description": "teste",
        "status": 0,
        "budget": 112121,
        "startDate": "2024-12-09T00:00:00",
        "endDate": "2024-12-24T00:00:00",
        "companyId": "bf498b3e-74df-4a7c-ac5a-b9b00d097498",
        "company": null,
        "employees": [],
        "tasks": [],
        "chat": null,
        "offers": []
      },
    ];

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse('http://localhost:5213/api/Project/$companyId/listAllProjects'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

    // Perform the service call
    final result = await projectService.listAllProjectsFromCompany(companyId);

    // Assertions
    expect(result, isA<List<ProjectDto>>());
    expect(result.length, 2);
    expect(result.first.projectId, "014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08");
  });

  test('getProjectsByCompanyId throws exception on failure', () async {
    const companyId = 'companyId';

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse('http://localhost:5213/api/Project/$companyId/listAllProjects'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('Not Found', 404));

    // Perform the service call and expect an exception
    expect(
        () async => await projectService.listAllProjectsFromCompany(companyId),
        throwsException);
  });

  test('updateProject updates a project successfully', () async {
    const projectId = 'projectId';
    final projectDto = ProjectDto(
      projectId: projectId,
      name: 'Updated Project Name',
      description: 'Updated Project Description',
      startDate: DateTime.now(),
      budget: 1000,
      endDate: DateTime.now().add(Duration(days: 30)),
      status: 1,
    );

    // Mock the HTTP PUT request
    when(mockClient.put(
      Uri.parse('http://localhost:5213/api/Project/editProject/$projectId'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async =>
        http.Response('{"Message": "Project updated successfully"}', 200));

    // Perform the service call
    final result = await projectService.updateProject(projectId, projectDto);

    // Assertions
    expect(result, 'Project updated successfully');
  });

  test('updateProject throws exception on failure', () async {
    const projectId = 'projectId';
    final projectDto = ProjectDto(
      projectId: projectId,
      name: 'Updated Project Name',
      description: 'Updated Project Description',
      budget: 1000,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
      status: 1,
    );

    // Mock the HTTP PUT request
    when(mockClient.put(
      Uri.parse('http://localhost:5213/api/Project/editProject/$projectId'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('Internal Server Error', 500));

    // Perform the service call and expect an exception
    expect(
        () async => await projectService.updateProject(projectId, projectDto),
        throwsException);
  });

  test('assignEmployee assigns an employee to a project successfully',
      () async {
    const projectId = 'projectId';
    const employeeId = 'employeeId';

    // Mock the HTTP POST request
    when(mockClient.post(
      Uri.parse(
          'http://localhost:5213/api/Project/$projectId/assignEmployee/$employeeId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('', 200));

    // Perform the service call
    await projectService.assignEmployee(projectId, employeeId);

    // Verify the call
    verify(mockClient.post(
      Uri.parse(
          'http://localhost:5213/api/Project/$projectId/assignEmployee/$employeeId'),
      headers: anyNamed('headers'),
    )).called(1);
  });

  test('assignEmployee throws exception on failure', () async {
    const projectId = 'projectId';
    const employeeId = 'employeeId';

    // Mock the HTTP POST request
    when(mockClient.post(
      Uri.parse(
          'http://localhost:5213/api/Project/$projectId/assignEmployee/$employeeId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('Internal Server Error', 500));

    // Perform the service call and expect an exception
    expect(
        () async => await projectService.assignEmployee(projectId, employeeId),
        throwsException);
  });

  test('removeEmployee removes an employee from a project successfully',
      () async {
    const projectId = 'projectId';
    const employeeId = 'employeeId';

    // Mock the HTTP DELETE request
    when(mockClient.delete(
      Uri.parse(
          'http://localhost:5213/api/Project/$projectId/removeEmployee/$employeeId'),
      headers: anyNamed('headers'),
    )).thenAnswer(
        (_) async => http.Response('Employee removed successfully', 200));

    // Perform the service call
    final result = await projectService.removeEmployee(projectId, employeeId);

    // Assertions
    expect(result, 'Employee removed successfully');
  });

  test('removeEmployee throws exception on failure', () async {
    const projectId = 'projectId';
    const employeeId = 'employeeId';

    // Mock the HTTP DELETE request
    when(mockClient.delete(
      Uri.parse(
          'http://localhost:5213/api/Project/$projectId/removeEmployee/$employeeId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('Internal Server Error', 500));

    // Perform the service call and expect an exception
    expect(
        () async => await projectService.removeEmployee(projectId, employeeId),
        throwsException);
  });

  test('listAllNewProjects returns a list of ProjectDto on success', () async {
    final mockResponse = [
      {
        "projectId": "projectId1",
        "name": "Teste",
        "description": "teste",
        "status": 0,
        "budget": 12121,
        "startDate": "2024-11-30T00:00:00",
        "endDate": "2024-11-30T00:00:00",
        "companyId": "bf498b3e-74df-4a7c-ac5a-b9b00d097498",
        "company": null,
        "employees": [],
        "tasks": [],
        "chat": null,
        "offers": []
      },
      {
        "projectId": "07d80df4-b124-4f3c-a4a8-09b38a55b15e",
        "name": "Testar",
        "description": "teste",
        "status": 0,
        "budget": 112121,
        "startDate": "2024-12-09T00:00:00",
        "endDate": "2024-12-24T00:00:00",
        "companyId": "bf498b3e-74df-4a7c-ac5a-b9b00d097498",
        "company": null,
        "employees": [],
        "tasks": [],
        "chat": null,
        "offers": []
      },
    ];

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse('http://localhost:5213/api/Project/listAllNewProjects'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

    // Perform the service call
    final result = await projectService.listAllNewProjects();

    // Assertions
    expect(result, isA<List<ProjectDto>>());
    expect(result.length, 2);
    expect(result.first.projectId, "projectId1");
  });
}
