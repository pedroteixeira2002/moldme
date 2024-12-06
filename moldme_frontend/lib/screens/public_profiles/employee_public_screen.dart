import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/review_dto.dart';
import 'package:front_end_moldme/dtos/employee_dto.dart';
import 'package:front_end_moldme/screens/project/reviews_screen.dart';
import 'package:front_end_moldme/services/review_service.dart';
import 'package:front_end_moldme/services/employee_service.dart';

class EmployeePublicScreen extends StatefulWidget {
  final String employeeId;
  EmployeePublicScreen({required this.employeeId});

  @override
  _EmployeePublicScreenState createState() => _EmployeePublicScreenState();
}

class _EmployeePublicScreenState extends State<EmployeePublicScreen> {
  late Future<EmployeeDto> _employeeFuture;
  late Future<List<ReviewDto>> _reviewsFuture;
  final _reviewService = ReviewService();
  final _employeeService = EmployeeService();
  final _commentController = TextEditingController();
  int _stars = 5;

  @override
  void initState() {
    super.initState();
    _employeeFuture = _fetchEmployee(widget.employeeId);
    _reviewsFuture = _reviewService.getReviews(widget.employeeId);
  }

  Future<EmployeeDto> _fetchEmployee(String employeeId) async {
    try {
      return await _employeeService.getEmployeeById(employeeId);
    } catch (e) {
      throw Exception('Failed to load employee details: $e');
    }
  }

  void _submitReview() async {
    String reviewerId = "1"; // O ID do revisor
    String reviewedId =
        "7f4bfd06-9ec8-4409-9eda-0d7771cddd65"; // O ID do funcionário avaliado
    String comment = _commentController.text; // O comentário do usuário
    int stars = _stars; // A quantidade de estrelas selecionadas

    try {
      await _reviewService.addReview(reviewerId, reviewedId, comment, stars);
      setState(() {
        _reviewsFuture = _reviewService
            .getReviews(widget.employeeId); // Recarregar as avaliações
      });
      _commentController.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Review added successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add review: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F9FF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner de Fundo
            Stack(
              children: [
                Image.network(
                  'https://via.placeholder.com/1200x400',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
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

            // Carregar as informações do funcionário
            FutureBuilder<EmployeeDto>(
              future: _employeeFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return Center(child: Text('Employee not found.'));
                }

                EmployeeDto employee = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue, // Cor de exemplo
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employee.name,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              employee.profession,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(employee.company?.name ?? 'No company'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Descrição do Funcionário
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Get To Know:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "INCOE designs and manufactures hot runner systems driven by performance for the processing of all injection moldable plastic materials.",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
              ),
            ),

            // Formulário para enviar uma avaliação
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Write a Review"),
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: "Comment",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _stars ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            _stars = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitReview,
                    child: Text("Submit Review"),
                  ),
                ],
              ),
            ),

            // Carregar as avaliações
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Employee Reviews",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder<List<ReviewDto>>(
              future: _reviewsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No reviews yet.'));
                }

                var reviews = snapshot.data!;
                return Column(
                  children: reviews.map((review) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: ReviewCard(review: review),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
