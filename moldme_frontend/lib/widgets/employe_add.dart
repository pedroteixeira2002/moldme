import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/employee_dto.dart';
import 'package:front_end_moldme/screens/project/project-page.dart';
import 'package:front_end_moldme/services/employee_service.dart';
import 'package:front_end_moldme/services/project_service.dart';

class EmployeeListWidget extends StatefulWidget {
  final String companyId;
  final String projectId;

  const EmployeeListWidget({
    Key? key,
    required this.companyId,
    required this.projectId,
  }) : super(key: key);

  @override
  _EmployeeListWidgetState createState() => _EmployeeListWidgetState();
}

class _EmployeeListWidgetState extends State<EmployeeListWidget> {
  final EmployeeService _employeeService = EmployeeService();
  final ProjectService _projectService = ProjectService();
  late Future<List<EmployeeDto>> _employees;

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  void _fetchEmployees() {
    // Carrega a lista de funcionários
    setState(() {
      _employees =
          _employeeService.listAllEmployeesFromCompany(widget.companyId);
    });
  }

  Future<void> _assignEmployee(String employeeId) async {
    try {
      await _projectService.assignEmployee(widget.projectId, employeeId);

      // Mostra mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Employee assigned successfully!")));

      // Força o refresh da página ao navegar para a mesma página
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProjectPage(
                  projectId: widget.projectId,
                  companyId: widget.companyId,
                )),
      );
    } catch (e) {
      // Mostra mensagem de erro
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProjectPage(
                  projectId: widget.projectId,
                  companyId: widget.companyId,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EmployeeDto>>(
      future: _employees,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No employees found."));
        }

        final employees = snapshot.data!;
        return ListView.separated(
          shrinkWrap: true, // Permite que a lista respeite os limites do pai
          separatorBuilder: (context, index) => const Divider(),
          itemCount: employees.length,
          itemBuilder: (context, index) {
            final employee = employees[index];
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1), // Altera a posição da sombra
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        const AssetImage('lib/assets/app-icon-person.png'),
                    radius: 24,
                    child: employee.name.isNotEmpty
                        ? null
                        : const Icon(Icons.person),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          employee.profession,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.green),
                    onPressed: () {
                      if (employee.employeeId != null) {
                        _assignEmployee(employee.employeeId!);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
