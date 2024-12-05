import 'package:flutter/material.dart';
import 'package:front_end_moldme/models/company.dart';
import 'package:front_end_moldme/screens/register/planSelectionScreen.dart';

class RegisterScreen2 extends StatefulWidget {
  final Company company;

  const RegisterScreen2({super.key, required this.company});

  @override
  _RegisterScreen2State createState() => _RegisterScreen2State();
}

class _RegisterScreen2State extends State<RegisterScreen2> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Parte esquerda com imagem decorativa
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'lib/images/register2.png'), // Substitua pelo caminho da imagem
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Parte direita com o formulário
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: SingleChildScrollView(
                  child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please fill your information below',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Campo "Company Name"
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Company Name',
                        prefixIcon: Icon(Icons.business),
                        border: OutlineInputBorder(),
                      ),
                      initialValue: widget.company.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the company name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        widget.company.name = value ?? '';
                      },
                    ),
                    const SizedBox(height: 16),

                    // Campo "Tax Information"
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Tax Information',
                        prefixIcon: Icon(Icons.receipt),
                        border: OutlineInputBorder(),
                      ),
                      initialValue: widget.company.taxId.toString(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the tax information';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        widget.company.taxId = int.tryParse(value ?? '0') ?? 0;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Campo "E-mail"
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      initialValue: widget.company.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        widget.company.email = value ?? '';
                      },
                    ),
                    const SizedBox(height: 16),

                    // Dropdown "Work Area"
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Work Area',
                        prefixIcon: Icon(Icons.work),
                        border: OutlineInputBorder(),
                      ),
                      value: widget.company.sector.isEmpty
                          ? null
                          : widget.company.sector,
                      items: const [
                        DropdownMenuItem(
                          value: 'Injection Systems',
                          child: Text('We do Injection Systems'),
                        ),
                        DropdownMenuItem(
                          value: 'Molds',
                          child: Text('We do Molds'),
                        ),
                        DropdownMenuItem(
                          value: 'Plastic Products',
                          child: Text('We need a plastic Product'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          widget.company.sector = value ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a work area';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Campo "Password"
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        widget.company.password = value;
                        return null;
                      },
                      onSaved: (value) {
                        widget.company.password = value ?? '';
                      },
                    ),
                    const SizedBox(height: 16),

                    // Campo "Repeat your password"
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Repeat your password',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != widget.company.password) {
                          return 'Passwords do not match';
                        }
                        widget.company.password = value;
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Botão "Finish"
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            print('Company Name: ${widget.company.name}');
                            print('Tax ID: ${widget.company.taxId}');
                            print('Email: ${widget.company.email}');
                            print('Company Sector: ${widget.company.sector}');
                            print('Password: ${widget.company.password}');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlanSelectionScreen(
                                    company: widget.company),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Select Plan'),
                      ),
                    ),
                  ],
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
