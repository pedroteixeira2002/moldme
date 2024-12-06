import 'package:flutter/material.dart';
import 'package:front_end_moldme/services/employee_service.dart';
import 'package:front_end_moldme/widgets/app_drawer.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart'; // Import your custom navigation bar

class AddEmployeeScreen extends StatefulWidget {
  final String companyId;

  const AddEmployeeScreen({Key? key, required this.companyId})
      : super(key: key);

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _nifController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final EmployeeService _employeeService = EmployeeService();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Cria o payload com os campos esperados pela API
      final Map<String, dynamic> payload = {
        "name": _nameController.text,
        "profession": _professionController.text,
        "nif": int.parse(_nifController.text),
        "email": _emailController.text,
        "contact": int.tryParse(_contactController.text),
        "password": _passwordController.text,
      };

      try {
        final message =
            await _employeeService.addEmployee(widget.companyId, payload);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        _clearForm();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao adicionar funcionário: $e")),
        );
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _professionController.clear();
    _nifController.clear();
    _emailController.clear();
    _contactController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AppDrawer(
      companyId: widget.companyId, // Add the required companyId argument
      userId: widget.companyId, // Add the required userId argument
      child: Scaffold(
        appBar:
            const CustomNavigationBar(), // Use the custom navigation bar here
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Adicionar Novo Funcionário",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField("Nome", _nameController),
                    const SizedBox(height: 16),
                    _buildTextField("Profissão", _professionController),
                    const SizedBox(height: 16),
                    _buildTextField("NIF", _nifController,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    _buildTextField("Email", _emailController,
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 16),
                    _buildTextField("Contato", _contactController,
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),
                    _buildTextField("Senha", _passwordController,
                        isPassword: true),
                    const SizedBox(height: 24),
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
                          ),
                          child: const Text("Cancelar"),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 12.0),
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text("Adicionar"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false,
      TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Por favor, insira o $label.";
        }
        return null;
      },
    );
  }
}

