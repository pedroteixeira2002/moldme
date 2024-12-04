import 'package:flutter/material.dart';
import 'package:front_end_moldme/services/employee_service.dart';
import '../dtos/review_dto.dart';

void main() {
  runApp(MaterialApp(
    home: ReviewCard(
      review: ReviewDto(
        reviewerId: '675943a6-6a50-40b9-a1c3-168b9dfc87a9',
        comment: 'espetaculo',
        date: DateTime.now(),
        stars: 5,
        reviewedId: '014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08',
      ),
    ),
  ));
}

class ReviewCard extends StatelessWidget {
  final ReviewDto review;

  const ReviewCard({
    Key? key,
    required this.review,
  }) : super(key: key);

  Future<String> _getEmployeeName(String employeeId) async {
    final employee = await EmployeeService().getEmployeeById(employeeId);
    return employee.name;
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
            if (review.reviewerId != null)
              FutureBuilder<String>(
                future: _getEmployeeName(review.reviewerId!),
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
            // Review Date
            if (review.date != null)
              Text(
                'Date: ${review.date!.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            const SizedBox(height: 8.0),
            // Review Stars
            Row(
              children: List.generate(
                review.stars,
                (index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            // Review Comment
            Text(
              review.comment,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
