import 'package:flutter/material.dart';
import 'package:front_end_moldme/screens/employee/add_employee_screen.dart';
import 'package:front_end_moldme/screens/employee/edit_employee_screen.dart';
import 'package:front_end_moldme/screens/employee/employee_profile_screen.dart';
import 'package:front_end_moldme/screens/employee/list_employee_screen.dart';
import 'package:front_end_moldme/screens/homescreen/homeScreen.dart';
//import 'package:front_end_moldme/screens/offer/offer_proposal_screen.dart';
//import 'package:front_end_moldme/screens/offer/offer_service_screen.dart';
import 'package:front_end_moldme/screens/public_profiles/available_companies_screen.dart';
import 'package:front_end_moldme/screens/public_profiles/company_public_screen.dart';
import 'package:front_end_moldme/screens/public_profiles/employee_public_screen.dart';
import 'package:front_end_moldme/screens/register/loginScreen.dart';
import 'package:front_end_moldme/screens/register/recoverPasswordScreen.dart';
import 'package:front_end_moldme/screens/register/registerScreen.dart';
import 'package:front_end_moldme/screens/project/new_project_screen.dart';
import 'package:front_end_moldme/screens/project/project-page.dart';
import 'package:front_end_moldme/screens/project/project_company_list.dart';
import 'package:front_end_moldme/screens/project/project_proposal.dart';
import 'package:front_end_moldme/widgets/chat_card.dart';
import 'package:front_end_moldme/widgets/project_table.dart';
import 'package:front_end_moldme/widgets/task_new_card.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const Homescreen(),
    '/login': (context) => LoginScreen(),
    '/register': (context) => const RegisterScreen(),
    '/recoverPassword': (context) => RecoverPasswordScreen(),

  

    '/project-proposal': (context) => const ProjectScreen(),  // ???? 
    /*
    '/project-page': (context) => const ProjectPage(
          projectId: '122749e9-f568-4c4b-b35b-6e8986442f21',
          companyId: 'bf498b3e-74df-4a7c-ac5a-b9b00d097498',
          currentUserId: '675943a6-6a50-40b9-a1c3-168b9dfc87a9',
        ),
        */
    '/project-table': (context) => const ProjectTable(         // Achamos que não está a ser utilizado
          data: [],),

    '/chat': (context) => const ChatCard(chatId: '1001'),
    '/task': (context) => const CreateTaskCard(
          projectId: '122749e9-f568-4c4b-b35b-6e8986442f21',
          employeeId: '9d738649-8773-4bf2-b046-39ac3c6f3113',
        ),
    //'/employee-profile': (context) => EmployeeProfileScreen(),
    

    //'/edit-employee': (context) => EditEmployeeScreen(),
    
    '/public-employee': (context) => EmployeePublicScreen(),
   // '/list-companies': (context) => AvailableCompaniesScreen(),
    /*
    '/company-profile': (context) {
      final String companyId =
          ModalRoute.of(context)!.settings.arguments as String;
      return CompanyProfileScreen(companyId: companyId);
    },
    */
  };
}
