import 'package:flutter/material.dart';
import 'package:front_end_moldme/screens/project/edit_project.dart';
import 'package:front_end_moldme/services/project_service.dart';
import 'package:front_end_moldme/widgets/employe_add.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart';
import 'package:front_end_moldme/widgets/team_project.dart';
import 'package:front_end_moldme/widgets/app_drawer.dart';
import 'package:front_end_moldme/dtos/project_dto.dart';

class ProjectPage extends StatefulWidget {
  final String companyId; // ID da empresa
  final String projectId; // ID do projeto

  const ProjectPage(
      {super.key, required this.companyId, required this.projectId});

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final ProjectService _projectService =
      ProjectService(); // Instância do serviço
  bool _showEmployeeList =
      false; // Controle de exibição da lista de funcionários
  ProjectDto? _project; // Detalhes do projeto

  @override
  void initState() {
    super.initState();
    _fetchProjectDetails(); // Busca os detalhes do projeto ao carregar a página
  }

  // Método para buscar os detalhes do projeto usando projectView
  Future<void> _fetchProjectDetails() async {
    try {
      final project = await _projectService.projectView(
        widget.companyId,
        widget.projectId,
      );
      setState(() {
        _project = project; // Define os detalhes do projeto no estado
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch project details: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomNavigationBar(), // Usa a nova AppBar
      body: AppDrawer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Verifica se os detalhes do projeto foram carregados
              if (_project != null) ...[
                // Título com o nome do projeto
                Text(
                  _project!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                // Descrição do projeto
                Text(
                  _project!.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                // Datas de início e fim do projeto
                Text(
                  "Start Date: ${_project!.startDate.toLocal().toString().split(' ')[0]}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "End Date: ${_project!.endDate.toLocal().toString().split(' ')[0]}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
              ] else
                // Indicador de carregamento enquanto os detalhes do projeto são buscados
                const Center(child: CircularProgressIndicator()),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProjectPage(projectId: widget.projectId),
                    ),
                  ).then((value) {
                    if (value == true) {
                      _fetchProjectDetails(); // Recarrega os detalhes do projeto após a edição
                    }
                  });
                },
              ),

              // Conteúdo principal
              Expanded(
                child: SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Coluna da esquerda
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Assign Employees',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Botão para mostrar/ocultar a lista de funcionários
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _showEmployeeList =
                                              !_showEmployeeList;
                                        });
                                      },
                                      child: Text(_showEmployeeList
                                          ? 'Close Employee List'
                                          : 'Show Employee List'),
                                    ),
                                    if (_showEmployeeList)
                                      const SizedBox(height: 16),
                                    if (_showEmployeeList)
                                      Container(
                                        height: 500,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: const SingleChildScrollView(
                                          child: EmployeeListWidget(
                                            companyId:
                                                'bf498b3e-74df-4a7c-ac5a-b9b00d097498',
                                            projectId:
                                                '122749e9-f568-4c4b-b35b-6e8986442f21',
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 16),
                                    // Time do projeto
                                    const ProjectTeamWidget(
                                      projectId:
                                          '122749e9-f568-4c4b-b35b-6e8986442f21',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Coluna da direita
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Write an update',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Tell us how this project’s going...',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Post update
                                      },
                                      child: const Text('Post Update'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
