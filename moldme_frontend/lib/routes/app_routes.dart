import 'package:flutter/material.dart';
import 'package:front_end_moldme/screens/employee/add_employee_screen.dart';
import 'package:front_end_moldme/screens/employee/edit_employee_screen.dart';
import 'package:front_end_moldme/screens/employee/employee_profile_screen.dart';
import 'package:front_end_moldme/screens/employee/list_employee_screen.dart';
import 'package:front_end_moldme/screens/home_page.dart';
import 'package:front_end_moldme/screens/homescreen/homeScreen.dart';
import 'package:front_end_moldme/screens/offer/offer_proposal_screen.dart';
import 'package:front_end_moldme/screens/offer/offer_service_screen.dart';
import 'package:front_end_moldme/screens/public_profiles/available_companies_screen.dart';
import 'package:front_end_moldme/screens/public_profiles/available_projects_screen.dart';
import 'package:front_end_moldme/screens/public_profiles/company_public_screen.dart';
import 'package:front_end_moldme/screens/public_profiles/employee_public_screen.dart';
import 'package:front_end_moldme/screens/register/loginScreen.dart';
import 'package:front_end_moldme/screens/register/recoverPasswordScreen.dart';
import 'package:front_end_moldme/screens/register/registerScreen.dart';
import 'package:front_end_moldme/screens/project/new_project_screen.dart';
import 'package:front_end_moldme/screens/project/project-page.dart';
import 'package:front_end_moldme/screens/project/project_company_list.dart';
import 'package:front_end_moldme/screens/project/project_proposal.dart';
import 'package:front_end_moldme/screens/settings/settings_screen.dart';
import 'package:front_end_moldme/widgets/chat_card.dart';
import 'package:front_end_moldme/widgets/employe_add.dart';
import 'package:front_end_moldme/widgets/project_table.dart';
import 'package:front_end_moldme/widgets/task_new_card.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => HomePageCompany(),
    '/login': (context) => LoginScreen(),
    '/register': (context) => const RegisterScreen(),
    '/recoverPassword': (context) => RecoverPasswordScreen(),
    '/new-project': (context) => const NewProjectPage(
          companyId: 'bf498b3e-74df-4a7c-ac5a-b9b00d097498',
        ),
    '/project-proposal': (context) => const ProjectScreen(),
    '/settings': (context) => const SettingsScreen(),
    '/project-page': (context) => const ProjectPage(
          projectId: '122749e9-f568-4c4b-b35b-6e8986442f21',
          companyId: 'bf498b3e-74df-4a7c-ac5a-b9b00d097498',
          currentUserId: '675943a6-6a50-40b9-a1c3-168b9dfc87a9',
        ),
    '/project-table': (context) => const ProjectTable(
          data: [],
        ),
    '/widget': (context) => const EmployeeListWidget(
        companyId: "bf498b3e-74df-4a7c-ac5a-b9b00d097498",
        projectId: "122749e9-f568-4c4b-b35b-6e8986442f21",
        currentUserId: "675943a6-6a50-40b9-a1c3-168b9dfc87a9"),
    '/projects-list': (context) => const ProjectsListWidget(
        companyId: "bf498b3e-74df-4a7c-ac5a-b9b00d097498",
        currentUserId: "675943a6-6a50-40b9-a1c3-168b9dfc87a9"),
    '/chat': (context) => const ChatCard(chatId: '1001'),
    '/task': (context) => const CreateTaskCard(
          projectId: '122749e9-f568-4c4b-b35b-6e8986442f21',
          employeeId: '9d738649-8773-4bf2-b046-39ac3c6f3113',
        ),
    '/employee-profile': (context) => EmployeeProfileScreen(),
    '/add-employee': (context) => AddEmployeeScreen(
          companyId: 'bf498b3e-74df-4a7c-ac5a-b9b00d097498',
        ),
    '/all-employees': (context) => AllEmployeesScreen(
          isCompany: true,
        ),
    '/edit-employee': (context) => EditEmployeeScreen(),
    '/available-projects': (context) => AvailableProjectsScreen(),
    '/propose-service': (context) => OfferServiceScreen(
          projectId: 'example-project-id',
          companyId: 'example-company-id',
        ),
    '/proposal-details': (context) => OfferProposalScreen(),
    '/public-employee': (context) => EmployeePublicScreen(),
    '/list-companies': (context) => AvailableCompaniesScreen(),
    '/company-profile': (context) {
      final String companyId =
          ModalRoute.of(context)!.settings.arguments as String;
      return CompanyProfileScreen(companyId: companyId);
    },
  };
}
