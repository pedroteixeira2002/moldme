import 'package:flutter/material.dart';
import 'package:front_end_moldme/services/project_service.dart';
import 'package:front_end_moldme/widgets/app_drawer.dart';

class ProjectCompanyList extends StatefulWidget {
  final String companyId; 

  const ProjectCompanyList({super.key, required this.companyId});

  @override
  State<ProjectCompanyList> createState() => _ProjectCompanyListState();
}

class _ProjectCompanyListState extends State<ProjectCompanyList> {
  final ProjectService projectService = ProjectService();
  late Future<List<dynamic>> _projects; 

  @override
  void initState() {
    super.initState();
    _projects = fetchProjects();
  }

  Future<List<dynamic>> fetchProjects() async {
    try {
      return await projectService.listAllProjectsFromCompany(widget.companyId);
    } catch (e) {
      throw Exception("Failed to fetch projects: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDrawer(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Company Projects"),
          backgroundColor: const Color(0xFF1D9BF0),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: _projects,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"), 
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No projects found for this company"),
              );
            }

            final projects = snapshot.data!;

            return ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      project['name'] ?? "Unnamed Project",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Status: ${_getStatusText(project['status'])}"),
                        Text("Budget: \$${project['budget']}"),
                        Text("Start Date: ${project['startDate']}"),
                        Text("End Date: ${project['endDate']}"),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectDetailsScreen(projectId: project['projectId']),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _getStatusText(int? status) {
    switch (status) {
      case 0:
        return "In Progress";
      case 1:
        return "Done";
      case 2:
        return "Closed";
      case 4:
        return "Canceled";
      case 5:
        return "Pending";
      case 6:
        return "Accepted";
      case 7:
        return "Denied";
      default:
        return "Unknown";
    }
  }
}

class ProjectDetailsScreen extends StatelessWidget {
  final String projectId;

  const ProjectDetailsScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return AppDrawer(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Project Details"),
          backgroundColor: const Color(0xFF1D9BF0),
        ),
        body: Center(
          child: Text("Details of project ID: $projectId"),
        ),
      ),
    );
  }
}
