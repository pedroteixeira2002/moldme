import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/employee_dto.dart';
import 'package:front_end_moldme/services/employee_service.dart';
import 'package:front_end_moldme/screens/app_drawer.dart';

class EditEmployeeScreen extends StatefulWidget {
  @override
  _EditEmployeeScreenState createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  final EmployeeService employeeService = EmployeeService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController nifController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late String companyId;
  late String employeeId;
  late EmployeeDto employee;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Recupera os argumentos passados para a página
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    employee = args['employee'] as EmployeeDto;
    companyId = args['companyId'] as String;
    employeeId = employee.employeeId;

    // Preenche os campos com os dados do funcionário
    nameController.text = employee.name;
    professionController.text = employee.profession;
    emailController.text = employee.email;
    contactController.text = employee.contact?.toString() ?? '';
    nifController.text = employee.nif.toString();
  }

  Future<void> updateEmployee() async {
    try {
      // Cria o objeto EmployeeDto atualizado
      final updatedEmployee = EmployeeDto(
        employeeId: employeeId,
        name: nameController.text,
        profession: professionController.text,
        nif: int.tryParse(nifController.text) ?? employee.nif,
        email: emailController.text,
        contact: int.tryParse(contactController.text),
        password: passwordController.text.isNotEmpty
            ? passwordController.text
            : employee.password,
        companyId: companyId,
        company: null,
      );

      // Chama o serviço para atualizar o funcionário
      await employeeService.updateEmployee(
          companyId, employeeId, updatedEmployee);

      // Mostra uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Funcionário atualizado com sucesso!')),
      );

      // Volta para a página anterior
      Navigator.pop(context);
    } catch (e) {
      // Mostra uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar o funcionário: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDrawer(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Editar Funcionário"),
          backgroundColor: Colors.blue.shade700,
        ),
        body: Padding(
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
            child: ListView(
              children: [
                Text(
                  "Atualizar Informações",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField("Nome", nameController),
                const SizedBox(height: 16),
                _buildTextField("Profissão", professionController),
                const SizedBox(height: 16),
                _buildTextField("Email", emailController),
                const SizedBox(height: 16),
                _buildTextField("Contato", contactController,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField("NIF", nifController,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField("Password", passwordController,
                    isPassword: true),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        "Cancelar",
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: updateEmployee,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      icon: Icon(Icons.save, color: Colors.white),
                      label: Text(
                        "Guardar alterações",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}
