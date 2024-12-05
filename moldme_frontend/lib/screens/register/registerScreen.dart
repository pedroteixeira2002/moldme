import 'package:flutter/material.dart';
import 'package:front_end_moldme/models/company.dart';
import 'package:front_end_moldme/models/subscriptionPlan.dart';
import 'package:front_end_moldme/screens/register/registerScreen2.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final Company _company = Company(
    companyId: '',
    name: '',
    taxId: 0,
    address: '',
    contact: 0,
    email: '',
    sector: '',
    plan: SubscriptionPlan.none, 
    password: '',
  );

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
                  image: AssetImage('lib/images/register.png'), // Substitua pelo caminho da imagem
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Parte direita com o formulário
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the company name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _company.name = value ?? '';
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the tax information';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _company.taxId = int.tryParse(value ?? '0') ?? 0;
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the email';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _company.email = value ?? '';
                          },
                        ),
                        const SizedBox(height: 32),

                        // Botão "Next"
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _formKey.currentState?.save();
                                //print('Company Name: ${_company.name}');
                                //print('Tax ID: ${_company.taxId}');
                                //print('Email: ${_company.email}');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen2(company: _company),
                                  ),
                                );
                              } else {
                                print('Form is not valid');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Link "Already have an account"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account? '),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/login'); // Adicione a rota da tela de login
                              },
                              child: const Text(
                                'Login to your account',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
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
        ],
      ),
    );
  }
}