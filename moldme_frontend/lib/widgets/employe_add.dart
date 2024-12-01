import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/employee_dto.dart';
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
    _employees = _employeeService.listAllEmployeesFromCompany(widget.companyId);
  }

  Future<void> _assignEmployee(String employeeId) async {
    try {
      await _projectService.assignEmployee(widget.projectId, employeeId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Employee assigned successfully!")),
      );
      setState(() {
        _employees = _employeeService.listAllEmployeesFromCompany(widget.companyId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to assign employee: $e")),
      );
    }
  }

  void _showAssignEmployeeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Assign Employee"),
          content: SizedBox(
            width: double.maxFinite,
            child: FutureBuilder<List<EmployeeDto>>(
              future: _employees,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No employees found.");
                }

                final employees = snapshot.data!;
                return ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    final employee = employees[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: const AssetImage(
                            'assets/images/placeholder.png'), // Use um placeholder caso não tenha imagem
                        child: employee.name.isNotEmpty
                            ? null
                            : const Icon(Icons.person),
                      ),
                      title: Text(employee.name),
                      subtitle: Text(employee.profession),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          _assignEmployee(employee.employeeId);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
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
        return Row(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final employee = employees[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundImage: const AssetImage(
                                'assets/images/placeholder.png'), // Placeholder de imagem
                            radius: 24,
                            child: employee.name.isNotEmpty
                                ? null
                                : const Icon(Icons.person),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            employee.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(employee.profession),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green),
              onPressed: _showAssignEmployeeDialog,
            ),
          ],
        );
      },
    );
  }
}
