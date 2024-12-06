import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/company_dto.dart';
import 'package:front_end_moldme/dtos/employee_dto.dart';
import 'package:front_end_moldme/models/subscriptionPlan.dart';
import 'package:front_end_moldme/widgets/app_drawer.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart'; // Importa a CustomNavigationBar

class EmployeeProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dados estáticos do funcionário
    final EmployeeDto employee = EmployeeDto(
      name: "John Doe",
      profession: "Software Engineer",
      nif: 123456789,
      email: "john.doe@example.com",
      contact: 123456789,
      company: CompanyDto(
          name: "Tech Corp",
          taxId: 999999999,
          email: '',
          sector: '',
          plan: SubscriptionPlan.Basic,
          password: '1234'),
      password: '',
      companyId: '',
    );

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
                            backgroundColor: Colors.lightBlueAccent,
                            child: Text(
                              employee.name[
                                  0], // Mostra a primeira letra do nome do funcionário
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            ),
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
