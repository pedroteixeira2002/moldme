import 'package:flutter/material.dart';
import '../services/employee_service.dart';
import '../models/employee_dto.dart';

class AddEmployeeScreen extends StatefulWidget {
  final String companyId;
  final String token;

  AddEmployeeScreen({required this.companyId, required this.token});

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _professionController = TextEditingController();
  final _nifController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final EmployeeService _employeeService = EmployeeService();

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final employeeDto = EmployeeDto(
        name: _nameController.text,
        profession: _professionController.text,
        nif: _nifController.text,
        email: _emailController.text,
        contact: _contactController.text,
        password: _passwordController.text,
      );

      final success =
          await _employeeService.addEmployee(widget.companyId, employeeDto);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Employee added successfully')),
        );
        _formKey.currentState?.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add employee')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _professionController,
                decoration: InputDecoration(labelText: 'Profession'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a profession';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nifController,
                decoration: InputDecoration(labelText: 'NIF'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a NIF';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'Contact'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a contact';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Employee'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
