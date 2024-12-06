import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/review_dto.dart';
import 'package:front_end_moldme/dtos/employee_dto.dart';
import 'package:front_end_moldme/services/review_service.dart';
import 'package:front_end_moldme/services/employee_service.dart';
import 'package:front_end_moldme/widgets/app_drawer.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart';

class EmployeePublicScreen extends StatefulWidget {
  final String employeeId;
  const EmployeePublicScreen({required this.employeeId});

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
    _employeeFuture = _employeeService.getEmployeeById(widget.employeeId);
    _reviewsFuture = _reviewService.getReviews(widget.employeeId);
  }

  void _submitReview() async {
    String reviewerId = "1"; // Simulando o ID do avaliador
    String reviewedId = widget.employeeId; // ID do avaliado
    String comment = _commentController.text;
    int stars = _stars;

    try {
      await _reviewService.addReview(reviewerId, reviewedId, comment, stars);
      setState(() {
        _reviewsFuture = _reviewService.getReviews(widget.employeeId);
      });
      _commentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review added successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add review: $e')));
    }
  }

  Widget _buildSubmitReviewCard() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Write a Review",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: "Comment",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Submit Review"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeInfo(EmployeeDto employee) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.blue.shade200,
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        employee.profession,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(employee.company?.name ?? 'No company'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBar(List<ReviewDto> reviews) {
    Map<int, int> starCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (var review in reviews) {
      starCounts[review.stars] = (starCounts[review.stars] ?? 0) + 1;
    }

    int totalReviews = reviews.length;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ratings Breakdown",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...List.generate(5, (index) {
              int star = 5 - index;
              int count = starCounts[star] ?? 0;
              double percentage = (count / totalReviews) * 100;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Text("$star ★",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: count / totalReviews,
                            child: Container(
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text("${percentage.toStringAsFixed(1)}%",
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsList(List<ReviewDto> reviews) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: reviews.map((review) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Card(
            child: ListTile(
              title: Text(review.comment),
              subtitle: Row(
                children: List.generate(
                  review.stars,
                  (index) =>
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: Column(
        children: [
          const CustomNavigationBar(),
          Expanded(
            child: AppDrawer(
              userId: widget.employeeId,
              companyId: "",
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<EmployeeDto>(
                      future: _employeeFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: Text('Employee not found.'));
                        }

                        return _buildEmployeeInfo(snapshot.data!);
                      },
                    ),
                    _buildSubmitReviewCard(),
                    FutureBuilder<List<ReviewDto>>(
                      future: _reviewsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No reviews yet.'));
                        }

                        var reviews = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRatingBar(reviews),
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "Employee Reviews",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            _buildReviewsList(reviews),
                          ],
                        );
                      },
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
