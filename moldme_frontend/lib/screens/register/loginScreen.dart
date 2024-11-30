import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
   Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                // Seção esquerda com imagem e ícones sociais
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
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
                            Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Please fill your information below",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 24),
                            // Campo de Email ou TaxID
                            TextField(
                              decoration: InputDecoration(
                                labelText: "Email or TaxID",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                prefixIcon: Icon(Icons.email),
                              ),
                            ),
                            SizedBox(height: 16),
                            // Campo de Senha
                            TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),
                            SizedBox(height: 24),
                            // Botão de próxima
                            ElevatedButton(
                              onPressed: () {
                                // Ação do botão
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, // Cor do botão
                                padding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Next"),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            // Link "Forgot your password?"
                            GestureDetector(
                              onTap: () {
                                // Navegar para recuperação de senha
                              },
                              child: Text(
                                "Forgot your password ?",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
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
      ),
    );
  }
}