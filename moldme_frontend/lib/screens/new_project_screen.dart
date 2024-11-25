import 'package:flutter/material.dart';
import '../services/company_service.dart';
import '../models/project_dto.dart';

class NewProjectScreen extends StatefulWidget {
  const NewProjectScreen({super.key});

  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  // Controllers for text fields
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController companyIdController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  // Variables
  final CompanyService companyService = CompanyService();
  int? projectStatus; // Dropdown status

  // List for status dropdown
  final List<Map<String, dynamic>> statusOptions = [
    {"label": "Not Started", "value": 0},
    {"label": "In Progress", "value": 1},
    {"label": "Completed", "value": 2},
  ];

  // Submit project function
  Future<void> _submitProject() async {
    try {
      final project = ProjectDto(
        name: projectNameController.text,
        description: descriptionController.text,
        budget: double.tryParse(budgetController.text),
        status: projectStatus,
        startDate: startDateController.text,
        endDate: endDateController.text,
        companyId: companyIdController.text,
        employeeIds: [], // Add team member IDs if needed
      );

      final response = await companyService.addProject(
        project,
        companyIdController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: Row(
        children: [
          // Sidebar Menu
          Container(
            width: 250,
            color: const Color(0xFFE5E5E5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Color(0xFF1D9BF0)),
                  child: Text(
                    "MouldMe",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("My Profile"),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.assignment),
                  title: const Text("Projects"),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text("Staff"),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text("Calendar"),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("Settings"),
                  onTap: () {},
                ),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Sign Out"),
                  onTap: () {},
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Page Title
                    const Text(
                      "New Project",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D3557),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Project Name
                    const Text("Project Name", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: projectNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter project name",
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Description
                    const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter project description",
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Project Budget
                    const Text("Project Budget", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: budgetController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter project budget",
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Company ID
                    const Text("Company ID", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: companyIdController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter company ID",
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Start Date
                    const Text("Start Date", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: startDateController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "YYYY-MM-DD",
                      ),
                    ),
                    const SizedBox(height: 20),

                    // End Date
                    const Text("End Date", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: endDateController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "YYYY-MM-DD",
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Status
                    const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<int>(
                      value: projectStatus,
                      items: statusOptions.map((option) {
                        return DropdownMenuItem<int>(
                          value: option['value'],
                          child: Text(option['label']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          projectStatus = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Select project status",
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Submit Button
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitProject,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1D9BF0),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        child: const Text(
                          "Add Project",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
