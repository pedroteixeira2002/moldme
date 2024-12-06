import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/project_dto.dart';
import 'package:front_end_moldme/models/status.dart';
import 'package:front_end_moldme/screens/project/project-page.dart';
import 'package:front_end_moldme/services/authentication_service.dart';
import 'package:front_end_moldme/services/employee_service.dart';
import 'package:front_end_moldme/services/project_service.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart';
import 'package:front_end_moldme/widgets/app_drawer.dart';

class ProjectsListWidget extends StatefulWidget {
  final String companyId;
  final dynamic currentUserId;

  const ProjectsListWidget({Key? key, required this.companyId, required this.currentUserId})
      : super(key: key);

  @override
  _ProjectsListWidgetState createState() => _ProjectsListWidgetState();
}

class _ProjectsListWidgetState extends State<ProjectsListWidget> {
  final ProjectService _projectService = ProjectService();
  final EmployeeService _employeeService = EmployeeService();
  late Future<List<ProjectDto>> _projects;
  final AuthenticationService _authenticationService = AuthenticationService();
  

  @override
  void initState() {
    super.initState();
    _initializeProjects();
  }

  Future<void> _initializeProjects() async {
    String? companyId = widget.companyId;

    if (companyId.isEmpty) {
      final role = await _authenticationService.checkRole();
      if (role == 'Company') {
        companyId = widget.currentUserId;
      } else if (role == 'Employee') {
        var company = await _authenticationService.getCompanyById(widget.currentUserId);
        companyId = company.companyId;
      }
    }

    setState(() {
      if (companyId == widget.currentUserId) {
        _projects = _projectService.listAllProjectsFromCompany(companyId!);
      } else {
        _projects = _employeeService.getEmployeeProjects(widget.currentUserId) as Future<List<ProjectDto>>;
      }
    });
  }

  /// Converte o enum Status para texto amigável ao usuário.
  String _statusToString(int status) {
    switch (Status.fromInt(status)) {
      case Status.newEntity:
        return "New";
      case Status.inProgress:
        return "In Progress";
      case Status.done:
        return "Done";
      case Status.closed:
        return "Closed";
      case Status.canceled:
        return "Canceled";
      case Status.pending:
        return "Pending";
      case Status.accepted:
        return "Accepted";
      case Status.denied:
        return "Denied";
      default:
        return "Unknown";
    }
  }

  /// Converte o enum Status para uma cor associada.
  Color _statusToColor(int status) {
    switch (Status.fromInt(status)) {
      case Status.newEntity:
        return Colors.blue;
      case Status.inProgress:
        return Colors.orange;
      case Status.done:
        return Colors.green;
      case Status.closed:
        return Colors.grey;
      case Status.canceled:
        return Colors.red;
      case Status.pending:
        return Colors.amber;
      case Status.accepted:
        return Colors.teal;
      case Status.denied:
        return Colors.purple;
      default:
        return Colors.black;
    }
  }

  /// Função para buscar a contagem de funcionários associados a um projeto.
  Future<int> _fetchEmployeeCount(String projectId) async {
    try {
      final employees = await _projectService.getEmployeesByProject(projectId);
      return employees.length;
    } catch (e) {
      return 0; // Retorna 0 em caso de erro
    }
  }

  /// Função para navegar para os detalhes do projeto.
  Future<void> _openProject(String projectId) async {
    final role = await _authenticationService.checkRole();
    String companyId;

    if (role == 'Company') {
      companyId = widget.currentUserId;
    } else if (role == 'Employee') {
      var company = await _authenticationService.getCompanyById(widget.currentUserId);
      companyId = company.companyId!;
    } else {
      // Handle unexpected role
      throw Exception('Unexpected role in project company list: $role');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectPage(
          projectId: projectId,
          companyId: companyId,
          currentUserId: widget.currentUserId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomNavigationBar(), // Adiciona a CustomNavigationBar
      body: AppDrawer(
        userId: widget.currentUserId,
        companyId: widget.companyId,  
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<ProjectDto>>(
            future: _projects,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No projects found."));
              }

              final projects = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection:
                    Axis.horizontal, // Para permitir rolagem horizontal
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 3, // Adiciona uma elevação ao DataTable
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Title')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Employees on this Project')),
                      ],
                      rows: projects.map((project) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(project.name),
                              onTap: () => _openProject(project.projectId!),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: _statusToColor(project.status)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  _statusToString(project.status),
                                  style: TextStyle(
                                    color: _statusToColor(project.status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                  "${project.startDate.year}/${project.startDate.month.toString().padLeft(2, '0')}/${project.startDate.day.toString().padLeft(2, '0')}"),
                            ),
                            DataCell(
                              FutureBuilder<int>(
                                future: _fetchEmployeeCount(project.projectId!),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Text("N/A");
                                  } else {
                                    final employeeCount = snapshot.data ?? 0;
                                    return Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundImage: const AssetImage(
                                              'lib/assets/avatar_placeholder.png'),
                                        ),
                                        const SizedBox(width: 4),
                                        Text("+$employeeCount"),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
