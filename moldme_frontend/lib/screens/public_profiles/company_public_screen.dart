import 'package:flutter/material.dart';

class CompanyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F9FF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner da Empresa
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.blue.shade200,
                  child: Center(
                    child: Text(
                      "We Connect Top Talents\nWith Top Companies",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Icon(Icons.facebook, color: Colors.white),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ],
            ),

            // Informações da Empresa
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        Colors.blue.shade100, // Cor padrão para o logo
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Incoe Corporation",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Hot Runner Systems",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text("Jakarta Selatan, Indonesia"),
                            SizedBox(width: 16),
                            Icon(Icons.group, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text("1 - 50 employees"),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.link, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text("www.incoe.com"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Botões de Navegação
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildNavigationButton("About", true),
                  _buildNavigationButton("Team & Culture", false),
                  _buildNavigationButton("Jobs", false),
                ],
              ),
            ),

            // Descrição da Empresa
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Get To Know Deal! Jobs:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "INCOE designs and manufactures hot runner systems driven by performance for the processing of all injection moldable plastic materials. A leader and pioneer in the plastics industry, our original patented design was the first commercial hot runner nozzle available. The development and use of hot runner systems has led to the advancement of injection molding on a global basis. By design, the hot runner system has been eco-friendly since inception with reduced material use and waste by-product.",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
              ),
            ),

            // Seção da Equipe
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Team:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/employee-profile');
                  },
                  child: _buildTeamCard(
                      "Andhika Sudarman", "Chief Executive Officer"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/employee-profile');
                  },
                  child:
                      _buildTeamCard("Eleanor Pena", "Marketing Coordinator"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/employee-profile');
                  },
                  child: _buildTeamCard("Jacob Jones", "Web Designer"),
                ),
              ],
            ),

            // Seção de Projetos
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Projects:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search job title here...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    items: [
                      DropdownMenuItem(
                        value: "Role Category",
                        child: Text("Role Category"),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
            _buildProjectCard("Hot Runner System Fix", "Portugal", "Contact"),
            _buildProjectCard(
                "Hot Runner System Fix", "Portugal", "In Progress"),
            _buildProjectCard("Hot Runner System Fix", "Portugal", "Ended"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(String title, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey.shade200,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Text(title),
      ),
    );
  }

  Widget _buildTeamCard(String name, String role) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blue.shade100, // Cor padrão para avatares
        ),
        SizedBox(height: 8),
        Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(role, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildProjectCard(String title, String location, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(location, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
            Text(
              status,
              style: TextStyle(
                color: status == "Contact"
                    ? Colors.blue
                    : status == "In Progress"
                        ? Colors.orange
                        : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
