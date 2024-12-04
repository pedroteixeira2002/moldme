import 'package:flutter/material.dart';

class RegisterScreen2 extends StatelessWidget {
  const RegisterScreen2({super.key});

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
                  image: AssetImage('lib/images/register2.png'), // Substitua pelo caminho da imagem
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
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Company Name',
                        prefixIcon: Icon(Icons.business),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo "Tax Information"
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Tax Information',
                        prefixIcon: Icon(Icons.receipt),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo "E-mail"
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dropdown "Work Area"
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Work Area',
                        prefixIcon: Icon(Icons.work),
                        border: OutlineInputBorder(),
                      ),
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
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 16),

                    // Campo "Password"
                    const TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo "Repeat your password"
                    const TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Repeat your password',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Botão "Finish"
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Finish'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}