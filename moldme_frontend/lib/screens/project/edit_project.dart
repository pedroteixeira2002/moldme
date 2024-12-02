import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/project_dto.dart';
import 'package:front_end_moldme/models/status.dart';
import 'package:front_end_moldme/services/project_service.dart';

class EditProjectPage extends StatefulWidget {
  final String projectId; // ID do projeto

  const EditProjectPage({Key? key, required this.projectId}) : super(key: key);

  @override
  _EditProjectPageState createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  final ProjectService _projectService = ProjectService();
  final _formKey = GlobalKey<FormState>();
  late Future<ProjectDto> _project;

  // Controladores de texto para os campos do formulário
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  int _status = 0;

  @override
  void initState() {
    super.initState();
    _project = _fetchProjectDetails();
  }

  Future<ProjectDto> _fetchProjectDetails() async {
    try {
      final project = await _projectService.projectView(
        '', // Substitua pelo `companyId` se necessário
        widget.projectId,
      );
      _populateFormFields(project);
      return project;
    } catch (e) {
      throw Exception("Failed to fetch project details: $e");
    }
  }

  void _populateFormFields(ProjectDto project) {
    _nameController.text = project.name;
    _descriptionController.text = project.description;
    _budgetController.text = project.budget.toString();
    _startDate = project.startDate;
    _endDate = project.endDate;
    _status = project.status;
  }

  Future<void> _updateProject() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedProject = ProjectDto(
          projectId: widget.projectId,
          name: _nameController.text,
          description: _descriptionController.text,
          status: _status,
          budget: double.parse(_budgetController.text),
          startDate: _startDate!,
          endDate: _endDate!,
        );

        await _projectService.updateProject(widget.projectId, updatedProject);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Project updated successfully!")),
        );

        Navigator.pop(context, true); // Retorna à página anterior
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update project: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Project"),
      ),
      body: FutureBuilder<ProjectDto>(
        future: _project,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration:
                        const InputDecoration(labelText: "Project Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a project name.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a description.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _budgetController,
                    decoration: const InputDecoration(labelText: "Budget"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a budget.";
                      }
                      if (double.tryParse(value) == null) {
                        return "Please enter a valid number.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    title: const Text("Start Date"),
                    subtitle: Text(_startDate != null
                        ? _startDate!.toLocal().toString().split(' ')[0]
                        : "Select start date"),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _startDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() {
                            _startDate = date;
                          });
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text("End Date"),
                    subtitle: Text(_endDate != null
                        ? _endDate!.toLocal().toString().split(' ')[0]
                        : "Select end date"),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _endDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() {
                            _endDate = date;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _status,
                    items: Status.values.map((status) {
                      return DropdownMenuItem(
                        value: status.toInt(),
                        child: Text(status.name),
                      );
                    }).toList(),
                    decoration: const InputDecoration(labelText: "Status"),
                    onChanged: (value) {
                      setState(() {
                        _status = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _updateProject,
                    child: const Text("Save Changes"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
