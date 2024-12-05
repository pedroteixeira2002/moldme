import 'package:flutter/material.dart';
import 'package:front_end_moldme/services/authentication_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationService _authenticationService = AuthenticationService();
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // Seção esquerda com imagem e ícones sociais
              Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/images/register.png'), // Substitua pelo caminho da sua imagem
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Seção direita com formulário de login
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                  child: Center( // Alinha verticalmente o conteúdo ao centro
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Apenas ocupa o espaço necessário
                        crossAxisAlignment: CrossAxisAlignment.start, // Alinha à esquerda
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Please fill your information below",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 24),
                           // Campo de Email
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              prefixIcon: const Icon(Icons.email),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Campo de Senha
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Botão de login
                          ElevatedButton(
                            onPressed: () {
                              // Ação do botão
                              final email = _emailController.text;
                              final password = _passwordController.text;
                              _authenticationService.login(email, password);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Cor do botão
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Link "Forgot your password?"
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/recoverPassword');
                            },
                            child: const Text(
                              "Forgot your password ?",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                //decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}