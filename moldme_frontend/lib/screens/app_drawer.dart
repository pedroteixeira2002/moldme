// FILE: lib/app_drawer.dart
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
                  leading: const Icon(Icons.person_add),
                  title: const Text("Add Employee"),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/add-employee',
                      arguments: {
                        'companyId': '94631481-d008-43df-8ad4-bf1fec866c6a',
                        'token':
                            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJzdHJpbmdAZ21haWwuY29tIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiQ29tcGFueSIsImV4cCI6MTczNDM2MTE0OSwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo1MjEzIiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDo1MjEzIn0.5Hlukw8IVK1LVKi3mzvJ3MgbT_Jdwac29MyYQA-Spw8', // Pass the token here
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text("Edit Employee"),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/edit-employee',
                      arguments: {
                        'companyId': '94631481-d008-43df-8ad4-bf1fec866c6a',
                        'employeeId':
                            '706d5046-cff8-4691-b95f-3a833e90d188', // Replace with actual employee ID
                        'token':
                            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJzdHJpbmdAZ21haWwuY29tIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiQ29tcGFueSIsImV4cCI6MTczNDM2MTE0OSwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo1MjEzIiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDo1MjEzIn0.5Hlukw8IVK1LVKi3mzvJ3MgbT_Jdwac29MyYQA-Spw8', // Pass the token here
                      },
                    );
                  },
                ),
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
