import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/employee_dto.dart';
import 'package:front_end_moldme/widgets/app_drawer.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart'; // Importa a CustomNavigationBar

class EmployeeProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Recupera os argumentos passados para a rota
    final EmployeeDto? employee =
        ModalRoute.of(context)?.settings.arguments as EmployeeDto?;

    if (employee == null) {
      // Caso o argumento seja nulo, mostre uma mensagem de erro
      return Scaffold(
        appBar: AppBar(
          title: Text("Error"),
        ),
        body: Center(
          child: Text("Erro: Nenhum funcionário selecionado."),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          const CustomNavigationBar(), // Adiciona a navbar no topo
          Expanded(
            child: AppDrawer(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                                "https://via.placeholder.com/150"), // Placeholder image
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  employee.name, // Nome do funcionário
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  employee
                                      .profession, // Profissão do funcionário
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                Text(
                                  "NIF: ${employee.nif}", // NIF do funcionário
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Exibe informações do funcionário
                      _buildTextField("Email", employee.email),
                      const SizedBox(height: 16),
                      _buildTextField(
                        "Phone Number",
                        employee.contact?.toString() ?? "Not provided",
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        "Company",
                        employee.company?.name ?? "No company associated",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: value,
        border: OutlineInputBorder(),
      ),
    );
  }
}
