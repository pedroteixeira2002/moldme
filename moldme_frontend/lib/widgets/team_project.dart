import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/employee_dto.dart';
import 'package:front_end_moldme/services/project_service.dart';

class ProjectTeamWidget extends StatefulWidget {
  final String projectId;

  const ProjectTeamWidget({Key? key, required this.projectId})
      : super(key: key);

  @override
  _ProjectTeamWidgetState createState() => _ProjectTeamWidgetState();
}

class _ProjectTeamWidgetState extends State<ProjectTeamWidget> {
  final ProjectService _projectService = ProjectService();
  late Future<List<EmployeeDto>> _teamMembers;

  @override
  void initState() {
    super.initState();
    _loadTeamMembers(); // Carregar membros da equipe ao inicializar
  }

  Future<void> _loadTeamMembers() async {
    setState(() {
      _teamMembers = _projectService.getEmployeesByProject(widget.projectId);
    });
  }

  Future<void> _removeEmployee(String employeeId) async {
    try {
      await _projectService.removeEmployee(widget.projectId, employeeId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Employee removed successfully!")),
      );
      _loadTeamMembers(); // Recarregar membros da equipe após remoção
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to remove employee: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EmployeeDto>>(
      future: _teamMembers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No team members found."));
        }

        final teamMembers = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Team",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: teamMembers.map((employee) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                              'lib/assets/app-icon-person.png', // Placeholder para avatar
                            ),
                            child: employee.name.isNotEmpty
                                ? null
                                : const Icon(Icons.person),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            employee.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            employee.profession,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8.0),
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                            onPressed: () {
                               if (employee.employeeId != null) {
                                 _removeEmployee(employee.employeeId!);
                               }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
