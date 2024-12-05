import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final Widget
      child; // O conteúdo principal da página será passado como um widget

  const AppDrawer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Row(
        children: [
          // Sidebar Menu
          Container(
            width: 250,
            color: const Color.fromRGBO(158, 187, 214, 1),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Home"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.assignment),
                  title: const Text("Projects"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/projects-list');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.assignment_add),
                  title: const Text("New Project"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/new-project');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text("Staff"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/staff');
                  },
                ),
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
                ListTile(
                  leading: const Icon(
                      Icons.business), // Ícone representando empresas
                  title: const Text("Available Companies"), // Título do botão
                  onTap: () {
                    Navigator.pushNamed(context, '/list-companies');
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
                
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Sign Out"),
                  onTap: () {
                    // Adicionar funcionalidade de logout
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: Container(
              color: const Color(0xFFF6F9FF),
              child: child, // O conteúdo da página é injetado aqui
            ),
          ),
        ],
      ),
    );
  }
}
