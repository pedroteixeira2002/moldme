import 'package:flutter/material.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Injection System for Automobile Production"),
        elevation: 0,
        backgroundColor: const Color(0xFF1D9BF0),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Add search functionality here
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Add notification functionality here
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Information Header
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Injection System for Automobile Production",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Incoe Corporation - Hot Runner Systems",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/company_logo.png'), // Replace with your image
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Create New Task Section
              _buildNewTaskSection(),
              const SizedBox(height: 20),

              // Team Section
              _buildTeamSection(),
              const SizedBox(height: 20),

              // Upload Files Section
              _buildUploadFilesSection(),
              const SizedBox(height: 20),

              // Your Files Section
              _buildFilesSection(),
            ],
          ),
        ),
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
                  // Add functionality to add a new member
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
