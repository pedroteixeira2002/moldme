import 'package:flutter/material.dart';
import 'package:front_end_moldme/screens/project/new_project_screen.dart';
import 'package:front_end_moldme/screens/project/project-page.dart';
import 'package:front_end_moldme/screens/project/project_proposal.dart';
import 'package:front_end_moldme/screens/settings/settings_screen.dart';
import 'package:front_end_moldme/widgets/employe_add.dart';
import 'package:front_end_moldme/widgets/project_table.dart';



class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/new-project': (context) => const NewProjectPage(
              companyId: 'bf498b3e-74df-4a7c-ac5a-b9b00d097498',
            ),
        '/project-proposal': (context) => const ProjectScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/project-page': (context) => const ProjectPage(),
        '/project-table':(context) => const ProjectTable(data: [],),
        '/widget':(context) => const EmployeeListWidget(companyId: "bf498b3e-74df-4a7c-ac5a-b9b00d097498", projectId: "122749e9-f568-4c4b-b35b-6e8986442f21")

  };
}