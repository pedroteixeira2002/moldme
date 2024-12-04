import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final Widget child;

  const AppDrawer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: Row(
        children: [
          Container(
            width: 250,
            color: const Color(0xFFE5E5E5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                // Botão para ir à página de Todos os Funcionários
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text("All Employees"),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/all-employees',
                      arguments:
                          "aaf284e6-8a87-4954-ba5e-8fea15b7e93c", // companyId
                    );
                  },
                ),
                // Botão para ir à página de Perfil da Empresa
                ListTile(
                  leading: const Icon(Icons.business),
                  title: const Text("Company Profile"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/company-profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.work),
                  title: const Text("Available Projects"),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, '/available-projects');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add_business),
                  title: const Text("Propose Service"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/propose-service',
                        arguments: {
                          'projectId': 'example-project-id',
                          'companyId': 'example-company-id',
                        });
                  },
                ),
                // Botão para Login
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text("Login"),
                  onTap: () {
                    Navigator.pushNamed(context, '/login'); // Rota de Login
                  },
                ),
                const Spacer(),
                // Botão para sair
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Sign Out"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFF6F9FF),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
