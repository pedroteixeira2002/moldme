import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/project_dto.dart';
import 'project_row_widget.dart';

class ProjectListWidget extends StatelessWidget {
  final List<ProjectDto> projects;
  final Function(String, String, String, String)
      onProjectTap; // Alterado para incluir companyId

  const ProjectListWidget({
    Key? key,
    required this.projects,
    required this.onProjectTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return ProjectRowWidget(
            title: project.name,
            date: project.startDate.toLocal().toString().split(' ')[0],
            status: project.status.toString(),
            onTap: () {
              // Passando companyId para o onProjectTap
              onProjectTap(
                project.name,
                project.startDate.toLocal().toString().split(' ')[0],
                project.status.toString(),
                project.companyId ?? '', // Passe apenas o companyId como string
              );

            },
          );
        },
      ),
    );
  }
}
