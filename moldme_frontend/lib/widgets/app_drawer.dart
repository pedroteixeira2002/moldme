import 'package:flutter/material.dart';
import 'package:front_end_moldme/screens/home_page.dart';
import 'package:front_end_moldme/screens/project/new_project_screen.dart';
import 'package:front_end_moldme/screens/project/project_company_list.dart';
import 'package:front_end_moldme/services/authentication_service.dart';

class AppDrawer extends StatefulWidget {
  final Widget
      child; // O conteúdo principal da página será passado como um widget
  final String userId;
  final String? companyId;

  const AppDrawer({
    super.key,
    required this.child,
    required this.userId,
    required this.companyId,
  });

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final AuthenticationService _authenticationService = AuthenticationService();
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    
  }

  Future<String> _loadUserRole() async {
    final role = await _authenticationService.checkRole();
    setState(() {
      _role = role;
    });
    print('Role: $_role');
    return role;
  }

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HomePageCompany(userId: widget.userId),
                      ),
                    );
                  },
                ),
                if (_role == 'Company') ...[
                  ListTile(
                    leading: const Icon(Icons.assignment),
                    title: const Text("Projects"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectsListWidget(currentUserId: widget.userId, companyId: widget.companyId!),
                        ), 
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.assignment_add),
                    title: const Text("New Project"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewProjectPage(userId: widget.userId),
                        ), 
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text("All Employees"),
                    onTap: () {
                      // Navega para a página de lista de funcionários
                    },
                  ),
                ] else if (_role == 'Employee') ...[
                  ListTile(
                    leading: const Icon(Icons.assignment),
                    title: const Text("My Tasks"),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/my-tasks');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.assignment_turned_in),
                    title: const Text("Completed Tasks"),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, '/completed-tasks');
                    },
                  ),
                ],
                // Adicione um Spacer para empurrar o Sign Out para o fundo
                Spacer(),
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
              child: widget.child, // O conteúdo da página é injetado aqui
            ),
          ),
        ],
      ),
    );
  }
}
