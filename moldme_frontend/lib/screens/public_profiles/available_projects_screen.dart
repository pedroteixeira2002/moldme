import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/project_dto.dart';
import 'package:front_end_moldme/services/project_service.dart';

class AvailableProjectsScreen extends StatefulWidget {
  @override
  _AvailableProjectsScreenState createState() =>
      _AvailableProjectsScreenState();
}

class _AvailableProjectsScreenState extends State<AvailableProjectsScreen> {
  late Future<List<ProjectDto>> _projectsFuture;
  List<ProjectDto> _allProjects = [];
  List<ProjectDto> _filteredProjects = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _projectsFuture = ProjectService().listAllNewProjects();
    _loadProjects();
    _searchController.addListener(_filterProjects);
  }

  Future<void> _loadProjects() async {
    try {
      final projects = await _projectsFuture;
      setState(() {
        _allProjects = projects;
        _filteredProjects = projects;
      });
    } catch (e) {
      // Trate o erro se necessário
      print("Error loading projects: $e");
    }
  }

  void _filterProjects() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProjects = _allProjects;
      } else {
        _filteredProjects = _allProjects.where((project) {
          return project.name.toLowerCase().contains(query) ||
              project.description.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Available Projects",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de Busca
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search projects...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
              ),
            ),
            const SizedBox(height: 16),

            // Lista de Projetos
            Expanded(
              child: FutureBuilder<List<ProjectDto>>(
                future: _projectsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No projects available"));
                  }

                  return ListView.builder(
                    itemCount: _filteredProjects.length,
                    itemBuilder: (context, index) {
                      final project = _filteredProjects[index];
                      return _buildProjectRow(
                        context: context,
                        title: project.name,
                        date: project.startDate
                            .toLocal()
                            .toString()
                            .split(' ')[0],
                        status: project.status.toString(),  // Possivel Erro aqui ou não 
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectRow({
    required BuildContext context,
    required String title,
    required String date,
    required String status,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/public-project', arguments: {
          'title': title,
          'date': date,
          'status': status,
        });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Informações do Projeto
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Date: $date",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              // Status do Projeto
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: status == "Open"
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: status == "Open" ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
