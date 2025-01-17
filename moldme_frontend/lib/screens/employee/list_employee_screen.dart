import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/employee_dto.dart';
import 'package:front_end_moldme/services/employee_service.dart';
import 'package:front_end_moldme/widgets/app_drawer.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart'; // Importa o custom navigation bar

class AllEmployeesScreen extends StatefulWidget {
  final bool isCompany;

  AllEmployeesScreen({required this.isCompany});

  @override
  _AllEmployeesScreenState createState() => _AllEmployeesScreenState();
}

class _AllEmployeesScreenState extends State<AllEmployeesScreen> {
  final EmployeeService employeeService = EmployeeService();
  final String companyId = "bf498b3e-74df-4a7c-ac5a-b9b00d097498";
  List<EmployeeDto> employees = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();

    if (widget.isCompany) {
      fetchEmployees();
    }
  }

  Future<void> fetchEmployees() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final List<EmployeeDto> fetchedEmployees =
          await employeeService.listAllEmployeesFromCompany(companyId);

      setState(() {
        employees = fetchedEmployees;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Erro ao carregar os funcionários: ${e.toString()}";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isCompany) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Acesso Restrito"),
          backgroundColor: Colors.red.shade700,
        ),
        body: Center(
          child: Text(
            "Esta página é exclusiva para empresas.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          const CustomNavigationBar(), // Navbar fixa no topo
          Expanded(
            child: AppDrawer(
              child: Stack(
                children: [
                  if (isLoading)
                    Center(child: CircularProgressIndicator())
                  else if (errorMessage.isNotEmpty)
                    Center(child: Text(errorMessage))
                  else if (employees.isEmpty)
                    Center(child: Text("Nenhum funcionário encontrado."))
                  else
                    ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final employee = employees[index];

                        return ListTile(
                          title: Text(employee.name),
                          subtitle: Text(employee.email),
                          trailing: Text(employee.profession),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/edit-employee',
                              arguments: {
                                'employee': employee,
                                'companyId': companyId,
                              },
                            ).then((_) => fetchEmployees());
                          },
                        );
                      },
                    ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/add-employee',
                          arguments: companyId,
                        ).then((_) => fetchEmployees());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        "Adicionar Funcionário",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
