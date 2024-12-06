import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/project_dto.dart';
import 'package:front_end_moldme/widgets/app_drawer.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart';
import 'package:intl/intl.dart';
import '../../services/project_service.dart';

class NewProjectPage extends StatefulWidget {
  final String userId;

  const NewProjectPage({Key? key, required this.userId}) : super(key: key);

  @override
  _NewProjectPageState createState() => _NewProjectPageState();
}

class _NewProjectPageState extends State<NewProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = ProjectService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  int _selectedStatus = 0;

  @override
  void initState() {
    super.initState();
    // Imprime o userId assim que a tela é carregada
    print('User ID: ${widget.userId}');
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select start and end dates')),
        );
        return;
      }

      try {
        // Validar campos obrigatórios
        if (_startDate == null || _endDate == null) {
          throw Exception('Both start and end dates must be selected');
        }

        final newProject = ProjectDto(
          name: _nameController.text,
          description: _descriptionController.text,
          status: _selectedStatus, // Converte o status para string
          budget: double.parse(_budgetController.text),
          startDate: _startDate!, // Mantém DateTime
          endDate: _endDate!, // Mantém DateTime
          
        );
        
        await _service.addProject(widget.userId, newProject);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project created successfully!')),
        );

        // Resetar o formulário
        _nameController.clear();
        _descriptionController.clear();
        _budgetController.clear();
        setState(() {
          _startDate = null;
          _endDate = null;
          _selectedStatus = 0;
        });

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create project: $e')),
        );
      }

    }
  }

  Future<void> _pickDate({required bool isStartDate}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Barra de Navegação no topo
          const CustomNavigationBar(),

          // Conteúdo principal com menu lateral e formulário
          Expanded(
            child: Row(
              children: [
                // Menu lateral (AppDrawer)
                SizedBox(
                  width: 250, // Largura fixa para o menu lateral
                  child: AppDrawer(
                    userId: widget.userId,
                    companyId: '', // Deixe o campo companyId vazio
                    child: Container(), // Deixe o menu fixo na lateral
                  ),
                ),

                // Formulário principal
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                            const Text(
                            "New Project",
                            style: TextStyle(
                              fontSize: 36, // Tamanho grande
                              fontWeight: FontWeight.bold, // Negrito
                              color: Color(0xFF4678A3), // Cor azul aproximada
                              shadows: [
                                Shadow(
                                  offset: Offset(2.0, 2.0), // Sombra deslocada
                                  blurRadius: 3.0, // Suavidade da sombra
                                  color: Color.fromRGBO(0, 0, 0, 0.2), // Cor da sombra (preto com 20% opacidade)
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center, // Centraliza o texto (opcional)
                          ),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: 'Project Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a project name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(labelText: 'Description'),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _budgetController,
                            decoration: const InputDecoration(labelText: 'Budget'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a budget';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                          ListTile(
                            title: Text(
                              _startDate == null
                                  ? 'Start Date'
                                  : 'Start Date: ${DateFormat.yMMMd().format(_startDate!)}',
                            ),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () => _pickDate(isStartDate: true),
                          ),
                          ListTile(
                            title: Text(
                              _endDate == null
                                  ? 'End Date'
                                  : 'End Date: ${DateFormat.yMMMd().format(_endDate!)}',
                            ),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () => _pickDate(isStartDate: false),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: const Text('Create Project'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
