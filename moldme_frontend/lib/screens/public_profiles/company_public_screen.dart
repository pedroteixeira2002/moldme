import 'dart:math';
import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/company_dto.dart';
import 'package:front_end_moldme/dtos/project_dto.dart';
import 'package:front_end_moldme/screens/offer/apply_to_project_screen.dart';
import 'package:front_end_moldme/services/authentication_service.dart';
import 'package:front_end_moldme/services/company_service.dart';
import 'package:front_end_moldme/services/project_service.dart';
import 'package:front_end_moldme/widgets/app_drawer.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart';

class CompanyProfileScreen extends StatefulWidget {
  final String companyId;

  const CompanyProfileScreen({Key? key, required this.companyId})
      : super(key: key);

  @override
  _CompanyProfileScreenState createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
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

  
  Color _generateRandomColor() {
    final Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomNavigationBar(),
          Expanded(
            child: AppDrawer(
              companyId: " ",
              userId: ,
              child: FutureBuilder<CompanyDto>(
                future: CompanyService().getCompanyById(widget.companyId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: Text('Company not found'));
                  }

                  final company = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(company),
                        _buildDetails(company),
                        _buildProjectsSection(widget.companyId),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(CompanyDto company) {
    final randomColor = _generateRandomColor();
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 250,
          color: randomColor,
          child: Center(
            child: Text(
              company.name.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(CompanyDto company) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(
                  Icons.business,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      company.sector,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(company.address ?? 'No address available'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.email, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(company.email),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Details:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildDetailRow("Tax ID", company.taxId.toString()),
          _buildDetailRow("Contact", company.contact.toString()),
          _buildDetailRow("Sector", company.sector),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsSection(String companyId) {
    return FutureBuilder<List<ProjectDto>>(
      future: ProjectService().listAllProjectsFromCompany(companyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          final errorMessage = snapshot.error.toString();
          if (errorMessage.contains('FormatException')) {
            return const Center(
              child:
                  Text('Invalid response from server. Please try again later.'),
            );
          } else {
            return Center(
              child: Text('Error loading projects: $errorMessage'),
            );
          }
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No projects found for this company.'));
        }

        final projects = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Projects:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(project.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status: ${project.status}'),
                          Text('Budget: \$${project.budget}'),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Não esquecer de adicionar condição que só a company pode enviar ofertas
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApplyToProjectPage(
                                companyId: widget.companyId,
                                projectId: project.projectId ?? '',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Send Offer'),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
