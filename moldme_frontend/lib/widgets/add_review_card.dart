import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../dtos/review_dto.dart';
import '../services/employee_service.dart';
import '../services/review_service.dart';

void main () {
  runApp(const MaterialApp(
    home: ReviewCard(
      reviewerId: '83ded5e6-b067-4b0a-a3b2-046570235588',
      reviewedId: '675943a6-6a50-40b9-a1c3-168b9dfc87a9',
    ),
  ));
}

class ReviewCard extends StatefulWidget {
  final String reviewerId;
  final String reviewedId;

  const ReviewCard({
    Key? key,
    required this.reviewerId,
    required this.reviewedId,
  }) : super(key: key);

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  late Future<String> _reviewerName;
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0;

  @override
  void initState() {
    super.initState();
    _reviewerName = _getEmployeeName(widget.reviewerId);
  }

  Future<String> _getEmployeeName(String employeeId) async {
    final employee = await EmployeeService().getEmployeeById(employeeId);
    return employee.name; // Assuming the Employee model has a 'name' field
  }

  Future<void> _createReview() async {
    final review = ReviewDto(
      comment: _commentController.text,
      stars: _rating.toInt(),
    );

    try {
      await ReviewService().addReview(review, widget.reviewerId, widget.reviewedId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review created successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create review: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reviewer Name
            FutureBuilder<String>(
              future: _reviewerName,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  );
                } else {
                  return Text(
                    'Reviewer: ${snapshot.data}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 8.0),
            // Rating Bar
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 8.0),
            // Comment TextField
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Comment',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            // Button to create a new review
            ElevatedButton(
              onPressed: _createReview,
              child: const Text('Create Review'),
            ),
          ],
        ),
      ),
    );
  }
}