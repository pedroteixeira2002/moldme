
import 'package:flutter/material.dart';
import 'package:front_end_moldme/services/project_service.dart';

import '../../models/project_dto.dart';

class ProjectPage extends StatefulWidget {
  final String projectId; // Recebe o ID do projeto como parâmetro

  const ProjectPage({super.key, required this.projectId});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final ProjectService _projectService = ProjectService();

  late Future<ProjectDto> _projectFuture;

  @override
  void initState() {
    super.initState();
    // Carregar os dados do projeto ao iniciar a página
    _projectFuture = _projectService.viewProject(widget.projectId) as Future<ProjectDto>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Details"),
        elevation: 0,
        backgroundColor: const Color(0xFF1D9BF0),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Adicionar funcionalidade de busca aqui
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Adicionar funcionalidade de notificações aqui
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<ProjectDto>(
        future: _projectFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Project not found."));
          }

          final project = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header de informações do projeto
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.name ?? "No name provided",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            project.description ?? "No description provided",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/company_logo.png'), // Substitua pela imagem real
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Seções adicionais (Tasks, Team, Upload Files, etc.)
                  _buildNewTaskSection(),
                  const SizedBox(height: 20),
                  _buildTeamSection(),
                  const SizedBox(height: 20),
                  _buildUploadFilesSection(),
                  const SizedBox(height: 20),
                  _buildFilesSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewTaskSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Create New Task",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            hintText: "Description...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Implement task creation
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1D9BF0),
          ),
          child: const Text("Create Task"),
        ),
      ],
    );
  }

  Widget _buildTeamSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Team",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildTeamMember("Andhika Sudarman", "Chief Executive Officer"),
              _buildTeamMember("Eleanor Pena", "Marketing Coordinator"),
              _buildTeamMember("Jacob Jones", "Web Designer"),
              GestureDetector(
                onTap: () {
                  // Adicionar funcionalidade de adicionar membro
                },
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  radius: 30,
                  child: const Icon(Icons.add, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamMember(String name, String role) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            role,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadFilesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upload Files",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade100,
          ),
          child: const Center(
            child: Text("Drag and drop files, or Browse"),
          ),
        ),
      ],
    );
  }

  Widget _buildFilesSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Files",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 10),
        ListTile(
          leading: Icon(Icons.insert_drive_file),
          title: Text("Website Design.png"),
          subtitle: Text("2.8 MB • Dec 13, 2022"),
          trailing: Icon(Icons.more_vert),
        ),
        ListTile(
          leading: Icon(Icons.insert_drive_file),
          title: Text("UX-UI.zip"),
          subtitle: Text("242 MB • Dec 12, 2022"),
          trailing: Icon(Icons.more_vert),
        ),
      ],
    );
  }
}
