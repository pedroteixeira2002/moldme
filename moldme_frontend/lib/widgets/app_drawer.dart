import 'package:flutter/material.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart';

class AppDrawer extends StatelessWidget {
  final Widget child; // O conteúdo principal da página será passado como um widget

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
                  title: const Text("My Profile"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.assignment),
                  title: const Text("Projects"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/project-list');
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
                  leading: const Icon(Icons.calendar_today),
                  title: const Text("Calendar"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/calendar');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("Settings"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/settings');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.assignment_add),
                  title: const Text("New Project"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/new-project');
                  },
                ),
                
                const Spacer(),
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

