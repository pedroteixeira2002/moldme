import 'package:flutter/material.dart';
import 'package:front_end_moldme/screens/employee/add_employee_screen.dart';
import 'package:front_end_moldme/screens/employee/edit_employee_screen.dart';
import 'package:front_end_moldme/screens/employee/employee_profile_screen.dart';
import 'package:front_end_moldme/screens/employee/list_employee_screen.dart';
import 'package:front_end_moldme/screens/home_page.dart';
import 'package:front_end_moldme/screens/offer/offer_proposal_screen.dart';
import 'package:front_end_moldme/screens/offer/offer_service_screen.dart';
import 'package:front_end_moldme/screens/public_profiles/available_companies_screen.dart';
import 'package:front_end_moldme/screens/public_profiles/available_projects_screen.dart';
import 'package:front_end_moldme/screens/public_profiles/company_public_screen.dart';

import 'package:front_end_moldme/screens/public_profiles/employee_public_screen.dart';


class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => HomePage(),
    '/employee-profile': (context) => EmployeeProfileScreen(),
    '/add-employee': (context) => AddEmployeeScreen(
          companyId: 'bf498b3e-74df-4a7c-ac5a-b9b00d097498',
        ),
    '/all-employees': (context) => AllEmployeesScreen(),
    '/edit-employee': (context) => EditEmployeeScreen(),
    '/available-projects': (context) => AvailableProjectsScreen(),
    //'/public-project': (context) => CompanyProfileScreen(),
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
