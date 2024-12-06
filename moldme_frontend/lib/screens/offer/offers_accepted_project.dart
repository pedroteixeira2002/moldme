import 'package:flutter/material.dart';
import 'package:front_end_moldme/screens/project/project-page.dart';
import 'package:front_end_moldme/services/offer_service.dart';
import 'package:front_end_moldme/services/project_service.dart';
import 'package:front_end_moldme/dtos/project_dto.dart';

class AcceptedOfferProjectsPage extends StatefulWidget {
  final String companyId;

  const AcceptedOfferProjectsPage({Key? key, required this.companyId})
      : super(key: key);

  @override
  _AcceptedOfferProjectsPageState createState() =>
      _AcceptedOfferProjectsPageState();
}

class _AcceptedOfferProjectsPageState extends State<AcceptedOfferProjectsPage> {
  final OfferService _offerService = OfferService();
  late Future<List<ProjectDto>> _acceptedProjects;

  @override
  void initState() {
    super.initState();
    _acceptedProjects =
        _offerService.getAcceptedProjectsByOffers(widget.companyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accepted Offer Projects"),
      ),
      body: FutureBuilder<List<ProjectDto>>(
        future: _acceptedProjects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No accepted projects found.'));
          }

          final projects = snapshot.data!;

          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return Card(
                child: ListTile(
                  title: Text(project.name),
                  subtitle: Text(project.description),
                  trailing: ElevatedButton(
                    // Navigate to project details
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectPage(
                            projectId: project.projectId!,
                            companyId: widget.companyId,
                            currentUserId: widget.companyId,
                          ),
                        ),
                      );
                    },
                    child: const Text("Enter"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
