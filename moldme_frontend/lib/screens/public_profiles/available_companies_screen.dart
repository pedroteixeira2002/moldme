import 'package:flutter/material.dart';
import 'package:front_end_moldme/models/company.dart';
import 'package:front_end_moldme/screens/app_drawer.dart';
import 'package:front_end_moldme/services/company_service.dart';

class AvailableCompaniesScreen extends StatefulWidget {
  @override
  _AvailableCompaniesScreenState createState() =>
      _AvailableCompaniesScreenState();
}

class _AvailableCompaniesScreenState extends State<AvailableCompaniesScreen> {
  late Future<List<Company>> _companiesFuture;

  @override
  void initState() {
    super.initState();
    _companiesFuture = CompanyService().listAllCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return AppDrawer(
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F9FF),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Available Companies",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: FutureBuilder<List<Company>>(
          future: _companiesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No companies available"));
            }

            final companies = snapshot.data!;
            return ListView.builder(
              itemCount: companies.length,
              itemBuilder: (context, index) {
                final company = companies[index];
                return ListTile(
                  title: Text(company.name),
                  subtitle: Text(company.email),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/company-profile',
                      arguments: company.companyId,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
